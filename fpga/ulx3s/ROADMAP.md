# Koti-1 on the ULX3S 85F — roadmap to a flashable bitstream

Written 2026-08-02. This is the plan for taking `fpga/ulx3s/` from an
untested scaffold to something you can genuinely plug in and flash, and —
just as importantly — a list of the checks *you* can run to confirm each
step actually happened rather than taking my word for it.

Every phase below ends with a **Verify** block: a command you can run, or
a CI link you can open, that either passes or does not. If a Verify block
does not pass, that phase is not done, whatever the prose says.

---

## Status — updated 2026-08-02

| Phase | State | Evidence |
| --- | --- | --- |
| 1 Pin constraints | **done** | `check_pins.py`: 40 ports, 40 locates, 40/40 sites cross-checked vs console's diffed file |
| 2 Harness rewrite | **done** | elaborates; the header-geometry bug is fixed |
| 3 Build infrastructure | **done** | `sources.txt`, `synth.ps1`, `.github/workflows/fpga-ulx3s.yaml` |
| 4 First green bitstream | **done** | run 30746378495 (pre-SDRAM): 9102 COMB (10%), 2835 FF (3%), 40 IO, 31.69 MHz PASS at 25 MHz, `koti.bit` 1.93 MB |
| 4b SDRAM in the bitstream | **done** | run 30840164421, `-DKOTI_FPGA` on: **9462 COMB (11%), 3030 FF (3%), 79 IO (21%), 27.48 MHz PASS at 25 MHz** |
| 5 Harness simulation | **done** | run 30746646060: 4/4 harness tests, plus the 6 existing ones still green |
| 6 Flash path | **done** | the cartridge writer's mapping is byte-identical to koti's; procedure in README step 4 |
| 7 Bring-up checklist | **done** | `README.md` |

**Tier A and tier B are complete; "flash a bitstream" is now a true
sentence for koti.** What remains is hardware: the board, the resistors,
and the steps in `README.md`.

Two results worth pulling out of the table:

- **31.04 MHz — quote this one** (run 30945077186, 2026-08-04). The number
  has moved five times and every earlier figure is still in circulation
  somewhere: 34.8 was an unconstrained local run whose artifacts were
  deleted; 31.69 was pre-SDRAM; 27.48 was the first SDRAM build; 30.90 and
  31.83 were intermediate. The current build is **11578 COMB (13%), 3637 FF,
  79 IO, 3/208 BRAM, 31.04 MHz post-route, PASS at 25 MHz** = **24.2%
  margin**.
  The 9.9%-margin worry recorded here when the number was 27.48 did not
  survive: the I-cache and the two 2026-08-04 core fixes together bought the
  margin back, and the core fixes were very nearly free (-74 LUTs, -0.69 MHz
  against the build immediately before them). Treat clock-rate ambition as
  work rather than headroom anyway — 25 MHz is what `ulx3s.lpf` constrains
  and what `koti.dts` tells Linux the timebase is.
- ⚠️ **nextpnr prints Max frequency TWICE and the first one is not the
  answer.** The 2026-08-04 run logs `23.51 MHz (FAIL)` and then
  `31.04 MHz (PASS)`;
  the first is the post-PLACEMENT estimate and the second is post-route.
  Reading the wrong one turns a passing build into a panic. Same trap as
  the console repo hit.
- **The two harnesses agree.** koti's J1 row algebra and the cartridge
  Pmod bring-up bitstream's, written independently months apart, assign
  the same `uio` bit to the same header wire. That is the strongest
  cross-check available without hardware.

---

## Where this actually stands (audited 2026-08-02)

The scaffold was written 2026-07-19 before the board existed, and the
notes about it have drifted optimistic. Ground truth:

