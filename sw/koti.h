// koti.h — Koti-1 memory map and helpers.
#ifndef KOTI_H
#define KOTI_H

// This header is included by sw/*.S as well as sw/*.c, so everything C-only
// lives behind __ASSEMBLER__ (gcc defines it for .S files, which it runs
// through the C preprocessor). The point is that the ASSEMBLY instruments read
// the SAME memory map as the C ones: a second copy of these addresses in a .S
// file is how the two silently drift apart, and an instrument that pokes the
// wrong register is worse than no instrument.
#ifndef __ASSEMBLER__
#include <stdint.h>
#define REG32(a) (*(volatile uint32_t *)(a))
#endif

// core MMIO. The _ADDR forms are the ones assembly uses; the REG32 forms below
// are the C spelling of the same number, so there is only one number.
#define LED_ADDR  0x00010000
#define UART_ADDR 0x00010004

#ifndef __ASSEMBLER__
#define LED       REG32(LED_ADDR)
#define UART      REG32(UART_ADDR)    // w: tx byte, r: bit0 = busy

// +0x10: the RECEIVE side. {ovf, avail, data[7:0]} -- reading POPS.
// ⛔ A SEPARATE ADDRESS FROM UART ON PURPOSE. uart_putc polls UART in a tight
// loop waiting for `busy`, so folding receive into that register would make
// every busy-poll eat an incoming byte.
#define UART_RX   REG32(0x00010010)   // ⚠️ READING POPS when UART_RX_AVAIL set
#define UART_RX_AVAIL 0x100u
#define UART_RX_OVF   0x200u

// ---- the ESP32 link at 0x0007_0000 (PLAN item 11, networking) -------------
// A second serial port on the ESP32's own pins, plus the straps that decide
// whether that chip is running at all.
//
// ⛔ ESP_EN RESETS TO 0 AND SHOULD STAY THERE UNLESS YOU MEAN IT. The ESP32's
// GPIOs ARE the microSD bus (GPIO2/4/12/13/14/15 = sd_d[0..3], sd_clk,
// sd_cmd), and koti loads its kernel off that card. Raising ESP_EN puts a
// second driver on those six wires; whether it actually drives them depends on
// the firmware the ESP32 boots, which is an experiment, not an assumption.
//
// ⚠️ ORDER: set ESP_GPIO0 first, THEN ESP_EN. A chip released from reset with
// gpio0 low comes up in serial download mode instead of booting its own flash.
#define ESP_DATA  REG32(0x00070000)   // w: tx byte. ⚠️ READING POPS when avail
#define ESP_STAT  REG32(0x00070004)   // r: no side effects (see below)
#define ESP_CTRL  REG32(0x00070008)   // rw: bit0 ESP_EN, bit1 ESP_GPIO0
#define ESP_COUNT REG32(0x0007000C)   // r: bytes received since reset
#define ESP_AVAIL     0x100u          // in ESP_DATA
#define ESP_OVF       0x200u          // in ESP_DATA
#define ESP_ST_TXBUSY 0x1u            // in ESP_STAT
#define ESP_ST_AVAIL  0x2u            // in ESP_STAT — ask HERE, not ESP_DATA
#define ESP_ST_OVF    0x4u            // in ESP_STAT
#define ESP_EN        0x1u            // in ESP_CTRL
#define ESP_GPIO0     0x2u            // in ESP_CTRL
#endif
#define GPIO_IN   REG32(0x00010008)
#define QSPI_CFG  REG32(0x0001000C)   // bit0 flash quad, bit1 PSRAM quad

// CLINT
#define MTIME_LO  REG32(0x00020010)
#define MTIME_HI  REG32(0x00020014)
#define MTIMECMP_LO REG32(0x00020008)
#define MTIMECMP_HI REG32(0x0002000C)

// VGA block
#define VGA_CTRL  REG32(0x00040000)   // bit0 VGA_EN, bit1 UART on B0
#define VGA_BASE  REG32(0x00040004)   // charbuf byte address
#define VGA_COLOR REG32(0x00040008)   // {bg[13:8], fg[5:0]}
// 0x0004000C was the PS/2 scancode word. PS/2 was REMOVED 2026-08-08 once the
// USB HID keyboard had typed on real hardware; the offset still decodes and
// reads zero. See USB_KBD below, which is the keyboard now.

