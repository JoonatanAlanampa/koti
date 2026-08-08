// memtest.c — walk the onboard SDRAM on real hardware and say what it found.
//
// WHY, precisely. Rung 0 (sw/bringup.c on the board, 2026-08-07) proved the
// SDRAM's read TIMING: `ra` goes to the stack and comes back on every printed
// line, and a read window off by one clock — the RD_ADV risk — is silent on
// writes and corrupts every read, so a working return proves the window. What it
// did NOT prove is ADDRESS COVERAGE. Everything rung 0 touched lives in the
// first few kilobytes of a 16 MB window: bank 0, row 0, a handful of columns.
//
// The failure this closes is the one that does not announce itself. A row or
// bank bit that is mis-wired, mis-ordered, or simply not decoded makes two
// different addresses the same location. Nothing faults; the machine just
// occasionally reads back something it never wrote — which under Linux is a
// corrupted page table or a returned-to garbage address, ten million
// instructions after the actual fault. `test/sdram_model.sv` has exactly this
// bug on purpose (it decodes 7 of 13 row bits) and no test noticed for weeks.
//
// SO THE PATTERN IS DERIVED FROM THE ADDRESS. That is the whole design of this
// file. Writing a constant everywhere and reading it back PASSES under total
// aliasing; writing f(address) fails at the first collision, and the failure
// report prints expected-vs-got, from which the aliased bit can be read off
// directly (got == f(other) tells you which address answered).
//
// It loops forever for the same reason bringup.c does: programming the FPGA
// takes ~60 s, so anything printed once has already gone by the time a host can
// open the port.
//
// ⚠️ THE 16 MB PHASE IS SUPPOSED TO FAIL IN SIMULATION. test/sdram_model.sv
// aliases every 128 KB (see SMALL_HI below), so a full-window pass reports
// thousands of mismatches there — correctly. Phase 1 is sized to fit inside that
// span so a sim run still exercises the code; the full walk is a HARDWARE test
// and its result is only meaningful on the board.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"

// The RAM window koti exposes is 32 MB, 0x0100_0000..0x02FF_FFFF. Start above
// the stack (__stack_top = 0x01008000) and the VGA charbuf that sits just over
// it — writing our own stack out from under ourselves would look exactly like a
// memory fault.
//
// ⚠️ IT WAS 16 MB UNTIL 2026-08-08, and this file is how that was found and how
// it is now defended. `addr[22]` used to BE the flash/RAM device select, so only
// 22 word-address bits reached the part and half the soldered SDRAM was
// unreachable — Linux reported `MemTotal: 8796 kB` on a 32 MB board. The old
// bound here was 0x0200_0000, which is exactly the boundary the bug sat on, so
// this test PASSED on the broken map. That is the failure mode the repo keeps
// meeting: a test whose bound is drawn at the edge of the thing it should be
// checking cannot fail, and reads as evidence anyway.
#define RAM_LO   0x01010000u
#define RAM_HI   0x03000000u
// The old bound, kept as a named phase. A run that passes `16M` and fails
// `upper` has the device-select bug specifically, rather than bad memory.
#define RAM_MID  0x02000000u
// 64 KB, and the bound is exact rather than round. test/sdram_model.sv's
// idx() is {ba, row[6:0], col}, while sdram_ctrl maps row = addr[20:8] on a
// 32-bit-WORD address — so the model drops row[7], which is word bit 15, which
// is BYTE offset 0x20000. Its contiguous span is therefore 128 KB and it aliases
// above that; the "~512 KB" quoted elsewhere is the array's total size across
// all four banks, and the banks only change at byte offset 8 MB.
// RAM_LO is at +64 KB, so this window ends exactly on the 128 KB boundary.
// ⭐ Measured, not reasoned: a 256 KB window here reported every word wrong, and
// each `got` was pat(address + 0x20000).
#define SMALL_HI 0x01020000u

#define MAX_REPORT 8

static void uart_hex(unsigned v) {
    for (int i = 28; i >= 0; i -= 4) {
        unsigned d = (v >> i) & 0xFu;
        uart_putc((char)(d < 10 ? '0' + d : 'a' + d - 10));
    }
}

static void uart_udec(unsigned v) {
    char buf[11];
    int i = 0;
    if (!v) { uart_putc('0'); return; }
    while (v && i < (int)sizeof(buf)) { buf[i++] = (char)('0' + v % 10u); v /= 10u; }
    while (i--) uart_putc(buf[i]);
}

// Multiplicative hash, not the address itself: an address stored verbatim makes
// a wrong-but-plausible read look right in a hex dump (0x01234560 vs
// 0x01234570 reads as a typo), and it puts a 0 in every high bit, so a stuck
// high data line would never show. This fills all 32 bits with something that
// changes in every bit when the address changes in one.
static inline unsigned pat(unsigned a) {
    unsigned h = a * 2654435761u;
    return h ^ (h >> 15);
}

static unsigned walk(unsigned lo, unsigned hi, const char *label) {
    volatile unsigned *p;
    unsigned errs = 0, reported = 0;

    uart_puts("  ");
    uart_puts(label);
    uart_puts(": write ");
    for (unsigned a = lo; a < hi; a += 4u) {
        p = (volatile unsigned *)a;
        *p = pat(a);
    }
    uart_puts("read ");
    for (unsigned a = lo; a < hi; a += 4u) {
        p = (volatile unsigned *)a;
        unsigned got = *p, want = pat(a);
        if (got != want) {
            errs++;
            if (reported < MAX_REPORT) {
                reported++;
                uart_puts("\r\n    MISMATCH @");
                uart_hex(a);
                uart_puts(" want ");
                uart_hex(want);
                uart_puts(" got ");
                uart_hex(got);
            }
        }
    }
    if (errs) {
        uart_puts("\r\n    errors: ");
        uart_udec(errs);
        uart_puts("\r\n");
    } else {
        uart_puts("OK\r\n");
    }
    return errs;
}

