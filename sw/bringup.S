# bringup.S — the image to flash when the question is "is this board alive?".
#
# WHY THIS ONE IS ASSEMBLY AND THE OTHER INSTRUMENTS ARE NOT. Every other image
# in sw/ encodes a PROTOCOL — SPI command sequences, HID report decoding, a
# keymap — and C represents those better than assembly does. This image encodes
# nothing. Its entire design goal, stated in the C version it replaces, is to
# "depend on as little as possible", and a compiler is a dependency: it decides
# what to keep in registers, what to spill, and what to delete. That is not a
# theoretical objection here, it already bit once — the delay loop needed
# `volatile` because -O2 deleted it, which would have turned the ~0.4 s pause
# into a full-speed flood no terminal can read.
#
# This is the image you reach for when you do not yet trust the board, the
# flash, the arbiter, the UART divisor or the SDRAM. Every instruction it runs
# should be one you can read. Now they are: `python tools/rvdis.py sw/bringup.bin
# --base 0 --count 40` prints the whole program.
#
# ⛔ THE STACK TRAFFIC IS LOAD-BEARING. DO NOT "OPTIMISE" IT AWAY.
# The reason a printed line proves anything about the SDRAM is that `ra` is
# pushed to and popped from the SDRAM stack on every call, and the line counter
# `n` is stored and reloaded across those calls. The RD_ADV read-window risk is
# silent on writes and corrupts every read, so a wrong window means the first
# `ret` goes somewhere random — there would be no second line, let alone 31
# gapless ones (2026-08-07, real hardware). An assembly rewrite that kept `n` in
# a saved register and inlined the printing would still print, would still look
# right, and would no longer test the thing this image exists to test.
# ⭐ Assembly makes that GUARANTEED rather than left to a register allocator:
# in the C version, whether `n` round-trips through memory was the compiler's
# choice. Here it is written down.
#
# WHY THE OUTPUT IS BYTE-IDENTICAL TO THE C VERSION. Because then the gate that
# already exists proves this file: test/tb_fpga_bram.v `+mark=0` waits for
# "Koti-1: hello from my own SoC" off the real UART pin, through the real
# qspi_ctrl, arbiter3, icache and SDRAM controller. A rewrite that also changed
# the output would have needed a new bench, and a new bench is a new thing to
# get wrong.
#
# NO .data AND NO .bss, WHICH IS WHY THERE IS NO crt0. Nothing to copy from
# flash and nothing to zero, so this file is its own startup — and the
# misaligned-`.data`-LMA trap that cost a bring-up session on 2026-08-07 cannot
# fire in an image that has no `.data` at all.
#
# WHAT A LINE OF IT PROVES, unchanged from the C version:
#   - the fabric (or Pmod) flash answers 03h and the CPU executes out of it
#   - the SDRAM serves the stack (see the load-bearing note above)
#   - the arbiter and the I-cache are moving instructions
#   - 0123456789 abcdefghijklmnopqrstuvwxyz walks every bit position through
#     the UART shifter, so a stuck data bit shows up as a wrong CHARACTER
#     rather than as a subtly wrong number nobody checks
#   - remu/divu in the decimal conversion exercise the M extension
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0

#include "koti.h"

# ~0.4 s at 25 MHz. The loop is `addi` + `bnez`, so roughly three clocks an
# iteration once the I-cache is warm — against the C version's ~20, which paid
# for a `volatile` counter in SDRAM every time round. The exact figure does not
# matter and is not worth measuring: the only requirement is that a human can
# read the lines as they arrive.
#
# ⚠️ Deliberately a REGISTER countdown, not a memory one. The C version's delay
# hammered the SDRAM as a side effect of `volatile`; that traffic was never what
# proved the memory works — the call/return traffic above is — and a delay loop
# that also exercises RAM makes it harder to say which part failed.
.equ DELAY_ITERS, 3000000

    .section .text.init
    .globl _start

