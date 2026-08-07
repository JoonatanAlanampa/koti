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

// The RAM window koti exposes is 16 MB (addr[22] selects flash/RAM, leaving
// 22 word-address bits). Start above the stack (__stack_top = 0x01008000) and
// the VGA charbuf that sits just over it — writing our own stack out from under
// ourselves would look exactly like a memory fault.
#define RAM_LO   0x01010000u
#define RAM_HI   0x02000000u
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

int main(void) {
    unsigned pass = 0;

    for (;;) {
        unsigned errs = 0;

        uart_puts("\r\nKoti-1 memtest pass ");
        uart_udec(pass);
        uart_puts("\r\n");

        errs += walk(RAM_LO, SMALL_HI, "64K ");
        errs += lanes();
        errs += walk(RAM_LO, RAM_HI, "16M ");

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
