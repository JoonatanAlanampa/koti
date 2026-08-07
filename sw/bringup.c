// bringup.c — the image to flash when the question is "is this board alive?".
//
// WHY THIS EXISTS RATHER THAN sw/hello.c. hello.c prints its banner about 5 ms
// after reset and then calls con_init(), which sets VGA_EN — and VGA_EN moves
// the UART from uo[0] to uo[6] and turns uo[0] into an RGB bit. On the bench
// that produces two problems at once:
//
//   1. Nothing that opens the serial port AFTER flashing can ever see the
//      banner. Programming the FPGA takes ~60 seconds and the banner is gone
//      5 ms after it finishes; no host process wins that race, so reading it
//      requires a human pressing BTN0 at the right moment.
//   2. What the port DOES see is the video raster being decoded as serial
//      noise — measured 2026-08-07: 219,995 bytes of mojibake in five minutes,
//      from a machine that was working perfectly.
//
// So this image prints FOREVER and never touches video. Flash it, open the
// port whenever, and the board either says this or it does not. No button, no
// window, no ambiguity — and the failure modes stay distinguishable: silence
// means the CPU is not running, mojibake means the divisor or the pin is wrong,
// and a clean line means the whole path works.
//
// WHAT A LINE OF IT PROVES, which is the reason it prints a counter and a
// pattern rather than just a string:
//   - the fabric (or Pmod) flash answers 03h and the CPU executes out of it
//   - the SDRAM serves the stack: uart_puts is a call, and `n` lives across it
//   - the arbiter and the I-cache are moving instructions
//   - 0123456789 abcdefghijklmnopqrstuvwxyz walks every bit position through
//     the UART shifter, so a stuck data bit shows up as a wrong CHARACTER
//     rather than as a subtly wrong number nobody checks
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"

// Decimal, by hand: there is no libc here and a %u would pull in one.
static void uart_udec(unsigned v) {
    char buf[11];
    int i = 0;
    if (v == 0) {
        uart_putc('0');
        return;
    }
    while (v && i < (int)sizeof(buf)) {
        buf[i++] = (char)('0' + (v % 10u));
        v /= 10u;
    }
    while (i--)
        uart_putc(buf[i]);
}

int main(void) {
    unsigned n = 0;

    for (;;) {
        uart_puts("Koti-1: hello from my own SoC #");
        uart_udec(n);
        uart_puts(" 0123456789 abcdefghijklmnopqrstuvwxyz\r\n");

        // LED0..LED5 count the lines, which is the one liveness signal that
        // needs no serial port at all. Written before the delay so a board
        // whose UART is misrouted still visibly counts.
        LED = (n & 0x3F);

        // ~0.4 s at 25 MHz, by counting rather than by timer: the point of
        // this image is to depend on as little as possible. `volatile` because
        // -O2 deletes an empty loop, which would turn the delay into a
        // full-speed flood that is unreadable on a terminal.
        for (volatile unsigned d = 0; d < 400000u; d++)
            ;

        n++;
    }
}
