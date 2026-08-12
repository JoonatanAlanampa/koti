#!/bin/sh
# test_koti_net.sh — unit-test the parts of koti-net that are arithmetic.
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
# Run:  sh sw/linux/test_koti_net.sh
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

echo
if [ "$fails" -eq 0 ]; then
	echo "test_koti_net: PASS ($checks checks)"
	exit 0
fi
echo "test_koti_net: FAIL ($fails of $checks checks)"
exit 1
