# Koti-1 — plan

## GOAL — restated 2026-08-02 by user directive: **FPGA, not silicon**

> **A computer I can actually use.** CPU + OS + memory + peripherals, running
> on the ULX3S 85F. Not a demo that boots once for a photograph — a machine
> you sit down at, with a keyboard and a screen, and use.

**Koti's Linux is an FPGA target. It is not going to a shuttle.** That is a
deliberate scope decision, and it changes what the constraints are:

| Was (TT silicon) | Is now (ULX3S) |
| --- | --- |
| 8x2 tiles, ~2 mm², area is the binding constraint | 10% of an 85F used; **84k LUTs, ~3.7 Mbit BRAM free** |
| Memory = 8 MB QSPI PSRAM on a Pmod, serial, high latency | **32 MB SDRAM onboard**, 16-bit parallel — 1-2 orders of magnitude faster |
| `ui` pins input-only ⇒ receive-only PS/2, no caps-lock LED | Every gp/gn pin is bidirectional; `usb_fpga_bd_*` exists ⇒ **USB is on the table** |
| Video = Tiny VGA Pmod, 8 pins, RGB222 | VGA Pmod *or* onboard **GPDI/HDMI** |
| No storage; software lives in flash | **Onboard microSD** ⇒ a real root filesystem |
| Regfile needs a DFFRAM macro to route | Regfile is flops; no macro, no harden |

Consequence: **the ASIC blockers are gone, not parked.** ⛔ **User directive
2026-08-08: "Koti will not be taped out. Clean ASIC related stuff so the focus
is on this FPGA project purely."** The 32x32 RF macro, the red 8x2 harden and
the shuttle submission are no longer tracked, and the apparatus that served
them has been DELETED — TinyTapeout flow files, the `gds`/`docs`/`fpga`
workflows, the ASIC cocotb suite, and every `KOTI_FPGA` conditional in `src/`.
There is one configuration now and it is the board. Details, including what
test coverage went with it, are at the end of the TODO list.

`tt_um_koti` keeps its name and its `ui_in`/`uo_out`/`uio_*` port list. That is
not a residual: `uio` is how the design reaches the QSPI flash on the pmod
variant and `uo` carries the VGA personality, so those pins are live on the
ULX3S. Renaming the top level is a refactor with no functional payoff, and it
would touch the harness, the LPF and every bench at once.

## TODO — the ladder to a usable machine

Hardware bring-up — ✅ **THE BOARD ARRIVED 2026-08-06. This is now doable
work, not a wait:**
1. [ ] **ULX3S first power-up** — `fpga/ulx3s/README.md`, steps 1-7. Bitstream
       and harness are done and green (**31.04 MHz** post-route, PASS at
       25 MHz; 4/4 harness tests). Needs: ~~the board~~ ✅ **in hand
       2026-08-06**, a **Tiny VGA Pmod** (bought 2026-08-02, **arrival still
       unconfirmed** — the only thing here still in transit), and the
       Cartridge Pmod you already have. **Nothing left to buy** — the PS/2
       keyboard came off the list with decision 2 below.
       ⚠ The VGA Pmod gates only the **font glyph visual check**; the UART
       path — which is what the kernel ladder's console actually is — needs
       nothing but the board. Do not treat the missing Pmod as a blocker on
       the ladder.
       ⚠ First real risk on this step is **SDRAM `RD_ADV`**: the part is
       clocked on `~clk`, and if the fitted device returns data later than
       the model predicts, writes look fine and every read is corrupted.
       Closes the long-standing **font glyph visual check**.

Software, in order:
2. [x] **Keyboard hookup — DONE 2026-08-02.** `sw/ps2kbd.c` translates scancode
       set 2 (US layout, shift, no caps-lock — the lock LEDs are host-driven and
       this design cannot transmit), SBI `console_getchar` returns real
       characters, and the S-mode payload ends in an echo loop. Two tests type
       at the machine and read the characters back off the UART; both green.
       ⚠ Known limitation, documented in `src/project.sv`: the keyboard byte
       register is single-entry with no overrun flag, so bytes arriving faster
       than software polls are dropped silently. Harmless against a real
       keyboard (0.7-1.1 ms per frame vs a ~0.28 ms poll), but **a Linux driver
       decoding E0/F0 prefix sequences will need an overrun bit** — a dropped
       byte desynchronises the decoder and nothing currently reports it.
3. [x] **Memory decision — DONE 2026-08-03: the onboard 32 MB SDRAM**
       (decision 1 below). Closed by measurement, not argument: 10 clocks for
       a random 32-bit read against QSPI's ~130.
3b.[x] **I-cache — DONE 2026-08-04** (decision 4 below), `src/icache.sv`.
       Fetch was costing ~8 clocks per instruction even with fast RAM; a hit
       now costs one. 3 of 208 block RAMs.
4. ~~xv6 rv32 port~~ and ~~Buildroot nommu uLinux~~ — **BOTH CUT 2026-08-04.**
       The three-rung ladder (xv6, then nommu, then sv32 Linux) was written
       before the MMU was finished, and the first two rungs are not smaller
       steps toward the third — they are steps sideways onto different
       machines. `CONFIG_MMU=n` turns `RISCV_M_MODE` on by default and
       `RISCV_SBI` off with it, so a nommu kernel replaces this firmware
       rather than calling it, and with koti's transmit-only non-16550 UART
       that leaves it with no console at all. xv6 brings its own M-mode boot,
       reads no devicetree, wants a 16550 and a virtio-blk rootfs. Full
       argument and the Kconfig quotes: `sw/linux/README.md`.
