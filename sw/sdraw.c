// sdraw.c — hand-clock CMD0 at the microSD card and print every byte that comes
// back, so that "the card is not there" and "the engine is wrong" stop being the
// same observation.
//
// WHY THIS IMAGE EXISTS. On 2026-08-07 `sdtest` returned `init: FAILED, status
// 00000004` (SD_ERR) on real hardware, while `tb_sd` and `tb_fpga_bram +mark=1`
// were both green in simulation and stayed green. Simulation cannot tell those
// two apart: `test/sd_model.sv` answers whenever it is clocked, so a green bench
// says the engine talks to a *model*, never that a card is electrically present.
// This image removes the engine from the question entirely — software drives
// CS/SCK/MOSI through the SD_RAW escape hatch and reads MISO straight off the
// pin (see src/sd_ctrl.sv).
//
// HOW TO READ THE OUTPUT — one round trip splits the problem:
//   idle MISO = 1 and every response byte ff
//        The card never drives the line. The pin's internal pull-up is all that
//        is holding it high, so: not seated, not powered, or sd_d[0] is not the
//        card's MISO. NOT an engine bug — do not touch sd_spi.sv.
//   idle MISO = 0, response bytes 00
//        Something is holding the line LOW. A pull-up cannot do that, so a driver
//        is: most likely the ESP32 still awake on the shared bus (the SD wires
//        ARE wifi_gpio2/4/12/13/14/15), or the wrong pin entirely.
//   any response byte with the top bit clear — 01 is the one CMD0 should give
//        THE CARD IS ALIVE AND SPEAKING SPI. The wires are right and the fault is
//        upstream in sd_spi.sv/sd_ctrl.sv, which is a completely different hunt.
//   R1 = 01 then CMD8 answers 01 aa
//        The card is fully conversational; only koti's init sequence is at fault.
//
// ⚠️ CLOCK RATE IS NOT INCIDENTAL HERE. The SD spec requires 100–400 kHz until
// the card is initialised. An MMIO write costs ~10 clocks at 25 MHz, so a naive
// bit-bang would clock at roughly 1.25 MHz — over the limit, which would make a
// perfectly good card stay silent and produce exactly the failure being chased.
// `half_period()` holds it near 60 kHz, comfortably inside the window and slow
// enough that marginal contact still works.
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

// Half a bit time. `volatile` so the loop survives -O2 — without it the compiler
// deletes the delay and the clock goes back over 400 kHz silently.
static void half_period(void) {
    for (volatile int i = 0; i < 40; i++)
        ;
}

// Long enough for a pin to settle through the board's own RC before it is read
// back — a few microseconds, which is many orders of magnitude more than the
// pin needs and costs nothing at one reading per pass.
static void settle(void) {
    for (volatile int i = 0; i < 200; i++)
        ;
}

// Chip select is held across whole commands, so it lives outside the bit loop.
// Starts deselected: asserting CS at a card before the 74 idle clocks is exactly
// what the spec says not to do.
static unsigned g_cs = SD_RAW_CSN;

// SPI mode 0: MOSI is presented while the clock is low, and both ends sample on
// the RISING edge. Sampling MISO anywhere else is the classic bit-bang bug that
// produces data shifted by one bit — which reads as garbage, not as silence.
static unsigned spi_bit(unsigned mosi) {
    unsigned b = SD_RAW_EN | g_cs | (mosi ? SD_RAW_MOSI : 0u);
    SD_RAW = b;                          // clock low, data presented
    half_period();
    SD_RAW = b | SD_RAW_SCK;             // rising edge
    unsigned in = SD_RAW & SD_RAW_MISO;  // sample here, with the clock high
    half_period();
    SD_RAW = b;                          // falling edge
    return in;
}

static unsigned spi_byte(unsigned out) {
    unsigned in = 0;
    for (int i = 7; i >= 0; i--)
        in = (in << 1) | spi_bit((out >> i) & 1u);
    return in & 0xFFu;
}

// Send a command and return the first byte whose top bit is clear, which is how
// SPI-mode SD marks the start of an R1 response. Every byte seen is printed, so
// a response that is malformed rather than absent is still visible.
static unsigned send_cmd(unsigned cmd, unsigned arg, unsigned crc) {
    spi_byte(0xFF);                      // one idle byte before the command
    spi_byte(0x40u | cmd);
    spi_byte((arg >> 24) & 0xFFu);
    spi_byte((arg >> 16) & 0xFFu);
    spi_byte((arg >>  8) & 0xFFu);
    spi_byte(arg & 0xFFu);
    spi_byte(crc);

    uart_puts("    bytes:");
    unsigned r1 = 0xFFu;
    for (int i = 0; i < 10; i++) {
        unsigned v = spi_byte(0xFF);
        uart_putc(' ');
        uart_hex8(v);
        if (r1 == 0xFFu && !(v & 0x80u))
            r1 = v;                      // first byte with the top bit clear
    }
    uart_puts("\r\n");
    return r1;
}

