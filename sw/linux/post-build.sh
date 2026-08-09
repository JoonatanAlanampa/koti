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
