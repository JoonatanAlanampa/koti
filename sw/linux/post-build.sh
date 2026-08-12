#!/bin/sh
# post-build.sh — add a getty on tty1, so koti has a shell on its own screen.
#
# WHY THIS IS A POST-BUILD SCRIPT AND NOT ANY OF THE OBVIOUS ALTERNATIVES:
#
#   * `BR2_TARGET_GENERIC_GETTY_PORT="tty1"` would MOVE the getty rather than
#     add one, taking the login off hvc0. hvc0 is the serial console a bring-up
#     session watches on COM3, and koti's UART is transmit-only — losing the
#     serial login would mean the only way in is the screen, on a machine whose
#     screen is the thing being brought up.
#   * shipping /etc/inittab in BR2_ROOTFS_OVERLAY would replace Buildroot's
#     generated one, which means owning a copy of its skeleton and silently
#     diverging from it on every Buildroot upgrade.
#
# A post-build script runs after both, so it appends to whatever inittab the
# rest of the build produced and cannot be reordered out from under.
#
# ⚠️ THIS IS WHERE THE LOGIN PROMPT ON THE MONITOR COMES FROM. Without it,
# koticon renders kernel messages and nothing else: /dev/console is hvc0, and
# nothing runs a shell on the VT. The screen is a log viewer until this line
# exists.
set -u

TARGET_DIR="$1"
INITTAB="$TARGET_DIR/etc/inittab"

[ -f "$INITTAB" ] || { echo "post-build: no $INITTAB"; exit 1; }

# Idempotent: Buildroot can re-run post-build without a clean, and two gettys
# on one tty respawn against each other.
if grep -q '^tty1::' "$INITTAB"; then
    echo "post-build: getty on tty1 already present"
else
    cat >> "$INITTAB" <<'EOF'

# koti: a shell on the screen (PLAN.md item 9b). The VT is driven by
# sw/linux/koticon.c over the 80x60 character buffer; keystrokes arrive from
# the USB keyboard through sw/linux/koti_kbd.c and drivers/tty/vt/keyboard.c.
# This is IN ADDITION to the hvc0 getty above, which is kept on purpose: its
# ECHO is what makes typed characters visible in a UART capture, and that was
# the primary instrument of the 2026-08-09 keyboard hunt.
tty1::respawn:/sbin/getty -L tty1 0 linux
EOF
    echo "post-build: added a getty on tty1"
fi

grep -n 'getty' "$INITTAB"

# ---------------------------------------------------------------------------
# Keep e2fsck and throw the rest of e2fsprogs away.
#
# ⛔ MEASURED, AND THE ESTIMATE THAT PRECEDED IT WAS WRONG BY AN ORDER OF
# MAGNITUDE. PLAN item 18 needs ONE program — a checker for the journal-less
# ext2 on the microSD. `BR2_PACKAGE_E2FSPROGS=y` installs FOURTEEN, and with
# BR2_STATIC_LIBS=y every one of them carries its own copy of libc and
# libext2fs. The rootfs went 1.18 MiB -> 7.04 MiB and check_rootfs.py failed it
# against a 2.5 MiB budget. The fragment comment predicting "a few hundred KiB"
# was reasoning about one binary; Buildroot does not install one binary.
#
# ⭐ THE GATE IS WHY THIS IS A DELETION AND NOT A RAISED LIMIT. A 7 MiB
# initramfs costs its size TWICE at peak and would have booted -- koti has 32 MB
# now -- so nothing would have failed loudly. It would simply have taken about
# a quarter of the machine's RAM, permanently, to make one boot-time check
# possible. The budget caught a real cost that no boot would have reported.
#
# ⚠️ fsck.ext2 is a symlink to e2fsck, which is what e2fsprogs itself ships and
# what makes busybox's `fsck` dispatcher work: it execs fsck.<type> and there
# was no such file, which is the whole reason item 18 could not be done with
# busybox alone.
# ⛔ AN EXPLICIT LIST, NOT A `case` PATTERN SPLIT OVER SEVERAL LINES. A
# backslash-continued pattern carries the NEXT LINE'S INDENTATION into the
# pattern, so `mklost+found` becomes `            mklost+found` and silently
# matches nothing — a deletion loop that deletes nothing, reported as success,
# discovered only by a rootfs that is still 7 MiB. Words in a variable are
# split on whitespace and have no such trap.
#
# ⚠️ BY NAME, one at a time. /sbin also holds getty, init, switch_root and
# mdev; anything resembling a blanket wipe there produces an unbootable rootfs
# that builds perfectly.
E2_DROP="e2undo e2freefrag mke2fs badblocks dumpe2fs filefrag logsave
         mklost+found tune2fs e4crypt e2image e2label e2mmpstatus findfs
         resize2fs fsck e2scrub e2scrub_all"
if [ -x "$TARGET_DIR/sbin/e2fsck" ]; then
    for b in $E2_DROP; do
        rm -f "$TARGET_DIR/sbin/$b"
    done
    rm -f "$TARGET_DIR/bin/compile_et" "$TARGET_DIR/bin/mk_cmds"
    rm -f "$TARGET_DIR/bin/chattr" "$TARGET_DIR/bin/lsattr"
    rm -rf "$TARGET_DIR/usr/share/et" "$TARGET_DIR/usr/share/ss"
    # busybox's own fsck symlink may have been overwritten by e2fsprogs'; the
    # dispatcher is worth having back now that fsck.ext2 exists for it to find.
    [ -e "$TARGET_DIR/sbin/fsck" ] || ln -sf ../bin/busybox "$TARGET_DIR/sbin/fsck"
    [ -e "$TARGET_DIR/sbin/fsck.ext2" ] || ln -sf e2fsck "$TARGET_DIR/sbin/fsck.ext2"
    echo "post-build: kept e2fsck, removed the rest of e2fsprogs"
    ls -l "$TARGET_DIR/sbin/e2fsck" "$TARGET_DIR/sbin/fsck.ext2"
    du -sh "$TARGET_DIR/sbin/e2fsck" || true
else
    echo "post-build: no e2fsck in the target - e2fsprogs did not build?"
fi
