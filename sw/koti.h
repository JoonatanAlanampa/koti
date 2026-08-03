// koti.h — Koti-1 memory map and helpers.
#ifndef KOTI_H
#define KOTI_H

#include <stdint.h>

#define REG32(a) (*(volatile uint32_t *)(a))

// core MMIO
#define LED       REG32(0x00010000)
#define UART      REG32(0x00010004)   // w: tx byte, r: bit0 = busy
#define GPIO_IN   REG32(0x00010008)
#define QSPI_CFG  REG32(0x0001000C)   // bit0 flash quad, bit1 PSRAM quad

// CLINT
#define MTIME_LO  REG32(0x00020010)
#define MTIME_HI  REG32(0x00020014)
#define MTIMECMP_LO REG32(0x00020008)
#define MTIMECMP_HI REG32(0x0002000C)

// VGA / PS2 block
#define VGA_CTRL  REG32(0x00040000)   // bit0 VGA_EN, bit1 UART on B0
#define VGA_BASE  REG32(0x00040004)   // charbuf byte address
#define VGA_COLOR REG32(0x00040008)   // {bg[13:8], fg[5:0]}
// {ovf[9], avail[8], scancode[7:0]}, read clears avail AND ovf.
// ovf = a byte arrived on top of an unread one, i.e. one was lost; any
// decoder holding E0/F0 prefix state must throw it away when it sees this.
#define PS2_DATA  REG32(0x0004000C)
#define PS2_AVAIL 0x100u
#define PS2_OVF   0x200u

static inline void uart_putc(char c) {
    while (UART & 1)
        ;
    UART = (uint8_t)c;
}

static inline void uart_puts(const char *s) {
    while (*s)
        uart_putc(*s++);
}

#endif
