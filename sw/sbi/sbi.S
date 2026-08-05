# sbi.S — Koti-1 M-mode firmware: boot, delegation, trap shim.
# Delegates S-level interrupts (mideleg=0x222) and the usual user/S
# exceptions EXCEPT illegal instruction (rdtime emulation lives in M)
# and ecall-from-S (that IS the SBI). Breakpoint (3) is delegated too, so
# Linux's WARN_ON/BUG_ON reach do_trap_break. Payload entry pinned at 0x4000.
    .section .text.init
    .globl _start
_start:
    li   sp, 0x01007000          # M-mode stack (PSRAM)
    csrw mscratch, sp
    la   t0, trap_entry
    csrw mtvec, t0
    li   t0, 0x222               # mideleg: SSIP | STIP | SEIP
    csrw mideleg, t0
    # medeleg: 0,3,4,6,8,12,13,15.
    # Bit 3 is BREAKPOINT and it was added 2026-08-05 alongside making an S/U
    # EBREAK trap instead of halting the core. Without it that trap comes to
    # M-mode, where trap_entry below has no case for cause 3 — which would have
    # swapped a silent halt for a silent firmware trap and looked like no
    # improvement at all. Linux wants it in S: do_trap_break() is where every
    # WARN_ON and BUG_ON in the kernel lands.
    li   t0, 0xB159
    csrw medeleg, t0
    call sbi_init

    # Choose the S-mode target: a kernel at 0x01400000 if one is loaded there,
    # otherwise the built-in flash payload. boot_target() returns the pair
    # {entry, dtb} in a0/a1 (an 8-byte struct goes back in registers under
    # ilp32), which is almost the handoff Linux wants already.
    call boot_target
    csrw mepc, a0                # entry, before a0 is repurposed below

    # The Linux boot protocol: enter S-mode with a0 = hartid and a1 = the
    # physical address of the devicetree blob. a1 is already right; a0 has to
    # stop being the entry address and start being the hart number. koti is
    # uniprocessor, so that is 0.
    li   a0, 0

    li   t0, 0x800               # MPP = S
    csrs mstatus, t0
    mret

    .align 2
trap_entry:
    csrrw sp, mscratch, sp       # sp <- M stack, mscratch <- S sp
    addi sp, sp, -64
    sw   ra,  0(sp)
    sw   t0,  4(sp)
    sw   t1,  8(sp)
    sw   t2, 12(sp)
    sw   a0, 16(sp)
    sw   a1, 20(sp)
    sw   a2, 24(sp)
    sw   a3, 28(sp)
    sw   a4, 32(sp)
    sw   a5, 36(sp)
    sw   a6, 40(sp)
    sw   a7, 44(sp)
    sw   t3, 48(sp)
    sw   t4, 52(sp)
    sw   t5, 56(sp)
    sw   t6, 60(sp)
    csrr a0, mcause
    mv   a1, sp
    call sbi_trap
    lw   ra,  0(sp)
    lw   t0,  4(sp)
    lw   t1,  8(sp)
    lw   t2, 12(sp)
    lw   a0, 16(sp)
    lw   a1, 20(sp)
    lw   a2, 24(sp)
    lw   a3, 28(sp)
    lw   a4, 32(sp)
    lw   a5, 36(sp)
    lw   a6, 40(sp)
    lw   a7, 44(sp)
    lw   t3, 48(sp)
    lw   t4, 52(sp)
    lw   t5, 56(sp)
    lw   t6, 60(sp)
    addi sp, sp, 64
    csrrw sp, mscratch, sp
    mret

    .section .payload, "ax"
    .globl payload_entry
payload_entry:
    li   sp, 0x01006000          # S-mode stack
    call smain
    ebreak