int main(void) {
    unsigned pass = 0;

    for (;;) {
        uart_puts("\r\nKoti-1 sdraw pass ");
        uart_udec(pass);
        uart_puts("\r\n");

        // Take the pins from the engine, park them at idle, and prove the write
        // landed. If the readback does not echo what was written, nothing below
        // means anything — the MMIO path is broken, not the card.
        g_cs = SD_RAW_CSN;
        SD_RAW = SD_RAW_EN | SD_RAW_CSN | SD_RAW_MOSI;
        unsigned rb = SD_RAW;
        uart_puts("  readback: ");
        uart_hex8(rb);
        uart_puts(rb & 0x2u ? "  (en+cs+mosi echoed, MMIO ok)\r\n"
                            : "  (WRITE DID NOT LAND — fix this first)\r\n");

        // The single most informative bit in this program: the line's resting
        // state, with the card deselected and nothing being clocked.
        uart_puts("  idle MISO: ");
        uart_putc((SD_RAW & SD_RAW_MISO) ? '1' : '0');
        uart_puts((SD_RAW & SD_RAW_MISO)
                      ? "  (high — pull-up, or the card driving idle)\r\n"
                      : "  (LOW — something is actively driving it)\r\n");

        // 80 clocks with CS HIGH. The card needs >=74 to wake into SPI mode, and
        // it must see them before chip select is ever asserted.
        uart_puts("  80 idle clocks with CS high\r\n");
        for (int i = 0; i < 10; i++)
            spi_byte(0xFF);

        // CMD0 GO_IDLE_STATE. CRC 0x95 is the fixed, mandatory one — CRC is off
        // in SPI mode except for CMD0 and CMD8, where the value is a constant.
        uart_puts("  CMD0 (expect R1 = 01):\r\n");
        g_cs = 0;                        // select
        unsigned r1 = send_cmd(0, 0, 0x95u);
        g_cs = SD_RAW_CSN;               // deselect
        spi_byte(0xFF);                  // trailing clocks so the card lets go

        uart_puts("  CMD0 R1: ");
        uart_hex8(r1);
        if (r1 == 0x01u)
            uart_puts("  *** THE CARD ANSWERED — wires are right ***\r\n");
        else if (r1 == 0xFFu)
            uart_puts("  no response at all (card silent)\r\n");
        else
            uart_puts("  unexpected, but the card IS driving the line\r\n");

        // Only worth asking if CMD0 worked: CMD8 tells a v2 card apart from a v1
        // one, and its R7 tail (00 00 01 aa) is unmistakable, so it is the second
        // independent proof that the bus is real and not a stuck pattern.
        if (r1 == 0x01u) {
            uart_puts("  CMD8 (expect 01 then 00 00 01 aa):\r\n");
            g_cs = 0;
            send_cmd(8, 0x1AAu, 0x87u);
            g_cs = SD_RAW_CSN;
            spi_byte(0xFF);
        }

        // ---- pin continuity ----------------------------------------------
        // Only meaningful when the card did not answer, and only safe with the
        // slot empty, so it is printed with that caveat attached rather than
        // silently. An INPUT that reads 0 cannot distinguish a silent card from
        // a pin that is not the card's MISO; an OUTPUT can.
        if (r1 != 0x01u) {
            unsigned base = SD_RAW_EN | SD_RAW_CSN | SD_RAW_MOSI | SD_RAW_MISO_OE;
            SD_RAW = base | SD_RAW_MISO_HI;
            settle();
            unsigned hi = SD_RAW & SD_RAW_MISO;
            SD_RAW = base;                       // drive low
            settle();
            unsigned lo = SD_RAW & SD_RAW_MISO;
            SD_RAW = SD_RAW_EN | SD_RAW_CSN | SD_RAW_MOSI;   // release

            uart_puts("  pin test (valid only with an EMPTY slot): driven 1 -> ");
            uart_putc(hi ? '1' : '0');
            uart_puts(", driven 0 -> ");
            uart_putc(lo ? '1' : '0');
            uart_puts("\r\n  verdict: ");
            if (hi && !lo)
                uart_puts("the pin FOLLOWS — J3 is real and free, so the fault "
                          "is contact with the card\r\n");
            else if (!hi)
                uart_puts("THE PIN CANNOT REACH 1 — held low by something, or "
                          "the site is wrong. No card will ever answer here\r\n");
            else
                uart_puts("stuck HIGH — the pin is not following the driver "
                          "either way\r\n");
        }

        // Hand the pins back, so a following image or a reset finds the engine in
        // charge rather than whatever the last bit-bang left on the wires.
        SD_RAW = 0;
        LED = (pass & 0x3Fu) | (r1 == 0x01u ? 0x40u : 0x80u);

        for (volatile unsigned d = 0; d < 3000000u; d++)
            ;
        pass++;
    }
}
