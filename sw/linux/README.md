# The kernel ladder — rung 1

Written 2026-08-04, when the last architecture decision closed and this
became the work. The point of this directory is to get an OS running on
koti; the point of *this file* is to make the gaps between "the hardware is
complete" and "Linux boots" explicit, because they are not the same claim
and the difference is all software.

> **Status:** the machine-side contract is complete and tested. `sbi.c`
> answers the SBI Base, TIME and SRST extensions — what Linux asks for before
> it trusts anything else — and `sbi.S` performs the Linux boot handoff:
> a kernel found at `0x01400000` is entered in S-mode with `a0` = hartid and
> `a1` = the DTB, otherwise the built-in flash payload runs as before.
> `koti.dts` describes the machine.
>
> **What is missing is a kernel.** Nothing has been built or booted; that
> needs a `riscv32-linux-musl` toolchain, which is task 4 below.

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

### 1. The firmware sits where the kernel wants to live — SOLVED 2026-08-04

`sw/sbi/link.ld` puts the firmware's RAM at `ORIGIN = 0x01000000`, `sbi.S`
puts the M stack at `0x01007000` and the S stack at `0x01006000`, and
`sw/console.c` puts the VGA charbuf at `0x01008000`. So the bottom ~35 KB of
RAM is occupied — and RAM starts at `0x01000000`, which is exactly where a
kernel wants to load, because RV32 Linux maps itself with sv32 megapages and
therefore needs a **4 MiB-aligned** physical address.

**Resolution: the kernel loads at `0x01400000`, and only the 64 KB the
firmware actually occupies is reserved.** Nothing in the firmware moves.
`koti.dts` carries the `reserved-memory` node that says so.

The reservation is 64 KB rather than the whole 4 MiB below the kernel because
the 4 MiB constraint is about where the *kernel* may load, not about how much
must be kept away from Linux: RV32 Linux maps all of RAM linearly and will
hand out pages below its own image quite happily. Reserving the gap would
have thrown away about 4 MB for nothing.

> ⚠️ The first version of this file recommended the opposite — moving the
> firmware to the top of RAM at `0x01FF8000` — and called the `0x01400000`
> option wasteful. **That recommendation was wrong on three counts**, all
> found while trying to implement it, and it is written down here because
> each one is a fact about this machine worth keeping:
>
> 1. **There was no 16 MB window to move to the top of.** `koti_core.sv`
>    faulted every data access with `addr[23]` set (`pa_psram_hi`), capping
>    RAM at 8 MB. See below.
> 2. **The simulation models do not reach that far.** `test/test.py` builds
>    its PSRAM as `SpiMem(1 << 16)` — 64 KB — and `test/sdram_model.sv`
>    decodes only `row[6:0]` of the part's 13 row bits, so it covers about
>    512 KB and *aliases* above that. A firmware at `0x01FF8000` would sit
>    outside both, so the move would have silently un-tested the firmware.
> 3. It would have churned `link.ld`, `sbi.S`, `console.c` and four
>    assertions in `test/test.py` — on a suite that is green — to buy less
>    memory than the option it dismissed.
>
> The reservation costs the kernel nothing it could otherwise have used,
> because 4 MiB alignment means `0x01400000` was the first legal load address
> regardless.

