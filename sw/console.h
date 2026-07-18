// console.h — VGA text console (40x30 charbuf in PSRAM).
#ifndef CONSOLE_H
#define CONSOLE_H

void con_init(void);
void con_putc(char c);
void con_puts(const char *s);

#endif
