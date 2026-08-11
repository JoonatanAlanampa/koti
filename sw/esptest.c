// esptest.c — the bring-up image for the ESP32 link, and the EXPERIMENT that
// decides whether that link can coexist with the microSD.
//
// WHY THIS EXISTS. koti's only plausible route to a network is the ESP32 that
// is already on this board, over the serial pair on K3/K4 (src/esp_uart.sv).
// But the ESP32's GPIOs ARE the microSD bus — upstream's constraint file says
// so and ulx3s_top.sv repeats it:
//     sd_clk = GPIO14   sd_cmd = GPIO15   sd_d[0] = GPIO2
//     sd_d[1] = GPIO4   sd_d[2] = GPIO12  sd_d[3] = GPIO13
// and koti loads its kernel off that card. So the question that gates all of
// PLAN item 11 is not "does the UART work", it is:
//
//     DOES AN ESP32 THAT IS AWAKE BREAK THE MICROSD, AND IS IT REVERSIBLE?
//
// That cannot be reasoned out from a datasheet, because the answer depends on
// what the ESP32's own firmware does with those pins after boot. It is an
// experiment, and this image is the experiment — automated end to end so the
// answer does not depend on a human watching two things at once.
//
// THE SEQUENCE, and each step exists to remove one way of being fooled:
//   1. init the card and read block 0 THREE times, keeping a checksum.
//      Three, not one: a baseline that is itself flaky proves nothing about
//      what happens later, and the whole verdict rests on this comparison.
//   2. report the ESP32 port with the chip still held in reset. Bytes arriving
//      HERE would mean the receiver is picking up noise, and every later
//      "the link works" reading would be worthless.
//   3. raise ESP_GPIO0, THEN ESP_EN. In that order: a chip released from reset
//      with gpio0 low comes up in serial download mode instead of booting its
//      own flash.
//   4. watch the link. An ESP32 leaving reset PRINTS — its ROM bootloader
//      talks first, then whatever app it holds. ⚠️ The ROM log is 74880 baud
//      and this port is 115200, so expect GARBAGE CHARACTERS, not text. That
//      is fine and is the point: bytes arriving AT ALL prove the wire, the
//      pin sites and the receiver. Legible text would be a bonus.
//   5. re-read block 0 and compare against the baseline checksum.
//   6. put the ESP32 back into reset and read the card a third time, which
//      answers the question the user will actually care about: if it breaks,
//      does it come back, or is the machine wedged until power-cycle?
//
// It then prints a one-line VERDICT and repeats forever, like every other
// bring-up image here, because programming the FPGA takes ~60 s and anything
// printed once is gone before a host can open the port.
//
// ⛔ THIS IMAGE IS THE ONLY THING IN THE REPO THAT RAISES ESP_EN. Every other
// build leaves esp_uart.sv's control register at its reset value of 0, which
// holds the ESP32 in reset exactly as the hardwired assignment used to.
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

static void spin(unsigned n) { while (n--) __asm__ volatile ("" ::: "memory"); }

// Bounded, always: a dead card must not hang the instrument that is measuring
// it. Same rule as sdtest.c.
static int sd_wait(unsigned mask, unsigned tries) {
    while (tries--)
        if (SD_CTRL & mask)
            return 1;
    return 0;
}

// A checksum of block 0 rather than the bytes themselves. What is on the card
// is whatever the user wrote, so the only properties worth testing are the ones
// that hold for ANY card: that the same block reads the same twice, and that it
// stops doing so when something breaks the bus.
static int sd_sum(unsigned lba, unsigned *sum_out) {
    unsigned sum = 0;
    SD_LBA  = lba;
    SD_CTRL = SD_START_RD;
    if (!sd_wait(SD_DONE, 4000000u))
        return 0;
    SD_DATA = 0;                       // rewind the buffer pointer
    for (unsigned i = 0; i < SD_BLOCK_WORDS; i++)
        sum += SD_DATA + i;            // + i so a buffer of zeros is not a
                                       // fixed point of the checksum
    *sum_out = sum;
    return 1;
}

