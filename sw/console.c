// console.c — 40x30 VGA text console over the PSRAM charbuf: cursor,
// newline, scroll. This grows into the SBI console putchar.
#include "koti.h"
#include "console.h"

#define CHARBUF 0x01008000u
#define COLS 40
#define ROWS 30

static volatile uint8_t *const cb = (volatile uint8_t *)CHARBUF;
static int cur_x, cur_y;

void con_init(void) {
    volatile uint32_t *w = (volatile uint32_t *)CHARBUF;
    for (int i = 0; i < COLS * ROWS / 4; i++)
        w[i] = 0x20202020u;          // spaces
    cur_x = 0;
    cur_y = 0;
    VGA_BASE = CHARBUF;
    VGA_COLOR = 0x0000003Fu;         // white on black
    VGA_CTRL = 1;                    // pins go VGA
}

static void scroll(void) {
    volatile uint32_t *w = (volatile uint32_t *)CHARBUF;
    for (int i = 0; i < COLS * (ROWS - 1) / 4; i++)
        w[i] = w[i + COLS / 4];
    for (int i = COLS * (ROWS - 1) / 4; i < COLS * ROWS / 4; i++)
        w[i] = 0x20202020u;
}

void con_putc(char c) {
    if (c == '\n') {
        cur_x = 0;
        cur_y++;
    } else if (c == '\r') {
        cur_x = 0;
    } else {
        cb[cur_y * COLS + cur_x] = (uint8_t)c;
        if (++cur_x == COLS) {
            cur_x = 0;
            cur_y++;
        }
    }
    if (cur_y == ROWS) {
        scroll();
        cur_y = ROWS - 1;
    }
}

void con_puts(const char *s) {
    while (*s)
        con_putc(*s++);
}
