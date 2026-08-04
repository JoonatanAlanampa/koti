# dtb.S — put the machine description in flash, where sbi.c expects it.
#
# `sbi.c` reads flash 0x6000, validates the FDT magic and `totalsize`, and
# copies that many bytes into RAM at 0x013F_0000 before entering a kernel, so
# a1 points at a blob Linux can reserve for itself. Everything on the firmware
# side of that was already written and tested; what was missing was anything
# that actually put a blob at 0x6000. Unprogrammed flash reads 0xFF, the magic
# test failed cleanly, and a kernel would have been entered with a1 = 0 — which
# a kernel does not survive, but does not complain about either.
#
# The section address is pinned in link.ld, not chosen by the linker, because
# 0x6000 is a number compiled into sbi.c: two files have to agree and only one
# of them can be the one that decides.
#
# ../linux/koti.dtb is a build product that is nevertheless committed. It has
# to be, because the firmware image is built on the development host and there
# is no dtc there. The .github/workflows/linux.yaml `dtb` job recompiles
# koti.dts and fails if the committed blob no longer means the same thing, so
# the copy in the tree cannot go stale unnoticed.
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0

    .section .dtb, "a"
    .globl koti_dtb
koti_dtb:
    .incbin "../linux/koti.dtb"