| Claim | Reality |
| --- | --- |
| "FPGA path synth/routes/closes timing @34.8 MHz" (CLAUDE.md) | **True but partial.** A local yosys+nextpnr run on 2026-07-22 got 8945 TRELLIS_COMB (10%), 2791 FF (3%), Fmax 34.8 MHz. Its artifacts were deleted and nothing in this repo records it — and it ran with **unconstrained IO**, so it is an approximation of a real build, not one. |
| `ulx3s.lpf` constrains the design | **No.** 41 lines. clk/led/btn/ftdi/wifi_gpio0 are real v2.0 sites; **every gp/gn site is a `TODO` comment**, which is all of QSPI, VGA and PS/2. |
| CI builds a bitstream | **No.** `.github/workflows/fpga.yaml` is the stock TinyTapeout **ICE40UP5K** action (for TT's ASIC-sim FPGA board), and its push trigger is `branches: none`. There is no ULX3S/ECP5 build anywhere. |
| `ulx3s_top.sv` maps the Pmods correctly | **No — real bug.** It puts `uio[7:0]` on `gp[0..7]` and VGA on `gn[0..7]`. Those are not Pmod footprints: **J1 is gp/gn 0-3 and J2 is gp/gn 4-7**, so a QSPI Pmod wired that way straddles two physical connectors. |
| The README's flashing procedure | Hand-typed yosys/nextpnr commands, and it tells you to program flash "bit-bang via the ESP32 or an external programmer" — see phase 6, there is a better path we already own. |

### The one big piece of luck

`console/fpga/ulx3s.lpf` already carries **verified v2.0 sites for every
header koti needs** — clk, btn, sw, led, ftdi_rxd, wifi_gpio0, J1
(gp/gn 0-3), J2 (gp/gn 4-7) and gp/gn 8-10 — and on 2026-07-30 every one
of them was diffed against upstream `emard/ulx3s doc/constraints/ulx3s_v20.lpf`.

So koti does not need a fresh transcription from the vendor file. It
needs to *reuse a transcription that has already been checked once*,
which is strictly safer. Phase 1 does that, and phase 1's checker proves
it mechanically.

### The other piece of luck

koti holds `uio[7]` (CS2) permanently high — `src/project.sv:9` — and the
Cartridge Pmod you already have boards of is exactly a TT QSPI Pmod with
CS2 replaced by an audio chain. koti never uses CS2, so **the Cartridge
Pmod is a valid memory Pmod for Koti-1**: flash plus the single PSRAM koti
addresses. That also means koti inherits `pmod-cartridge/fpga/flash_cartridge.py`
as its software-loading path (phase 6) instead of needing a programmer.

---

## What "ready for FPGA" means here

Three tiers, because they buy different things and it is worth knowing
which one you are standing on:

- **Tier A — the bitstream is real and trustworthy** (phases 1-4).
  Every pin lands on a site from the v2.0 constraint file, place-and-route
  meets 25 MHz, and CI hands you a `koti.bit`. This is the tier that makes
  "just flash it" a true sentence.
- **Tier B — flashing it will do something observable** (phases 5-6).
  The harness is simulated end to end, and there is a way to get software
  into flash.
- **Tier C — you can sit down with the board and follow a procedure**
  (phase 7). An ordered checklist where each step's failure has one
  plausible cause.

None of these tiers is "Linux boots". That is downstream of all of it and
is the *point* of the chip; this roadmap gets the board to the starting
line, not across it.

---

## Phase 1 — Real pin constraints

**Goal.** `ulx3s.lpf` constrains every port of the harness to a real
ULX3S v2.0 site.

**Changes.** Rewrite `fpga/ulx3s/ulx3s.lpf` reusing console's
already-diffed sites. The header plan:

| Block | Sites | Carries |
| --- | --- | --- |
| J1 (gp/gn 0-3) | B11 A10 A9 B9 / C11 A11 B10 C10 | Cartridge (or TT QSPI) Pmod — `uio[7:0]` |
| J2 (gp/gn 4-7) | A7 C8 C6 A6 / A8 B8 C7 B6 | Tiny VGA Pmod — `uo[7:0]` in VGA mode |
| gp[8], gp[9] | A4, A2 | PS/2 clock, PS/2 data — `ui[1:0]` |
| btn[0] | D6 | reset (PWR, active low) |
| btn[1..6] | R1 T1 R18 V1 U1 H16 | `ui[7:2]` GPIO |
| sw[0..3] | E8 D8 D7 E7 | orientation + view straps |
| led[0..7], ftdi_rxd, wifi_gpio0 | B2..H3, L4, L2 | status, UART, keep-alive |

**Verify.**

```
python fpga/ulx3s/check_pins.py
```

A checker written as part of this phase. It reads `ulx3s_top.sv` and
`ulx3s.lpf` and fails if: any harness port has no `LOCATE`, any `LOCATE`
names a port that does not exist, or any site disagrees with the reference
transcription in `console/fpga/ulx3s.lpf`. It exits non-zero on any of
those, so it is a real gate, not a report.

**Does not prove.** That your board is a v2.0. Nothing short of reading
the silkscreen does, and a wrong revision builds perfectly and drives the
wrong balls — this is step 1 of the phase-7 checklist for that reason.

---

## Phase 2 — Rewrite the harness

**Goal.** `ulx3s_top.sv` maps the chip onto the board's actual connectors.

**Changes.**

1. **Fix the header geometry** — J1 carries `uio`, J2 carries `uo`, using
   the same row algebra console proved (`gp[n] = bit[3-n]`, `gn[n] = bit[7-n]`,
   swapped by a strap).
2. **Orientation straps.** A 12-pin Pmod seats either way round and a
   reversed one is a silent failure that looks like dead gateware.
   `sw[0]` flips the J1 rows, `sw[1]` flips J2 — a switch flip instead of
   a re-flash.
3. **UART source mux.** koti's `uo` has two personalities: headless
   (`uo[0]`=UART, `uo[1]`=HALTED, `uo[7:2]`=LEDs) and, once software sets
   VGA_EN, Tiny VGA order with UART optionally on `uo[6]`. `ftdi_rxd`
   must follow. `sw[2]` selects `uo[0]` vs `uo[6]` so you can watch the
   serial console in either mode without rebuilding.
4. **LED view.** `sw[3]` picks raw `uo_out` (the headless personality,
   the useful view at first power) vs a VSYNC frame counter (`uo[3]` is
   VSync in VGA mode) — counting LEDs then means video timing is alive.
5. **Reset.** btn[0] (PWR, active low) gated with a 16-bit power-on-reset
   counter, replacing the scaffold's bare `btn[1]`. btn[1..6] become the
   `ui[7:2]` GPIO inputs the MMIO register at 0x10008 reads.
6. **PS/2** on gp[8]/gp[9] into `ui[1:0]`.

The `tt_um_koti` instance stays untouched and unwrapped — what runs on
the FPGA must be what gets hardened.

**Verify.**

```
powershell -File fpga\ulx3s\synth.ps1 -SynthOnly
python fpga/ulx3s/check_pins.py
```

The first elaborates the whole design through yosys (fast, no
place-and-route) and fails on any syntax or width error; the second
re-checks that the ports and the LPF still agree after the rewrite. That
second run is the point — phase 2 is exactly where a port gets renamed
and the constraint silently orphaned.

**Does not prove.** That the row algebra is *right*, only that it
compiles. Phase 5 is what proves it.

---

## Phase 3 — Build infrastructure

**Goal.** One source list, two builders, no drift.

**Changes.**

- `fpga/ulx3s/sources.txt` — the single elaboration-ordered source list,
  read by both the local script and CI. (This is console's pattern, and
  the reason for it is that a source added to only one builder shows up as
  "green in CI, broken locally", or worse the reverse: CI green on a
  design that is not the one you flash.)
- `fpga/ulx3s/synth.ps1` — local **fast check only**: stops after yosys.
  Full place-and-route stays off your PC per the project compute policy.
- `.github/workflows/fpga-ulx3s.yaml` — yosys → nextpnr-ecp5 → ecppack,
  pinned to the same oss-cad-suite release as your local install, with
  Fmax and utilization in the job summary and `koti.bit` uploaded as an
  artifact. nextpnr's exit code is captured rather than allowed to kill
  the job, so a timing failure still tells you *how far off* it was.

The existing `fpga.yaml` (TT's ICE40UP5K action) is left alone — it
targets a different board and is disabled anyway. The new workflow gets a
distinct name so the two are never confused.

**Verify.**

```
gh workflow list --repo JoonatanAlanampa/koti
gh workflow run fpga-ulx3s.yaml --repo JoonatanAlanampa/koti
```

**Does not prove.** Anything about the design. This phase only builds the
machine that will tell you about the design.

---

## Phase 4 — First green bitstream, with pins

**Goal.** A `koti.bit` built with every IO constrained, meeting 25 MHz.

**Changes.** Whatever the first constrained run turns up. Realistic
possibilities, in the order I would expect them:

- Timing drops below the 34.8 MHz that the unconstrained run reported —
  constraining IO to specific balls forces real routing distances, and
  koti at 10% of an 85F has plenty of room but its critical path is a
  long one (MMU + muldiv). 25 MHz is the constraint and there was ~40%
  margin before, so this should hold, but it is the number to watch.
- Tristate inference on the J1 bidirectionals.
- Some `ui`/`uo` bit ending up unconnected and optimised away.

**Verify.** Open the run's job summary; it prints the utilization rows and
the timing line. What you are looking for:

```
Info: Max frequency for clock '$glbnet$clk_25mhz...': NN.NN MHz (PASS at 25.00 MHz)
```

and a `koti-fpga` artifact containing `koti.bit`. For comparison, the
2026-07-22 unconstrained local run was 8945 COMB / 2791 FF / 34.8 MHz, and
console (a much smaller SoC) currently gets 6401 COMB / 2493 FF / 53.72 MHz.
A koti number in the 30s is expected and fine; a number below 25 is the
one finding that would make this phase real work rather than bookkeeping.

**This is the end of tier A.** After phase 4, "flash a bitstream" is a
true statement.

---

## Phase 5 — Simulate the harness before powering anything

**Goal.** Prove the harness — not just the chip — boots.

koti already has four green simulation suites, but every one of them
drives `tt_um_koti` directly. **None of them has ever seen `ulx3s_top`**,
which means the row algebra, the straps, the UART mux and the tristates
are all unverified logic sitting between a proven chip and the pins.

**Changes.** A harness-level test that instantiates `ulx3s_top`, hangs the
existing `test/xip_model.sv` QSPI flash model off the J1 pins, loads
`sw/hello.bin`, and checks the UART banner comes out of `ftdi_rxd` — run
in **both** strap orientations, since exactly one of them must work and
the other must fail cleanly. Then the same for `sw/sbi/sbi_test.bin`.

**Verify.**

```
python test/run_fpga.py
```

Also wired into the `test` workflow, so it gates every push.

⚠ **Locally this will not run**, and neither will the existing `run.py`:
oss-cad-suite's iverilog (14.0-devel) rejects koti's RTL over
declare-after-use — `Unable to bind ... Check for declaration after use`.
CI installs iverilog 12 from apt and is unaffected. This is pre-existing
and hits both suites identically; it is a toolchain version gap, not a
regression. Fixing it means either installing iverilog 12 locally or
reordering the declarations in `koti_core.sv`, which is `src/` work and
outside this workstream's claim.

**Does not prove.** Signal integrity, connector wiring, or that a real
W25Q128 behaves like the model. Those need the board.

---

## Phase 6 — Getting software into flash

**Goal.** A path from `sw/hello.bin` to the flash chip that does not
require buying anything.

The current README says to bit-bang via the ESP32 or use an external
programmer. Neither is necessary: `pmod-cartridge/fpga/` already contains
a bring-up bitstream that doubles as a **UART flash writer** with an
I/E/P/R protocol, plus `flash_cartridge.py` to drive it from the host —
and that chain was simulated end to end on 2026-07-20 including wire
read-back.

**Changes.** Mostly documentation: confirm the cartridge writer's pin
mapping matches koti's J1 assignment, and write the two-bitstream
procedure (flash the writer → load software → flash koti). If the mapping
differs, a small koti-side variant of the writer.

**Verify.**

```
python pmod-cartridge/fpga/flash_cartridge.py --help
```

and the procedure written into the phase-7 checklist.

**Later, not now.** When kernel images outgrow a UART link, console's
`sd_loader` is the answer — it copies from microSD into cartridge flash
while the SoC is held in reset. That is a port, not a write, but it is
Linux-ladder work rather than bring-up work.

---

## Phase 7 — First power-up checklist

**Goal.** Replace the current README with an ordered procedure in
console's style, where each step is chosen so the next step's failure has
only one plausible cause left.

Rough order: confirm the board revision → power the board alone and load
the bitstream (LEDs should show koti's headless personality) → Cartridge
Pmod on J1, check SW1 orientation → flash `hello.bin`, watch the UART
banner at 115200 → VGA Pmod on J2, software sets VGA_EN, **visually check
the font glyphs on a real monitor** (a check that only hardware can close) → PS/2 keyboard.

Plus a "things that will look like bugs and are not" section — the
orientation straps, the two UART pin positions, and the fact that koti
boots headless by default so a blank monitor at first power is correct.

**Verify.** Read it. It is a document; its correctness is judged by
whether it survives contact with the board.

---

## Open decisions I need from you

1. **PS/2 keyboard — you need one, and it is not on the shopping list.**
   Everything else koti needs is either owned or is the Tiny VGA Pmod.
   Modern USB keyboards almost never do PS/2 fallback any more, so a
   passive USB→PS/2 adapter is a gamble; a genuine PS/2 keyboard
   second-hand is the reliable route. Not urgent — it is the last step of
   the checklist and nothing before it depends on the keyboard.

   *(Electrical settled, corrected 2026-08-02: power the keyboard from
   **3.3 V**, with ~4.7 kΩ pull-ups to that same rail. ECP5 IO is not 5 V
   tolerant. An earlier version of this file was vaguer about that and
   floated a resistor divider as the 5 V fallback — that is wrong: the
   keyboard's pull-up to 5 V and a divider to ground fight each other and
   land the high level near 1.6 V, under the input threshold. If a
   keyboard will not run at 3.3 V, use a BSS138 level-shifter module.)*
2. **Which memory Pmod.** The Cartridge Pmod works (see above) and you
   have boards. If you would rather keep the cartridge with the console
   and use a stock TT QSPI Pmod for koti, that is also fine — the J1 pin
   assignment is identical either way, so this decision does not block
   anything.

Neither of these blocks phases 1-5, so I am proceeding.

## Hardware you will need at phase 7

- ULX3S 85F (ordered; not yet here as of the last board note — say if it
  has arrived)
- Cartridge Pmod, board #1 (the one that passed the bench check) or a
  stock TT QSPI Pmod
- Tiny VGA Pmod + a monitor that will accept 640x480@60
- A PS/2 keyboard (or USB keyboard with PS/2 fallback) + two 4.7 kΩ
  resistors
- USB cable for power, bitstream loading and the serial console
