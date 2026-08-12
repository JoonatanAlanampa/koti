#!/bin/sh
# test_rootfs_shell.sh — unit-test the parts of koti's rootfs shell that are
# pure functions: koti-net's calendar arithmetic and Date-header parser, and
# S45kotisd's never-run-the-clock-backwards rule.
#
# WHY THIS EXISTS. `koti-net` decides what year this machine thinks it is, from
# a string parsed out of a wire that is known to corrupt its first byte, using
# calendar arithmetic written by hand. Nothing in this repository executed a
# single line of it: check_rootfs.py checks Buildroot SYMBOLS, check_initramfs.py
# checks that the committed cpio matches the overlay, and no cocotb suite runs
# shell. The whole script reached the machine as a green build that had never
# been run.
#
# ⛔ AND THE FEEDBACK LOOP IS 70 MINUTES LONG. A change here goes: userspace
# (~40 min) -> commit the cpio -> linux (~25 min) -> card into a PC reader ->
# elevated sdkernel.py -> card back -> fujprog. A typo in a `sed` costs that
# whole round trip and one of the user's evenings. Two seconds of `dash` here
# is the cheapest gate in the repo by a factor of a thousand.
#
# ⚠️ WHAT IT CANNOT DO: it does not talk to an ESP32, so it says nothing about
# whether `wake`, `join` or `get` work. It tests the three things that are pure
# functions of their input — the calendar arithmetic, the Date-header parser,
# and the "is the clock unset" predicate — and it should not be read as
# covering more than that.
#
# ⭐ THE EXPECTED VALUES COME FROM GNU date, NOT FROM THE SAME ARITHMETIC. The
# sweep below formats a header with `date -d @N`, feeds it through the parser,
# and compares the epoch it produced against N. That is an independent
# implementation as the oracle, which is the only way a self-check of a
# calendar means anything.
#
# Run:  sh sw/linux/test_rootfs_shell.sh
# ⚠️ Run it under `dash` or `busybox sh` if you can — koti's shell is busybox
# ash, and bash accepts things ash does not (the octal trap below is exactly
# such a case: bash says "value too great for base", ash says "Illegal number",
# and only one of them is the machine we ship to).
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
set -u

here=$(dirname "$0")
NET=${1:-$here/rootfs-overlay/usr/bin/koti-net}
[ -r "$NET" ] || { echo "cannot read $NET" >&2; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fails=0
checks=0

ok() { checks=$((checks + 1)); }
bad() {
	checks=$((checks + 1))
	fails=$((fails + 1))
	echo "FAIL: $*"
}
eq() {
	# eq DESC EXPECTED ACTUAL
	if [ "$2" = "$3" ]; then ok; else bad "$1: expected '$2', got '$3'"; fi
}

# ---------------------------------------------------------------------------
# Pull the pure functions out of the real script.
#
# ⛔ EXTRACTED, NOT COPIED. A copy of the arithmetic in this file would pass
# forever while the shipped script rotted beside it — the classic test that
# tests itself. awk takes everything from the first calendar function up to the
# first command, so an edit to koti-net is an edit to what runs here.
# ---------------------------------------------------------------------------
awk '/^days_from_civil\(\) \{/{p=1} /^cmd_wake\(\) \{/{p=0} p' "$NET" > "$TMP/funcs.sh"
grep -q '^clock_from_capture() {' "$TMP/funcs.sh" || {
	echo "extraction failed — koti-net's function names moved" >&2
	exit 1
}

# ---------------------------------------------------------------------------
# Pick the oracle explicitly instead of trusting whichever `date` the shell
# happens to resolve. busybox can be built as a "standalone shell" that prefers
# its own applets over $PATH, so under `busybox sh` a bare `date` may or may not
# be the coreutils one — and the difference matters here, because this test
# also SHADOWS date with a stub. Probing for one that answers `-d @0` correctly
# is both the selection and the proof that it works.
# ---------------------------------------------------------------------------
ORACLE=""
for cand in /usr/bin/date /bin/date date; do
	if [ "$("$cand" -u -d @0 +'%Y-%m-%d %H:%M:%S' 2>/dev/null)" \
	     = "1970-01-01 00:00:00" ]; then
		ORACLE=$cand
		break
	fi
done
[ -n "$ORACLE" ] || {
	echo "no date(1) understands -d @N here; the round-trip oracle cannot run" >&2
	exit 1
}

CAP=$TMP/cap
: > "$CAP"
FAKE_YEAR=""
SET_TO=""

# Stub `date` so `-s` is recorded instead of applied (this test does not need
# to be root and must never move the developer's clock), and so the current
# year can be forced for clock_unset.
date() {
	case "${1:-}" in
	-s)	SET_TO=${2#@}; return 0 ;;
	-u)
		shift
		case "${1:-}" in
		-s)	SET_TO=${2#@}; return 0 ;;
		+%Y)	if [ -n "$FAKE_YEAR" ]; then echo "$FAKE_YEAR"; return 0; fi ;;
		esac
		"$ORACLE" -u "$@" ;;
	*)	"$ORACLE" "$@" ;;
	esac
}

