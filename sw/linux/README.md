# The kernel ladder — rung 1

Written 2026-08-04, when the last architecture decision closed and this
became the work. The point of this directory is to get an OS running on
koti; the point of *this file* is to make the gaps between "the hardware is
complete" and "Linux boots" explicit, because they are not the same claim
and the difference is all software.

> **Status 2026-08-04: it boots.**
>
> ```
> [    0.000000] Linux version 6.12.0 (riscv64-linux-gnu-gcc 13.3.0) #1
> [    0.000000] Machine model: Koti-1 (ULX3S 85F)
> [    0.000000] SBI specification v0.2 detected
> [    0.000000] SBI implementation ID=0x4b4f5449 Version=0x1
> [    0.000000] SBI TIME extension detected
> [    0.000000] earlycon: sbi0 at I/O port 0x0 (options '')
> [    0.000000] OF: reserved mem: 0x01000000..0x0100ffff (64 KiB) nomap firmware@1000000
> [    0.000000] Zone ranges:  Normal [mem 0x0000000001400000-0x0000000001ffffff]
> [    0.000000] riscv: base ISA extensions aim
> [    0.000000] Kernel command line: console=hvc0 earlycon=sbi
> [    0.000000] Built 1 zonelists ... Total pages: 3072
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] riscv-intc: 32 local interrupts mapped
> [    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff ...
> [    0.000153] sched_clock: 64 bits at 25MHz, resolution 40ns
> [    0.159587] ASID allocator using 9 bits (512 entries)
> [    0.186960] Memory: 8460K/12288K available (2324K kernel code, 301K
>                rwdata, 468K rodata, 163K init, 158K bss, 3584K reserved)
> [    0.219279] devtmpfs: initialized
> ```
>
> Every line there is a piece of this directory being confirmed: the machine
> model comes from `koti.dts`, so the firmware found the blob at flash
> `0x6000`, copied it to RAM and passed it in `a1`; the SBI lines are `sbi.c`
> answering; `base ISA extensions aim` is the core being read correctly out of
> the devicetree; and the console is arriving through the legacy SBI call this
> firmware implements. In simulation, on `test/tb_boot.v`.
>
The timestamps advance, the interrupt controller and the SBI timer are up, and
the memory subsystem reports itself. The CI run above ends on its **clock
limit**, not on a hang — 15 M clocks is what a push spends; `workflow_dispatch`
takes `maxclk`, `quiet` and `trace` for a longer look, and the runner is about
five times faster at this bench than the development host.

> It is **not yet a computer**: no userspace output, `init` has not run.

Getting this far cost **three real CPU defects**, each of which would have hung
the ULX3S in exactly the same way, and **all three needing the MMU on** — which
is precisely why 58 official tests, 1252 muldiv vectors and six green suites
touched none of them: the official atomics tests run with `satp = 0`.

| # | Where | What |
|---|---|---|
| 1 | `koti_core.sv` | **AMO/page-walk livelock.** M holds an AMO so it holds the data port; EX's next memory op misses the 2-entry DTLB so `tlb_stall` is up; the page-table walker may only take the port while M is quiet. Each waits for the other. Linux hit it in `boot_cpu_init`, ~40 instructions before its first print. |
| 2 | `arbiter3.sv` | **Deadlock on a dropped request.** Grant was held until `m_ack`, but `m_req` IS the granted port's own req — and the fetch port walks away on every pipeline flush, leaving the arbiter waiting for an ack nobody sends. |
| 3 | `koti_core.sv` | **A fetch pair straddling a page skipped an instruction.** The dropped second word was right; advancing `npc` by 8 anyway was not. Needs an odd-word-aligned stream, so it only bites after a redirect to a 4-mod-8 target that reaches a page end — which `kfree()` does on every retry. That was the SLUB stall. |

Each is described in the source at the point of the fix, and each is now
regression-tested: 1 and 2 by the `boot` job, 3 additionally by
`test_fetch_pair_straddling_a_page_is_not_skipped`.

**Booting a real OS is a different kind of test, and this is what it was for.**
Carry the prior forward: when this boot next stops, suspect the core before the
config.

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
5. ~~Boot it~~ **PARTLY DONE 2026-08-04**: `test/tb_boot.v` boots the Image
   through the real firmware, DTB and SBI console, as far as SLUB init. The
   `boot` job in `linux.yaml` runs it on every kernel build and greps for the
   lines only a real boot produces.
