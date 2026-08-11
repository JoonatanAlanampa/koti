# koti — user manual

What this machine is, what it can do, and where it will surprise you.

koti is a RISC-V computer built from the CPU upwards: an RV32IMA + Zicsr core
with an sv32 MMU, 32 MB of SDRAM, a microSD, HDMI text video and a USB
keyboard, running mainline Linux 6.12 on a ULX3S 85F at **25 MHz**. Everything
below the kernel — the CPU, the caches, the memory controller, the video, the
keyboard, the SBI firmware — was written for this project.

A short version of this document lives on the machine itself: type **`koti-help`**.
For the machine's current state — RAM, uptime, which root it booted, the card,
interrupts, and the memories Linux cannot see — type **`koti-status`**.
That matters because koti has no networking, so a manual you can only read on
another computer is a manual you cannot read while using it.

---

## Logging in

The machine boots to a login prompt in about 50 seconds. The user is **`root`**
and there is no password.

The screen clears when you log in. The boot log is not lost — it is also on the
serial line — but the 80x60 screen is small enough that starting from a clean
one is worth more than keeping forty lines of kernel messages.

## The two consoles, and why output sometimes doubles

koti has **two** consoles and they both receive **every keystroke**:

| | where its output goes | who can type at it |
|---|---|---|
| **tty1** | the HDMI monitor | you |
| **hvc0** | the serial line (UART) | you, on a bitstream built after 2026-08-10 |

The keyboard queue has two independent read ports: the firmware pops one to
feed hvc0, the Linux driver pops the other to feed tty1. So one `root` + Enter
logs you in **twice**, and every command afterwards runs on **two shells**.

That is deliberate, and it is kept on purpose: the serial echo is how this
machine gets debugged — it is what makes typed characters visible in a capture
taken from another computer. But it is why you may see doubled output, and why
two shells can drift into different states.

⚠️ **hvc0 was transmit-only until 2026-08-10, and whether yours can be typed at
depends on the bitstream, not the kernel.** koti had no UART receiver at all
until then; `src/uart_rx.sv` added one and SBI `console_getchar` now reads it.
But the firmware lives inside the bitstream, so a board still running an older
`image: sbi` build has the one-way console described above. If typing at the
serial port does nothing, that is which build you are on — re-route and reflash
to change it. As of 2026-08-10 this has been verified in simulation only.

## Keyboard

Finnish layout, loaded at boot. You will see `koti: fi keymap loaded` go past.

**AltGr works**, which matters more than it sounds: `@ $ { } [ ] \ |` are all
AltGr keys on a Finnish board, and a shell without a pipe or braces is not much
of a shell.

⚠️ The two consoles use **separate** keymaps — tty1 uses Linux's (loaded from
`/etc/koti-fi.bmap`), hvc0 uses the firmware's own table in `sw/usbkbd.c`. They
agree today because both are Finnish, not because they are linked.

## Storage — read this before you lose something

**koti has two possible roots, and which one you got is decided at every boot.**
The kernel command line says `root=/dev/kotisd2`, but `/init` treats that as a
request rather than an order: if the card is missing, or p2 will not mount, or
p2 has no executable `/sbin/init`, it stays in RAM and says so instead of
panicking. That is deliberate — the kernel's own `root=` handling would panic,
and a bring-up board must not become unbootable because a card was absent.

**Ask the machine, do not guess:**

```sh
grep ' / ' /proc/mounts     # rootfs -> RAM;  /dev/kotisd2 -> the card
dmesg | grep '^koti: root'  # the decision, in /init's own words
```

`koti: root on /dev/kotisd2 (ext2), switching` means the card is your root.
`koti: root stays in RAM (<reason>)` names the reason it is not.

| path | what it is | survives power-off? |
|---|---|---|
| `/` when it stayed in RAM | initramfs | **no** |
| `/` after the switch | microSD p2, ext2 | **yes** |
| `/dev/kotisd2` | microSD partition 2, ext2 | **yes** |

If `/` is still the initramfs, the card is not mounted anywhere and you reach it
by hand:

```sh
mount /dev/kotisd2 /mnt
# ... work in /mnt ...
sync
umount /mnt
```

If the switch happened, `/dev/kotisd2` is already `/` — mounting it again on
`/mnt` is not what you want, and writing to `/` persists directly.

⚠️ **ext2 has no journal.** Run `sync` before pulling the power, or you lose
whatever was still sitting in the page cache. This is the single easiest way to
lose work on koti.

The card's first partition is not a filesystem: it holds the kernel image as
raw blocks, which is how the firmware loads it. Do not mount or write it.

## Shutting down