# shellcheck disable=SC1090
. "$TMP/funcs.sh"

echo "== days_from_civil (table, independent of the parser) =="
# Hand-checked against GNU date at the time of writing; the point of a table is
# that it does not move when either implementation does.
for row in \
	"1970 1 1 0" \
	"1970 1 2 1" \
	"1999 12 31 10956" \
	"2000 2 29 11016" \
	"2000 3 1 11017" \
	"2020 1 1 18262" \
	"2024 2 29 19782" \
	"2026 8 12 20677" \
	"2100 2 28 47540" \
	"2100 3 1 47541"
do
	# shellcheck disable=SC2086
	set -- $row
	eq "days_from_civil $1-$2-$3" "$4" "$(days_from_civil "$1" "$2" "$3")"
done

echo "== month_num =="
eq "Jan" 1 "$(month_num Jan)"
eq "Dec" 12 "$(month_num Dec)"
if month_num Xyz > /dev/null 2>&1; then bad "month_num accepted 'Xyz'"; else ok; fi

# ---------------------------------------------------------------------------
# The header parser, driven by GNU date as the oracle.
# ---------------------------------------------------------------------------
hdr() { "$ORACLE" -u -d "@$1" +'%a, %d %b %Y %H:%M:%S GMT'; }

parse_epoch() {
	# parse_epoch CAPTURE-TEXT -> prints the epoch clock_from_capture chose,
	# or nothing if it declined.
	printf '%s\n' "$1" > "$CAP"
	SET_TO=""
	clock_from_capture > /dev/null 2>&1
	printf '%s' "$SET_TO"
}