// Drain whatever the ESP32 has sent, printing it as hex, and return the count.
// Hex, not characters: at a baud rate we do not match this is not text, and
// printing it as text would invite reading meaning into noise.
static unsigned esp_drain(unsigned budget, unsigned show) {
    unsigned got = 0;
    while (budget--) {
        if (ESP_STAT & ESP_ST_AVAIL) {
            unsigned v = ESP_DATA;     // this POPS
            if (got < show) {
                uart_hex8(v & 0xFFu);
                uart_putc(' ');
            }
            got++;
        }
    }
    return got;
}

// ---- 4b's instrument -------------------------------------------------------
//
// Capture FIRST, print AFTERWARDS, and the separation is the point: the console
// UART runs at the same 115200 as the link, so a loop that printed each byte as
// it arrived would spend as long transmitting as receiving and fall behind the
// far end. The 64-byte FIFO absorbs a little of that and then drops the rest —
// silently, and precisely during the burst worth reading. A tight poll into a
// buffer cannot fall behind for the same reason.
//
// ⚠️ Bytes past the buffer are counted but not kept, so a truncated dump is
// reported as truncated rather than looking like the far end stopped talking.
static unsigned char espbuf[1024];

// Print what esp_capture() kept, as text. CR and LF pass through so the far
// end's own line structure shows; everything else non-printable becomes '.',
// so a stray byte cannot move the cursor or eat the report printed around it.
static void esp_show(unsigned n) {
    unsigned i, lim = (n < sizeof espbuf) ? n : (unsigned)sizeof espbuf;
    for (i = 0; i < lim; i++) {
        unsigned c = espbuf[i];
        if (c == 13u || c == 10u || (c >= 32u && c < 127u))
            uart_putc(c);
        else
            uart_putc('.');
    }
    if (n > sizeof espbuf) uart_puts("\r\n[TRUNCATED to 1024]");
}

static unsigned esp_capture(unsigned budget) {
    unsigned got = 0;
    while (budget--) {
        if (ESP_STAT & ESP_ST_AVAIL) {
            unsigned v = ESP_DATA & 0xFFu;      // this POPS
            if (got < sizeof espbuf) espbuf[got] = (unsigned char)v;
            got++;
        }
    }
    return got;
}