`sync`, then pull the power.

`poweroff` and `halt` stop the CPU — the firmware halts the core on the SBI
reset call — but there is no power controller on the board to actually switch
anything off, so the machine stops rather than powers down.

## What is *not* here

**No IP address, but there is a way to the internet.** koti has no MAC and no
PHY, so it is not on a network in the way another computer is: `ip`, `ping`,
`wget`, `telnet`, `traceroute` and `nslookup` all exist as busybox applets and
all still fail. That is expected, not a fault, and so is
`Starting network: ... FAIL` in the boot log.

What koti has instead is a **modem**. The ULX3S carries an ESP32 alongside the
FPGA, koti reaches it over its own serial link (`/dev/ttyKOTI0`), and that
ESP32 runs MicroPython with a working WiFi stack. `koti-net` drives it:

```
koti-net wake                     # release the ESP32 from reset
koti-net join <ssid> <password>   # prints the address it was given
koti-net get http://example.com/  # the page, on standard output
koti-net off                      # put it back into reset
```

⚠️ **The address `join` prints belongs to the ESP32, not to koti.** Nothing on
this machine gains a socket, which is why `wget` still fails a moment after
`koti-net get` has fetched a page. It is remote control of somebody else's TCP
stack — genuinely the internet, genuinely not networking.

⚠️ **`koti-net wake` is not free.** The ESP32's GPIO pins are physically the
same wires as the microSD bus, so while it is awake two chips can drive the
card's signals. That was measured on 2026-08-11 over 25 runs and the card read
identically before, during and after — but `koti-net off` when you are done is
still the right habit, and it is the first thing to suspect if the card starts
misbehaving.

⛔ **Use `koti-net` from koti's own keyboard and screen, not over the COM3
serial console.** An awake ESP32 makes that console unusable. This is wiring
rather than a fault: the USB serial adapter's transmit line reaches both the
FPGA and the ESP32's receiver, and the ESP32's transmitter shares the adapter's
receive line with the FPGA — so a woken MicroPython prompt echoes your
keystrokes onto the same wire koti is transmitting on, and the two collide.
Measured: after `wake` over serial the shell still echoed newlines, so input
was arriving, but no prompt ever appeared again, and it came back the instant
`koti-net off` ran. It looks exactly like a crash and is not one. The HDMI
output and the USB keyboard share nothing with the ESP32.

⚠️ **http only.** The fetch is plain HTTP; there is no TLS, so `https://` URLs
will not work.

**No compiler, no package manager, no floating point.** koti has no FPU, and
userspace is built soft-float and statically linked against musl. There is no
way to add software on the machine; software is built into the rootfs image.

**No swap, no users but root, no ssh.**

---

## Commands

Userspace is **busybox on musl, statically linked** — one binary with about
280 applets. They behave the way the busybox versions do, which is mostly but
not exactly like their GNU counterparts: expect fewer long options.

### The ones you will actually use

| what for | commands |
|---|---|
| **files** | `ls` `cd` `pwd` `cp` `mv` `rm` `mkdir` `rmdir` `ln` `touch` `find` `tree` `stat`-ish via `ls -l` |
| **reading** | `cat` `less` `more` `head` `tail` `strings` `hexdump` `xxd` `od` |
| **editing** | `vi` (the editor), `sed`, `awk`, `patch` |
| **text** | `grep` `egrep` `fgrep` `sort` `uniq` `cut` `paste` `tr` `wc` `diff` `cmp` `fold` `nl` `tee` |
| **archives** | `tar` `gzip` `gunzip` `zcat` `xz` `unzip` `cpio` `ar` |
| **processes** | `ps` `top` `kill` `killall` `pidof` `free` `uptime` `nice` `renice` `time` `watch` |
| **disks** | `mount` `umount` `df` `du` `sync` `blkid` `fdisk` `mke2fs` `fsck` `losetup` |
| **system** | `uname` `dmesg` `date` `hostname` `id` `whoami` `env` `printenv` `lsmod` `sysctl` `reboot` `poweroff` |
| **maths** | `bc` `dc` `expr` `factor` `seq` |
| **console** | `clear` `reset` `chvt` `openvt` `loadkmap` `dumpkmap` `setfont`-ish via `loadfont` |
| **koti** | `koti-help` (this manual), `koti-status` (what the machine is and is doing) |

### Everything else

