# Koti-1 — a home computer, built from the CPU up

*Koti* (Finnish: "home", from *kotitietokone* — home computer.)

A computer you can sit down at: an RV32IMA CPU with an sv32 MMU, 32 MB of
SDRAM, a microSD filesystem, an HDMI screen and a USB keyboard, running
mainline Linux 6.12 — on a ULX3S 85F FPGA board.

Not a demo that boots once for a photograph. You log in and use it.

![koti's screen, at a shell](docs/img/koti-shell.png)

> Reconstructed, not photographed — see [About these images](#about-these-images).
> That is koti's own 40x30 text console: real capture, real font ROM, and yes,
> the hardware really does render everything in uppercase.

## What works, on real hardware

Every line below has been seen on the bench, not only in simulation.

| | |
| --- | --- |
| **CPU** | RV32IMA + Zicsr, M/S/U privilege, **sv32 MMU**, CLINT, PLIC, precise traps |
| **Memory** | 32 MB onboard SDRAM; full 16 MB window walked with an address-derived pattern, 0 errors |
| **Storage** | microSD, **read and write**, ext2 — files survive a reboot |
| **Screen** | HDMI (GPDI), 640x480, 40x30 text console |
| **Keyboard** | USB HID on US2, Finnish layout |
| **OS** | mainline **Linux 6.12** riscv32, busybox userspace, ~250 applets |
| **Boot** | own M-mode SBI firmware loads the kernel off the card into RAM |

```
buildroot login: root
# uname -a
Linux buildroot 6.12.0 #1 riscv32 GNU/Linux
# mount -o rw /dev/kotisd2 /mnt
# echo koti wrote this > /mnt/hello.txt
# sync ; umount /mnt ; mount /dev/kotisd2 /mnt
# cat /mnt/hello.txt
koti wrote this
```

The unmount in there is the point: it drops the page cache, so the last `cat`
genuinely read those bytes back off the card.

## What does not work yet

Kept honest and specific, because a README that only lists wins is not useful:

- **No networking.** The kernel is built without `CONFIG_NET`, so `ip`, `ping`
  and `wget` exist as busybox applets and cannot work.
- **`root=` is still the initramfs**, deliberately. The block driver is new;
  pointing root at it before it had been used in anger would turn a driver bug
  into a machine that will not boot. Moving it is a config change, not work.
- **ext2 has no journal.** `sync` before pulling the power.
- **No PS/2 keyboard**, and there never will be — the RTL is still present but
  superseded by USB.
- **This is an FPGA project.** Koti-1 is not going to a shuttle; see
  [PLAN.md](PLAN.md). The ASIC path (8x2 tiles, a DFFRAM regfile macro) is
  parked, not deleted.

## Boot, end to end

![koti booting Linux](docs/img/koti-boot.png)

The SBI firmware lives in 32 KB of block RAM inside the FPGA and the kernel is
3.95 MB, so the kernel had nowhere to live — that gap was the last thing between
a machine that booted in simulation and one that booted on the bench:

| route | per attempt |
| --- | --- |
| over the 115200 UART | **~343 s** |
| baked into the bitstream | a place-and-route per kernel |
| **microSD** | **~4 s** |

`sw/sbi/sdboot.c` reads a header at LBA 2048, loads the image straight into
SDRAM at `0x0140_0000` and checksums it; the firmware then finds the RISC-V
Image magic it was already looking for and enters it. `tools/sdkernel.py` writes
that layout to a card. About 49 seconds from reset to a login prompt.

⭐ The boot log appears on the monitor **with no framebuffer driver and no
Linux video support at all**: SBI `console_putchar` writes the UART *and* the
40x30 text buffer, and Linux's console is `hvc0` over SBI. Nothing in the kernel
knows the video hardware exists.

## Getting it running

`fpga/ulx3s/README.md` is the bring-up procedure, in order, with the traps that
cost real time written next to the step that hits them. In short:

```
gh workflow run fpga-ulx3s.yaml -f image=sbi     # build a bitstream
fujprog koti-bram.bit                            # NOT openFPGALoader
python tools/sdkernel.py write Image --disk N --yes   # needs admin
```

Two that will otherwise waste an evening:

- **DIP switch 3 must be ON** for the `sbi` image. That firmware enables video,
  which gives `uo[0]` to the raster and mirrors the UART on `uo[6]`; SW3 is what
  points the FTDI at `uo[6]`. With it off the console is mojibake.
- **Flash, then open the serial port, then press BTN0.** The early boot is
  otherwise already gone by the time anything is listening.

## Layout

- [PLAN.md](PLAN.md) — the ladder, the architecture decisions and why each was
  taken, the risks
- `src/` — the SoC: core, MMU/TLB, SDRAM, I-cache, arbiter, video, microSD, USB
- `sw/` — bare-metal images, the SBI firmware (`sw/sbi/`), Linux (`sw/linux/`)
- `fpga/ulx3s/` — the board harness, pin plan and bring-up procedure
- `vendor/` — verbatim copies from elsewhere, with provenance and why each is
  vendored rather than written
- `tools/` — card writer, screen renderer, ROM generators
- `test/` — the benches; `.github/workflows/` runs them all on every push

## About these images

**The screenshots are reconstructions, not photographs.** There is no frame
grabber on the HDMI link, so nothing here has seen koti's monitor.

What makes them faithful rather than an impression is that every pixel is
decided by things in this repository, and the text is a real UART capture from
the machine — which carries exactly the same bytes as the screen, because
`putc_both()` writes both:

- `src/font_rom.svh` — the actual glyph bitmaps the hardware scans out, parsed
  by `tools/screenshot.py` rather than redrawn
- `src/vga_text.sv` — the cell geometry, and the character folding that makes
  lowercase come out uppercase (the ROM holds only `0x20..0x5F`)
- `sw/console.c` — the 40x30 wrap and scroll rules

Regenerate with `python tools/screenshot.py <captured text> out.png`.

If you want a photograph, point a camera at the monitor — that is the one thing
this repository cannot produce for you.

## Licence

Apache-2.0. See `vendor/README.md` for the provenance and licences of the
vendored cores.