echo "== Date header round trip (oracle: GNU date) =="
# Every hour of a day, because 08 and 09 are octal literals to ash's $(( )) and
# would fail on exactly two hours out of twenty-four — the kind of bug that
# looks like a flaky link when it surfaces at 8am.
base=1786492800   # 2026-08-12 00:00:00 UTC
h=0
while [ "$h" -lt 24 ]; do
	e=$((base + h * 3600 + 9 * 60 + 8))   # :09:08, octal traps in mm and ss too
	got=$(parse_epoch "HTTP/1.1 200 OK
Date: $(hdr "$e")
Content-Type: text/html")
	eq "hour $h" "$e" "$got"
	h=$((h + 1))
done

echo "== boundaries and leap days =="
for e in \
	0 \
	951782400 \
	1709164800 \
	1735689599 \
	1735689600 \
	1767225600 \
	4107456000 \
	4107542400
do
	got=$(parse_epoch "Date: $(hdr "$e")")
	if [ "$e" -lt 1577836800 ]; then
		# Before 2020 the plausibility guard is supposed to refuse it.
		eq "guard rejects $(hdr "$e")" "" "$got"
	else
		eq "epoch $e ($(hdr "$e"))" "$e" "$got"
	fi
done

echo "== survives the wire =="
e=1786543598   # 2026-08-12 14:06:38 UTC — the reply that closed PLAN item 11

# ⛔ THE FIRST CHARACTER OF EVERY BURST FROM THE ESP32 IS DESTROYED, measured
# repeatedly on 2026-08-12. A Date header that happens to open a burst arrives
# with its D gone. This is the case the parser exists to survive, and anchoring
# on `Date:` would make it work most of the time and fail at random.
eq "lost first character" "$e" \
	"$(parse_epoch "HTTP/1.1 200 OK
ate: $(hdr "$e")
Server: whatever")"
eq "lowercase header" "$e" "$(parse_epoch "date: $(hdr "$e")")"
eq "leading whitespace" "$e" "$(parse_epoch "  Date:   $(hdr "$e")")"
eq "the whole first line mangled" "$e" \
	"$(parse_epoch "rTTP/1.1 200 OK
Date: $(hdr "$e")")"

# The real capture also holds the REPL's echo of what we sent and both markers.
eq "amongst REPL noise" "$e" "$(parse_epoch ">>> exec(c)
zz KOTI-BEGIN HTTP/1.1 200 OK
Date: $(hdr "$e")
Content-Length: 646

<html><head></head><body>hello</body></html>
zz KOTI-END
>>> ")"

echo "== declines what it should decline =="
eq "no Date header" "" "$(parse_epoch "HTTP/1.1 200 OK
Content-Type: text/html

<html>nothing here</html>")"
# Last-Modified and Expires carry the same value format. Neither contains the
# substring `ate:`, which is why matching on that is safe rather than lucky.
eq "Last-Modified is not the Date" "" \
	"$(parse_epoch "HTTP/1.1 200 OK
Last-Modified: $(hdr "$e")
Expires: $(hdr "$e")")"
eq "implausible year 1902" "" "$(parse_epoch "Date: Mon, 06 Jan 1902 12:00:00 GMT")"
eq "implausible year 2250" "" "$(parse_epoch "Date: Mon, 06 Jan 2250 12:00:00 GMT")"
eq "truncated value" "" "$(parse_epoch "Date: Wed, 12 Aug 2026 14:06 GMT")"
eq "empty capture" "" "$(parse_epoch "")"

# The first Date wins, because headers precede the body and a proxy chain can
# legitimately put another one further down.
eq "first Date wins" "$e" "$(parse_epoch "Date: $(hdr "$e")
Date: $(hdr $((e + 86400)))")"

echo "== clock_unset =="
FAKE_YEAR=1970
if clock_unset; then ok; else bad "clock_unset said no at 1970"; fi
FAKE_YEAR=2026
if clock_unset; then bad "clock_unset said yes at 2026"; else ok; fi
FAKE_YEAR=""

# ---------------------------------------------------------------------------
# S45kotisd's clock rules.
#
# ⛔ THE ONE THAT MATTERS IS "NEVER BACKWARDS". The card holds the last time the
# machine was running; the kernel starts at the epoch. Restoring unconditionally
# is right on the usual boot and WRONG on the one that matters — if `koti-net
# time` has already set a real clock this boot, a value saved last week would
# drag it back, and every file written afterwards would be stamped before files
# that already exist. A silent, cumulative corruption of the only ordering
# information on the card, from a line that looks obviously correct.
#
# Extracted from the shipped script for the same reason as above.
# ---------------------------------------------------------------------------
echo "== S45kotisd clock rules =="
SD=$here/rootfs-overlay/etc/init.d/S45kotisd
awk '/^restore_clock\(\) \{/{p=1} /^case "\$1" in/{p=0} p' "$SD" > "$TMP/sd.sh"
grep -q '^save_clock() {' "$TMP/sd.sh" || {
	echo "extraction failed — S45kotisd's function names moved" >&2
	exit 1
}

CLOCKFILE=$TMP/koti-clock
NOW=0
# A second stub: restore_clock reads the current time with `date -u +%s` and
# writes with `date -s`, both of which this test must control rather than obey.
date() {
	case "${1:-}" in
	-s)	SET_TO=${2#@}; return 0 ;;
	-u)
		shift
		case "${1:-}" in
		+%s)	echo "$NOW"; return 0 ;;
		+%Y)	"$ORACLE" -u -d "@$NOW" +%Y; return 0 ;;
		esac
		"$ORACLE" -u "$@" ;;
	*)	"$ORACLE" "$@" ;;
	esac
}
# shellcheck disable=SC1090
. "$TMP/sd.sh"