5. [x] **Mainline sv32 Linux — IT BOOTS, 2026-08-04.** Linux 6.12 RV32,
       built in CI by `.github/workflows/linux.yaml` (no Buildroot: the kernel
       links no libc, so Ubuntu's `gcc-riscv64-linux-gnu` builds it directly).
       Reaches SLUB init through the real firmware, DTB and SBI console on
       `test/tb_boot.v`; the `boot` job runs it on every kernel build. Reaches
       `devtmpfs: initialized` and stops on the CLOCK LIMIT, not a hang.
       Cost **three real CPU defects** on the way — an AMO/page-walk livelock
       and a straddling-fetch-pair instruction skip in `koti_core.sv`, and a
       dropped-request deadlock in `arbiter3.sv`. All three need the MMU on,
       which is why the 58 official tests (`satp = 0`) missed every one.
6. [x] **DONE ON HARDWARE 2026-08-07 — Linux boots to a login prompt on the
       real ULX3S, and the boot log is on the HDMI monitor.**
       `Run /init as init process` / `koti: userspace is alive` /
       `buildroot login:`, ~49 s, with busybox+musl userspace.
       - **The kernel arrives over the microSD** (`sw/sbi/sdboot.c` +
         `tools/sdkernel.py`): header at LBA 2048, image after it, 32-bit
         checksum. 3,954,608 bytes = 7724 blocks in ~4 s, against ~343 s over
         the UART. That transport was the whole gap between simulation and the
         bench, since koti boots from a 32 KB fabric flash.
       - **The text console works too**, on HDMI, with no framebuffer driver:
         SBI `console_putchar` writes the VGA text buffer as well as the UART.
7. [x] **Root filesystem on microSD — READ AND WRITE, ON HARDWARE.**
       ```
       kotisd: kotisd1 kotisd2
       koti-sd 50000.mmc: 61067264 sectors (29818 MiB), read-only
       # mount /dev/kotisd2 /mnt   -> a file read back byte-exact
       ```
       `sw/linux/koti_sd.c` is a blk-mq driver for `src/sd_ctrl.sv`; the card
       carries an MBR with p1 (type 0xDA) for the raw kernel and p2 (ext2) for
       the filesystem. `tools/sdkernel.py` writes all three.
       - ✅ **THE WRITE HALF IS DONE TOO, ON HARDWARE 2026-08-08.**
         ```
         # echo koti wrote this > /mnt/hello.txt
         # sync ; umount /mnt ; mount /dev/kotisd2 /mnt
         # cat /mnt/hello.txt   ->  koti wrote this
         ```
         The unmount is the proof: it drops the page cache, so the second read
         came off the card. CMD24 went into the engine upstream in console
         (`9d75e1c`) and was re-vendored; `sd_ctrl.sv` gained a write buffer the
         engine pulls from; the driver gained `REQ_OP_WRITE` and answers
         `REQ_OP_FLUSH` immediately because there is no cache to flush.
       - ⚠️ **ext2 has NO JOURNAL** — `sync` before pulling the power.
       - 🟡 **`root=` MOVED ONTO THE CARD 2026-08-08 — written and CI-gated,
         and STILL not confirmed on hardware as of 2026-08-10.**
         ⚠️ **Which root is live is CARD STATE, not a repo fact**, so no amount
         of reading this tree answers it. `tools/sdkernel.py writefs` has to
         have been run on the card in the slot; the 2026-08-09 sessions wrote
         *kernels* (`write`), which is a different subcommand. The machine
         already answers it out loud — `koti: root on /dev/kotisd2 (ext2),
         switching` or `koti: root stays in RAM (<reason>)`, and afterwards
         `grep ' / ' /proc/mounts`. **Read the boot log; do not infer.**
         ⛔ `docs/MANUAL.md` used to assert flatly that `/` is the initramfs.
         That is one of two possible outcomes stated as fact, and it is wrong
         on any board whose card has been written. Fixed 2026-08-10: it now
         documents both and says how to tell.
         ⭐ The CI gate that keeps the card image switch_root-able was checking
         `/sbin/init`'s TYPE while its own heading said "and be executable", and
         `debugfs stat` does not follow the symlink Buildroot actually ships —
         so a mode-644 busybox would have passed on a symlink's 0777. Now
         resolved and mode-checked, with an unreadable mode failing loudly. `koti.dts` bootargs carry
         `root=/dev/kotisd2 rootfstype=ext2 rw`, Buildroot now also emits
         `rootfs.ext2` for p2 (`sdkernel.py writefs`), and
         `sw/linux/rootfs-overlay/init` switch_roots onto it.
         ⛔ **It is a switch_root, NOT the kernel's own `root=`, deliberately.**
         The kernel answers a missing card with a panic; `/init` answers it by
         staying in RAM and printing why — the same rule `sw/sbi/sdboot.c`
         already applies to the kernel transport, one layer down. All five
         decision paths are exercised; the four failure paths all reach a
         booting machine.
         ⚠️ **Ordering: the `userspace` workflow must rebuild and the new
         `rootfs.cpio` be committed BEFORE `linux` can pass** — the committed
         cpio still holds Buildroot's stock `/init`, and `check_initramfs.py`
         now fails on it by design.
         ⚠️ To force RAM deliberately, take the card out. There is no
         command-line escape hatch on purpose: the cmdline lives in the DTB in
         flash, so using it would mean reflashing.
7b.[x] 🏆 **DONE 2026-08-07 — THE KEYBOARD WORKS AND GOAL 2 IS ACHIEVED.**
       `buildroot login: root` / `# uname -a`, typed on a real USB keyboard.
       ⛔ The old note here ("the login prompt cannot be typed at") is DEAD.
       USB HID host on US2: core vendored, `src/usb_kbd.sv` does the 12->25 MHz
       crossing and turns held keys into keystrokes, `sw/usbkbd.c` carries a
       Finnish keymap. See item 8 for what is still open.
8. [x] ⌨️ **PS/2 REMOVED — DONE 2026-08-08.** The standing condition ("PS/2
       stays until USB types a character on real hardware") was met on
       2026-08-07, so the whole path is gone: `src/ps2_rx.sv`, `sw/ps2kbd.c/.h`,
       the MMIO word at `0x0004000C`, the `ps2_gp` pins, three cocotb tests and
       the LPF constraints. ⭐ **The PLIC's one wired source moved from PS/2's
       `kb_avail` to the USB FIFO's `usb_kb_irq`** — deleting PS/2 without that
       would have left the interrupt controller Linux binds to with no source at
       all. `meip` is now tied low; every interrupt reaches Linux via `seip`.
       ⚠️ `0x0004000C` still decodes and reads **zero**, deliberately: to a
       surviving PS/2 driver that means "no key waiting", which idles rather
       than misbehaves. gp[8]/gp[9] (A4/A2) are free.
       ⚠️ **Open and undiagnosed**: the first USB login echoed `rooo. .. .t. .t`
       — possible duplicate keystrokes, never reproduced. There is now no
       fallback input path, so this is worth chasing.

9. [x] ⌨️ **DONE, AND VERIFIED ON HARDWARE 2026-08-08.** The keyboard is a real
       Linux input device:
       ```
       input: Koti USB HID keyboard as /devices/platform/soc/60000.keyboard/input/input0
       koti-kbd 60000.keyboard: koti keyboard on irq 1; hvc0 keeps its own port
       ```
       `src/usb_kbd.sv` grew a SECOND read port at +0x08 with its own pointer
       and overflow bit, so the firmware keeps feeding `hvc0` from +0x00 and the
       driver feeds `/dev/input/eventN` from its own — one keypress reaching the
       console AND evdev, as a PC does. ⛔ Port 2 is strictly passive and CANNOT
       starve port 1; that property is `test/tb_usb_kbd.v` test 5, proven able
       to fail (`got 8, want 40`).
       ⚠️ The RTL/driver landed in `2ee14b9` but the BOARD ran a kernel built
       the previous day, so it was written-but-unverified for most of a day.
       Hardware verification needed the current Image written to the microSD.

       ~~(the original entry)~~ Keystrokes were NOT an input device: `usb_kbd.sv` →
       MMIO → `sw/usbkbd.c` (M-mode firmware, Finnish keymap) → SBI
       `console_getchar` → `hvc0`. Linux therefore sees *console characters*,
       exactly as it would from a UART. Verified 2026-08-08: **zero**
       `INPUT`/`HID`/`EVDEV` symbols in `koti_defconfig` and **zero** mention of
       the keyboard in `koti.dts`.
       Consequences: no `/dev/input/*`, no evdev, no key-RELEASE events, no
       modifiers as events, `loadkeys` does nothing (the keymap lives in koti's
       firmware, not the OS), and M-mode firmware sits in the path of every
       keystroke. Mainline will not recognise a soft host core any more than it
       recognised koti's PS/2 word, so this is a small custom driver either
       way — plan for one, not for `usbhid` to just work.

9b.[x] 🖥️ **DONE ON HARDWARE 2026-08-08 — LINUX OWNS THE SCREEN.**
       ```
       [ 5.945626] Console: switching to mono koti 40x30 text 40x30
       [ 6.667186] koticon 40000.koticon: koti text console 40x30 at pa 0x01caa000;
                   the firmware keeps its own buffer
       ```
       The HDMI monitor shows kernel messages and STOPS before `buildroot
       login:` — which is the success signature, not a fault: the screen is the
       VT, and the login prompt lives on `hvc0` over the UART.
       ⭐ **THE OWNERSHIP HANDOVER THIS ITEM WARNED ABOUT DOES NOT EXIST.** The
       raster reads the charbuf at whatever address `VGA_BASE` holds — the base
       is a REGISTER. `sw/linux/koticon.c` allocates its own page and points the
       hardware at it; M-mode keeps writing 0x0100_8000 forever, into memory
       nobody displays. No SBI call, no firmware change, no protocol.
       ⭐ Text mode, not fbcon: koti has character cells, so a `struct consw`
       writes 8-bit characters and the font ROM in fabric renders them.
       🪤 **The first hardware test showed a BLANK screen and the driver was
       working the whole time**: bootargs said `console=hvc0` alone, so nothing
       ever wrote to tty1 and a buffer full of spaces renders as black. Fixed by
       `console=tty1 console=hvc0` — order load-bearing, last one becomes
       /dev/console and therefore where the login prompt lives.
       🪤 **The DTB lives in the FIRMWARE, which lives in the BITSTREAM.** A new
       DT node needs a place-and-route and a reflash, not just a kernel; the
       first attempt ran a new kernel against an old machine description.
       ⛔ **STILL TO DO for a shell on the screen: a getty on `tty1`.** Today the
       monitor shows kernel messages only, because `/dev/console` is hvc0 and
       nothing runs a getty on the VT. That is an inittab change in the rootfs.

       ~~(the original entry)~~ The natural sequel to item 9, and
       the thing that would make koti a computer whose OS owns its own screen
       and keyboard instead of borrowing both from the firmware.
       - **The problem, precisely.** Linux has two kinds of console. `hvc0` is
         a serial-style character stream: bytes in, bytes out, no notion of
         keys. A **VT** (`tty1`) is the kernel's own terminal emulator, and its
         input half (`drivers/tty/vt/keyboard.c`) is **the only thing in the
         kernel that turns input events into console characters** — it applies
         the keymap (that is what `loadkeys` changes) and feeds a tty. It feeds
         VTs, not `hvc0`. So `/dev/input/event0` from item 9 has nowhere to go:
         the login prompt is on `hvc0`, and no VT exists.
       - **Why no VT exists.** A VT needs a console driver to draw on, and
         Linux cannot see koti's display at all. The HDMI text is drawn by the
         FIRMWARE: SBI `console_putchar` writes the UART *and* the 40x30
         charbuf, and `vga_text.sv` scans that out through the font ROM. There
         is no fbdev, no DRM, no driver — ⛔ never call the current setup a
         framebuffer.
       - ⭐ **The cheap route is a TEXT-MODE console driver, not a framebuffer.**
         `fbcon` wants a linear pixel buffer to draw glyphs into, which koti
         does not have and which would mean new gateware. But koti's charbuf is
         literally character cells in memory — exactly what the old `vgacon`
         drove. A `koticon` (`struct consw`) writes characters into the charbuf
         and lets the existing hardware render them. **No new video hardware.**
       - 🪤 **It is an OWNERSHIP handover, the output twin of item 9's input
         one.** If Linux owns the charbuf the firmware must stop writing it, or
         the two scribble over each other. `getty` moves to `tty1`. Plan the
         handover deliberately — that is the part that will bite.
       - Payoff: `loadkeys` works, the Finnish keymap moves out of firmware and
         into the OS, key repeat becomes meaningful, Ctrl+Alt+Fn works.

10. [x] ⚡ **D-cache. BUILT, CORRECT AND ENABLED 2026-08-08** (`src/dcache.sv`,
       write-through, 512 lines of one word, no-write-allocate). Every FPGA
       build has it: project.sv derives `KOTI_DCACHE` from `KOTI_FPGA`, so
       there is no flag to remember and no fifth source list to forget.
       `KOTI_NO_DCACHE` puts the bypass back for a bring-up A/B.
       ⭐ **The coherence objection had a cheap answer: WRITE-THROUGH.** The
       worry was that the video DMA reads the charbuf out of the same SDRAM the
       CPU writes, so a write-back cache could hold text that never reaches the
       screen. The DMA only ever READS — there is no DMA-writes / CPU-reads
       direction — so write-through eliminates the problem instead of managing
       it. BRAM was never the constraint: 19 of 208 used.
       🏆 **MEASURED ON THE REAL BOARD 2026-08-08 — 4.5%, and that is the
       number to quote.** Controlled A/B on the ULX3S: same commit, same
       `image: sbi`, same `bram` variant, one variable (`-DKOTI_NO_DCACHE`),
       two runs per arm, SRAM loads so the config flash was untouched.
       | | no cache | D-cache | |
       |---|---|---|---|
       | kernel time (run 1 / 2) | 46.8252 / 46.8350 s | 44.7331 / 44.7233 s | **−4.49%** |
       | wall-clock to the prompt | 83.41 / 83.50 s | 80.09 / 79.80 s | −4.21% |
       ✅ **Correct on real SDRAM** — both reach `buildroot login:`, all four
       boots print 4230 chars / 52 printks / 0 non-printable, and the logs are
       textually identical once timestamps are stripped. Run-to-run spread
       ≤0.01 s, so the 2.10 s gap is ~200x the noise.
       🔴 **The simulation predicted 8.9% and was 2x optimistic** — a flat
       10-clock memory model is dearer than the real `sdram_ctrl` on a row hit.
       **8.9% is a property of `test/sim_mem.sv`, not of this machine.**
       📌 **The model's own numbers — clocks to userspace, identical output:**
       | `+memlat` | no cache | D-cache | |
       |---|---|---|---|
       | 0 | 503,134,412 | 594,781,497 | 18.2% **slower** — model artefact |
       | 4 | 1,017,805,763 | 1,012,172,330 | 0.55% faster — the crossover |
       | **6** | 1,262,089,595 | 1,205,653,407 | **4.47% — matches the board** |
       | 9 | 1,666,686,417 | 1,518,594,747 | 8.9% faster — 2x optimistic |
       Read hit rate a steady **73%** at every latency.
       ⭐ **`+memlat=6` is now CALIBRATED against hardware** (4.47% predicted vs
       4.49% measured), so the model is usable rather than discredited. ~10
       clocks is the *worst* case — a random read missing the open row — and as
       a flat average it overstates memory, and so overstates any cache in
       front of it. **Use 6 for the next memory decision, not 9.**
       ⚠️ **Do NOT benchmark it at `+memlat=0` and believe the answer.**
       `sim_mem` answers in one clock, which is faster than any cache in front
       of it. That 18% is a property of the model, not of the design, and it is
       what nearly got the cache thrown away on the day it started working.
       ⚠️ **It breaks even at about a five-clock memory**, and `sdram_ctrl` is
       ~10 — the right side of the line, but not by a mile. Making memory
       cheaper moves the machine back toward the crossover, so if the open-row
       policy below ever lands, re-measure the two together.
       ⚠️ **What still limits it, both measured in that run**: 21.5M writes
       against 27.6M cacheable reads, and write-through means every write is a
       full memory round trip plus the cache's two cycles; and 13.2M page-table
       reads are bypassed yet still pay those two cycles. A write buffer and a
       combinational walker bypass are the two named next moves.
       ⚠️ **Still worth measuring first**: `sdram_ctrl`'s own header names an
       open-row policy and a real 4-word burst as the performance left on the
       table. Those roughly halve EVERY line fill — both caches — and they
       change one FSM rather than adding anything.

10b.[x] ⌨️ **hvc0 IS TWO-WAY — DONE 2026-08-10 (simulation; not yet on hardware).**
       koti had `uart_tx.sv` and no receiver at all until `2d0e911`, which is
       where every "the UART is transmit-only" note in this repo came from. The
       receiver landed then, wired to `ftdi_txd` (M1) at MMIO **+0x10**; this
       item is the other half — SBI `console_getchar` now reads it when the USB
       keyboard has nothing, so a character typed on the PC's serial console
       reaches Linux.
       ⚠️ **Each device is touched EXACTLY ONCE per call, and the order is
       load-bearing.** Both reads POP: `usb_getchar()` consumes a report slot,
       reading `UART_RX` consumes the byte. The UART is asked only after USB
       comes up empty, so a keystroke is never read and discarded. The keyboard
       wins a tie because it is the machine's own input device; nothing is lost,
       since `UART_RX` holds its byte and flags `UART_RX_OVF` if a second
       arrives first.
       🧪 `test_uart_rx_reaches_the_cpu` in `test_cpu.py` drives a real 8N1 byte
       at the pin and has a program poll +0x10 — the half `tb_uart_rx.v` cannot
       cover, since it tests the receiver as a module and not the CPU's ability
       to GET the byte. `tb_cpu.v`'s `uart_rxd` became a driven reg for it.
       Proven able to fail: `io_hi_m = 1'b0` (the +0x10 decode gone) spins the
       poll loop for ever, and shifting MSB-first delivers `0xd6` for `0x6b`.
       🔴 **NOT on hardware.** No bitstream has been built with any of this, so
       the receiver has still never met a real pin. It needs a place-and-route
       and a reflash, because the firmware lives in the bitstream.

11a.[x] 🔌 **The ESP32 PORT exists — 2026-08-10. The LINK does not.**
       `src/esp_uart.sv` at **0x0007_0000**: a second serial port on the
       ESP32's own pins (`wifi_rxd` **K3**, `wifi_txd` **K4**, verified against
       upstream's v3.1.6 file and cross-checked against v2.0 — unlike `wifi_en`
       and `wifi_gpio0`, these did not move between revisions). Reuses
       `uart_tx.sv`/`uart_rx.sv` rather than a second implementation.
       ⛔ **IT DOES NOT WAKE THE ESP32.** The control register resets to 0, so
       both straps are driven low out of reset — bit for bit what
       `ulx3s_top.sv` hardwired before. Waking is a write software makes on
       purpose and can undo in one more write.
       ⚠️ **WHY: THE ESP32's GPIOs ARE THE MICROSD BUS** — GPIO14/15/2/4/12/13
       are `sd_clk`, `sd_cmd`, `sd_d[0..3]`, and koti loads its kernel off that
       card. Whether an awake ESP32 actually drives them depends on the
       firmware it boots. That is an experiment, not a thing to assume.
       🧪 `tb_esp_uart.v` (17 checks; the FIRST is the safety property, proven
       able to fail) and `sw/esptest.c` + `+mark=4`, which runs the card three
       times for a stable baseline, reads `ESP_CTRL`, raises the straps in the
       right order (gpio0 THEN enable), listens, re-reads the card, puts the
       chip back and re-reads again — then prints a one-line VERDICT.
       📌 Post-route with it in: **30.44 MHz (pmod) / 30.16 MHz (bram)**,
       PASS at 25.
       🔴 **NOTHING HAS RUN ON HARDWARE.** The link has never carried a byte
       between two real chips, and the verdict is unmeasured. ▶️ **The bench
       session is one bitstream**: `image: esptest`, watch COM3, read the
       VERDICT line.

11. [x] 🌐 **Networking. DONE 2026-08-12 — koti fetched and displayed a real
       web page.** `koti-net get http://188.184.67.127/ info.cern.ch` returned
       `HTTP/1.1 200 OK`, `Content-Length: 646`, and the complete HTML of
       info.cern.ch, 874 bytes, rendered on the HDMI monitor. Run through the
       documented three-command sequence unaided, on the real board.
       ⚠️ Read the "no IP address" caveat at the end of this item before
       calling koti networked — it is still a modem client, not a network
       layer, and that caveat is the one part of this item still open.
       Two defects had to be fixed first, both invisible in simulation:
       - **`join` dialled before the radio was up.** `w.connect()` 150 ms after
         `w.active(True)` returns None like a good connect and then never
         associates, so it reported `address FAILED` about a network on the air
         with a correct password. 3 s of settle → `1010 True 172.20.10.2`.
       - **Every burst from the ESP32 loses its first character**, so an
         unpadded `print('KOTI-BEGIN')` arrives as `OTI-BEGIN` and `get` times
         out with the whole page already captured. Markers now print `zz`
         first. ⛔ NOT an `esp_uart.sv` defect — that FIFO pops only when
         non-empty and reads `fifo[rptr]` combinationally.
       (built 2026-08-10/11, finished 2026-08-12)
       ✅ (a) the link — `src/esp_uart.sv` at `0x0007_0000` on the ESP32's own
       pair (`wifi_rxd` K3 / `wifi_txd` K4), 64-byte FIFOs both ways, PLIC
       source 2.
       ✅ (b) Linux reaches it — `sw/linux/koti_esp.c` gives `/dev/ttyKOTI0`,
       plus **`esp_power`** and `esp_rx_count` in sysfs (2026-08-11), which is
       the only way to wake the ESP32 from Linux.
       ✅ (c) the stack — `CONFIG_NET`/`INET`/`SLIP` are on. The old text here
       said `grep -c CONFIG_NET` = 0; that has not been true since 2026-08-10.
       ✅ (d) the far end — `sw/linux/rootfs-overlay/usr/bin/koti-net`, **run
       on hardware 2026-08-12 and it fetched a page.** `wake`, `join`, `scan`,
       `get` and `off` are all measured on the real board.

       ⛔ **THE "STOCK ESP-AT" PLAN WAS WRONG FOR THIS BOARD, and it was wrong
       in the cheap direction.** The far end is not an unknown to be chosen: it
       was measured on 2026-08-08 and written down in `fpga/ulx3s/README.md`.
       That ESP32 holds **stock MicroPython 1.14**, whose `network` and
       `socket` modules are already an AT command set in a better language. So
       reaching a fetched page needs **no ESP32 reflash, no ESP-IDF toolchain,
       no esp-hosted, and no kernel networking** — `koti-net` drives the REPL
       over the tty like a modem. The SLIP route in `koti_defconfig` remains
       the way to a real IP address on koti, and it still costs custom ESP32
       firmware; it is no longer on the path to the first page.

       ✅ **`image: esptest` RAN 2026-08-11 AND THE CARD SURVIVES.** 25
       consecutive passes, unanimous: block 0 read identically with the ESP32
       held in reset, awake, and back in reset, while the link carried 477
       bytes. An awake ESP32 is a second driver on the microSD bus koti boots
       from (`sd_clk`=GPIO14, `sd_cmd`=GPIO15, `sd_d`=GPIO2/4/12/13), and it
       is measurably harmless. Procedure and results in `fpga/ulx3s/README.md`
       § 2e. ⇒ **the Ethernet-Pmod fallback is dead** and `koti-net` was not
       wasted work. `koti-net off` when done remains the right habit.

       ⚠️ Even when it all works, **koti has no IP address** — `ping`, `wget`
       and `ip` still fail. The ESP32 owns the TCP stack. Do not report this
       item done on the strength of a fetched page: (d) is a modem client, not
       a network layer.

11d. [x] 🖥️ **80 COLUMNS — DONE AND CONFIRMED ON HARDWARE 2026-08-09.**
       8x8 glyphs 1:1 in 640x480: 80x60, four times the text. Four places
       had to agree — `vga_text.sv`, `sw/console.c` (the FIRMWARE's console,
       which still writes that buffer for hvc0), `koticon.c`, and
       `tools/screenshot.py`.
       ⚠️ The charbuf changed KIND, not just size: 4800 bytes needs
       `__get_free_pages(order 1)` because the raster reads it by PHYSICAL
       address and two separate pages would render the bottom half of the
       screen from whatever else lived in the next frame.
       ⚠️ Timing margin fell from ~29 to **26.27 MHz** post-route (PASS at
       25) — real cost, still passing.
       ⛔ The arbiter was NOT the constraint. Video is under 2% of the bus
       even at 4x the fetches; I flagged it as a risk and was wrong.
       [superseded] 40x30 was too coarse to use (user, 2026-08-09).
       The raster is 640x480 and the font is 8x8 **doubled to 16x16**, which is
       where 40x30 comes from. Drawing 1:1 gives **80x60** in the same mode, or
       80x30 with double-height rows only.
       Why 80 specifically: every unix tool assumes it. At 40, `ls -l`, `dmesg`
       and `ps` wrap on every line, which is most of why the shell feels unusable.
       - cheap: the text buffer is 1200 → 4800 bytes, and `koticon` is mostly
         `KOTI_COLS`/`KOTI_ROWS` constants.
       - ⚠️ the real question: **`vga_text`'s fetch rate DOUBLES**, and the video
         DMA shares the memory bus with the CPU through `arbiter3`. Failure mode
         is flicker or CPU stalls, not a clean error, so measure the arbiter
         rather than assuming 32 MB of SDRAM makes it free.
       - ⚠️ THREE things must agree on the geometry: `vga_text.sv`, the
         `koticon` node in `sw/linux/koti.dts`, and the FIRMWARE's own console
         (`sw/console.c`), which still writes the text buffer for hvc0. A
         stride mismatch means two writers scribbling over each other.

11c. [x] 🇫🇮 **FINNISH KEYMAP — DONE AND CONFIRMED ON HARDWARE 2026-08-09.**
       `koti: fi keymap loaded`, and `-` types `-`. AltGr works, which is
       the bigger win: `@ $ { } [ ] \ |` are all AltGr on a Finnish board
       and none of them reached the screen before.
       ⛔ NOT hand-written. busybox `loadkmap` loads WHOLE TABLES, so a
       keymap is complete or it is wrong; `loadkeys --bkeymap fi` in CI
       emits it from kbd's upstream data. Only the 2311-byte file ships.
       ⚠️ tty1 ONLY — hvc0 still uses the FIRMWARE's own Finnish table in
       `sw/usbkbd.c`. Two tables, in two languages; changing one does not
       change the other.
       [superseded] the screen types a US layout — load a Finnish keymap.
       Noticed on hardware 2026-08-09: `-` comes out as `/`. **Expected, not a
       regression**, and it is the price of PLAN item 9. HID usage `0x38` is
       "the key right of period" — `/` on a US board, `-` on a Finnish one —
       and the thing that maps position→character MOVED when Linux took the
       keyboard:
       - before: `sw/usbkbd.c`'s **Finnish** table drew the screen;
       - now: `koti_kbd.c` reports a KEYCODE and **Linux's keymap** decides,
         and the kernel's built-in default is **US**.
       ⇒ The screen (tty1) is US; hvc0 is still Finnish, because the firmware
       still translates for it. Two layouts on one machine.
       Fix: a Finnish keymap in the rootfs overlay loaded at boot (busybox
       `loadkmap` takes a binary map; `loadkeys` is the full kbd package).
       Rootfs rebuild, ~26 min. ⚠️ Do NOT "fix" this by putting the Finnish
       table back in the driver — that would undo item 9 and make the keymap
       unchangeable again, which is the thing item 9 bought.

12. [x] 🧠 **Double the RAM — DONE 2026-08-08 in simulation, `MemTotal: 8780 →
       25004 kB`** (`Memory: 23996K/28672K available`, MemFree 3296 → 19452 kB),
       userspace still reached. **NOT yet run on hardware** — see the end of
       this item.
       **What changed:** the core's word address went from 23 bits to 24
       (PA[25:2]) so the device select stops eating an address bit. New map:
       `a[23:22]` = 00 flash+MMIO, 01 RAM low, 10 RAM high, 11 faults.
       ⭐ **RAM's base did NOT move, deliberately.** RAM is 0x0100_0000 ..
       0x02FF_FFFF, so the base is exactly half the size, which makes the
       offset `a - 0x400000` collapse to **`{a[23], a[21:0]}` — a bit
       selection, no adder** (verified exhaustively over all 8,388,608
       addresses before it was written). That is what kept both linker scripts,
       `sbi.c`'s `KERNEL_ADDR`, `sdboot.c`, `sdkernel.py`, `ktrace.py` and
       `tb_boot`'s `+ramoff` untouched; only the DTS length moved.
       ⭐ **`sw/memtest.c` was extended FIRST, as this item demanded**, and it
       earned it: a new `addrbits` phase walks a 1 across the address and NAMES
       the dead bit instead of printing millions of mismatches. On the old RTL
       it reported `BIT 24 dead @02010000 want dbb0b762 got ffffffff` — the read
       came back from flash — and on the new RTL it reports OK. The old 16 MB
       bound stopped exactly at the boundary of the bug, so the previous test
       **could not have failed**.
       🪤 **The trap that cost a boot run:** `dtc -o koti.dtb` at the repo root
       is NOT what ships. `sw/sbi/dtb.S` embeds **`sw/linux/koti.dtb`**, so the
       firmware carried the old 16 MB blob and the kernel dutifully reported the
       old number while every RTL check passed.
       🏆 **CONFIRMED ON THE REAL ULX3S, 2026-08-08 — both halves.**
       `image: memtest` (SW3 **off**): **eight consecutive clean passes**, each
       walking the full 32 MB with an address-derived pattern —
       `addrbits: OK`, `16M: OK`, `upper: OK`, `pass N CLEAN, errors: 0`,
       1120 bytes and 0 non-printable. The upper 16 MB physically decodes on the
       fitted part, through real bank and row wiring.
       `image: sbi` (SW3 **on**): `Memory: 24012K/28672K available`,
       **`MemTotal: 25020 kB`**, `MemFree: 19412 kB`, `Run /init as init
       process`, `koti: userspace is alive`, `buildroot login:`.
       📌 Boot cost ~0.65%: `Run /init` at **45.02 s** against 44.73 s with
       16 MB — the kernel initialises twice the page structs. Cheap for 16 MB.

       ~~(the original entry)~~ Found in the standalone boot log —
       `MemTotal: 8796 kB` — and it was
       **architectural, not a devicetree typo, so `koti.dts` was then
       CORRECT for the hardware as built.**
       **The cause is one bit.** `d_addr = byte_addr[24:2]`, and **`addr[22]` is
       spent as the flash/RAM device select**, so only `addr[21:0]` — 4M words,
       **16 MB** — ever reaches the SDRAM. ⭐ `src/sdram_ctrl.sv` already takes a
       full 23-bit word address (`8M words = 32 MB`) and drives the whole part;
       `src/project.sv` drops the top bit on the way in, with the comment
       "addr[22] is dropped on the way in: it was the device select".
       ⇒ The part, the controller and the pins are all fine. **Only the memory
       map is in the way.**
       ⚠️ **NOT a one-line change — these must move together or nothing boots:**
       - `src/project.sv` — a new flash/RAM select that does not eat an address
         bit (the CPU's `[24:2]` bus is already fully spent, so this likely
         means widening the address path, not just re-decoding it).
       - ⚠️ `sel_ram` is latched per-transaction (`inflight`/`sel_q`, and the
         comment there warns the obvious version is a trap). Whatever replaces
         `addr[22]` has to keep that capture-once behaviour.
       - `sw/linux/koti.dts` — the `memory@1000000` node.
       - the linker scripts and **SBI's kernel load address** (`0x0140_0000`).
       - `sw/memtest.c` — today it walks 16 MB and would still pass on a broken
         32 MB map, so **extend it first**; a memory test that cannot fail is
         the standing lesson of this repo.
       **Payoff:** 8.8 MB free -> ~25 MB, which is the difference between a
       machine that boots Linux and a machine that can run things on it. It also
       de-risks item 11, whose stack costs RAM koti does not currently have.

~~Parked — Koti-1 as a chip~~ — **REMOVED 2026-08-08 (user directive: "Koti
will not be taped out. Clean ASIC related stuff so the focus is on this FPGA
project purely").** The DFFRAM 32x32 regfile macro, the 8x2 harden and the
shuttle submission are no longer tracked here, and the apparatus that served
them is deleted rather than parked: `info.yaml`, `src/config.json`,
`docs/info.md`, the `gds`/`docs`/`fpga` workflows, the ASIC cocotb suite
(`test/tb.v`, `test/test.py`, `test/run.py`, `test/Makefile`) and every
`KOTI_FPGA` conditional in `src/`.
⭐ The collapse was proven behaviour-preserving rather than assumed: the old
`project.sv` preprocessed with `-DKOTI_FPGA` and the new one preprocessed with
nothing are **identical, 285 lines each**.
⚠️ **What the ASIC suite took with it, honestly.** Its five tests were all
built on the CPU reaching flash AND PSRAM over the QSPI pins — a configuration
that no longer exists — so they could not simply be moved. Two guarded named
defects:
- **F3** (disabling video parks the arbiter grant) → re-expressed as
  `test/tb_vga_grant.v`, at module level, no CPU needed, and **proven able to
  fail**: restoring `assign v_req = f_busy && en` trips it.
- ✅ **F1 — COVERAGE RESTORED 2026-08-10.** `test_flash_does_not_alias_into_the_
  mmio_window` plus its pair `test_mmio_window_is_readable` in `test_cpu.py`:
  a load from **0x0009_080C** (0x0001_000C + 512 KB) must return the flash word
  there, not QSPI_CFG. Proven able to fail by restoring the original defect —
  `io_m = addr_m[18:16] == 3'b001` — which returns `0x0` instead of the
  sentinel while the paired MMIO test still passes, so the mutant is caught for
  aliasing rather than for breaking MMIO outright.
  🪤 **It is TWO tests because this harness supports exactly one `run_program`
  per cocotb test.** Written as one test with two calls it hung at max_cycles
  ("program never halted"), which reads exactly like a decode bug in the core
  and is not one. All 24 pre-existing tests already obeyed the rule; it was
  simply never written down. It is now, in `run_program`'s docstring.
  `test_koti_boot_and_timer`, `test_vga_text` and `test_hello_c` went too;
  those are substantially covered by `tb_boot`, `tb_fpga_bram` and the real
  hardware, which is why they are not listed as gaps.

---

## Open items found 2026-08-12, by asking the running machine

Measured at koti's own shell the day networking closed, not inferred. None was
on the ladder; the first two are small and change how the machine feels.

13. [x] 🕐✅ **CONFIRMED ON HARDWARE 2026-08-12 — koti wakes up knowing what day
    it is.** Set the clock, `poweroff`, BTN0, and the next boot printed
    `koti: clock restored from the card: Wed Aug 12 15:53:35 UTC 2026`, with
    `date` reading 15:53:57 — the 22 s the boot took — instead of 1970.
    ⭐ `date -s @1786550000` returned exactly the instant `days_from_civil`
    computed, so the epoch arithmetic and busybox agree on real hardware.
    ⏳ Only `koti-net time` itself is unproven (blocked by item 27). `koti-net time`
    sets the clock from the `Date:` header of any HTTP reply, and `get` does the
    same on its own while the clock is still unset (never afterwards, so
    browsing cannot move a correct clock). The time is then written to
    `/mnt/.koti-clock` and restored by `S45kotisd` at the next boot, so a reboot
    starts from **when the machine was last running** instead of the epoch.
    ⚠️ **Monotonic, not accurate** — after a week unplugged it believes it is
    still the moment it was switched off. That is the point: file timestamps
    stay in the order the files were written. A DS3231 is still the real fix.
    ⭐ **The parser had a defect that the first execution of it found**: it read
    the RFC 1123 value year-first, assigning the day (12) to the year, so the
    plausibility guard rejected every good header as "an implausible server date
    (12)" — a correct-looking refusal. `sw/linux/test_koti_net.sh` caught it in
    two seconds; the round trip that would otherwise have caught it is ~70
    minutes and a card shuffle. ⛔ **Nothing in this repo had ever executed a
    line of the rootfs shell** before that test existed. It runs in `core-tests`
    under **busybox ash**, not bash — `$((08))` is an octal literal there, so
    two hours out of every twenty-four were a live trap.
    ⏳ **Still to prove on the board**: that `date -s @N` takes, that `/mnt` is
    mounted when `clock_save` runs, and that a reboot restores it.

    (original entry) 🕐 **koti does not know what day it is.** `date` answers
    `Thu Jan  1 01:01:50 UTC 1970`. There is no `rtc` node in `koti.dts` and no
    `ntpd` in the rootfs, so every boot restarts at the epoch and every file
    saved to the card is stamped 1970.
    ⭐ **The fix became free on 2026-08-12**: the HTTP reply that closed item 11
    carried `Date: Wed, 12 Aug 2026 14:06:38 GMT`. koti is already receiving
    the correct time and discarding it — `koti-net` can `date -s` from the Date
    header of any fetch. No NTP, no daemon, no hardware, no battery. A real RTC
    (a €2 DS3231 on the spare gp/gn pins) is the follow-up if the time should
    survive a power cycle, and is a separate, larger job.

14. [x] 💾✅ **CONFIRMED ON HARDWARE 2026-08-12.** `koti: microSD mounted at
    /mnt` on both boots, and `mount | grep kotisd` answers
    `/dev/kotisd2 on /mnt type ext2 (rw,relatime,errors=continue)`.
    ⭐ The `stop` path works too: after `poweroff` the next boot found the
    filesystem CLEAN, which only happens if S45kotisd unmounted it.
    `sw/linux/rootfs-overlay/etc/init.d/S45kotisd` mounts `/dev/kotisd2` at
    `/mnt` at every boot, and says which of four things happened.
    ⛔ **A script, not an `/etc/fstab` line, and the reason is item 7**: the card
    may already BE the root filesystem, and which of the two happened is CARD
    STATE that no file in this tree knows. An fstab entry would mount the live
    root a second time at `/mnt` — legal, and exactly the kind of thing that
    looks fine until something writes through the wrong one. So it checks
    `/proc/mounts` first and says `the microSD IS /`.
    Every failure path ends in a booting machine that names the reason, which is
    the same rule `sdboot.c` and `/init` already apply one layer down.
    ⏳ **Still to prove on the board**: that S45 runs before the login prompt and
    that `mount | grep kotisd` is no longer empty.
    ⛔⛔ **AND THE COROLLARY NOBODY HAD WRITTEN DOWN: if p2 ever holds a rootfs,
    every change in the initramfs silently stops taking effect.** `/init`
    switch_roots onto the card whenever p2 carries an executable `/sbin/init`,
    so the card's older userspace would win and `S45kotisd`, `koti-net`, `koti`
    and `10-koti.sh` would all be shadowed — on a machine that boots perfectly
    and shows no error at all. The probe failing (this item's own cause) is
    what keeps root in RAM today. ⇒ **`sdkernel.py write` puts a new kernel on
    p1 and is what a rootfs update needs; `writefs` is a different decision**
    that moves root onto the card, and after it every future initramfs edit
    needs `writefs` again or it does nothing.

    (original entry) 💾 **The microSD is NOT MOUNTED after boot** — `mount | grep kotisd`
    returns nothing on a booted machine. `rootfs-overlay/init:70` mounts the
    card at `/mnt` to probe for `/sbin/init`, does not find one, and
    **`umount`s it at line 77**; nothing mounts it again.
    ⇒ item 7's "koti saves files to the microSD" is true, but every boot you
    must `mount /dev/kotisd2 /mnt` by hand before you can reach what you saved.
    Two lines in `S99koti` or `/etc/fstab`. ⚠️ Keep the `sync` habit — ext2
    here has no journal.

15. [x] 🪤✅ **CONFIRMED ON HARDWARE 2026-08-12.** `ping 8.8.8.8` answers
    `ping: koti has no IP address of its own, so this cannot work.` and prints
    the three koti-net commands.
    `/etc/profile.d/10-koti.sh` defines `ping` and `wget` as shell functions
    that name the reason and print the three `koti-net` commands instead.
    ⛔ **Functions, not shims in `$PATH`** — busybox installs its applets as
    symlinks whose directory depends on the applet (`/bin/ping` but
    `/usr/bin/wget`) and the default PATH puts `/bin` first, so a dropped-in
    file would shadow one and not the other, which is worse than nothing. A
    function shadows the name for the interactive shell only: scripts still get
    the real applet and `command ping` reaches it.
    ⚠️ `ip`/`ifconfig`/`netstat` are deliberately NOT wrapped — they report on
    interfaces koti really has, and their output is truthful.

    (original entry) 🪤 **`wget` and `ping` are installed and cannot work.** Both are in the
    rootfs, and koti has no IP address — the ESP32 owns the TCP stack. They are
    the first two commands anyone reaches for, and they fail in a way that
    reads as "the network is broken" when it is working. Drop them, or wrap
    them to say `use koti-net`. (Genuinely fixed only by item 11's IP-address
    caveat, which is a much bigger job.)

16. [ ] 🔴 **Duplicate/lost keystrokes — A MECHANISM AT LAST, 2026-08-12.**
    Observed on the bench: `/etc/init.d/S45kotisd start` arrived as `tart`
    (22 characters gone), `date` as `ddate`, and `ps` RAN TWICE.
    ⭐ **`ps` showed TWO `-sh` processes (PIDs 80 and 81)** — the documented
    doubled console — and both are fed from the SAME single-entry input. Two
    consumers popping one byte register do not each get a copy: they SPLIT the
    stream, which is precisely the shape of the corruption seen. That also
    explains why a long line is shredded while a short one usually survives.
    ⚠️ It is the same class of defect as the two-`cat` capture split that
    `koti-net`'s `reader_start` already documents, one layer down.
    📌 Next step is to test it deliberately: log in on ONE console only and see
    whether the corruption stops. If it does, the doubled getty is the cause and
    the 2026-08-09 decision to keep hvc0's echo has a cost nobody had priced.

    (original entry) 🔴 **Duplicate keystrokes, undiagnosed** — the first USB login echoed
    `rooo. .. .t. .t`, never reproduced. Recorded at item 8 and repeated here
    because of what changed since: **PS/2 is deleted, so there is no fallback
    input path.** If the keyboard misbehaves there is nothing else to type on.

17. [x] 🔴✅ **THE GATE IS CONFIRMED ON HARDWARE 2026-08-12** (after item 27 was
    fixed, which is what let `koti-net` run at all):
    ```
    # koti-net repl
    koti-net: 'repl' has hung this machine before and is not
    koti-net: diagnosed (PLAN item 17). Use 'koti-net py' for
    koti-net: one-shot commands, which is what it is for.
    koti-net: If you really want it: koti-net repl -f
    ```
    ⛔ **THE HANG ITSELF IS STILL NOT DIAGNOSED** — only the gate and the
    `exec` removal are proven. Do not read a passing refusal as a fixed bug. —
    do not read this as a fix.** It is out of the help text, it requires `-f`,
    and it prints the recovery procedure before it runs.
    ⭐ **One thing was plainly wrong independent of the cause and is fixed: it
    used to `exec microcom`, REPLACING the shell.** That removed the only
    recovery path there was — quit microcom and there is no shell to return to,
    so the tty stays held and getty cannot respawn a login while it does.
    Whatever makes microcom hang, `exec` is what turned "a stuck program" into
    "a stuck machine". It is a child process now.
    Unconfirmed candidates for the hang itself: microcom leaves the tty in raw
    mode if it dies abnormally; a stale `cat $DEV` started outside the script
    splits the byte stream (`reader_stop` only knows our own pid file); and on
    hvc0 keystrokes reach BOTH consoles, so Ctrl-X may arrive somewhere other
    than where it is awaited.

    (original entry) 🔴 **`koti-net repl` wedges the machine.** microcom never returns and
    the console does not recover; on 2026-08-11 it took a `killall microcom`
    from a second session. It is a shipped subcommand listed in the help text.
    Diagnose or remove it — a command that hangs the computer should not be
    advertised.

18. [x] 🧹✅ **CONFIRMED ON HARDWARE 2026-08-12, AND IT EARNED ITS PLACE ON THE
    FIRST BOOT IT EXISTED FOR.** `koti: e2fsck repaired /dev/kotisd2 (exit 1)
    — mounting it`: the machine had been powered off without `sync`, the
    filesystem was genuinely dirty, and the checker fixed it. The next boot,
    after a clean shutdown, printed nothing — correct, because rc was 0.
    `S45kotisd` runs `e2fsck -p` before it mounts.
    ⛔ **busybox could not supply this.** Its `fsck` applet is only a dispatcher
    — it execs a `fsck.ext2` that did not exist, so `fsck /dev/kotisd2` on the
    machine as it stood failed in a way that read like a broken card. The
    checker had to come from **`BR2_PACKAGE_E2FSPROGS`**, asserted in
    `check_rootfs.py` because an unmet package symbol is dropped by
    `olddefconfig` in silence.
    ⚠️ **Only on the unmounted, not-root filesystem** — e2fsck on a mounted rw
    filesystem corrupts it, so if the card is `/` the earlier branch has already
    exited. And a filesystem it cannot repair is **still mounted**, loudly:
    refusing would hide the user's files behind a failure they cannot act on
    from a machine with no rescue shell.
    ⛔⛔ **SIZE: THE FIRST ATTEMPT FAILED THE BUDGET AND THE ESTIMATE WAS WRONG
    BY AN ORDER OF MAGNITUDE.** Run 31614542225 measured `rootfs.cpio` **1.18
    MiB → 7.04 MiB** against a 2.5 MiB budget, because Buildroot installs
    **fourteen** e2fsprogs programs and `BR2_STATIC_LIBS=y` gives each its own
    libc. "A few hundred KiB for a static e2fsck" was reasoning about a binary
    Buildroot never installs alone.
    ⇒ `sw/linux/post-build.sh` deletes the other thirteen and keeps `e2fsck`
    plus an `fsck.ext2` symlink (which also makes busybox's `fsck` dispatcher
    work — it execs `fsck.<type>`, and that missing file is why item 18 could
    not be done with busybox at all).
    ⭐ **Nothing would have failed at boot.** koti has 32 MB, so a 7 MiB
    initramfs fits; it would simply have spent ~a quarter of RAM, forever, on
    programs nothing calls, with no boot log mentioning it. **That is what a
    size gate is for — catching a cost that runs perfectly.**
    📌 While fixing it: `check_rootfs.py`'s budget comment still described a
    **12 MiB machine**, four days after `236d169` gave koti all 32 MB
    (`MemTotal` 8796 → 25020 kB). The comment is corrected; **the 2.5 MiB
    number is deliberately unchanged** — with no rootfs on p2 the initramfs is
    `/` for the whole session, so it is a discipline now rather than a wall.

    (original entry) 🧹 **The card mounts unchecked on every boot** — `EXT2-fs (kotisd2):
    warning: mounting unchecked fs, running e2fsck is recommended`, seen again
    2026-08-12. Nothing ever fsck's it, ext2 has no journal, and this machine
    is powered off by pulling a charger. Slow-burn corruption risk on the one
    thing that persists.

27. [x] 🔌✅ **FIXED 2026-08-12 THE SAME EVENING, AND IT WAS ONE CAUSE BEHIND TWO
    SYMPTOMS.** The board was running the bitstream flashed on 2026-08-08 for
    the standalone milestone. Two things landed AFTER it, both on 2026-08-10:
    - `e2b7d2b` added the `serial@70000` DT node ⇒ **no `/dev/ttyKOTI0`**;
    - `8588168` "hvc0 can be typed at: console_getchar reads the UART receiver"
      ⇒ **COM3 input reached nothing**, because that firmware never read the
      UART receiver at all. An hour went into that symptom looking at the
      ESP32, at pacing and at kdrive; the console was output-only by
      construction and no amount of driver work could have found it.
    ⛔ **EVERY `fujprog` LOAD SINCE HAS GONE TO SRAM, WHICH A POWER CYCLE
    DISCARDS.** That is why networking worked in the morning and died the moment
    we power-cycled for the card write. A board can silently travel BACKWARDS in
    time by being switched off.
    ✅ `fujprog -j flash koti-bram.bit` (a78900b, 140.72 s) fixed both:
    ```
    70000.serial: ttyKOTI0 at MMIO 0x70000 (irq = 1, ...) is a koti_esp
    koti_esp 70000.serial: koti ESP32 link on irq 1, 115200 baud, 64-byte FIFOs
    ```
    and COM3 typing reached the login prompt on the first try afterwards.
    📌 **The diagnosis was made from commit ancestry, not from the bench**:
    `git merge-base --is-ancestor` proved the local bitstream contained both
    commits, and `git diff a78900b..HEAD -- src/ sw/sbi/ koti.dts` was empty, so
    it was still current. That is the cheap move to reach for first whenever
    hardware behaves like an older version of itself.
    ⚠️ **STANDING RULE THIS ESTABLISHES: after any `fujprog` WITHOUT `-j flash`,
    the next power cycle reverts the machine.** If two unrelated things break at
    once after a power cycle, check which bitstream is in the flash BEFORE
    debugging either.

    (original entry) 🔌🔴 **`/dev/ttyKOTI0` DOES NOT EXIST on the running
    machine, so koti has no network at all.** `koti-net` dies immediately with
    `does not exist — is koti_esp bound? check dmesg`, which blocks items 13's
    network half, 17, 19, 22 and 23.
    ⚠️ **NOT caused by this batch** — nothing in it touches `koti_esp.c`, the
    devicetree or `src/`. Both boot logs show `kotisd`, the USB keyboard and
    SLIP registering, and **no esp/serial line at all**.
    📌 **First hypothesis to test, and it is cheap: the running bitstream.**
    ⛔ The DTB lives in the FIRMWARE inside the BITSTREAM, so the `serial@70000`
    node comes from whatever bitstream is in the config flash — not from the
    kernel. A `fujprog` load goes to SRAM and is LOST on a power cycle, so a
    board that was networking earlier today can lose the node simply by being
    power-cycled back onto an older flashed bitstream. That also fits the second
    symptom below.
    🔴 **Second symptom, possibly the same cause: COM3 INPUT DOES NOT REACH
    koti.** Output is perfect (the whole boot log arrives, and
    `echo COM3-TEST > /dev/hvc0` appears), but nothing typed from the PC ever
    echoes. Every command that ran on 2026-08-12 was typed at koti's own
    keyboard; `tools/kdrive.py` achieved nothing, despite `echo_wait=3.0`
    exceeding hvc0's 2 s poll ceiling.
    ⇒ Check which bitstream is in the flash BEFORE debugging either driver.

19. [ ] 🌐 **DNS: `getaddrinfo(name, 80)` → `OSError: -202`**, so only literal
    addresses can be dialled. Item 11 routes around it with `get URL [HOST]`.
    ⚠️ Forcing `8.8.8.8` via `ifconfig` did NOT help and may drop the
    association (a static ifconfig replaces the DHCP lease — re-`join` after).
    First thing to check is whether DHCP handed the ESP32 a usable resolver.

20. [ ] 📄 **A reader for what `get` returns.** `koti-net get` prints raw HTML;
    something that strips tags, wraps to 80 columns and follows a link by
    number is what makes koti a machine you read the web *on*. Self-contained,
    no hardware, and the first job that uses koti's own screen for something a
    terminal cannot do.
    📌 Survey `lynx`/`links`/`w3m` before writing one — porting `w3m` to rv32
    musl is plausibly less work than a renderer, and this is one of the few
    places on this project where reading beats measuring.

---

## Items added 2026-08-12 from the user's four questions

21. [ ] 🔊 **Sound. A PORT, not an invention — the jack is proven on this board.**
    `console/fpga/ulx3s.lpf:107` wires the **onboard 3.5 mm jack as a 4-bit R2R
    ladder per channel** (`audio_l[3]`→B3, `audio_l[2]`→C3, …) and the user
    heard music out of it on 2026-08-04. ⚠️ **koti's own LPF has NO audio pins**
    — the only occurrence of the word is a comment about the cartridge.
    Work: 8 pins in the LPF, a sigma-delta or PWM block, one MMIO register.
    ⚠️ **Scope it in three honest tiers, they are not the same job:**
    - **a beep** (tone register: frequency + gate) — an evening;
    - **sampled audio** — koti has no DMA, so at 8 kHz the CPU has ~3600 clocks
      per sample. A polling loop works; a small fabric FIFO is what keeps the
      CPU from being pinned to the DAC. A real project;
    - **an ALSA device** — much bigger than the RTL that feeds it. A raw
      `/dev/audio`-style write is the cheap 80%.

22. [ ] 🤖 **`koti ask` — koti as a client of a frontier model. THE TLS QUESTION
    IS SETTLED: the ESP32 can do it.** Measured on hardware 2026-08-12:
    ```
    zz ['ussl', 'ssl', 'ubinascii', 'ujson']            <- all import
    zz ussl-ok ['__class__', '__name__', 'wrap_socket']
    zz freeheap 4096736                                 <- 4 MB free (SPIRAM)
    ```
    A handshake needs ~40-50 KB against 4 MB, so headroom is not the issue.
    The endpoint is a plain `POST https://api.anthropic.com/v1/messages` with
    two headers (`x-api-key`, `anthropic-version: 2023-06-01`) — raw HTTP, no
    SDK, which is exactly what a machine like this wants. Smallest/cheapest
    model is `claude-haiku-4-5`.
    ⭐ **`ujson` on the ESP32 is what makes it work at all.** The link loses one
    byte per burst (see item 11), and a lost byte makes JSON unparseable — so
    **parse at the far end and send back only the extracted text.** Do not try
    to move raw JSON across this wire.
    ⚠️ An API key would sit in clear text in the initramfs or on the card, and
    every call costs real money. Decide both before building it.

23. [ ] 🌡️ **Weather station — the separate ESP32 + DHT22, and it needs NO new
    plumbing.** Have that ESP32 serve a tiny HTTP endpoint on the hotspot and
    let koti fetch `http://<its-ip>/`: a **local IP means no DNS** (item 19)
    and **plain HTTP means no TLS** (item 22). It works with `koti-net` as it
    stands today.
    `weather` is then a shell script: fetch, append to a log on the card, print
    the last 10 days. ⇒ **it needs items 13 and 14** — a clock for the
    timestamps and the card actually mounted to hold the log. That dependency
    is the argument for doing those two first.
    ⚠️ **Do not oversell it.** A DHT22 measures where it *is*, ±0.5 °C, one
    reading per 2 s, and needs a pull-up. Indoors that is room conditions, not
    weather; real weather means a forecast API, which needs item 22's TLS.

24. [x] 🧹✅ **CONFIRMED ON HARDWARE 2026-08-12.** `koti peek mtime` returned
    `0x00020010  0x72C2DF98 (CLINT cycle counter, low 32 …)` — a live counter
    read through /dev/mem. `koti peek kbd` REFUSED, with the keystroke warning.
    `koti help why is the date wrong` printed the CLOCK section.
    `/usr/bin/koti` — `koti peek` and `koti help`, and neither uses a model.
    - **`koti peek`** is a table of physical addresses (from `koti.dts` and
      `src/project.sv`) plus `devmem`. ✅ `CONFIG_DEVMEM=y` and
      `STRICT_DEVMEM` off were **checked in the built kernel's own
      `config-koti.txt`** before writing it, so this is not another applet
      that ships and cannot work (item 15).
      ⛔ **It REFUSES registers that change when read**, by name and by raw
      address: the keyboard and ESP32 queues pop, and **the PLIC claim
      register is the worst of them** — `src/plic.sv:70`, `inflight` is set by
      a claim and cleared only by a matching complete, so a stray peek does
      not lose one keystroke, it wedges that source permanently, on a machine
      with no PS/2 fallback left. `--force` overrides, loudly.
    - **`koti help QUESTION`** is a keyword table over `koti-help`'s sections,
      which are addressable now (`koti-help STORAGE`, `koti-help -l`).
      ⛔ **Retrieval, not generation: the worst it can do is show the wrong
      section of something a person wrote.** It cannot invent a fact.
      🪤 **A generic keyword wins ties and silently misroutes everything
      containing it** — `can` in WHAT IS HERE beat `compile` in WHAT IS NOT
      HERE. Keywords must name a subject. 13 real questions are gated in CI.
    📌 The interface is question-in, section-name-out **so item 25's classifier
    is a swap, not a rewrite** — and this is what it degrades to.

    (original entry) 🧹 **The housekeeper, tier 1: NO MODEL AT ALL.** The two example
    questions want different machines, and one of them wants no intelligence:
    - **"what is in memory location x" is not an AI question** — it is
      `devmem`. Deterministic, instant, exact. A neural net in front of it
      would be slower *and* occasionally wrong. koti has genuinely interesting
      things to peek at (`esp_rx_count`, `VGA_BASE`, the SDRAM window,
      `/proc`), so `koti peek 0x...` is an hour's work and zero weights.
    - **"how do I do X" is retrieval, not generation** — the answer is already
      in `MANUAL.md` and `koti-help`; the job is finding the right section.
      A command table plus `grep` covers most of it in ~200 lines of shell.
    ⇒ Build this first whatever else happens: it makes koti self-documenting,
    and it is the fallback item 25 degrades *to* rather than fails into.

25. [ ] 🧠⭐ **The housekeeper, tier 2 and the LAST tier — A TINY INTENT
    CLASSIFIER — TRAINED ON
    THE PC, RUNNING ON koti. This is the one where self-built weights genuinely
    pay, and it is small enough to understand end to end.**
    The model does not answer anything. It maps a fuzzily-worded question onto
    one of N known intents, and the intent then runs a **deterministic** action
    from item 24. ⇒ a misclassification shows the wrong help section; it can
    never invent a fact. That safety property is the reason to build it this
    way round.
    **Architecture that suits THIS machine** (hashed bag-of-words / char
    n-grams → embedding → one hidden layer → softmax):
    - vocab 4096 × 128-dim embedding = **524K params ≈ 512 KB at int8**;
    - ⭐ **the embedding table costs almost nothing at inference because it is a
      LOOKUP, not a matmul** — only the ~10 words actually present contribute,
      as 10 × 128 = **1280 adds, no multiplies**;
    - hidden 128×64 = 8192 MACs, output 64×50 = 3200 MACs;
    - **≈ 11K MACs total ⇒ ~12 ms** even at koti's slow 0.9M MAC/s.
    ⇒ **Instant on the real machine, half a megabyte on the card.** No
    attention, no sequence model, no float — integer dot products.
    **Training is a laptop job of minutes**, and the interesting work is the
    data: ~10-20 phrasings per intent, written by hand. ⚠️ **Training never
    happens on koti** — train on the PC or in CI, ship the weights to the
    microSD, koti does inference only. Same split as the kernel: heavy build in
    the cloud, artifact on the card.
    📌 Have it emit a confidence; below a threshold, fall through to item 24's
    `grep`. The model is then a pure improvement over the fallback, never a
    regression.

⛔ **26 was removed from the roadmap 2026-08-12 by user directive.** The number
is retired with it; **there is no item 26**, and the housekeeper is two tiers —
24 and 25.

⛔ **NON-GOAL, so nobody re-proposes it: a FRONTIER-CLASS LLM running ON koti.**
⚠️ **Read the scope of this before quoting it: it rules out a ~0.5B model doing
multiplies. It does NOT rule out item 25**, whose own arithmetic is in its
entry — ~11K MACs, about 12 ms, a few hundred KB — and which is therefore
governed by its measurements, not by this paragraph. **What is out of reach is
a model of that size, not the idea of weights on koti.**
Not "hard" — infeasible by about four orders of magnitude, and the arithmetic
is short enough to check. koti is ~29 MHz with an **iterative 32-cycle
multiplier** (`M extension`, above) and no FPU ⇒ **~0.9M multiplies/second**.
A 0.5B-parameter model needs ~1e9 multiply-accumulates **per token**:
- 1e9 ÷ 0.9e6 ≈ **1100 s/token — 18 minutes per token**; a 100-token reply is
  **~30 hours**. Assume a generous 10x from int8 tricks and it is still ~2
  minutes per token.
- Memory: 0.5B at 4-bit ≈ **300 MB against koti's 25 MB** — 12x over, with the
  weights streaming off the microSD every token.
⛔ **Claude Code specifically is not a porting effort either**: it is Node.js,
and V8 has no RV32 backend at all.
⇒ **There are two reachable versions of this wish, and they are different
wishes.** Item 22 rents someone else's model over a wire — koti as a terminal,
which is what a 1970s terminal was and no bad thing. Items 24-25 put weights
you built yourself on the machine. ⭐ **The second one is the one that fits this
project's spine** — physics → cells → CPU → Linux → **your own weights** is the
same move one layer up. Renting is useful; building is the point.

📌 **Suggested order across the whole list, given the dependencies above:**
13 (clock) → 14 (card mount) → **24 (housekeeper, no model — a day, and it
makes koti self-documenting)** → 23 (weather, which uses 13+14 and needs no new
plumbing) → **25 (the intent classifier — the first self-built weights, and the
end of that line)** → 19 (DNS) → 22 (`koti ask`) → 20 (browser) → 21 (sound).

## Architecture decisions — ALL FOUR CLOSED (2026-08-03 / 2026-08-04)

These gated the kernel ladder. Nothing here is open any more; the entries are
kept with their evidence because each one constrains work downstream of it.

1. ~~**Where does Linux's RAM live?**~~ **DECIDED AND WORKING 2026-08-03: the
   onboard SDRAM.** `src/sdram_ctrl.sv` speaks the same request-port contract
   as `qspi_ctrl` and is selected by `KOTI_FPGA` in `src/project.sv`, so the
   ULX3S build serves the RAM half of the map from the board's 32 MB part.
   Measured **10 clocks for a random 32-bit read against QSPI's ~130**.
   The flag is ON in all three build files and the harness suite is **4/4**
   with it on; the 2026-08-02 claim of "done" was made while it was 2/4 and the
   flag was off, so treat 2026-08-03 as the date this became true.
   ⚠️ **One bring-up number to confirm on the board**: `RD_ADV` in
   `sdram_ctrl.sv`. The part is clocked on `~clk`, which puts its read-data
   window one whole system clock ahead of a same-clock part's, and `RD_ADV=1`
   is what pulls the capture edge in to match. If the fitted part turns out to
   return data a clock later than `test/sdram_model.sv` predicts, that one
   parameter is the fix — nothing else moves. Getting it wrong is silent on
   writes and corrupts every read, which is exactly how it hid for four
   debugging rounds in simulation.
   The memory MAP is unchanged on purpose — `addr[22]` still picks flash from
   RAM, RAM still starts at `0x01000000` — so link scripts, the SBI firmware,
   the charbuf address and every existing test carried over untouched. The
   16 MB window reaches half the part; widening it needs a wider address bus
   through the core and arbiter, for memory sv32 Linux does not need.
2. ~~**Keyboard: keep PS/2, or move to USB?**~~ **DECIDED 2026-08-04 (user):
   USB HID host.** koti's keyboard is a USB one on `usb_fpga_bd_dp/dn`;
   PS/2 is no longer the target shape.
   - **Consequence, act on it: the PS/2 keyboard comes OFF the shopping
     list.** It was the last unbought item on the FPGA critical path, so
     there is now nothing left to buy for koti bring-up.
   - ⚠️ **PS/2 stays in the RTL until USB is proven on hardware.** It is
     ~50 flops, it is tested end to end, it is already wired to `gp[8]/gp[9]`
     in the LPF, and it is the only keyboard path that works today. Deleting
     a working input before its replacement has ever seen a real device would
     leave bring-up with no keyboard at all. Retire it once USB types a
     character on the board, not before.
   - What was weighed: the usual argument for USB is "mainline Linux already
     has drivers", and that argument does **not** hold here — a soft host
     core on the ECP5 is not an EHCI or OHCI controller, so mainline would no
     more recognise it than it recognises koti's one-word PS/2 register
     (ladder item 8). Both paths need a small custom driver. USB's real win
     is that it works with keyboards you already own.
   - Scope, so this is not mistaken for a small job: a low-speed (1.5 Mbps)
     host needs its own oversampling clock domain, device enumeration
     (`SET_ADDRESS`, `GET_DESCRIPTOR`, `SET_CONFIGURATION`, boot protocol),
     and periodic IN transactions on the interrupt endpoint, before any
     8-byte HID boot report reaches software. Vendor a proven core rather
     than writing the protocol from scratch — the same route the console repo
     took for the Gamepad Pmod, where upstream's reference receiver is
     protocol truth and koti-side code is a thin adapter.
   - **It does not gate the kernel ladder.** Rung 1 runs its console on the
     UART, so this lands at ladder item 8 as before — the decision changes
     *what gets built there*, not *when*.
3. **Video: BOTH — HDMI is the standard output, VGA stays. REVERSED BY USER
   DIRECTIVE 2026-08-07: *"make HDMI the standard video output of koti as
   well"*, scoped to "port console's GPDI, keep VGA too".**
   ⛔ **The 2026-08-04 decision below said "GPDI is off the roadmap". That is
   SUPERSEDED — do not quote it as current.** Its reasoning is kept because it
   is still correct about the *cost*, and about the one thing that makes this
   cheap: both paths hang off the same RGB + sync signals, so HDMI is a pure
   output-side addition that need not touch the text pipeline.
   - **Why this is now cheap rather than speculative: `console` has GPDI/HDMI
     WORKING ON THIS EXACT BOARD** (colour bars on the real monitor,
     2026-08-06). `console/fpga/tmds_encoder.sv`, `dvi_tx.sv`, `pll_25_125.v`
     and `gpdi.lpf` are proven silicon-adjacent code on a ULX3S 85F. Vendor
     them the way `vendor/sd_spi.sv` was vendored — do not write a TMDS encoder.
   - **VGA is kept**, not deleted: it costs nothing, it already works, and the
     Tiny VGA Pmod is bought. Same rule as PS/2 vs USB — a working path is not
     removed until its replacement has been seen working on hardware.
   - Still true and still the real work: a **~125 MHz DDR clock domain** and a
     PLL, on a design whose post-route Fmax is 31.05 MHz. The video clock is
     separate from the system clock, so this is a CDC question, not a timing
     regression — but it is the part to be careful with.

   ~~(superseded 2026-08-04 reasoning)~~ The VGA path is already complete —
   `vga_text.sv` + `vga_timing.sv`, the `uo` VGA personality in `project.sv`,
   and J2 constrained in `ulx3s.lpf` — so that decision cost zero new work.
   Hardware was never the constraint either way: the monitor bought 2026-07-30
   takes **both** VGA and HDMI.
4. ~~**Caches.**~~ **DECIDED 2026-08-04 (user): an I-cache now, a D-cache
   later. IMPLEMENTED — `src/icache.sv`.**
   - **The number that settled it.** Walk `sdram_ctrl`'s FSM at 25 MHz, where
     `C_RCD` and `C_RP` are one clock each and `RD_WAIT` is zero:
     `IDLE→ACT→RCD→RD→RD_WAIT×2→DONE×2` is **8 clocks for one 32-bit word**,
     and a burst is a second full pass because the first auto-precharged the
     row. So a 64-bit fetch is **~16 clocks for two instructions — ~8 clocks
     per instruction of pure fetch**, which dominates CPI (~11-12) and pins
     the machine near **2 MIPS**. A hit answers in one clock.
   - **Shape:** 512 entries × 64 bits, physically indexed and tagged. A line
     is exactly the *pair* the fetch port already asks for, which is what
     makes one memory transaction fill one line and deletes the
     straddling-pair case entirely. Costs **3 of the 85F's 208 block RAMs**;
     koti used zero before. Full reasoning in the header of `src/icache.sv`.
   - **`fence.i` is no longer a NOP.** It was one (`control.sv` had no case
     for it) and that was harmless with nothing in front of memory; with a
     fetch-side cache it is what makes code written through the data port —
     a bootloader staging a kernel, a module loader — executable. Decoded in
     `koti_core.sv`, it invalidates the cache and serializes fetch the same
     way `sfence.vma` has since F2.
   - **`sfence.vma` deliberately does NOT flush it.** The cache is tagged on
     physical addresses (`if_addr` is `fpc_pa`, post-translation), so
     remapping a page cannot leave a stale line behind. Page-table walks,
     which share the fetch port, **bypass** the cache — otherwise a cached
     PTE would outlive the `sfence.vma` meant to retire it.
   - ~~**A D-cache is deliberately not part of this.**~~ ✅ **It was built and
     enabled on 2026-08-08** — see item 10 above. The coherence question the
     data side has and the fetch side does not was answered by making it
     write-through rather than by managing it. The kernel that was wanted "to
     measure" now exists, and it measured 8.9% at realistic memory latency.
     The cheaper companion is still unbuilt and still worth more per hour: an
     open-row policy and a real 4-word SDRAM burst would make line fills
     roughly twice as fast, for BOTH caches, and `sdram_ctrl`'s own header
     already names both as the performance left on the table.

Precedent that the memory-starved version works at all: KianV RV32IMA uLinux
SoC (TT06, 30 MHz, QSPI Pmod).

Base: TinyRV32 (tt-riscv), core vendored in `core/`. The QSPI memory
subsystem (fetch FSM, 2:1 arbiter, serial-boot + quad opt-in) carries
over; it becomes a 3-port arbiter (ifetch / data / video DMA).

## Architecture deltas vs TinyRV32

1. **Back to 32 registers.** Mainline Linux has no usable RV32E port;
   RV32IMA is the floor. Routing evidence from tt-riscv hardening:
   32-reg regfile failed 4x2 @ 75% (390k violations) but routed at
   6x2 @ 55%. Target **8x2 tiles @ ~55%** — the largest size the
   template offers (16 tiles; the square 4x4/5x4 "colossal" formats
   were a TT08 experiment and would need arranging with TT). If the
   wide aspect ratio hurts routing, that conversation is the fallback.
2. **M extension**: iterative multiplier/divider (32 cycles, tiny).
   CPI is memory-dominated anyway; do not spend area on a fast one.
3. **A extension** — DONE 2026-07-18, in the core, not the controller
   (revising the earlier sequencing note): AMOs are a 2-phase M-stage
   RMW microsequence (astall) that rides whatever memory M talks to,
   so the same logic works over BRAM now and QSPI after unification —
   nothing throwaway. LR = load + reservation; SC = conditional store
   + success flag, no FSM. Uniprocessor reservation rules: dies on any
   store/SC/RMW/trap. 2 tests: all 9 AMO ops with hazard checks; the
   LR/SC protocol incl. intervening-store kill. Bonus fix while adding
   commit gating: EX commands (trap/mret/csr-write) held across a
   multi-cycle stall used to re-fire and clobber the MPIE/MIE stack —
   all now gated on the actual commit cycle (!pstall).
4. **Privilege + CSR**: M/S/U modes, trap/mret/sret, wfi-as-nop,
   mstatus/mie/mip/mtvec/mepc/mcause/mscratch + S-mode twins, medeleg/
   mideleg, satp. One `csr.sv` module — M-mode half DONE 2026-07-18:
   CSR ops execute in EX and forward like ALU results; precise
   EX-taken traps (older stages always commit, the wrong-path fetch
   dies like a mispredict); ECALL traps (it is the SBI path), **EBREAK
   now halts** (role moved from tt-riscv's ECALL); MRET; WFI=NOP;
   mtip/msip/meip ports (never injected onto an in-flight muldiv).
   Compliance gaps CLOSED 2026-07-18: **illegal-instruction traps**
   (cause 2, mtval = instruction bits) for unknown major opcodes,
   bad funct3/funct7 combos, bad SYSTEM encodings, unknown CSRs,
   CSR privilege + read-only-write violations, and mret/sret/sfence
   below their privilege — illegal instructions are excluded from
   memory ops, muldiv, CSR writes and branch redirects.
   **Misaligned traps**: load (4) / store-AMO (6) with mtval =
   address (page faults outrank misalign per the spec priority
   table), and misaligned fetch targets (cause 0) on taken jumps
   with mtval = target. Verified by a 7-trap cause/mtval sequence
   test and a U-mode CSR-privilege test (incl. SRET-in-U); 15/15
   directed + 58/58 official + pin-level green. Remaining known
   gaps: mcycle/minstret, MPRV, EBREAK halts instead of raising
   breakpoint (deliberate), coarse funct7 legality corners.
5. **sv32 MMU**: hardware page-table walker sharing the data port;
   split I/D TLBs, 2–4 entries each, flop-based. sfence.vma flushes
   both. TLB miss = walker microsequence (2 loads). Keep it dumb.
6. **CLINT** (`src/clint.sv`, done): mtime/mtimecmp/msip, compact map.
7. **PLIC-lite**: 4 sources (UART rx, PS/2 rx, vsync, spare), fixed
   priority, claim/complete registers. Linux `plic` driver compatible
   enough, or a tiny custom driver — decide at software bring-up.
8. **VGA text mode** (`src/vga_timing.sv` done, `vga_text.sv` next):
   - 640x480@60. Core clock 50 MHz, pixel enable at /2 (25 MHz —
     monitors accept 25.0 vs 25.175).
   - 80x30 chars, 8x16 font. Charbuf lives in **PSRAM**; on-die is only
     a double line buffer (2x80 bytes) + font ROM (96 glyphs x 16 B =
     1536 B, synthesized as logic — budget ~3-5k cells, measure early;
     fallback 8x8 font / 64 glyphs halves it).
   - Prefetch: one 80-byte charbuf burst per 16 scanlines, issued at
     hblank with absolute priority in the arbiter. Bandwidth is trivial
     (~240 kB/s); the design problem is *latency bounding* — the burst
     must fit in hblank + inactive rows, verify worst case in sim.
9. **Pinout** (verify against Tiny VGA Pmod docs before freeze):
   - `uio[7:0]`: QSPI Pmod, identical to tt-riscv. All 8 taken.
   - `uo[7:0]`: Tiny VGA Pmod (RRGGBB + HS + VS). All 8 taken.
   - `ui`: ps2_clk, ps2_dat, uart_rx, boot straps (uart-mux, quad-dis).
   - **UART TX has no free pin** → mux onto the blue LSB `uo` pin,
     selected by reset strap on `ui` + MMIO override. Early bring-up
     runs headless with UART; once fbcon works, blue LSB returns.
     5-bit-blue cost is invisible in text mode.

## Memory map (as built — this table was a draft until 2026-08-04)

| Range | What |
|---|---|
| 0x0000_0000+ | flash XIP: SBI firmware; `.payload` at 0x4000, `.dtb` at 0x6000 |
| 0x0001_0000 | MMIO: LED, UART, GPIO-lite, QSPI_CFG (as tt-riscv) |
| 0x0002_0000 | CLINT (full 64 KB window decoded) |
| 0x0004_0000 | VGA ctrl + PS/2 (full 64 KB window) |
| 0x00C0_0000–0x00FF_FFFF | **PLIC** — the top 4 MB of flash space, not a 64 KB carve-out: it is register-compatible with `sifive,plic-1.0.0`, whose driver hard-codes the context registers at offset 0x200000 |
| 0x0100_0000+ | RAM, 16 MB window. ULX3S: the onboard SDRAM. QSPI build: 8 MB PSRAM |
| 0x0100_0000 | firmware .bss + M/S stacks + VGA charbuf, 64 KB, reserved in `koti.dts` |
| 0x013F_0000 | where the firmware copies the DTB before entering a kernel |
| 0x0140_0000 | Linux load address — the first 4 MiB boundary clear of the above, which is also what the Image header's `text_offset` asks for |

`addr[22]` picks flash from RAM throughout, which is why the PLIC comes off
the TOP of flash space: software keeps a contiguous run from zero.

M-mode firmware: **write our own minimal SBI** (console putchar via
UART/VGA, timer via CLINT, ~2-4 KB) — OpenSBI is too big for XIP+8 MiB
comfort. KianV's firmware is the reference.

## Software ladder

1. riscv-tests rv32ui/um/ua — DONE 2026-07-18: **all 58 official
   tests pass** on koti_core over the XIP model (fence_i and ma_data
   skipped as on tt-riscv: XIP ROM / no misalign support). Koti env
   uses EBREAK for pass/fail (ECALL traps here). Prebuilt bins
   committed (44 KB) so CI runs the suite without the toolchain;
   rebuild with test/build_riscv_tests.py (needs CPU repo + xpack
   gcc). Privilege (rv32mi subset) deferred until illegal-instr +
   misalign traps exist (milestone 8).
2. ~~xv6-riscv (rv32 port)~~ and ~~Buildroot nommu uLinux~~ — **both CUT
   2026-08-04**; see the ladder above and `sw/linux/README.md`. Going
   straight at sv32 Linux was the right call and the evidence is that it
   boots.
3. **Mainline Linux sv32 + `koti.dts` — BOOTS to SLUB init, 2026-08-04.**
   Next: past SLUB, then a busybox userspace, then fbcon on the text console.
4. Yocto layer (meta-koti) once the kernel is stable — feeds the
   bigger own-PC project.

## Verification / bring-up

- ~~Verilator full-boot sim~~ — **done with iverilog instead, 2026-08-04**:
  `test/tb_boot.v` + `test/sim_mem.sv` boot the real Image at ~45 kHz
  simulated, which is 11 M clocks in about seven minutes and enough to reach
  SLUB init. Verilator becomes worth the extra harness only when the boot runs
  long enough that iverilog cannot finish it — i.e. once userspace starts.
- ULX3S 85F: same RTL + real QSPI Pmod + real monitor.
- Gate-level of the arbiter/video corner: video underrun under worst
  case ifetch+data+walker contention.
- cocotb pin-level suite as in tt-riscv; TT precheck; then submit.

## Milestones

1. [~] Core surgery (2026-07-18):
       - 32 regs: free — the vendored core/ is the RV32I FPGA pipeline
         (the RV32E cut lived in tt-riscv's ASIC-side copies).
       - M: `core/muldiv.sv` (iterative, 32-cycle, shared datapath) +
         decode (`funct7[0]` on OP) + whole-pipe md_stall in cpu_pipe;
         result rides EX/MEM and forwards normally. Unit-tested: 1252
         vectors (edge cross-product + seeded random) green vs a
         Python golden model, `test/run_core.py`.
       - Found+fixed latent hazard: SDRAM ack landing while the pipe
         is frozen by md_stall would re-issue the transaction; added
         sd_seen/sd_data_r capture in M.
       - Instruction-level harness landed (same day): sim imem/dmem/
         audio_gen models + tb_cpu + a tiny Python assembler
         (`test/run_cpu.py`). 4 directed programs green on the real
         pipeline: 32-reg exercise, M ops incl. div-zero/overflow,
         M-result forwarding chains, load-use into muldiv, taken
         branch killing a speculative mul. CI runs both core suites
         (core-tests.yaml). This harness is the vehicle for the
         official riscv-tests later.
       - A extension DONE in-core (see delta 3). Core ISA is now
         RV32IMA + Zicsr + M-mode traps — KianV-class. 9/9
         instruction-level tests green.
2. [x] Peripheral trio: `vga_timing.sv`, `ps2_rx.sv`, `clint.sv`
       (2026-07-18).
3. [~] cocotb suite (2026-07-18): bring-up top `tt_um_koti` (VGA
       checkerboard + PS/2-selected colors) passes 3 pin-level tests —
       reset pattern, hsync width/period, PS/2 frames incl. bad-parity
       reject. Open: clint bench (not yet wired into top), vsync
       count, VGA frame dumped to PPM.
4. [x] `vga_text.sv` DONE (2026-07-18): 80x30 text, 8x8 font in 8x16
       cells (line-doubled) — font ROM only 768 B (tools/genfont.py
       generates src/font_rom.svh from the public-domain font8x8 set;
       **glyph art needs visual verification on FPGA before tapeout**).
       Ping-pong 80-byte line buffers; row r+1 fetched during row r
       (10 pair-reads, ~3.3 scanlines worst-case serial vs 16
       available); row 0 prefetched at vblank line 508, swap at row
       ends + line 524. `arbiter3.sv`: video > data > fetch, grant
       held to ack (worst video wait = one serial burst, ~132 clk).
       SoC: VGA/PS2 MMIO block at 0x0004_0000 (ctrl/base/colors/
       keyboard, read-clears avail — captured pre-clear after a
       classic read-race bug), ps2_rx wired to ui[1:0], kb_avail →
       meip. uo personality is software-switched: headless at reset
       (UART/HALTED/LED — all older tests still pass), Tiny VGA once
       VGA_EN set, UART mux onto blue LSB via ctrl bit 1. Pin-level
       test renders 'K' row 0 pixel-exact on uo after a PS/2 MMIO
       round-trip. Bug found: hblank_start was visible-lines-only,
       silently killing the vblank prefetch + frame swap.
       **First 8x2 harden attempt FAILED as predicted by risk #1**
       (run 29655252221): 247.9k um^2 of logic on a 302.4k um^2 core
       = 94.5% utilization, detailed placement (DPL-0036) gave up.
       Fallback levers pulled (2026-07-18): TLBs 4->2 entries each;
       **40x30 text** (16x16 cells, pixels doubled both ways — halves
       the line buffers to 2x40 B and the row DMA to 5 bursts);
       **64-glyph font** (lowercase folds to uppercase in vga_text,
       C64 style — ROM now 512 B). All suites re-green.
       **Harden campaign log (2026-07-18, 5 attempts)**:
       1. 50 MHz, full design: 94.5% util, DPL-0036 at placement.
       2. After cuts: 69.7% util, PLACES; dies in setup repair — the
          template's CLOCK_PERIOD was 20 ns (50 MHz), never our
          target. 1338 violating endpoints.
       3. CLOCK_PERIOD=40 (25 MHz real): CI network timeout (noise).
       4. Re-run: setup violations 1338 -> 223, but pre-CTS
          fanout/slew repair inserts ~2900 buffers -> placement
          80.8% -> post-CTS legalization fails (DPL-0036).
       5. + registered VGA pixel pipe: no change (251 endpoints,
          81.4%) — the dominant fanout/timing is in the CPU (pstall
          network, TLB-after-ALU), not the video path.
       **Conclusion**: flop-everything RV32IMA+MMU+VGA saturates 8x2
       at ~70% pre-repair; the flow needs ~10-15% more headroom than
       exists. The design is CLOSE — it places and mostly times at
       the real clock; only repair margin is missing.
       **RF-macro research (2026-07-18)**: TT has an experimental
       **32x32 register file macro by Sylvain Munaut** — *exactly*
       our regfile: 2 read ports + 1 write port, 32x32, ~88% of ONE
       tile (vs our multi-tile flop version), no DRC waivers,
       validated on ttsky25b (tt_um_tnt_rf_validation; repo cloned
       to ../rf-val for reference — public sources are a stub, the
       macro GDS/LEF/lib/model are NOT publicly packaged).
       **Pipeline made macro-ready (2026-07-18)**: decided not to
       wait on the read-timing question — architected for sync-read
       (registered address, read-first), the superset-compatible
       assumption (a comb macro + input address register reproduces
       it exactly). src/regfile.sv is now the sync-read behavioral
       model; the pipeline's r1_e/r2_e operand registers are GONE
       (the RF read output is the pipeline register), the WB->ID
       bypass became latched hit flags + value (byp*_e/bypv_e), and
       a freeze-time address mux re-selects the EX instruction's
       registers so operands stay coherent through stalls. All
       suites green first run. The macro is now a body-swap in
       regfile.sv + LibreLane config.
       **CORRECTED 2026-07-22 (verified, NOT a human ask):** AUCOHL/DFFRAM
       generates the sky130 32x32 2R1W register file directly (netlist+LEF+GDS+
       lib) — its docs list "Register File: 32x32 (2R1W)". The old fallback line
       was WRONG: DFFRAM is not 1RW-only. Path: run dffram.py under OpenLane/nix
       (CI, or WSL once installed) -> commit the macro -> body-swap regfile.sv
       (guard a USE_MACRO branch, keep the behavioral model for sim) + LibreLane
       EXTRA_LEFS/GDS/LIB + macro placement -> re-harden 8x2. CONFIRM the DFFRAM
       RF read timing (comb vs registered) vs regfile.sv's sync-read/read-first
       model; add an input address register if the macro reads combinationally.
       Deeper fallbacks (fanout pruning, colossal tile) unchanged, now unlikely
       needed.
5. [~] Bus unification (2026-07-18): `src/koti_core.sv` is now THE
       core — rv32_core.sv's fetch FSM/data port/MMIO merged with the
       RV32IMA+Zicsr pipeline; `src/qspi_ctrl.sv` (+2:1 arbiter)
       vendored from tt-riscv. core/cpu_pipe.sv and cpu.sv remain as
       frozen references. All 9 instruction-level tests re-run against
       koti_core over the XIP model (LAT=4) — green first run; data
       moved to the PSRAM map (0x0100_0000+). CLINT/PLIC/VGA MMIO
       (0x0002_0000+) rides the data port for the SoC top to decode.
       SoC top DONE (same day): `src/project.sv` is the real
       `tt_um_koti` — koti_core + arbiter + qspi_ctrl + CLINT
       (intercepted on the data port at 0x0002_0000, 1-cycle ack,
       mtip/msip wired to the core). Headless v1 pinout = tt-riscv's
       proven demo layout (uio QSPI Pmod, uo UART/HALTED/LED, ui
       GPIO). Shared modules copied core/ -> src/ (TT wants sources in
       src/; src/ is canonical now). Pin-level test: boots from the
       SpiMem flash model over real SPI protocol, PSRAM serial+quad
       traffic, CLINT timer irq into a handler, EBREAK halt — 1/1,
       first run. VGA/PS2 bring-up stub retired; vga_timing/ps2_rx
       coverage returns with the video milestone. info.yaml now 8x2 —
       the GDS action attempt gives the first honest area datapoint.
       Open: 3-port arbiter + video priority with worst-case latency
       proof (video milestone).
6. [~] csr.sv M-mode DONE with 3 instruction-level tests green (CSR
       RMW forms + forwarding, ECALL->handler->MRET resume, async mtip
       interrupting a spin loop — 7/7 in test/run_cpu.py). Open: wire
       CLINT's mtip/msip to the core in the SoC top; official riscv
       privilege tests once the XIP harness exists.
7. [~] Software track started (2026-07-18): `sw/` — crt0 (flash XIP,
       .data copy to PSRAM, bss zero, EBREAK on return), link.ld,
       koti.h MMIO map, console.c (80x30 VGA console: cursor/newline/
       scroll — the future SBI console), build.py (xpack gcc,
       rv32ima_zicsr). hello.c (601 B) proven pin-level: UART banner
       decoded bit-by-bit at uo[0], then the VGA console brings the
       pins up and "KOTI-1 / hello, visible world" lands in the
       charbuf. hello.bin committed so CI runs it.
       **SBI firmware DONE (2026-07-19, sw/sbi/)**: boot + delegation
       (mideleg 0x222, medeleg 0xB151 — illegal stays in M for rdtime
       emulation, ecall-from-S is the SBI), full-frame trap shim with
       mscratch stack swap, legacy SBI set_timer/putchar/getchar,
       M-timer -> STIP injection, and **rdtime/rdtimeh emulated via
       the illegal-instruction trap** (mtval decodes the CSR read).
       Console mirrors to UART (on the blue LSB, uo[6]) + the VGA
       charbuf. Proven pin-level: the S-mode payload prints 'S', arms
       the timer via rdtime, takes the delegated S-timer irq ('T'),
       finishes ('K') — decoded off uo[6], mirrored in the charbuf.
       mcycle/minstret CSRs added (retire counted at W advance).
       Datasheet (docs/info.md) written for real. This is the exact
       runtime contract xv6/Linux sit on. Next: xv6 (kernel rungs
       need a Linux build env).
8. [~] S/U privilege plumbing DONE (2026-07-18): `src/csr.sv` rewrote
       with M/S/U modes, full mstatus (MPP/SPP/xPIE/xIE stack),
       S-mode CSR set (sstatus/sie/sip/stvec/sepc/scause/stval/
       sscratch/satp), medeleg/mideleg, sret, S-irq injection via
       M-writes to mip (STIP/SSIP/SEIP), spec-correct interrupt
       take/delegation rules. satp is a plain register until the
       walker lands. core/csr.sv stays the frozen M-only ancestor.
       3 new tests: delegated ecall-from-S handled in S + sret;
       ecall-from-U to M with MPP=U; and the Linux timer flow — M
       takes MTI, masks, injects STIP, delegated S-timer trap lands
       at stvec.
       **sv32 MMU DONE (same day)**: `src/tlb.sv` (4-entry fully-assoc
       I and D TLBs, FAULT-caching entries, uniform 4K fills — mega-
       pages fill as the resolved 4K entry); i-walker embedded in the
       fetch FSM (PTE reads ride the fetch port; walks complete even
       across redirects — fills are path-independent); d-walker at EX
       borrowing the data port while M is quiet, so ALL traps stay at
       the one precise EX commit point and stval gets the faulting VA
       (Linux do_page_fault needs it). SUM + MXR in mstatus; A=0 or
       D=0-on-store fault (spec-allowed, kernels cope); page-crossing
       pair fetches drop the skid word; sfence.vma flushes both TLBs
       and serializes the pipe; satp writes flush too. Fetch faults
       poison one NOP that traps at EX (cause 12); load/store faults
       are causes 13/15 with tval. End-to-end test: M builds real
       tables, S runs translated, RW 4K page round-trips to its PA,
       RO store + unmapped load + unmapped fetch fault in order with
       correct mtval, RO page physically untouched. 13/13 directed +
       58/58 official + pin-level green. Open: xv6 boot (software),
       MPRV gap logged.
9. [ ] Mainline Linux sv32 boots to shell on fbcon, Verilator + ULX3S.
10. [ ] Harden at 8x2 @ ~55%; iterate. Submit to the next shuttle
        after TTSKY26c (this is NOT a TTSKY26c project — no rushing a
        privilege-mode CPU past signoff in seven weeks).

## Risks (ranked)

1. Font ROM + line buffer + TLB flop area blows the 8x2 budget →
   measure in trial hardens from milestone 4 on; fallbacks: 8x8 font,
   2-entry TLBs, negotiating a colossal tile with TT.
2. sv32 walker/TLB bugs are the classic Linux-boot graveyard → xv6
   first, and the privilege test suite before any kernel.
3. Video underrun under contention → bounded-latency arbiter proof in
   sim before hardening.
4. 50 MHz timing on Sky130 through the MMU-extended load path → the
   TLB lookup must not sit in series with the whole ALU; pipeline it.
5. One-chip-per-tapeout: everything must work first silicon → the
   Verilator-boots-Linux gate is non-negotiable before submission.