**What did change** is the 8 MB cap, because that one was a real defect:
`pa_psram_hi` exists to catch the APS6404 PSRAM's 8 MiB **mirror** on the
QSPI Pmod, where an access above 8 MB silently lands somewhere else. The
ULX3S's RAM is soldered SDRAM with a genuine 16 MB window and nothing
mirrors, so on that build the fault rejected real memory — and specifically
the half a 4 MiB-aligned kernel lives in. It is now `` `ifdef KOTI_FPGA ``'d
off for the FPGA build and kept for the QSPI build, where it is correct.

Net effect: **Linux gets the whole 16 MB window bar a 64 KB reservation** —
12 MB contiguous above the kernel at `0x01400000`, plus the ~4 MB below it.

### 2. There is no PLIC — BUILT 2026-08-04, `src/plic.sv`

`PLAN.md`'s architecture delta 7 had listed a "PLIC-lite" since the start and
it was never built. What stood in for it was one wire — `project.sv` did
`assign kb_irq = kb_avail;` straight into the core's `meip` — which meant
Linux had no interrupt controller to bind a driver to, and the keyboard raised
an **M-mode** interrupt while `mideleg` delegates SEIP, which nothing raised.
A keystroke could not reach supervisor mode however the kernel was configured.

**It is register-compatible with the SiFive PLIC**, so mainline's
`sifive,plic-1.0.0` driver runs it unmodified. That is worth paying for:
every other koti device needs a custom driver, and the interrupt controller
is the one place where adopting somebody else's register map buys a whole
working one. The price is address space — the context registers live at
offset `0x200000` and the driver hard-codes it, so the PLIC cannot fit in a
64 KB carve-out beside the CLINT. It takes the **top 4 MB of flash address
space**, `0x00C0_0000`–`0x00FF_FFFF`, off the top rather than out of the low
addresses so software keeps a contiguous run from zero.

**Why not the cheap alternative.** Forwarding `meip` into `mip.SEIP` from
M-mode firmware needs no new hardware and does not work: `sip.SEIP` is
read-only to supervisor mode (`csr.sv` only lets S write SSIP), so once the
handler returns nothing S can do clears the bit and it re-traps forever.
Breaking that loop needs a non-standard SBI call on every single interrupt.
Claim/complete is an acknowledgement path that already exists in the spec.

Wired today: source 1 = the keyboard. **VSync is deliberately not wired** even
though `PLAN.md` lists it — `vt_vs` is a pulse, and a level-sensitive gateway
would either miss it or latch it forever depending on which cycle it landed
on. It needs a read-to-clear status bit first, the way the keyboard has one.
Sources 2–4 are tied low so the register map already has room.

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

## Which OS — decided 2026-08-04: mainline sv32 Linux, and rung 1 is deleted

`PLAN.md` had a three-rung ladder — xv6, then nommu uClinux, then sv32 Linux —
written before the MMU was finished. Re-examined when task 4 came up, **the
first two rungs are not smaller steps toward the third; they are steps
sideways onto different machines.** The evidence, checked against Linux v6.12
rather than recalled:

**nommu is not "sv32 Linux without the MMU". It is a different privilege
model with no console.**

```
config RISCV_M_MODE            config RISCV_SBI
	bool "Build a kernel that runs in machine mode"      bool
	depends on !MMU                depends on !RISCV_M_MODE
	default y                      default y
