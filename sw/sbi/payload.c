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

// A v0.2-and-later SBI call: {a7=EID, a6=FID} in, {a0=error, a1=value} out.
// Distinct from the legacy shape above, which returns a bare value in a0.
struct sbiret { int32_t error; uint32_t value; };

static inline struct sbiret sbi_call(uint32_t eid, uint32_t fid,
                                     uint32_t arg0, uint32_t arg1) {
    register uint32_t a0 asm("a0") = arg0;
    register uint32_t a1 asm("a1") = arg1;
    register uint32_t a6 asm("a6") = fid;
    register uint32_t a7 asm("a7") = eid;
    asm volatile("ecall" : "+r"(a0), "+r"(a1) : "r"(a6), "r"(a7) : "memory");
    struct sbiret r = { (int32_t)a0, a1 };
    return r;
}

#define EXT_BASE 0x10u
#define EXT_TIME 0x54494D45u

// Deliberately the TIME EXTENSION, not the legacy call. The timer is the one
// SBI service this payload can prove end to end — the 'T' printed by the
// interrupt handler is only reachable if the call was dispatched, mtimecmp was
// armed and the interrupt was delegated. Routing it through the v0.2 path means
// the existing `STK` assertion in test/test.py is now also the regression test
// for the extension dispatch, with no new output to keep in sync.
static inline void sbi_set_timer(uint32_t lo, uint32_t hi) {
    sbi_call(EXT_TIME, 0, lo, hi);
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

    // The handshake Linux performs before it trusts any SBI service: ask for
    // the spec version, then probe each extension. A kernel that gets an error
    // here silently assumes v0.1 and takes the legacy path, so a firmware bug
    // in this area does not announce itself — it just quietly costs you the
    // modern interface. Failing loudly with 'X' instead means the pin-level
    // test sees "SX" where it expects "STK", which is a real assertion.
    struct sbiret v = sbi_call(EXT_BASE, 0, 0, 0);       // get_spec_version
    struct sbiret p = sbi_call(EXT_BASE, 3, EXT_TIME, 0); // probe_extension
    if (v.error != 0 || v.value < 2u || p.error != 0 || p.value != 1u) {
        sbi_putchar('X');
        for (;;)
            ;
    }

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
