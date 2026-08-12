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

# ---------------------------------------------------------------------------
# PLAN item 15: the networking applets that ship and cannot work.
#
# `ping` and `wget` are the first two commands anyone reaches for, they are both
# in the rootfs, and neither can ever succeed: koti has no IP address, because
# the ESP32 owns the TCP stack and koti drives it by remote control. They fail
# with `ping: bad address` and `wget: bad address`, which reads as "the network
# is broken" at exactly the moment the network is working perfectly. That is a
# worse failure than not shipping them.
#
# ⛔ SHELL FUNCTIONS, NOT SHIMS IN $PATH, and the reason is specific. Buildroot
# installs the busybox applets as symlinks whose directory depends on the
# applet (`/bin/ping`, `/usr/bin/wget`), and the default PATH puts /bin FIRST —
# so a file dropped in /usr/bin would shadow one of them and not the other,
# which is worse than doing nothing. A function shadows the name for the
# INTERACTIVE shell only: scripts and subshells still get the real applet, and
# `command ping` reaches it from here too. The person typing gets the sentence;
# nothing else changes.
#
# ⚠️ Deliberately NOT wrapping `ip`, `ifconfig` or `netstat`. Those report on
# interfaces koti really has (`lo`, and whatever a future SLIP link becomes) and
# their output is truthful. It is only the two that try to reach the OUTSIDE
# that mislead.
for _koti_app in ping wget; do
	eval "$_koti_app() {
		echo \"$_koti_app: koti has no IP address of its own, so this\" \\
		     \"cannot work.\" >&2
		echo \"Use koti-net instead — it drives the onboard ESP32, which\" \\
		     \"does have one:\" >&2
		echo \"    koti-net wake\" >&2
		echo \"    koti-net join SSID PASSWORD\" >&2
		echo \"    koti-net get http://ADDRESS/ [HOSTNAME]\" >&2
		echo \"('koti-help' explains why; 'command $_koti_app' runs the\" \\
		     \"real one anyway.)\" >&2
		return 1
	}"
done
unset _koti_app

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
