// payload.c — S-mode test payload: exercises the whole SBI stack.
// Prints 'S' via SBI console, arms the SBI timer using rdtime (which
// itself round-trips through M's illegal-instruction emulation),
// takes the delegated S-timer interrupt ('T'), and finishes ('K').
#include <stdint.h>

static volatile int tick;

static inline void sbi_putchar(char c) {
    register uint32_t a0 asm("a0") = (uint32_t)c;
    register uint32_t a7 asm("a7") = 1;
    asm volatile("ecall" : "+r"(a0) : "r"(a7));
}

static inline void sbi_set_timer(uint32_t lo, uint32_t hi) {
    register uint32_t a0 asm("a0") = lo;
    register uint32_t a1 asm("a1") = hi;
    register uint32_t a7 asm("a7") = 0;
    asm volatile("ecall" : "+r"(a0) : "r"(a1), "r"(a7));
}

static inline uint32_t rdtime(void) {
    register uint32_t a0 asm("a0");
    asm volatile("csrr a0, time" : "=r"(a0));  // traps; M emulates
    return a0;
}

static inline int sbi_getchar(void) {
    register uint32_t a0 asm("a0");
    register uint32_t a7 asm("a7") = 2;
    asm volatile("ecall" : "=r"(a0) : "r"(a7));
    return (int)a0;
}

__attribute__((interrupt("supervisor")))
static void s_timer(void) {
    sbi_putchar('T');
    sbi_set_timer(0xFFFFFFFFu, 0xFFFFFFFFu);   // ack: clears STIP
    tick = 1;
}

void smain(void) {
    sbi_putchar('S');
    tick = 0;
    asm volatile("csrw stvec, %0" :: "r"((uint32_t)&s_timer));
    asm volatile("csrs sie, %0" :: "r"(1u << 5));   // STIE
    asm volatile("csrsi sstatus, 2");               // SIE
    sbi_set_timer(rdtime() + 5000u, 0);
    while (!tick)
        ;
    sbi_putchar('K');

    // From here on the payload is a terminal: poll the keyboard through SBI
    // and echo. This is what makes the machine interactive rather than a
    // program that prints three letters and stops, and it is the only way the
    // scancode path gets exercised end to end - RTL, MMIO, translator, SBI
    // call and console, in one loop.
    for (;;) {
        int c = sbi_getchar();
        if (c >= 0)
            sbi_putchar((char)c);
    }
}
