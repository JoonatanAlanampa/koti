# The kernel ladder — rung 1

Written 2026-08-04, when the last architecture decision closed and this
became the work. The point of this directory is to get an OS running on
koti; the point of *this file* is to make the gaps between "the hardware is
complete" and "Linux boots" explicit, because they are not the same claim
and the difference is all software.

> **Status:** the machine-side contract is being built. `sbi.c` now answers
> the SBI Base and TIME extensions, which is what Linux asks for before it
> trusts anything else. `koti.dts` describes the machine. No kernel has been
> built or booted yet.

## What is already true

- **RV32IMA + Zicsr, M/S/U, sv32 MMU, precise traps.** All of it verified:
  58/58 official rv32ui/um/ua, 15 directed CPU tests including
  `test_sv32_translation_and_faults` and the F2 satp-serialization
  regression, and pin-level tests through the real memory path.
- **32 MB SDRAM**, ~8 clocks for a 32-bit access (decided 2026-08-03).
- **An I-cache**, so instruction fetch costs 1 clock on a hit instead of ~8
  (decided and built 2026-08-04). `fence.i` now really invalidates.
- **An M-mode SBI firmware** that boots, delegates, drops to S-mode, and
  serves a console and a timer.

## The gaps, in the order they will bite

### 1. The firmware sits where the kernel wants to live — BLOCKING

`sw/sbi/link.ld` puts the firmware's RAM at `ORIGIN = 0x01000000`, and
`sbi.S` puts the M stack at `0x01007000` and the S stack at `0x01006000`.
`sw/console.c` puts the VGA charbuf at `0x01008000`. So the bottom ~35 KB of
RAM is occupied — and RAM starts at `0x01000000`, which is exactly where a
kernel wants to be loaded, because RV32 Linux maps itself with sv32
megapages and therefore needs a **4 MiB-aligned** physical load address.

Two ways out, and the choice matters because the window is only 16 MB:

- **Move the firmware to the top** (`0x01FF8000` upward) and give Linux
  `0x01000000`. Costs one linker-script edit, two constants in `sbi.S`, the
  `CHARBUF` constant in `console.c`, and the `0x8000` charbuf offset that
  `test/test.py` asserts on. **Recommended** — it keeps the whole 16 MB
  contiguous and the kernel at the natural address.
- Load the kernel at `0x01400000` instead. No code changes, but it throws
  away 4 MiB of 16, which is a quarter of the machine's memory to save an
  afternoon.

`koti.dts` is written for the first option and is **not true until it is
done** — its `memory` node already excludes the top 32 KB.

### 2. There is no PLIC — so Linux gets no device interrupts

`PLAN.md`'s architecture delta 7 lists a "PLIC-lite" as part of the design.
It was never built: there is no `src/plic.sv`. What exists instead is a
single wire — `project.sv` does `assign kb_irq = kb_avail;` straight into
the core's `meip`.

Two consequences, both real:

- Linux has no interrupt controller to bind to, so no driver can claim an
  interrupt. That is survivable for rung 1 (a UART/SBI console is polled and
  the timer is CPU-local) and **not** survivable for a keyboard.
- The keyboard raises **MEIP**, an M-mode interrupt. `mideleg = 0x222`
  delegates *SEIP*, but nothing raises SEIP, so as things stand a keystroke
  traps to the firmware and never reaches S-mode at all. Either the firmware
  forwards it by setting SEIP in `mip` (cheap, and the same trick it already
  uses for the timer), or a PLIC-lite gets built.

### 3. Loading a multi-megabyte kernel over a 115200 UART

At 115200 8N1 that is ~11.5 KB/s, so a 3 MB kernel takes about four and a
half minutes per attempt. Survivable for the first boot, miserable as an
edit-test loop. The real answer is ladder item 7 (root filesystem on
microSD) arriving early: console's `sd_loader` copies from the card into
flash while the SoC is held in reset, and that is a port rather than a
write.

### 4. `rdtime` is emulated through a trap

`sbi.c` catches the illegal-instruction trap and services `rdtime`/`rdtimeh`
by hand. It is correct, and Linux reads `time` constantly — every
`get_cycles()`. Each one is a full trap, save, decode and return. Fine for
booting; worth measuring before blaming the SDRAM for a sluggish machine.

## Kernel configuration this firmware implies

- **`CONFIG_RISCV_SBI_V01` is not required.** `sbi.c` answers the Base
  extension, so a kernel will detect spec v0.2 and use `TIME` for the timer
  rather than the deprecated legacy path. The legacy calls are still
  implemented, so a kernel that does use them also works.
- **`CONFIG_HVC_RISCV_SBI`** for the console, plus `earlycon=sbi`.
- **`CONFIG_SMP=n`.** koti is uniprocessor, and the firmware deliberately
  does not claim the IPI or RFENCE extensions rather than answering them
  with lies — `probe_extension` returns 0 for both.
- **`CONFIG_MMU=y`** for rung 2. Rung 1 (nommu uClinux) needs a
  `riscv32-linux-musl` toolchain; the `xpack` compiler in `sw/build.py` is
  a bare-metal newlib one and cannot build a kernel.

## Order of work

1. Move the firmware and charbuf to the top of RAM (gap 1). Small, and
   everything else assumes it.
2. Forward MEIP to SEIP in the firmware, or build `plic.sv` (gap 2). Not
   needed for rung 1; needed the moment a keyboard matters.
3. Build a kernel. Rung 1 is Buildroot nommu with the console on UART; it
   proves the boot handoff, the DTB and the SBI without the MMU in the way.
4. Rung 2 is mainline sv32 with the console on the VGA text mode, which is
   the frontier and the thing the `koti-handbook` product cannot yet claim.

## The boot handoff, for whoever writes it

Linux is entered in **S-mode** with `a0` = hartid (0) and `a1` = the
physical address of the DTB, MMU off. `sbi.S` today enters a fixed
`payload_entry` at `0x4000` with neither register set, so that is the
next thing to change — and the payload must move out of flash, since a
kernel does not run XIP.
