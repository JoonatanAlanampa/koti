// sdboot.c — pull a kernel image off the microSD into RAM before the firmware
// decides what to boot.
//
// THIS IS THE TRANSPORT, and it is the last thing standing between a kernel
// that reaches userspace in simulation and one that does it on the bench. koti
// boots out of a 32 KB block RAM pretending to be a flash chip; the kernel is
// 3.95 MB. Every other route we own is worse:
//
//   over the 115200 UART   3.95 MB * 10 bits = ~343 s PER ATTEMPT
//   in the bitstream       a place-and-route per kernel, and it does not fit
//   the board's SPI flash  needs pins not in the LPF and an offset FSM
//   the microSD            ~4 s, and the card slot is onboard
//
// The card wins by roughly 85x against the UART, which is the difference
// between iterating on a kernel and dreading it.
//
// WHY A RAW BLOCK RANGE AND NOT A FILE. Reading a FAT32 file means a partition
// parser, a BPB parser, a directory walk and a cluster-chain walk — several
// hundred lines that all have to be right before a single byte of kernel
// arrives, in firmware that has 16 KB of flash and no debugger. A header block
// at a fixed LBA is about forty lines and fails in exactly one way. When the
// rootfs rung arrives it will want a real filesystem, but the kernel does not:
// it is one contiguous blob whose only reader is this file.
//
// ON-CARD LAYOUT, written by tools/sdkernel.py:
//
//   LBA 2048      header, this format, 512 bytes
//   LBA 2049..    the kernel image, zero-padded to a whole number of blocks
//
//   header word 0   magic 0x49544F4B  ('K','O','T','I' little-endian)
//   header word 1   version, 1
//   header word 2   blocks — 512-byte blocks of image that follow
//   header word 3   load address, must be KERNEL_ADDR
//   header word 4   sum — 32-bit additive sum of every loaded word
//
// ⚠️ EVERY FAILURE PATH RETURNS 0 AND CHANGES NOTHING. No card, no header, a
// wrong magic, a bad length, a checksum mismatch — all of them leave RAM as it
// was, and `boot_target()` then falls through to the built-in flash payload
// exactly as it did before this file existed. That is deliberate: a bring-up
// board must not become unbootable because a card was missing.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "../koti.h"
#include "sdboot.h"

#define KOTI_SD_MAGIC   0x49544F4Bu
#define KOTI_SD_VERSION 1u
#define KOTI_SD_HDR_LBA 2048u

// Must match KERNEL_ADDR in sbi.c. Checked rather than trusted: the header says
// where it wants to be loaded, and a header asking for anywhere else is a
// header for a different machine.
#define SDBOOT_LOAD 0x01400000u

// 16 MB. RAM is 32 MB from 0x0100_0000 and the kernel lands 4 MB in, so this
// cannot run off the end; it exists to stop a corrupt `blocks` field from
// turning into a multi-minute read of nothing.
#define SDBOOT_MAX_BLOCKS 32768u

// Bounded, always — a card that stops answering must not hang the machine
// before it has even chosen what to boot.
static int sd_wait(unsigned mask, unsigned tries) {
    while (tries--)
        if (SD_CTRL & mask)
            return 1;
    return 0;
}

// Reads only the first `n` words of the block. The whole 512 bytes are already
// in the controller's buffer by the time SD_DONE rises, so stopping early costs
// nothing and saves putting a 512-byte buffer on a firmware stack.
static int sd_read_words(unsigned lba, unsigned *out, unsigned n) {
    SD_LBA  = lba;
    SD_CTRL = SD_START_RD;
    if (!sd_wait(SD_DONE, 4000000u))
        return 0;
    SD_DATA = 0;                        // rewind the buffer pointer
    for (unsigned i = 0; i < n; i++)
        out[i] = SD_DATA;
    return 1;
}

int sd_load_kernel(void) {
    unsigned hdr[8];

    SD_CTRL = SD_START_INIT;
    // Wait for READY **or ERR**, not READY alone. `sd_spi` gives up on its own
    // and raises `err` when nothing answers — which is exactly what happens on
    // a bench with no card model wired up, and what happened on hardware with a
    // deaf MISO pin. Polling only READY would spin the full timeout there:
    // ~8M iterations of firmware before Linux even starts, on every boot of
    // every simulation. Bailing on ERR makes the no-card case cost microseconds.
    // The budget is still long because ACMD41 can take a real card tens of ms.
    if (!sd_wait(SD_READY | SD_ERR, 8000000u))
        return 0;                       // never answered at all
    if (SD_CTRL & SD_ERR)
        return 0;                       // answered "no card"

    if (!sd_read_words(KOTI_SD_HDR_LBA, hdr, 8u))
        return 0;
    if (hdr[0] != KOTI_SD_MAGIC || hdr[1] != KOTI_SD_VERSION)
        return 0;                       // an ordinary card, not a koti boot card

    unsigned blocks = hdr[2];
    unsigned load   = hdr[3];
    unsigned want   = hdr[4];

    if (blocks == 0u || blocks > SDBOOT_MAX_BLOCKS)
        return 0;
    if (load != SDBOOT_LOAD)
        return 0;

    uart_puts("sd: loading kernel");

    volatile unsigned *dst = (volatile unsigned *)load;
    unsigned sum = 0u;

    for (unsigned b = 0; b < blocks; b++) {
        // Straight into RAM, a block at a time. The image is contiguous, so the
        // destination just walks forward — no scatter, no bounce buffer.
        SD_LBA  = KOTI_SD_HDR_LBA + 1u + b;
        SD_CTRL = SD_START_RD;
        if (!sd_wait(SD_DONE, 4000000u)) {
            uart_puts(" FAILED (block read timed out)\r\n");
            return 0;
        }
        SD_DATA = 0;
        for (unsigned i = 0; i < SD_BLOCK_WORDS; i++) {
            unsigned w = SD_DATA;
            *dst++ = w;
            sum += w;
        }
        // ~4 s of silence otherwise, which on a bring-up board is
        // indistinguishable from a hang.
        if ((b & 0x1FFu) == 0x1FFu)
            uart_putc('.');
    }

    // The checksum is the whole reason this is trustworthy. A truncated read, a
    // card that returned a stale buffer, or an image written to the wrong LBA
    // all produce a plausible-looking kernel that faults somewhere unhelpful
    // later; here they produce one clear line and a fallback to the payload.
    if (sum != want) {
        uart_puts(" FAILED (checksum)\r\n");
        return 0;
    }

    uart_puts(" ok\r\n");
    return 1;
}
