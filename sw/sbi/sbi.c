// sbi.c — Koti-1 SBI firmware: legacy console + timer, the M->S timer
// injection, and rdtime/rdtimeh emulation through the illegal-
// instruction trap (mtval carries the instruction).
#include "../koti.h"
#include "../console.h"

#define csr_read(c) ({ uint32_t v_; \
    asm volatile("csrr %0, " #c : "=r"(v_)); v_; })
#define csr_write(c, v) asm volatile("csrw " #c ", %0" :: "r"(v))
#define csr_set(c, v)   asm volatile("csrs " #c ", %0" :: "r"(v))
#define csr_clear(c, v) asm volatile("csrc " #c ", %0" :: "r"(v))

// saved-register slots in the trap frame (see sbi.S)
#define A0 4
#define A1 5
#define A7 11

void sbi_init(void) {
    con_init();
    VGA_CTRL = 3;                // VGA on + UART mirrored on blue LSB
}

static void putc_both(char c) {
    uart_putc(c);
    con_putc(c);
}

// map an rd field onto its trap-frame slot (caller-saved regs only —
// the payload/kernel receives rdtime results in those by ABI)
static int rd_slot(uint32_t rd) {
    if (rd == 1) return 0;
    if (rd >= 5 && rd <= 7) return 1 + (int)(rd - 5);
    if (rd >= 10 && rd <= 17) return 4 + (int)(rd - 10);
    if (rd >= 28 && rd <= 31) return 12 + (int)(rd - 28);
    return -1;
}

void sbi_trap(uint32_t cause, uint32_t *r) {
    if (cause == 0x80000007u) {          // M timer: inject S timer
        csr_set(mip, 1u << 5);           // STIP
        csr_clear(mie, 1u << 7);         // mask MTIE until set_timer
        return;
    }
    if (cause == 9u) {                   // ecall from S = SBI call
        switch (r[A7]) {
        case 0:                          // legacy set_timer(lo, hi)
            MTIMECMP_LO = 0xFFFFFFFFu;
            MTIMECMP_HI = r[A1];
            MTIMECMP_LO = r[A0];
            csr_clear(mip, 1u << 5);
            csr_set(mie, 1u << 7);
            r[A0] = 0;
            break;
        case 1:                          // legacy console_putchar
            putc_both((char)r[A0]);
            r[A0] = 0;
            break;
        case 2:                          // legacy console_getchar
            r[A0] = (uint32_t)-1;        // keyboard hookup pending
            break;
        default:
            r[A0] = (uint32_t)-2;        // SBI_ERR_NOT_SUPPORTED
        }
        csr_write(mepc, csr_read(mepc) + 4);
        return;
    }
    if (cause == 2u) {                   // illegal: rdtime emulation
        uint32_t instr = csr_read(mtval);
        uint32_t csrn = instr >> 20;
        int slot = rd_slot((instr >> 7) & 31u);
        if ((instr & 0x7Fu) == 0x73u && ((instr >> 12) & 7u) == 2u
            && ((instr >> 15) & 31u) == 0u && slot >= 0
            && (csrn == 0xC01u || csrn == 0xC81u)) {
            r[slot] = (csrn == 0xC01u) ? MTIME_LO : MTIME_HI;
            csr_write(mepc, csr_read(mepc) + 4);
            return;
        }
    }
    putc_both('!');                      // firmware panic
    asm volatile("ebreak");
}