// Byte and halfword stores go through the controller's `be` lanes and the part's
// DQM pins, which the word walk above never touches. A dqm bit stuck low writes
// neighbouring bytes as well; stuck high drops the write entirely. Both corrupt
// a struct field and neither faults.
static unsigned lanes(void) {
    volatile unsigned char *b = (volatile unsigned char *)RAM_LO;
    volatile unsigned      *w = (volatile unsigned *)RAM_LO;
    unsigned errs = 0;

    uart_puts("  lanes: ");
    for (unsigned i = 0; i < 4096u; i += 4u) {
        w[i / 4u] = 0u;
        b[i + 0] = 0x11; b[i + 1] = 0x22; b[i + 2] = 0x33; b[i + 3] = 0x44;
    }
    for (unsigned i = 0; i < 4096u; i += 4u)
        if (w[i / 4u] != 0x44332211u) {
            if (!errs) {
                uart_puts("\r\n    MISMATCH @");
                uart_hex(RAM_LO + i);
                uart_puts(" want 44332211 got ");
                uart_hex(w[i / 4u]);
            }
            errs++;
        }
    if (errs) { uart_puts("\r\n    errors: "); uart_udec(errs); uart_puts("\r\n"); }
    else        uart_puts("OK\r\n");
    return errs;
}

// Walking-1 over the ADDRESS, which NAMES the broken bit instead of drowning
// the console in mismatches.
//
// A full 32 MB walk reports millions of errors when one address bit is dead and
// tells you nothing about WHICH — and at 115200 baud you see the first eight and
// a count. This writes an address-derived pattern to `base` and to
// `base + (1<<i)` for every word-address bit the window spans, then reads them
// all back. If bit i does not reach the part, `base + (1<<i)` answers with
// base's pattern, and the report says "bit 24" rather than "3.9 million errors".
//
// ⭐ Bit 24 is the one this exists for: a 16 MB offset is exactly the bit that
// `addr[22]`-as-device-select used to eat. This phase FAILS on the pre-2026-08-08
// map and passes after it, which is what makes it a test rather than a comment.
//
// ⚠️ In simulation against test/sdram_model.sv this reports several dead bits and
// is RIGHT to: that model decodes 7 of 13 row bits on purpose. Like the full
// walk, it is a hardware test. Against test/sim_mem.sv it is meaningful.
static unsigned addr_bits(void) {
    volatile unsigned *p;
    unsigned errs = 0;

    uart_puts("  addrbits: ");
    p = (volatile unsigned *)RAM_LO;
    *p = pat(RAM_LO);
    for (unsigned i = 2; i < 25u; i++) {
        unsigned a = RAM_LO + (1u << i);
        if (a >= RAM_HI) continue;
        p = (volatile unsigned *)a;
        *p = pat(a);
    }
    // Read back only AFTER every write: an alias that is written last would
    // otherwise be masked by checking each address immediately.
    p = (volatile unsigned *)RAM_LO;
    if (*p != pat(RAM_LO)) {
        uart_puts("\r\n    base @");
        uart_hex(RAM_LO);
        uart_puts(" clobbered, got ");
        uart_hex(*p);
        errs++;
    }
    for (unsigned i = 2; i < 25u; i++) {
        unsigned a = RAM_LO + (1u << i);
        if (a >= RAM_HI) continue;
        p = (volatile unsigned *)a;
        unsigned got = *p;
        if (got != pat(a)) {
            errs++;
            uart_puts("\r\n    BIT ");
            uart_udec(i);
            uart_puts(" dead @");
            uart_hex(a);
            uart_puts(" want ");
            uart_hex(pat(a));
            uart_puts(" got ");
            uart_hex(got);
            // Naming the aliasing partner is most of the diagnosis: if the
            // value is base's, bit i never reached the part at all.
            if (got == pat(RAM_LO)) uart_puts("  (= base: bit never arrives)");
        }
    }
    if (errs) { uart_puts("\r\n    errors: "); uart_udec(errs); uart_puts("\r\n"); }
    else        uart_puts("OK\r\n");
    return errs;
}

int main(void) {
    unsigned pass = 0;

    for (;;) {
        unsigned errs = 0;

        uart_puts("\r\nKoti-1 memtest pass ");
        uart_udec(pass);
        uart_puts("\r\n");

        errs += walk(RAM_LO, SMALL_HI, "64K ");
        errs += lanes();
        // Before the long walks, because it is seconds rather than minutes and
        // it names the bit. A failure here makes the walks below predictable
        // rather than informative.
        errs += addr_bits();
        errs += walk(RAM_LO, RAM_MID, "16M ");
        // The half that did not exist before 2026-08-08. Kept as its own phase
        // rather than folded into one 32 MB walk, so the log distinguishes
        // "the memory is bad" from "the upper half is not wired".
        errs += walk(RAM_MID, RAM_HI, "upper");

        uart_puts("  pass ");
        uart_udec(pass);
        errs ? uart_puts(" FAILED, errors: ") : uart_puts(" CLEAN, errors: ");
        uart_udec(errs);
        uart_puts("\r\n");

        // LED0..LED5 = pass count, LED7 = "some pass has failed", latching so a
        // failure that happened while nobody was watching is still visible.
        LED = (pass & 0x3F) | (errs ? 0x80u : (LED & 0x80u));
        pass++;
    }
}