int main(void) {
    unsigned pass = 0;

    for (;;) {
        unsigned base = 0, after = 0, back = 0;
        int have_base = 0, have_after = 0, have_back = 0;
        unsigned quiet, awake;

        uart_puts("\r\n=== koti esptest pass ");
        uart_udec(pass);
        uart_puts(" ===\r\n");

        // ---- 1. the baseline -------------------------------------------
        uart_puts("1. microSD baseline: init ");
        SD_CTRL = SD_START_INIT;
        if (!sd_wait(SD_READY, 4000000u)) {
            uart_puts("FAILED, status ");
            uart_hex32(SD_CTRL);
            uart_puts("\r\n   no card? the rest of this test cannot mean anything\r\n");
        } else {
            uart_puts("OK, block 0 x3: ");
            have_base = 1;
            for (unsigned i = 0; i < 3; i++) {
                unsigned s;
                if (!sd_sum(0, &s)) { have_base = 0; break; }
                if (i == 0) base = s;
                else if (s != base) { have_base = 0; break; }
            }
            if (have_base) { uart_puts("stable "); uart_hex32(base); }
            else uart_puts("UNSTABLE — baseline is worthless, stop here");
            uart_puts("\r\n");
        }

        // ---- 2. the link with the ESP32 still in reset ------------------
        uart_puts("2. link, ESP32 held in reset: ctrl=");
        uart_hex32(ESP_CTRL);
        uart_puts(" bytes=");
        quiet = esp_drain(20000u, 8);
        uart_udec(quiet);
        if (quiet) uart_puts("  ⚠️ NOISE — nothing should arrive yet");
        uart_puts("\r\n");

        // ---- 3+4. wake it and listen ------------------------------------
        // ⚠️ THE CI MARKER IS THIS LINE, not the VERDICT, and the budget below
        // is why: listening long enough for an ESP32 to boot and print is
        // ~seconds at 25 MHz, far past what any simulation reaches. Gating here
        // proves the image ran the card baseline, read ESP_CTRL and got to the
        // straps — everything a bench can honestly check. What the hardware
        // answers afterwards is the experiment, and a gate that demanded a
        // particular verdict would be asserting a result nobody has measured.
        uart_puts("3. waking: gpio0 first, then enable\r\n");
        ESP_CTRL = ESP_GPIO0;
        spin(20000u);
        ESP_CTRL = ESP_GPIO0 | ESP_EN;
        // ⛔ CAPTURE, do not drain. esp_drain() POPS every byte and shows the
        // first 16, so by the time step 4b looked, the FIFO was empty and the
        // far end had long since stopped talking — 4b printed "bytes=0" and
        // that reads exactly like a chip that boots and says nothing. It is
        // not: those 477 bytes had already been read and thrown away HERE.
        // Measured 2026-08-11, on the run that was supposed to answer the
        // MicroPython question and instead answered a question about itself.
        uart_puts("4. link, ESP32 awake: bytes=");
        awake = esp_capture(4000000u);
        {
            unsigned i, lim = (awake < 16u) ? awake : 16u;
            for (i = 0; i < lim; i++) {
                uart_hex8(espbuf[i]);
                uart_putc(' ');
            }
        }
        uart_udec(awake);
        uart_puts(awake ? "  <- THE LINK CARRIES DATA\r\n"
                        : "  (silence: wire, baud or ESP32 firmware)\r\n");

        // ---- 4b. what the ESP32 actually SAYS ---------------------------
        //
        // ⭐ THE PREDICTION ABOVE THAT THIS WOULD BE GARBAGE IS WRONG ON THIS
        // BOARD, measured 2026-08-11: the 16 bytes line 4 printed decode to
        // "ts Jul 29 2019 1", the tail of the ROM banner. 74880 baud is what
        // an ESP32 with a 26 MHz crystal does; this module has a 40 MHz
        // crystal, so its ROM log comes out at 115200 and reads perfectly.
        //
        // So the hex dump is no longer the most informative thing available,
        // and this step exists to answer what line 4 structurally could not:
        // the chip talks, but does it get all the way to MicroPython? Line 4's
        // budget is well under a second — enough for the ROM banner and
        // nothing after it. The REPL prompt is the thing usr/bin/koti-net
        // depends on, and until it appears here it is an assumption.
        //
        // Look for `>>>`. `ets`/`rst:`/`boot:` alone means the chip reached its
        // ROM bootloader and stopped, which is a firmware question, not a wire
        // one — and a different problem from silence.
        uart_puts("4b. what it SAID — step 4's bytes, then ~10 s more.\r\n");
        uart_puts("---- 8< ----\r\n");
        esp_show(awake);                    // what step 4 already captured
        {
            unsigned more = esp_capture(60000000u);
            esp_show(more);                 // and anything that follows
            uart_puts("\r\n---- 8< ----\r\n4b. step-4 bytes=");
            uart_udec(awake);
            uart_puts(" then ");
            uart_udec(more);
            uart_puts(" more\r\n");
        }

        // ---- 5. the card, with the ESP32 awake --------------------------
        uart_puts("5. microSD with ESP32 AWAKE: ");
        if (sd_sum(0, &after)) {
            have_after = 1;
            uart_hex32(after);
            uart_puts(after == base ? "  same" : "  DIFFERENT");
        } else uart_puts("read FAILED");
        uart_puts("\r\n");

        // ---- 6. and does it recover -------------------------------------
        ESP_CTRL = 0;                  // straight back into reset
        spin(200000u);
        uart_puts("6. microSD after ESP32 back in reset: ");
        if (sd_sum(0, &back)) {
            have_back = 1;
            uart_hex32(back);
            uart_puts(back == base ? "  same" : "  DIFFERENT");
        } else uart_puts("read FAILED");
        uart_puts("\r\n");

        // ---- the verdict -------------------------------------------------
        uart_puts("VERDICT: ");
        if (!have_base)
            uart_puts("INCONCLUSIVE — no stable card baseline");
        else if (have_after && after == base)
            uart_puts("the card SURVIVES an awake ESP32");
        else if (have_back && back == base)
            uart_puts("the ESP32 BREAKS the card, and it RECOVERS on reset");
        else
            uart_puts("the ESP32 BREAKS the card and it did NOT recover");
        uart_puts(awake ? "; link carried data\r\n" : "; link silent\r\n");

        pass++;
    }
    return 0;
}
