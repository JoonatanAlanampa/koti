# 10-koti.sh — sourced by /etc/profile for every login shell.
#
# WHAT IT IS FOR: koti's screen is 80x60 and the boot log fills it. Logging in
# and finding your prompt at the bottom of forty lines of kernel messages is
# workable on a big terminal and unpleasant on this one, so the screen is
# cleared once, at the point the machine becomes yours to use.
#
# ⚠️ NOTHING IS LOST BY CLEARING. The full boot log is also on the UART
# (console=hvc0 is on the kernel command line), so anything the screen wipes is
# still in a serial capture. That is why this is safe to do at all -- on a
# machine whose only record was the screen it would be destroying evidence.
#
# ⚠️ The VT interprets the escape sequence, not koticon: vt.c parses ESC [ 2 J
# and calls the driver's con_clear. So this works for the same reason `vi` and
# `less` do, and it would keep working on any console driver koti grows later.
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0

# Only for an interactive shell on a real terminal. Sourcing this from a script
# or a pipe must not emit escape codes into whatever is reading the output.
if [ -n "$PS1" ] && [ -t 1 ]; then
	clear

	# One line, deliberately. A long banner on a 60-row screen is just the
	# boot log again in a different costume. `koti-help` is the on-machine
	# copy of docs/MANUAL.md, which matters because koti has no network yet
	# and cannot look anything up.
	echo "koti ready - 'koti-help' for what this machine can do"
fi