6. ~~Get past SLUB init~~ **DONE 2026-08-04** — and the prior recorded here was
   right: it was a third hardware defect, the straddling fetch pair that
   dropped an instruction outright (`koti_core.sv`). The boot then ran on into
   the driver initcalls.
   **Then it stopped again, and that second stall was NOT a hang at all**
   (2026-08-05). Read this before spending a session on it:
   - The boot went quiet after `io scheduler kyber registered` and every run
     died on the quiet window. Two readings were proposed and **both were
     wrong**: an entropy wait, and a stuck PLIC probe.
   - It was `blake2s_mod_init` running the **BLAKE2s self-test** — the
     `device_initcall` two entries after the io schedulers. It printed nothing
     for **>33 million clocks** and had never once been allowed to finish.
   - The machine was healthy the whole time. The proof is forward progress, not
     absence of a crash: `blake2s_random_test` — a *later phase* of the same
     self-test — first appears at 47.4M and is still running at 60M, and
     `blake2s_compress_generic` holds 63% of samples across **1014 distinct
     addresses**, which is a 7964-byte unrolled function being walked rather
     than a loop being spun. ⭐ Sample COUNT cannot tell those apart; distinct
     ADDRESS count can, and `tools/ktrace.py` now reports it.
   - Fixed by `CONFIG_CRYPTO=y` + `CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y`.
     CRYPTO is on purely because it is the gate that makes the disable symbol
     *exist*: with it off the symbol is absent from the whole tree,
     `IS_ENABLED()` is false, and the self-test cannot be switched off from
     outside the crypto menu.
   - 🪤 **The quiet window had become a liar.** At `quiet=4000000` any run
     reaching ~27M died mid-self-test and reported a working kernel as stuck.
     It is 8M now. Before believing "assuming stuck", check what the machine
     was doing with `+trace` and `tools/ktrace.py`.
7. **A real userspace**, in progress. `.github/workflows/userspace.yaml` builds
   a Buildroot busybox rootfs and `sw/linux/check_rootfs.py` asserts the
   binaries are ones this core can execute — ELF32, RISC-V, and `e_flags == 0`,
   which means no compressed instructions and no hardware float ABI.
   ⚠️ That check is not ceremony: Buildroot's RISC-V default enables C, and a
   userspace built with it boots a perfectly healthy kernel straight into an
   illegal instruction at `execve`.
   After that, the console on VGA text mode — the frontier, and the thing the
   `koti-handbook` product cannot yet claim.

**A note on what `halted` means, since 2026-08-05.** An `ebreak` in M-mode
still stops the core; in S or U it now raises a Breakpoint exception (cause 3)
and is resumable, because that is what Linux's `WARN_ON`/`BUG_ON` are — 2812 of
them in this Image — and halting turned every warning the kernel was designed
to survive into a silent death. `medeleg` gained bit 3 so the trap reaches
S-mode. The bench correspondingly no longer treats a bare halt as success: it
requires the marker `init.S` prints before asking for power-off.

## What the `boot` job's green badge means — and what it does not

Read this before quoting a green `linux` run as evidence of anything.

On **2026-08-06** three runs dispatched the day before to answer "does koti
reach userspace?" were re-read. All three are green. **None of them reached
userspace**, and two never executed one instruction in user mode. Two separate
holes let that happen:

1. `tb_boot` ends an `INCOMPLETE` run with `$finish`, so `vvp` exits 0, and no
   step ever read the verdict line. The `It really booted` greps were the only
   gate, and every line they match is printed inside the kernel's first 0.29
   simulated seconds.
2. The `FAIL` verdicts *do* `$fatal` and `vvp` *does* exit 1 — but the step
   pipes through `tee`, and a `run:` step with no `shell:` key uses
   `bash -e {0}` **without pipefail**, so the status was `tee`'s. The verdict
   that exists to catch a kernel dying on a `WARN_ON`/`BUG_ON` had never been
   able to turn the job red.

Both are fixed. What the badge means now is explicit:

| run | budget | what a green badge claims |
|---|---|---|
| push, or `full=no` | 20M clocks | the kernel starts, times itself, allocates, and brings up `devtmpfs` — and **nothing about userspace**. `INCOMPLETE` is its correct outcome and it says so in a notice. |
| `full=yes` | 250M clocks, quiet window ~off | koti reached userspace: a shell from `sw/linux/rootfs.cpio` printed the marker `test/tb_boot.v` waits for. |

