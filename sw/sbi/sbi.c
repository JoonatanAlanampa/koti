// sbi.c — Koti-1 SBI firmware: legacy console + timer, the M->S timer
// injection, and rdtime/rdtimeh emulation through the illegal-
// instruction trap (mtval carries the instruction).
#include "../koti.h"
#include "../console.h"
#include "sdboot.h"
#ifdef KOTI_ULX3S
#include "../usbkbd.h"
#endif

#define csr_read(c) ({ uint32_t v_; \
    asm volatile("csrr %0, " #c : "=r"(v_)); v_; })
#define csr_write(c, v) asm volatile("csrw " #c ", %0" :: "r"(v))
#define csr_set(c, v)   asm volatile("csrs " #c ", %0" :: "r"(v))
#define csr_clear(c, v) asm volatile("csrc " #c ", %0" :: "r"(v))

// saved-register slots in the trap frame (see sbi.S)
#define A0 4
#define A1 5
#define A6 10
#define A7 11

// ---- SBI extension IDs ----------------------------------------------
// Legacy (spec v0.1) extensions are the small numbers and return their value
// in a0 with no error word. Everything from v0.2 on is {a7=EID, a6=FID} in and
// {a0=error, a1=value} out — a different calling convention through the SAME
// instruction, which is why the dispatch below splits on the EID before it
// decides what to write back.
#define SBI_EXT_BASE  0x10u
#define SBI_EXT_TIME  0x54494D45u   // "TIME"
#define SBI_EXT_SRST  0x53525354u   // "SRST"

#define SBI_SUCCESS         0
#define SBI_ERR_NOT_SUPPORTED (-2)

// Spec version is minor in bits [23:0], major in [30:24]. 0x2 = v0.2, which is
// the version that introduced the extensions implemented here — claiming more
// than we implement would be a lie a kernel acts on.
#define SBI_SPEC_VERSION 0x00000002u

// Implementation ID. 0=BBL, 1=OpenSBI, 2=Xvisor, 3=KVM, 4=RustSBI, ... — koti
// has no registered ID, so this is deliberately outside the assigned range.
// Linux only logs it.
#define SBI_IMPL_ID      0x4B4F5449u   // "KOTI"
#define SBI_IMPL_VERSION 1u

void sbi_init(void) {
    con_init();
    VGA_CTRL = 3;                // VGA on + UART mirrored on blue LSB
}

// ---- what to boot ----------------------------------------------------
// Two possible S-mode targets, chosen by what is actually in memory rather
// than by a build flag, so one firmware image serves both and every existing
// test keeps working untouched:
//
//   a Linux kernel at 0x0140_0000, if one has been loaded there, or
//   the built-in flash payload at 0x4000 otherwise.
//
// 0x0140_0000 is not arbitrary: RV32 Linux maps itself with sv32 megapages and
// so must load on a 4 MiB boundary, and that is the first one clear of the
// firmware's own RAM at the bottom of the window.
#define KERNEL_ADDR 0x01400000u
#define PAYLOAD_ADDR 0x00004000u

// A RISC-V "Image" carries this at byte 0x38 of its header — see
// arch/riscv/kernel/head.S. Reading uninitialised RAM could in principle
// collide with it; at one chance in 2^32 that is not worth guarding.
#define RISCV_IMAGE_MAGIC2 0x05435352u   // "RSC\x05"

// The devicetree blob: kept in flash, copied into RAM before entry.
// It has to end up in RAM rather than being pointed at in flash, because
// Linux reserves the blob it is handed (early_init_fdt_reserve_self) and
// expects it inside a memory node. DTB_DST sits just below the kernel, in
// ordinary mappable memory rather than in the firmware's reserved region.
#define DTB_SRC  0x00006000u
#define DTB_DST  0x013F0000u
#define DTB_MAX  (64u * 1024u)
#define FDT_MAGIC 0xD00DFEEDu

// The FDT header is big-endian regardless of the machine, so both fields we
// read out of it need swapping. Unprogrammed flash reads 0xFF, which fails the
// magic test cleanly — a missing blob costs a0 = 0, not a wild copy.
static uint32_t be32(uint32_t v) {
    return (v >> 24) | ((v >> 8) & 0x0000FF00u)
         | ((v << 8) & 0x00FF0000u) | (v << 24);
}

// Returned in {a0, a1}: an 8-byte struct of two words goes back in registers
// under ilp32, which is exactly the pair sbi.S needs.
struct boot_target { uint32_t entry; uint32_t dtb; };

struct boot_target boot_target(void) {
    struct boot_target b = { PAYLOAD_ADDR, 0u };

    // Try the microSD first. This is what puts a kernel at KERNEL_ADDR on real
    // hardware. It changes nothing on failure, so a missing or ordinary card
    // costs one bounded attempt and falls through to the flash payload.
    //
    // ⛔ COMPILE-TIME, not runtime, and there is no way round that. On the
    // ASIC-shaped machine the microSD window DOES NOT EXIST — koti_core.sv's
    // `pa_dev` stops at 0x04 without KOTI_FPGA — so 0x0005_0000 is
    // flash-read-only there. A write takes a store access fault and a read
    // never acks, which hangs the firmware before it can decide anything. Even
    // a "probe" would have to touch the address to find out, so the check
    // cannot be made at runtime; the machine has to be known when the firmware
    // is built. That is why build.py emits TWO binaries.
#ifdef KOTI_ULX3S
    (void)sd_load_kernel();
#endif

    const volatile uint32_t *k = (const volatile uint32_t *)KERNEL_ADDR;
    if (k[0x38u / 4u] != RISCV_IMAGE_MAGIC2)
        return b;                        // no kernel: run the flash payload

    b.entry = KERNEL_ADDR;

    const volatile uint32_t *d = (const volatile uint32_t *)DTB_SRC;
    if (be32(d[0]) == FDT_MAGIC) {
        uint32_t n = be32(d[1]);         // totalsize
        if (n >= 8u && n <= DTB_MAX) {
            volatile uint8_t *dst = (volatile uint8_t *)DTB_DST;
            const volatile uint8_t *src = (const volatile uint8_t *)DTB_SRC;
            for (uint32_t i = 0; i < n; i++)
                dst[i] = src[i];
            b.dtb = DTB_DST;
        }
    }
    return b;                            // a kernel with no DTB still boots,
}                                        // and fails visibly rather than oddly

static void putc_both(char c) {
    uart_putc(c);
    con_putc(c);
}

// Arm mtimecmp, then hand the S-mode timer back to the caller's control.
// Shared by the legacy call and the TIME extension so the two can never drift.
//
// The LO / HI / LO write order is not cosmetic: mtimecmp is a 64-bit compare
// reached through two 32-bit windows, so parking the low half at all-ones first
// guarantees the comparator cannot transiently match while the high half is
// half-written. Writing HI first without that guard can fire a spurious timer
// interrupt at an arbitrary point in the future.
static void sbi_set_timer(uint32_t lo, uint32_t hi) {
    MTIMECMP_LO = 0xFFFFFFFFu;
    MTIMECMP_HI = hi;
    MTIMECMP_LO = lo;
    csr_clear(mip, 1u << 5);     // drop a pending STIP: this call acks it
    csr_set(mie, 1u << 7);       // re-arm MTIE, masked by the handler on entry
}

// ---- THE TIMER MUST NOT DEPEND ON LINUX ANSWERING EVERY TICK -------------
// koti lost its scheduler on 2026-08-09 and looked, from every angle, like a
// dead keyboard. What actually happened: the M-timer stopped firing, so no
// tick reached Linux, so nothing was ever scheduled again — while DEVICE
// interrupts kept waking the CPU out of wfi, so the keyboard ISR still ran and
// still drained its queue. Every hardware lamp read healthy because the
// hardware WAS healthy. The M-mode profiler proved it by going silent itself:
// it lives in this very interrupt.
//
// The cause was the line that used to be here:
//
//     csr_clear(mie, 1u << 7);      // mask MTIE until set_timer
//
// That is OpenSBI's pattern and it is correct only while set_timer is
// GUARANTEED to be called again. It makes every future tick depend on Linux
// completing a round trip on this one, with no recovery if a single call is
// missed — one lost tick disables the timer for ever. A scheduler that can be
// switched off permanently by one missed message is a single point of failure,
// whatever it is that misses it.
//
// So the firmware now keeps the timer alive on its own account: MTIE stays
// enabled and mtimecmp is pushed a fallback period ahead. In normal operation
// Linux reprograms it long before that expires and this is invisible. If Linux
// ever misses a call, the machine gets a tick anyway and keeps running.
//
// ⚠️ The fallback is DELIBERATELY much longer than the 10 ms tick (HZ=100), so
// it never races normal operation — it is a safety net, not a second timer. A
// spurious STIP costs Linux one check of its own timer state.
#define MTIME_HZ         25000000u
#define TIMER_FALLBACK   (MTIME_HZ / 10u)      // 100 ms

static void timer_fallback_arm(void) {
    // mtime is 64 bits behind two 32-bit windows, so it has to be read with
    // the standard hi/lo/hi retry or a carry between the halves is missed.
    uint32_t hi, lo, hi2;
    do { hi = MTIME_HI; lo = MTIME_LO; hi2 = MTIME_HI; } while (hi != hi2);

    // 32-bit carry rather than uint64_t: this firmware links -nostdlib and a
    // 64-bit helper call from a trap handler is not worth the risk.
    uint32_t nlo = lo + TIMER_FALLBACK;
    uint32_t nhi = hi + (nlo < lo ? 1u : 0u);

    // Same LO/HI/LO order as sbi_set_timer, and for the same reason: parking
    // the low half at all-ones first means the comparator cannot transiently
    // match while the high half is half-written.
    MTIMECMP_LO = 0xFFFFFFFFu;
    MTIMECMP_HI = nhi;
    MTIMECMP_LO = nlo;
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

// ---- SAMPLING PROFILER (KOTI_PROFILE builds only) -------------------------
// koti wedged on 2026-08-09 in a way nothing inside Linux could report: the
// kernel kept servicing interrupts (the keyboard ISR drained its queue on every
// keypress) while both consoles went silent and userspace stopped. The kernel
// is built CONFIG_PREEMPT_NONE, so a loop in kernel context starves userspace
// forever while interrupts carry on — exactly that shape — and with no
// hung-task or softlockup detector configured it prints nothing at all.
//
// ⭐ THIS RUNS UNDERNEATH LINUX. The M-mode timer interrupt fires 100 times a
// second (HZ=100) whatever the kernel is doing, `mepc` is the PC it interrupted,
// and `mstatus.MPP` is the privilege it interrupted. Writing that to the UART
// from here needs no console, no lock and no scheduler — the three things a
// wedged kernel takes away.
//
// Read the output as:
//   mpp=0  it interrupted USER mode -> userspace IS running
//   mpp=1  supervisor -> the kernel. A pc that stops changing is the loop, and
//          the address goes straight into System.map.
#ifdef KOTI_PROFILE
extern volatile unsigned prof_last_kbd;   // recorded in sw/usbkbd.c
static uint32_t prof_ticks;

static void prof_hex32(uint32_t v) {
    for (int i = 28; i >= 0; i -= 4)
        uart_putc("0123456789abcdef"[(v >> i) & 0xFu]);
}

static void prof_sample(void) {
    uint32_t pc  = csr_read(mepc);
    uint32_t mpp = (csr_read(mstatus) >> 11) & 3u;

    // Every 100th tick = once a second. Rate-limited rather than every tick
    // because at 115200 baud a line per tick would itself change the timing of
    // the thing being measured.
    if (++prof_ticks < 100u)
        return;
    prof_ticks = 0;
    uart_puts("\r\n[prof pc=");
    prof_hex32(pc);
    uart_puts(" mpp=");
    uart_putc((char)('0' + mpp));
    // ⭐ AND THE MODIFIER LEVEL, which is the prime suspect as of the run that
    // proved the machine merely IDLE rather than wedged. USB_STAT is
    // side-effect free by design (that is why status does not live in the
    // popping register), so sampling it here cannot eat a keystroke.
    //
    // The bits are the HID boot-protocol modifiers, live from the USB core:
    //   bit0 LCTRL  bit1 LSHIFT  bit2 LALT  bit3 LGUI
    //   bit4 RCTRL  bit5 RSHIFT  bit6 RALT  bit7 RGUI
    // A bit that STAYS SET with no key held is the bug: usb_getchar() folds
    // ctrl to 0x01..0x1A and returns -1 outright for AltGr on a key with no
    // AltGr form, so one stuck bit silences hvc0 completely — and koti_kbd.c
    // brackets every keystroke with the same level, so it silences tty1 too.
    // st should read 000001xx while nothing is held (typ=1, no modifiers).
    uart_puts(" st=");
    prof_hex32(USB_STAT);
    // ⭐ The last raw word POPPED from the keyboard queue: {ovf, avail, usage}.
    // The usage byte is the point. 04..1d are the letters, 1e..27 the digits,
    // 2c space, 28 enter. Anything outside 04..38 (bar 64) is DROPPED BY BOTH
    // CONSUMERS — usb_getchar returns -1 and koti_kbd.c does `continue` — so
    // usages that turn to junk, or merely shift out of the letter range,
    // silence hvc0 and tty1 at the same instant while the queue keeps filling
    // and draining exactly as a healthy one would. That is the last mechanism
    // standing that fits every measurement taken on 2026-08-09.
    uart_puts(" kb=");
    prof_hex32(prof_last_kbd);
    // ⭐ THE SUPERVISOR'S OWN INTERRUPT STATE, which is the one thing M-mode can
    // see and Linux cannot report once it has stopped scheduling.
    //
    // arch/riscv/kernel/time.c masks STIE on EVERY tick and relies on the
    // clockevent handler reprogramming the next event to turn it back on:
    //
    //     csr_clear(CSR_IE, IE_TIE);   evdev->event_handler(evdev);
    //
    // If that reprogram ever fails to happen, STIE stays clear and the timer is
    // masked FOR EVER — and this firmware's fallback becomes useless, because
    // it injects STIP into a supervisor that is not listening. M-mode keeps
    // getting ticks (this line keeps printing) while Linux gets none: jiffies
    // stop, every timeout dies, sleep() never returns, nothing is ever woken,
    // and the machine idles with perfectly healthy hardware. That is exactly
    // the state observed on 2026-08-09 — userspace stopped entirely while the
    // profiler carried on.
    //
    // sie bit5 = STIE (timer), bit9 = SEIE (external), bit1 = SSIE (software).
    //   sie=...220 with sip=...020  -> STIP pending but MASKED: the theory.
    //   sie=...222                  -> the timer is enabled and this is wrong.
    uart_puts(" sie=");
    prof_hex32(csr_read(sie));
    uart_puts(" sip=");
    prof_hex32(csr_read(sip));
    uart_puts("]\r\n");
}
#endif

void sbi_trap(uint32_t cause, uint32_t *r) {
    if (cause == 0x80000007u) {          // M timer: inject S timer
        csr_set(mip, 1u << 5);           // STIP
        // ⛔ MTIE IS DELIBERATELY *NOT* MASKED HERE ANY MORE. See
        // timer_fallback_arm(): masking made every future tick depend on Linux
        // completing a round trip on THIS one.
        timer_fallback_arm();
#ifdef KOTI_PROFILE
        prof_sample();
#endif
        return;
    }
    if (cause == 9u) {                   // ecall from S = SBI call
        uint32_t eid = r[A7], fid = r[A6];
        int32_t  err = SBI_SUCCESS;
        uint32_t val = 0;

        switch (eid) {
        // ---- legacy (v0.1): value in a0, no error word ----
        // Kept because this firmware's own payload uses them and because a
        // kernel built without the v0.2 path still works against them. They
        // return early: writing the {error, value} pair over a0/a1 would
        // clobber a legacy result.
        case 0:                          // legacy set_timer(lo, hi)
            sbi_set_timer(r[A0], r[A1]);
            r[A0] = 0;
            csr_write(mepc, csr_read(mepc) + 4);
            return;
        case 1:                          // legacy console_putchar
            putc_both((char)r[A0]);
            r[A0] = 0;
            csr_write(mepc, csr_read(mepc) + 4);
            return;
        case 2:                          // legacy console_getchar
            // Non-blocking, per the legacy SBI spec: -1 when nothing is
            // ready. usb_getchar consumes at most one report slot per call, so
            // modifier-only presses and releases also return -1 — the caller
            // polls.
            // USB is now the ONLY keyboard. PS/2 was removed 2026-08-08,
            // once USB had typed on real hardware — the condition PLAN.md set
            // for retiring it.
            // ⚠️ usb_getchar() POPS its queue, so it must be called exactly
            // once per invocation. On a build without the USB host there is no
            // keyboard at all and this correctly returns -1 forever, which the
            // legacy SBI spec defines as "nothing ready".
            {
                int ch = -1;
#ifdef KOTI_ULX3S
                ch = usb_getchar();
#endif
                r[A0] = (uint32_t)ch;
            }
            csr_write(mepc, csr_read(mepc) + 4);
            return;

        // ---- Base extension: what Linux asks FIRST ----
        // sbi_init() calls get_spec_version before anything else and falls
        // back to assuming v0.1 if it errors. Answering it properly is what
        // lets a kernel use the extensions below without needing the
        // deprecated CONFIG_RISCV_SBI_V01 legacy path compiled in.
        case SBI_EXT_BASE:
            switch (fid) {
            case 0: val = SBI_SPEC_VERSION;  break;
            case 1: val = SBI_IMPL_ID;       break;
            case 2: val = SBI_IMPL_VERSION;  break;
            case 3:                          // probe_extension(a0 = EID)
                val = (r[A0] == SBI_EXT_BASE || r[A0] == SBI_EXT_TIME
                    || r[A0] == SBI_EXT_SRST || r[A0] <= 2u) ? 1u : 0u;
                break;
            // mvendorid / marchid / mimpid. Zero is the spec's "not
            // implemented" answer, and it is the honest one: koti has no
            // vendor allocation, and reading the CSRs would trap here since
            // they are not in csr.sv's known set.
            case 4: case 5: case 6: val = 0; break;
            default: err = SBI_ERR_NOT_SUPPORTED; break;
            }
            break;

        // ---- TIME extension ----
        case SBI_EXT_TIME:
            if (fid == 0) sbi_set_timer(r[A0], r[A1]);
            else          err = SBI_ERR_NOT_SUPPORTED;
            break;

        // ---- SRST: this is what `poweroff` in userspace reaches ----
        // EBREAK halts koti's core, so "system reset" is literally the machine
        // stopping — which is the correct behaviour for a board with no power
        // controller, and is what the harness watches for.
        case SBI_EXT_SRST:
            if (fid == 0) {
                putc_both('\n');
                asm volatile("ebreak");
            }
            err = SBI_ERR_NOT_SUPPORTED;
            break;

        // IPI and RFENCE are deliberately absent, and probe_extension says so.
        // koti is uniprocessor: there is no remote hart to send an IPI to or
        // to shoot down a TLB entry on, and claiming an extension we answer
        // with a no-op would be worse than a clean "not supported".
        default:
            err = SBI_ERR_NOT_SUPPORTED;
            break;
        }

        r[A0] = (uint32_t)err;
        r[A1] = val;
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