`[` `[[` `addgroup` `adduser` `ar` `arch` `arp` `arping` `ascii` `ash` `awk`
`base32` `base64` `basename` `bc` `blkid` `bunzip2` `busybox` `bzcat` `cat`
`chattr` `chgrp` `chmod` `chown` `chroot` `chrt` `chvt` `cksum` `clear` `cmp`
`cp` `cpio` `crc32` `crond` `crontab` `cut` `date` `dc` `dd` `deallocvt`
`delgroup` `deluser` `devmem` `df` `diff` `dirname` `dmesg` `dnsd`
`dnsdomainname` `dos2unix` `du` `dumpkmap` `echo` `egrep` `eject` `env`
`ether-wake` `expr` `factor` `fallocate` `false` `fbset` `fdflush` `fdformat`
`fdisk` `fgrep` `find` `flock` `fold` `free` `freeramdisk` `fsck` `fsfreeze`
`fstrim` `fuser` `getfattr` `getopt` `getty` `grep` `gunzip` `gzip` `halt`
`hdparm` `head` `hexdump` `hexedit` `hostid` `hostname` `hwclock` `i2cdetect`
`i2cdump` `i2cget` `i2cset` `i2ctransfer` `id` `ifconfig` `ifdown` `ifup`
`inetd` `init` `insmod` `install` `ip` `ipaddr` `ipcrm` `ipcs` `iplink`
`ipneigh` `iproute` `iprule` `iptunnel` `kill` `killall` `killall5` `klogd`
`last` `less` `link` `linux32` `linux64` `loadfont` `loadkmap` `logger` `login`
`logname` `losetup` `ls` `lsattr` `lsmod` `lsof` `lspci` `lsscsi` `lsusb`
`lzcat` `lzma` `lzopcat` `makedevs` `md5sum` `mdev` `mesg` `microcom` `mim`
`mkdir` `mkdosfs` `mke2fs` `mkfifo` `mknod` `mkpasswd` `mkswap` `mktemp`
`modprobe` `more` `mount` `mountpoint` `mt` `mv` `nameif` `netstat` `nice` `nl`
`nohup` `nologin` `nproc` `nslookup` `nuke` `od` `openvt` `partprobe` `passwd`
`paste` `patch` `pidof` `ping` `pipe_progress` `pivot_root` `poweroff`
`printenv` `printf` `ps` `pwd` `rdate` `readlink` `readprofile` `realpath`
`reboot` `renice` `reset` `resize` `resume` `rm` `rmdir` `rmmod` `route`
`run-init` `run-parts` `runlevel` `sed` `seedrng` `seq` `setarch` `setconsole`
`setfattr` `setkeycodes` `setlogcons` `setpriv` `setserial` `setsid` `sh`
`sha1sum` `sha256sum` `sha3sum` `sha512sum` `shred` `sleep` `sort`
`start-stop-daemon` `strings` `stty` `su` `sulogin` `svc` `svok` `swapoff`
`swapon` `switch_root` `sync` `sysctl` `syslogd` `tail` `tar` `tee` `telnet`
`test` `tftp` `time` `top` `touch` `tr` `traceroute` `tree` `true` `truncate`
`ts` `tsort` `tty` `ubirename` `udhcpc` `uevent` `umount` `uname` `uniq`
`unix2dos` `unlink` `unlzma` `unlzop` `unxz` `unzip` `uptime` `usleep`
`uudecode` `uuencode` `vconfig` `vi` `vlock` `w` `watch` `watchdog` `wc` `wget`
`which` `who` `whoami` `xargs` `xxd` `xz` `xzcat` `yes` `zcat`

⚠️ **The presence of a command is not a promise that it works.** Every
networking applet in that list — `ping`, `wget`, `telnet`, `ifconfig`, `ip`,
`udhcpc`, `traceroute`, `nslookup` — will fail, because koti has no address of
its own for them to bind to. Use `koti-net` instead; the difference is
explained under "What is *not* here" above, and it is a real difference rather
than a wording one. Likewise `lspci`, `lsusb` and `i2c*` name buses koti
does not have. busybox ships its whole applet set; koti provides the hardware
for a subset of it.

---

## Known rough edges

- **Everything runs twice** when both consoles are logged in. See above.
- **`ls -l` and `dmesg` are wide.** The screen is 80x60, which fits most
  output, but long paths still wrap.
- **No `man`.** There are no manual pages in the rootfs — that is what this
  file and `koti-help` are for. `busybox <applet> --help` works for most
  applets and is the fastest reference on the machine.
- **The clock has no battery.** `date` starts from the epoch every boot;
  there is no RTC and no network time.

## If something goes wrong

The serial console carries the full kernel log at 115200 8N1, whatever the
screen is doing, and it keeps working when the screen does not. Capturing it
from another computer is the first thing to do when koti misbehaves — most of
this machine's hardest bugs were found that way and none of them were visible
on the screen.