// microSD (FPGA builds only — a TinyTapeout tile has no pin for a card).
// See src/sd_ctrl.sv. Poll SD_DONE, never SD_BUSY: sd_spi leaves `ready` high
// through a read and only toggles `busy`, and `busy` has not risen yet when the
// start write returns — so waiting on it can pass on a half-filled buffer.
#define SD_CTRL   REG32(0x00050000)   // w: bit0 init, bit1 read; r: status
#define SD_LBA    REG32(0x00050004)   // block number for the next read
#define SD_DATA   REG32(0x00050008)   // r: next word of the block, ptr++; w: rewind
#define SD_READY  0x1u                // initialised and idle
#define SD_BUSY   0x2u
#define SD_ERR    0x4u
#define SD_DONE   0x8u                // sticky: the buffer holds a full block
#define SD_START_INIT 0x1u
#define SD_START_RD   0x2u
// ---- writes (CMD24) ----
// ⚠️ The ENGINE gained CMD24 on 2026-08-07; before that the hardware could not
// write a block at all. Fill SD_WDATA with 128 words, then start.
// Order matters: SD_WREWIND, 128 x SD_WDATA, SD_LBA, then SD_START_WR.
#define SD_WDATA   REG32(0x00050010)   // w: push a word into the write buffer
#define SD_WREWIND REG32(0x00050014)   // w: rewind the fill pointer (value ignored)
#define SD_START_WR   0x4u
#define SD_BLOCK_WORDS 128u

// Bring-up escape hatch: drive the four wires from software and read MISO back.
// While SD_RAW_EN is set the `sd_spi` engine is disconnected from the pins, so
// nothing else may touch the card. WRITE bits and READ bits are NOT the same
// map — reading gives MISO in bit0, which is the whole point of the register.
#define SD_RAW      REG32(0x0005000C)
#define SD_RAW_EN    0x1u             // w: take the pins away from the engine
#define SD_RAW_CSN   0x2u             // w: chip select, active LOW
#define SD_RAW_SCK   0x4u             // w: clock
#define SD_RAW_MOSI  0x8u             // w: data out
#define SD_RAW_MISO  0x1u             // r: the card's data line, live off the pin
// Pin-continuity test. ⚠️ THE SLOT MUST BE EMPTY — this drives a pin the card
// also drives. It answers the one question an input cannot: whether the pin can
// be pulled to 1 at all. On a board whose resting level is low, "the card is
// silent" and "this is not the card's MISO" are the same reading otherwise.
#define SD_RAW_MISO_OE 0x10u          // w: drive MISO from the FPGA
#define SD_RAW_MISO_HI 0x20u          // w: the value to drive

// USB HID keyboard on US2 (FPGA builds only). See src/usb_kbd.sv.
// The CODE IS A HID USAGE, not a character and not a PS/2 scancode —
// sw/usbkbd.c translates it, and carries the Finnish keymap. The `avail` and
// `ovf` bit positions were chosen to match the PS/2 register this replaced,
// which is why they sit at 8 and 9 rather than 0 and 1.
// ⚠️ READING USB_KBD POPS the queue when USB_AVAIL is set. Read it once.
#define USB_KBD   REG32(0x00060000)   // ⚠️ READING POPS when USB_AVAIL is set
#define USB_STAT  REG32(0x00060004)   // status + live modifiers, NO side effects
// ⛔ +0x08 IS LINUX'S, NOT THE FIRMWARE'S. Same layout as USB_KBD and it POPS
// the same way, but it has its OWN read pointer and overflow bit over the same
// entries, so the two consumers do not steal each other's keystrokes. The
// firmware must never read it and sw/linux/koti_kbd.c must never read USB_KBD:
// that is the whole point of there being two.
#define USB_KBD_LINUX 0x00060008u

// +0x0C: keystrokes OFFERED since reset. Free-running, READ-ONLY, NO side
// effects — unlike +0x00 and +0x08, this one may be read as often as you like.
// The difference between two samples a second apart is the rate at which the
// USB path is producing keystrokes, which is the measurement the 2026-08-09
// hunt lacked: a real keyboard cannot exceed ~125/s, so anything far above
// that is the host core free-running rather than a person typing.
#define USB_KBD_CNT REG32(0x0006000C)
#define USB_AVAIL  0x100u
#define USB_OVF    0x200u             // sticky; cleared by the read that sees it
// From USB_STAT only. Status is in the other register on purpose: a "is a
// keyboard there?" check must not eat the keystroke it was asked about.
#define USB_MODS(v) ((v) & 0xFFu)
#define USB_TYP(v)  (((v) >> 8) & 3u) // 0 none, 1 keyboard, 2 mouse, 3 gamepad
#define USB_CONERR  0x400u
// HID modifier bits, as the boot protocol defines them.
#define USB_MOD_LCTRL  0x01u
#define USB_MOD_LSHIFT 0x02u
#define USB_MOD_LALT   0x04u
#define USB_MOD_RCTRL  0x10u
#define USB_MOD_RSHIFT 0x20u
#define USB_MOD_RALT   0x40u
#define USB_MOD_SHIFT  (USB_MOD_LSHIFT | USB_MOD_RSHIFT)
#define USB_MOD_CTRL   (USB_MOD_LCTRL  | USB_MOD_RCTRL)

#ifndef __ASSEMBLER__
static inline void uart_putc(char c) {
    while (UART & 1)
        ;
    UART = (uint8_t)c;
}

static inline void uart_puts(const char *s) {
    while (*s)
        uart_putc(*s++);
}
#endif  // __ASSEMBLER__

#endif  // KOTI_H