They are separate because reaching a shell is on the order of 1e8 clocks —
upwards of an hour of iverilog at the ~25k clocks/s a runner manages — and a
push cannot spend that on every change to `src/`. The push job's real value is
regression cover for the two CPU defects it found (the AMO/page-walk livelock
and the dropped-request deadlock), and both show up in the first few million
clocks.

### The silence after the PLIC probe is not a hang

Three times now a silent-but-working koti has been read as a stuck machine. The
third was traced symbol by symbol on 2026-08-06, reproduced bit-for-bit on the
development host from the CI `Image` artifact, and the profile moves through
completely different code as it goes: `kernfs_name_hash` and `strcmp` (sysfs
nodes), then `vsnprintf`, then `inflate_fast` and `zlib_inflate_table`, then
`eat` in `init/initramfs.c` — **the initramfs being gunzipped and unpacked** —
at 40 to 127 *distinct* addresses per symbol, which is `tools/ktrace.py`'s own
test for "slow, not stuck".

It is structural, not pathological. `System.map` puts `plic_driver_init` at
initcall #126, and the next fourteen (`simple_pm_bus`, three clk drivers,
`n_null`, `pty`, `hvc_sbi`, `random_sysctls`, `topology_sysfs`,
`cacheinfo_sysfs`, `serport`, `atkbd`, `psmouse`, `hid`, `hid_generic`) print
nothing at all. ⚠️ The real rootfs is roughly forty times the archive that trace
was taken on, so the silence gets **longer**. Any `quiet` window tuned against
the one-program initramfs is tuned against the easy case.

### The rootfs can burn the whole clock budget without anything looking wrong

The base Buildroot config is `qemu_riscv32_virt_defconfig`, which has a virtio
NIC and therefore sets `BR2_SYSTEM_DHCP="eth0"`. **koti has no network interface
of any kind.** Buildroot turns that symbol into an `/etc/network/interfaces`
stanza with `wait-delay 15`, and ships `/etc/network/if-pre-up.d/wait_iface`,
which on a missing interface loops `sleep 1` fifteen times.

At koti's 25 MHz timebase that is **375,000,000 clocks** spent by `S40network`
**before `S99koti` ever runs** — half again the entire 250M full-boot budget. A
machine that reached userspace perfectly would still have reported `INCOMPLETE`.

⚠️ **And it prints while it does it.** `Waiting for interface eth0 to appear....`
looks like progress, so the quiet-window heuristic never trips and nothing in
the log says anything is wrong. If a `full=yes` run comes back `INCOMPLETE`,
**grep the log for `Waiting for interface` before suspecting the CPU.**

Fixed by `BR2_SYSTEM_DHCP=""` in `buildroot_koti.fragment`, and guarded by
`check_initramfs.py`, which asserts the **generated file** configures nothing but
`lo` — not the Buildroot symbol, because more than one setting can produce that
stanza and it is the file that stalls the boot.

### Reproducing a boot on the development host

No CI round trip is needed to trace one, and this is the cheapest debugging loop
available. The host cannot build the kernel — its RISC-V toolchain is bare-metal
newlib — but it does not have to:

```sh
gh run download <id> -n koti-linux-Image -D img     # Image AND System.map
iverilog -g2012 -I src -DKOTI_FPGA -DKOTI_SIMMEM \
  -o tb_boot.vvp src/*.sv test/sim_mem.sv test/tb_boot.v
py -3 test/mkhex.py sw/sbi/sbi_test.bin fw.hex
py -3 test/mkhex.py img/arch/riscv/boot/Image kernel.hex
vvp tb_boot.vvp +flash=fw.hex +ram=kernel.hex +ramoff=1048576 \
    +maxclk=30000000 +quiet=29000000 +trace=2000
py -3 tools/ktrace.py img/System.map boot.log --from <clock>
```

⚠️ Take the `System.map` from the **same run** as the log — `ktrace.py` says why.
The reproduction is exact only while `src/`, `sw/sbi/` and `test/sim_mem.sv` are
unchanged since that run; check with `git diff --stat <sha> HEAD -- src sw/sbi
test/sim_mem.sv` before trusting a clock number to match.

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