```

`CONFIG_MMU=n` turns `RISCV_M_MODE` **on by default**, and `RISCV_SBI` is
switched off by exactly that. So a nommu kernel does not call the firmware —
it *replaces* it. Every piece of machine-side work of the last few days is
outside that kernel's world: the SBI console it would not call, the boot
handoff it would not use, the DTB the firmware copies for it, the S-mode drop.
And koti's UART is transmit-only at a core-internal MMIO address and is not a
16550, so a kernel that cannot use the SBI console **has no console at all** —
the failure mode of "rung 1" is a machine that boots perfectly and says
nothing. Turning `RISCV_M_MODE=n` back off to get S-mode nommu is legal
Kconfig and a configuration essentially nobody upstream runs.

That is before the userspace problem: musl requires an MMU, so a nommu rootfs
means uClibc-ng plus binfmt_flat on RV32, which is thin ground.

**xv6-rv32 is a port, not a configuration.** It would prove the sv32 walker,
and it is genuinely small — but it brings its own M-mode boot code (so the SBI
firmware is bypassed, not tested), it reads no devicetree, its console driver
is a 16550 that koti does not have, and its root filesystem arrives over
virtio-blk that koti does not have either. That is four replacements to reach
a shell, and none of them is reusable afterwards. It also cannot make the
claim the whole project is aimed at.

**Mainline RV32 sv32 Linux is the shape koti already is.** S-mode + sv32 + an
SBI v0.2 firmware + a `sifive,plic-1.0.0`-compatible interrupt controller +
`riscv,timer` is not a lucky match; it is what mainline RV32 expects, and each
piece was built to that spec on purpose. The MMU is not the risk it was when
the ladder was written: `test_sv32_translation_and_faults` and the F2
satp-serialisation regression have been green since 2026-07-18.

**So the ladder loses two rungs and the target is `CONFIG_ARCH_RV32I` +
`CONFIG_MMU=y`.** The risk that ordering removed — "the MMU is the graveyard,
de-risk everything else first" — is instead handled by making the boot
*observable*: `earlycon=sbi` prints before the console driver probes, so a
kernel that dies in `setup_vm` says where.

### What that decision bought, and what it costs

The prerequisite everyone names for this work is a `riscv32-linux` toolchain,
and the usual answer is Buildroot, which builds its own. It is not needed for
the kernel: **the kernel is freestanding and links no libc**, so Ubuntu's
stock `gcc-riscv64-linux-gnu` builds it as soon as it is told `-march=rv32ima
-mabi=ilp32`, which the kernel's own Makefile does from `CONFIG_ARCH_RV32I`.
Verified: that compiler emits ELF32 RISC-V objects. `.github/workflows/
linux.yaml` therefore builds the kernel in ~10 minutes instead of Buildroot's
~40 cold, which is what makes CI a usable debug loop when nothing here can be
run on the development host.

The cost is that there is no userspace: the initramfs is `sw/linux/init.S`,
one static program that prints a line and powers the machine off. Buildroot
returns at the point koti wants busybox and a shell — that is a rootfs
problem, not a kernel-toolchain problem, and it is worth paying for then.

## Kernel configuration this firmware implies

The whole list is now `sw/linux/koti_defconfig`, and `sw/linux/check_config.py`
asserts it against the **resolved** `.config` in CI — because kconfig silently
drops a defconfig line whose dependencies are unmet, so the file you write is
not evidence of the kernel you get. The reasoning behind the load-bearing ones:

- 🔴 **`CONFIG_RISCV_SBI_V01=y` IS required, for the console.** An earlier
  version of this file said it was not, on the grounds that `sbi.c` answers
  the Base extension so a kernel detects spec v0.2 and uses `TIME` rather than
  the deprecated legacy timer call. That part is true and it is about the
  *timer*. The console is a different question, and in v6.12 both
  `hvc_riscv_sbi.c` and `earlycon-riscv-sbi.c` prefer the SBI **DBCN** (debug
  console) extension and fall back to the v0.1 calls only
  `if (IS_ENABLED(CONFIG_RISCV_SBI_V01))`. koti's firmware implements the
  legacy console (EID 1 and 2) and **not** DBCN — `probe_extension` returns 0
  for it — so without this symbol the kernel boots and has no way to say so.
  (Implementing DBCN in `sbi.c` is the other fix and is a better one long
  term: it is ~15 lines, it takes *physical* addresses so M-mode needs no
  translation, and it would drop the dependency on a deprecated symbol. Not
  done yet.)
- **`CONFIG_HVC_RISCV_SBI=y`** for the console, plus `earlycon=sbi` in
  bootargs. Note it `depends on RISCV_SBI && NONPORTABLE` — the second is on
  anyway, because `ARCH_RV32I` depends on it too.
- **`CONFIG_RISCV_ISA_C=n`.** Default `y`. koti is RV32IMA with no compressed
  instructions, and a kernel built with them dies on an illegal instruction
  before printing anything.
- **`CONFIG_SMP=n`.** koti is uniprocessor, and the firmware deliberately
  does not claim the IPI or RFENCE extensions rather than answering them
  with lies — `probe_extension` returns 0 for both.
- **`CONFIG_MMU=y`**, and see the decision above for why there is no longer a
  nommu rung below it.

## Order of work

1. ~~Move the firmware off the kernel's load address~~ **DONE 2026-08-04**
   (gap 1): kernel at `0x01400000`, bottom 4 MiB reserved, 8 MB cap lifted
   for the FPGA build. 12 MB contiguous for Linux.
2. ~~Set up the boot handoff~~ **DONE 2026-08-04**: `sbi.S` now chooses its
   S-mode target by what is in memory rather than by a build flag — a kernel
   at `0x01400000` if one is loaded there, the flash payload otherwise — and
   enters it with `a0` = hartid and `a1` = the DTB, which the firmware copies
   out of flash into RAM first. Covered by
   `test_boots_a_kernel_image_with_the_linux_handoff`.
3. ~~Forward MEIP to SEIP, or build `plic.sv`~~ **DONE 2026-08-04** (gap 2):
   a SiFive-register-compatible PLIC at `0x00C0_0000`, driving the core's new
   S-external input. `koti.dts` has the node; `test/tb_plic.v` covers it.
4. Build a kernel — **mainline sv32, not nommu; see the decision above.**
   `.github/workflows/linux.yaml` builds RV32 Linux 6.12 with
   `sw/linux/koti_defconfig` and a one-program initramfs, and checks both the
   resolved config and the Image header against what this machine can run.
   No Buildroot: the kernel links no libc, so Ubuntu's `gcc-riscv64-linux-gnu`
   builds it directly.
5. Boot it. The console is `earlycon=sbi` then `hvc0`; a successful boot ENDS,
   because `init` asks for power-off and the firmware's SRST is an `ebreak`.
6. Then a real userspace (Buildroot busybox + musl), and after that the
   console on the VGA text mode — which is the frontier and the thing the
   `koti-handbook` product cannot yet claim.

## A simulation limit to remember before trusting a sim boot

`test/sdram_model.sv` decodes `{ba[1:0], row[6:0], col[8:0]}` — seven of the
part's thirteen row bits — so it models about 512 KB and **aliases** beyond
that. No current test notices, because they all work low in RAM. A kernel
loaded at `0x01400000` would alias catastrophically in that model, so rung 1
cannot be booted in the existing SDRAM bench without widening it first. The
real part is fine; the bench is the limit.

## The boot handoff, for whoever writes it

Linux is entered in **S-mode** with `a0` = hartid (0) and `a1` = the
physical address of the DTB, MMU off. `sbi.S` today enters a fixed
`payload_entry` at `0x4000` with neither register set, so that is the
next thing to change — and the payload must move out of flash, since a
kernel does not run XIP.
