// usbtest.c — plug a USB keyboard into US2 and see whether koti hears it.
//
// The bring-up image for the keyboard rung, and the same shape as bringup.c and
// sdtest.c for the same reason: it prints FOREVER and never touches video,
// because programming the FPGA takes ~60 s and anything printed once is gone
// before a host can open the serial port.
//
// WHAT IT ESTABLISHES, in order, so a failure says which layer broke:
//   1. `typ` becomes 1        — a keyboard ENUMERATED. That is the whole USB
//      stack working: reset, SET_ADDRESS, GET_DESCRIPTOR, SET_CONFIGURATION,
//      boot protocol. Until this happens nothing else can.
//   2. `conerr` stays 0       — no connection or protocol error
//   3. keys arrive            — the report path, the 12 MHz -> 25 MHz crossing,
//      the held-to-pressed edge detection and the FIFO all work
//   4. the character is right — the HID usage table in usbkbd.c, and shift
//
// ⚠️ IT PRINTS THE RAW USAGE CODE AS WELL AS THE CHARACTER, on purpose. If the
// keyboard is a layout this table does not match, the usage codes will still be
// sane and only the characters wrong — which is a completely different problem
// from silence, and the two are indistinguishable if only characters are shown.
//
// ⚠️ US2 IS THE PORT NEXT TO THE POWER/JTAG ONE (US1). US1 is the FTDI serial
// port this output arrives on; plugging the keyboard in there does nothing at
// all, and is the first thing to check if `typ` stays 0.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"

static void uart_hex8(unsigned v) {
    for (int i = 4; i >= 0; i -= 4)
        uart_putc("0123456789abcdef"[(v >> i) & 0xFu]);
}

static void uart_udec(unsigned v) {
    char b[11];
    int i = 0;
    if (!v) { uart_putc('0'); return; }
    while (v && i < (int)sizeof(b)) { b[i++] = (char)('0' + v % 10u); v /= 10u; }
    while (i--) uart_putc(b[i]);
}

static const char *type_name(unsigned t) {
    switch (t) {
    case 0:  return "nothing";
    case 1:  return "KEYBOARD";
    case 2:  return "mouse";
    default: return "gamepad";
    }
}

int main(void) {
    unsigned last_typ = 99u;           // force a print on the first pass
    unsigned last_err = 99u;
    unsigned keys = 0;
    unsigned spin = 0;

    uart_puts("\r\nKoti-1 usbtest: plug a USB keyboard into US2 and type.\r\n"
              "  (US2 is the port NEXT TO the one this console arrives on)\r\n");

    for (;;) {
        // Status first, and from USB_STAT, which has no side effects. Reading
        // USB_KBD to check status would pop the queue and eat the keystroke.
        unsigned st  = USB_STAT;
        unsigned typ = USB_TYP(st);
        unsigned err = (st & USB_CONERR) ? 1u : 0u;

        // Only on CHANGE: a status line every pass would bury the keystrokes,
        // and enumeration is an event, not a level worth repeating.
        if (typ != last_typ) {
            uart_puts("\r\n  device: ");
            uart_puts(type_name(typ));
            uart_puts("\r\n");
            last_typ = typ;
        }
        if (err != last_err) {
            uart_puts(err ? "  conerr: SET (connection or protocol error)\r\n"
                          : "  conerr: clear\r\n");
            last_err = err;
        }

        unsigned v = USB_KBD;          // ⚠️ this POPS when USB_AVAIL is set
        if (v & USB_AVAIL) {
            unsigned usage = v & 0xFFu;
            unsigned mods  = USB_MODS(st);

            uart_puts("  key #");
            uart_udec(++keys);
            uart_puts(" usage=0x");
            uart_hex8(usage);
            uart_puts(" mods=0x");
            uart_hex8(mods);

            // The raw code is the evidence; the character is the interpretation.
            // Printing both is what tells a wrong keymap from a dead bus.
            uart_puts(" char='");
            if (usage >= 0x04u && usage <= 0x1Du) {
                char c = (char)('a' + usage - 0x04u);
                if (mods & USB_MOD_SHIFT) c = (char)(c - 32);
                uart_putc(c);
            } else if (usage == 0x28u) {
                uart_puts("\\n");
            } else if (usage == 0x2Cu) {
                uart_puts("space");
            } else {
                uart_putc('?');
            }
            uart_puts("'");
            if (v & USB_OVF)
                uart_puts("   [OVERFLOW - keys were dropped]");
            uart_puts("\r\n");

            LED = (unsigned char)usage;
        }

        // A slow heartbeat, so a board that is alive but hearing nothing is
        // distinguishable from one that has stopped. Every ~2 s.
        if (++spin == 400000u) {
            spin = 0;
            uart_putc('.');
        }
    }
}
