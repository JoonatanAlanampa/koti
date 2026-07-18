// hello.c — first C on Koti-1: banner over UART (headless pins), then
// the console comes up on the VGA charbuf.
#include "koti.h"
#include "console.h"

int main(void) {
    uart_puts("Koti-1: hello from my own SoC\r\n");

    con_init();
    con_puts("KOTI-1\n");
    con_puts("hello, visible world");

    LED = 0x2A;
    for (;;)
        ;
}
