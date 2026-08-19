// sdtest.c — read the microSD card on real hardware and say what came back.
//
// The bring-up image for the SD rung, and the same shape as sw/bringup.c for the
// same reason: it prints FOREVER and never touches video, because programming
// the FPGA takes ~60 s and anything printed once is gone before a host can open
// the serial port. See fpga/ulx3s/README.md step 2b.
//
// WHAT IT ACTUALLY ESTABLISHES, in order, so a failure says which layer broke:
//   1. `SD_READY` after init  — the card answered CMD0/CMD8/ACMD41/CMD58, so the
//      four wires are right and the card is present and speaking SPI
//   2. block 0 reads          — CMD17 works and the buffer fills
//   3. the first 16 bytes AND the last 8 — the last 8 are the ones that matter.
//      A Windows-formatted MBR leaves its 446-byte bootstrap area all zeros, so
//      the head of block 0 reads identically on a healthy card and on a bus
//      stuck low; the 0x55AA signature at bytes 510-511 is the cheapest real
//      "this is the card's data and not a stuck bus" check. ⚠️ Earlier versions
//      of this header claimed that check while only printing the first 16 bytes
//   4. block 0 read TWICE     — identical both times, so the buffer is not
//      returning whatever the previous transfer left behind
//   5. a DIFFERENT block      — must differ from block 0. This is the one that
//      catches an address that is ignored, and on a formatted card the odds of
//      two blocks matching by accident are negligible
//
// ⚠️ It cannot check the CONTENT against an expectation: what is on the card is
// whatever the user wrote. So it checks the properties that hold for any card —
// repeatability and address-dependence — and prints the bytes for a human.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"

static void uart_hex8(unsigned v) {
    for (int i = 4; i >= 0; i -= 4)
        uart_putc("0123456789abcdef"[(v >> i) & 0xFu]);
}

static void uart_hex32(unsigned v) {
    for (int i = 28; i >= 0; i -= 4)
        uart_putc("0123456789abcdef"[(v >> i) & 0xFu]);
}

static void uart_udec(unsigned v) {
    char b[11];
    int i = 0;
    if (!v) { uart_putc('0'); return; }
    while (v && i < (int)sizeof(b)) { b[i++] = (char)('0' + v % 10u); v /= 10u; }
    while (i--) uart_putc(b[i]);
}

// Bounded, always. A card that never answers must not hang the machine — the
// whole point of a bring-up image is that it keeps talking even when the thing
// it is testing is dead.
static int sd_wait(unsigned mask, unsigned tries) {
    while (tries--)
        if (SD_CTRL & mask)
            return 1;
    return 0;
}

static int sd_read(unsigned lba, unsigned *out, unsigned nwords) {
    SD_LBA  = lba;
    SD_CTRL = SD_START_RD;
    if (!sd_wait(SD_DONE, 4000000u))
        return 0;
    SD_DATA = 0;                       // rewind the buffer pointer
    for (unsigned i = 0; i < nwords; i++)
        out[i] = SD_DATA;
    return 1;
}

int main(void) {
    unsigned pass = 0;
    static unsigned a[SD_BLOCK_WORDS], b[SD_BLOCK_WORDS];

    for (;;) {
        unsigned bad = 0;

        uart_puts("\r\nKoti-1 sdtest pass ");
        uart_udec(pass);
        uart_puts("\r\n  init: ");
        SD_CTRL = SD_START_INIT;
        if (!sd_wait(SD_READY, 4000000u)) {
            uart_puts("FAILED, status ");
            uart_hex32(SD_CTRL);
            uart_puts("\r\n  (no card, or the four wires are not the card's)\r\n");
            bad = 1;
        } else {
            uart_puts("OK\r\n");

            uart_puts("  block 0: ");
            if (!sd_read(0, a, SD_BLOCK_WORDS)) {
                uart_puts("read timed out\r\n");
                bad = 1;
            } else {
                for (unsigned i = 0; i < 4; i++) {
                    for (unsigned by = 0; by < 4; by++) {
                        uart_hex8((a[i] >> (8 * by)) & 0xFFu);
                        uart_putc(' ');
                    }
                }
                uart_puts("\r\n");

                // The END of block 0, which is where the evidence actually is.
                // A Windows/SD-Formatter MBR leaves the 446-byte bootstrap area
                // ALL ZEROS, so the first 16 bytes printed above are zeros on a
                // perfectly good card and prove nothing either way — which is
                // exactly how a stuck-low bus would look too. The partition
                // table and the 0x55AA signature live in the last 66 bytes, so
                // that is the part worth looking at. This is the check this
                // file's header claimed from the start but never performed.
                uart_puts("  block 0 tail: ");
                for (unsigned i = 126; i < 128; i++) {
                    for (unsigned by = 0; by < 4; by++) {
                        uart_hex8((a[i] >> (8 * by)) & 0xFFu);
                        uart_putc(' ');
                    }
                }
                // Bytes 510-511 are the high half of the last word, little-endian.
                unsigned sig = (a[127] >> 16) & 0xFFFFu;
                uart_puts(sig == 0xAA55u
                              ? "\r\n  55 aa PRESENT — genuinely the card's data\r\n"
                              : "\r\n  no 55 aa (unformatted card, or not the card's data)\r\n");

                // Repeatability: the same block twice must be identical.
                if (!sd_read(0, b, SD_BLOCK_WORDS)) {
                    uart_puts("  reread timed out\r\n");
                    bad = 1;
                } else {
                    unsigned diff = 0;
                    for (unsigned i = 0; i < SD_BLOCK_WORDS; i++)
                        if (a[i] != b[i]) diff++;
                    uart_puts("  reread: ");
                    if (diff) {
                        uart_puts("DIFFERS in ");
                        uart_udec(diff);
                        uart_puts(" words\r\n");
                        bad = 1;
                    } else {
                        uart_puts("identical\r\n");
                    }
                }

                // Address-dependence: a different block must read differently.
                // 12345 rather than 1, so a truncated or byte-swapped LBA on the
                // way into CMD17 shows up instead of landing somewhere plausible.
                if (!sd_read(12345, b, SD_BLOCK_WORDS)) {
                    uart_puts("  block 12345 timed out\r\n");
                    bad = 1;
                } else {
                    unsigned same = 1;
                    for (unsigned i = 0; i < SD_BLOCK_WORDS; i++)
                        if (a[i] != b[i]) { same = 0; break; }
                    uart_puts("  block 12345: ");
                    if (same) {
                        uart_puts("IDENTICAL to block 0 — the address is ignored\r\n");
                        bad = 1;
                    } else {
                        uart_puts("differs from block 0, as it must\r\n");
                    }
                }
            }
        }

        uart_puts(bad ? "  pass FAILED\r\n" : "  pass CLEAN\r\n");
        // LED7 latches any failure so a bad pass is visible after the fact.
        LED = (pass & 0x3Fu) | (bad ? 0x80u : (LED & 0x80u));

        for (volatile unsigned d = 0; d < 2000000u; d++)
            ;
        pass++;
    }
}