try_restore() {
	# try_restore SAVED CURRENT -> the epoch it set, or nothing
	if [ -n "$1" ]; then printf '%s\n' "$1" > "$CLOCKFILE"; else rm -f "$CLOCKFILE"; fi
	NOW=$2
	SET_TO=""
	restore_clock > /dev/null 2>&1
	printf '%s' "$SET_TO"
}

past=1786543598      # 2026-08-12 14:06:38
later=$((past + 604800))
eq "epoch boot restores the saved time" "$past" "$(try_restore "$past" 0)"
eq "never backwards: a real clock is not dragged back" "" \
	"$(try_restore "$past" "$later")"
eq "equal times change nothing" "" "$(try_restore "$past" "$past")"
eq "no saved file is not an error" "" "$(try_restore "" 0)"
eq "a corrupt clock file is ignored" "" "$(try_restore "not-a-number" 0)"
eq "a partially written clock file is ignored" "" "$(try_restore "17865435xx" 0)"

# ⛔ THE CLOCK FILE IS NOT ALWAYS UNDER /mnt. When the card is the ROOT
# filesystem (what /init does whenever p2 carries an executable /sbin/init)
# /mnt is empty and `/` is the persistent place. Hardcoding /mnt made the
# clock silently stop surviving reboots in exactly that configuration, with
# no error — restore_clock finds no file and returns 0, which is
# indistinguishable from a first boot. Both scripts must pick the same two
# paths, or the boot restores from a file koti-net never writes.
# Presence of each path, not a count: counting occurrences would go red on a
# harmless refactor and say nothing about the behaviour.
for pat in 'CLOCKFILE=/\.koti-clock' 'CLOCKFILE=$MP/\.koti-clock'; do
	if grep -q "$pat" "$SD"; then ok
	else bad "S45kotisd never sets $pat — one card layout loses its clock"; fi
done
for pat in '_cf=/\.koti-clock' '_cf=/mnt/\.koti-clock'; do
	if grep -q "$pat" "$NET"; then ok
	else bad "koti-net never sets $pat — one card layout cannot save"; fi
done

# save_clock must refuse to write the epoch back: doing so would carry 1970
# forward as if it were a real observation and make restore_clock a permanent
# no-op on a machine that had never been told the time.
NOW=0
rm -f "$CLOCKFILE"
save_clock
if [ -f "$CLOCKFILE" ]; then bad "save_clock wrote a 1970 timestamp"; else ok; fi
NOW=$past
save_clock
eq "save_clock writes a real time" "$past" "$(cat "$CLOCKFILE" 2>/dev/null)"

# ---------------------------------------------------------------------------
# `koti` — the housekeeper. PLAN item 24.
#
# Two things are worth a gate here and the second is the important one.
#
# The retrieval table is checked against the questions a person would actually
# type, because its failure mode is silent: a keyword that is too generic wins
# ties and quietly misroutes every question containing it. That is not
# hypothetical — "can I compile something" answered with WHAT IS HERE, because
# `can` was a keyword there and tied with `compile` in WHAT IS NOT HERE.
#
# ⛔ AND THE SAFETY REFUSAL, WHICH IS THE ONE THAT CAN DAMAGE THE MACHINE.
# `koti peek` reads physical memory, and several of koti's registers CHANGE
# when read: the keyboard and ESP32 queues pop, and the PLIC's claim register
# claims an interrupt that only a matching complete clears (src/plic.sv:70 —
# a claim nobody completes wedges that source for good, on a machine with no
# PS/2 fallback left). A regression that turned the refusal into a pass would
# be invisible until someone lost a keystroke or a keyboard.
# ---------------------------------------------------------------------------
echo "== koti (housekeeper) =="
BIN=$here/rootfs-overlay/usr/bin
PATH="$BIN:$PATH"
export PATH