# Register plan, fixed for the whole file so the disassembly reads without a
# decoder ring. s0/s1 are set once and never reloaded; nothing this file calls
# touches them.
#   s0 = UART_ADDR      s1 = LED_ADDR
#   n  = 0(sp) in _start's frame — in MEMORY, on purpose (see the header)
_start:
    la      sp, __stack_top
    li      s0, UART_ADDR
    li      s1, LED_ADDR

    addi    sp, sp, -16
    sw      zero, 0(sp)             # n = 0

.Lline:
    la      a0, msg_head
    call    puts
    lw      a0, 0(sp)               # n, back out of the SDRAM
    call    udec
    la      a0, msg_tail
    call    puts

    # LED0..LED5 count the lines, which is the one liveness signal that needs
    # no serial port at all. Written before the delay so a board whose UART is
    # misrouted still visibly counts.
    lw      t0, 0(sp)
    andi    t0, t0, 0x3F
    sw      t0, 0(s1)

    li      t1, DELAY_ITERS
1:  addi    t1, t1, -1
    bnez    t1, 1b

    lw      t0, 0(sp)               # n++, through memory again
    addi    t0, t0, 1
    sw      t0, 0(sp)
    j       .Lline

    # Unreachable: .Lline never exits. Here so that "fell out of the loop"
    # halts the core visibly instead of running into whatever follows.
    ebreak

# ---- putc: a0 = character ---------------------------------------------------
# The leaf. Calls nothing, so it saves nothing — but it must not touch s0/s1 or
# any register its callers keep live across a call, which is why it works in t0.
putc:
1:  lw      t0, 0(s0)               # UART bit0 = busy
    andi    t0, t0, 1
    bnez    t0, 1b
    sw      a0, 0(s0)
    ret

# ---- puts: a0 = pointer to a NUL-terminated string --------------------------
puts:
    addi    sp, sp, -16
    sw      ra, 12(sp)              # <- the SDRAM round trip that matters
    sw      s2, 8(sp)
    mv      s2, a0
1:  lbu     a0, 0(s2)
    beqz    a0, 2f
    call    putc
    addi    s2, s2, 1
    j       1b
2:  lw      s2, 8(sp)
    lw      ra, 12(sp)
    addi    sp, sp, 16
    ret

# ---- udec: a0 = unsigned value, printed in decimal --------------------------
# Digits come out least-significant first, so they are built on the stack and
# replayed backwards — the same shape as the C version's `char buf[11]`, and
# the same memory traffic. 32 bits is at most 10 digits, and they live at
# sp[0..9], clear of the three saves at 20/24/28.
#
# ⚠️ s2/s3 rather than t-registers for the pointer and the count: both stay live
# across `call putc`, and t-registers are caller-saved by convention. putc
# happens not to touch them today, which is exactly the kind of thing that stops
# being true one edit later.
udec:
    addi    sp, sp, -32
    sw      ra, 28(sp)
    sw      s2, 24(sp)
    sw      s3, 20(sp)
    beqz    a0, .Ludec_zero
    mv      t0, a0
    li      t1, 10
    mv      s2, sp                  # digit write pointer
    li      s3, 0                   # digit count
1:  remu    t2, t0, t1
    divu    t0, t0, t1
    addi    t2, t2, 48              # '0'
    sb      t2, 0(s2)
    addi    s2, s2, 1
    addi    s3, s3, 1
    bnez    t0, 1b
2:  addi    s2, s2, -1
    lbu     a0, 0(s2)
    call    putc
    addi    s3, s3, -1
    bnez    s3, 2b
    j       .Ludec_out
.Ludec_zero:
    li      a0, 48                  # '0'
    call    putc
.Ludec_out:
    lw      s3, 20(sp)
    lw      s2, 24(sp)
    lw      ra, 28(sp)
    addi    sp, sp, 32
    ret

# ---- strings ----------------------------------------------------------------
# .rodata lands inside .text in link.ld, so these are read in place out of
# flash: no copy, no .data, nothing for crt0 to do.
    .section .rodata
msg_head:
    .asciz "Koti-1: hello from my own SoC #"
msg_tail:
    .asciz " 0123456789 abcdefghijklmnopqrstuvwxyz\r\n"
