# init.S — the smallest /init that proves userspace ran, in ~20 instructions.
#
# Rung 1's whole question is whether the kernel gets from the firmware's mret
# all the way to executing a user program, and this answers it without a libc,
# a shell or a toolchain koti does not have: a static RV32 ELF that writes one
# line and then asks the machine to switch off.
#
# The power-off is not decoration. reboot(LINUX_REBOOT_CMD_POWER_OFF) goes
# kernel -> pm_power_off -> SBI SRST -> sw/sbi/sbi.c -> `ebreak`, which halts
# koti's core. So a successful boot ENDS, and a simulation of it terminates on
# its own instead of running until a timeout that cannot tell "finished" from
# "hung". The fall-through loop is there for the case where SRST does not take.
#
# Built by .github/workflows/linux.yaml as:
#   riscv64-linux-gnu-gcc -march=rv32ima -mabi=ilp32 -nostdlib -static \
#       -no-pie -Wl,--build-id=none -o init init.S
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0

    .section .rodata
msg:
    .ascii "koti: userspace is alive\n"
    .set    msglen, . - msg

    .section .text
    .globl _start
_start:
    # write(1, msg, msglen). fd 1 is the console only because the initramfs
    # carries a /dev/console node — without it the kernel prints "Warning:
    # unable to open an initial console" and init runs with no file
    # descriptors at all, which looks exactly like init never running.
    li      a0, 1
    la      a1, msg
    li      a2, msglen
    li      a7, 64                  # __NR_write
    ecall

    # reboot(LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2,
    #        LINUX_REBOOT_CMD_POWER_OFF, NULL)
    li      a0, 0xfee1dead          # LINUX_REBOOT_MAGIC1
    li      a1, 0x28121969          # LINUX_REBOOT_MAGIC2 (672274793)
    li      a2, 0x4321fedc          # LINUX_REBOOT_CMD_POWER_OFF
    li      a3, 0
    li      a7, 142                 # __NR_reboot
    ecall

1:  j       1b                      # SRST refused: park rather than exit, so
                                    # the kernel does not panic on losing init