for pair in \
	"STORAGE:how do I save a file" \
	"STORAGE:where does the microsd get mounted" \
	"CLOCK:why is the date wrong" \
	"CLOCK:what year does it think it is" \
	"INTERNET:how do I get on the internet" \
	"INTERNET:why does wget not work" \
	"THE TWO CONSOLES:everything runs twice" \
	"PEEKING:what is in memory location 0x40004" \
	"WHAT IS NOT HERE:can I compile something" \
	"WHAT IS NOT HERE:is there a package manager" \
	"WHAT IS HERE:what commands are there" \
	"SHUTTING DOWN:how do I turn it off" \
	"KEYBOARD:the keyboard types the wrong character"
do
	want=${pair%%:*}
	q=${pair#*:}
	# shellcheck disable=SC2086
	eq "help '$q'" "$want" "$(koti help $q 2>/dev/null | head -n 1)"
done

# A question about nothing must SAY so rather than pick a section at random.
if koti help xyzzy plugh > /dev/null 2>&1; then
	bad "koti help answered a question with no keywords in it"
else
	ok
fi

echo "== koti peek refuses what a read would damage =="
for name in kbd esp sd_ctrl plic_claim; do
	if koti peek "$name" > /dev/null 2>&1; then
		bad "koti peek $name was NOT refused"
	else
		ok
	fi
done
# Raw addresses inside those windows must be refused too — the table is a
# convenience, not the guard.
# ⛔ A MALFORMED HEX ADDRESS MUST BE REFUSED WITH A SENTENCE. $(( )) does not
# return an error for one, it ABORTS THE SHELL — `koti peek 0xZZ` died with
# `value too great for base (error token is "0xZZ")` and no `koti:` line at
# all. A command whose whole job is answering exactly must not fail in the
# voice of the shell it happens to be written in.
for junk in 0xZZ 0x 0xdeadbeefZ; do
	if koti peek "$junk" 2>&1 | grep -qi 'koti:'; then ok
	else bad "koti peek $junk did not refuse with a koti: message"; fi
done

for addr in 0x00050010 0x00060004 0x00070004 0x00E00004; do
	if koti peek "$addr" > /dev/null 2>&1; then
		bad "koti peek $addr (an unsafe window) was NOT refused"
	else
		ok
	fi
done
# ...and a safe one must get past the guard. It cannot actually read anything
# here (no /dev/mem on a build machine), so the check is that it fails LATER,
# for the devmem reason, rather than at the refusal.
out=$(koti peek mtime 2>&1)
case "$out" in
	*"refused"*) bad "koti peek mtime was refused as unsafe" ;;
	*) ok ;;
esac

# Every address in the table must parse as a number, and every row must carry
# all four fields. A typo here is a wrong answer delivered with confidence,
# which is exactly what this command exists not to do.
map_rows=$(awk '/^map\(\) \{/{p=1;next} /^EOF$/{p=0} p' "$BIN/koti" | grep '|')
echo "$map_rows" | while IFS='|' read -r n a s d; do
	[ -n "$n" ] && [ -n "$a" ] && [ -n "$d" ] || echo "BADROW:$n"
	case "$s" in y|n) ;; *) echo "BADSAFE:$n" ;; esac
	case "$a" in 0x*) ;; *) echo "BADADDR:$n" ;; esac
done > "$TMP/maprows"
if [ -s "$TMP/maprows" ]; then
	bad "koti peek map has malformed rows: $(cat "$TMP/maprows")"
else
	ok
fi

echo
if [ "$fails" -eq 0 ]; then
	echo "test_rootfs_shell: PASS ($checks checks)"
	exit 0
fi
echo "test_rootfs_shell: FAIL ($fails of $checks checks)"
exit 1
