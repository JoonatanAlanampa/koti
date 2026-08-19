#!/bin/sh
# test_net_get.sh — run koti-net's `get` end to end against a fake ESP32.
#
# WHY THIS EXISTS. test_rootfs_shell.sh covers the pure functions — the
# calendar and the Date parser — and says so explicitly: "it does not talk to
# an ESP32, so it says nothing about whether wake, join or get work". That left
# the transport, the hostname check, `link_up`, the marker matching and the
# page extraction with no gate at all, and every one of them was written from a
# measurement taken at the bench. The feedback loop for a mistake in them is
# `userspace` (~40 min) -> commit the cpio -> `linux` (~28 min) -> a microSD
# card carried to a PC reader and back, i.e. one of the user's evenings.
#
# ⭐ ITS FIRST RUN FOUND A REAL DEFECT, 2026-08-14: the `zz` that pads the END
# marker against the link's first-character fault was landing in the fetched
# page, on every fetch. It arrived with the padding the evening before and no
# page had been fetched since, so nothing had seen it.
#
# ⚠️ WHAT IT CANNOT DO: fake_esp.py is CPython with fake socket/sys/w objects,
# not MicroPython 1.14. It says nothing about whether the real far end accepts
# a construct this one does. It says everything about whether koti-net's own
# logic survives a far end that behaves the way the bench measured.
#
# Run:  busybox sh sw/linux/test_net_get.sh
#
# Copyright (c) 2026 Joonatan Alanampa
# SPDX-License-Identifier: Apache-2.0
set -u

HERE=$(dirname "$0")
NET=${NET:-$HERE/rootfs-overlay/usr/bin/koti-net}
PY=${PY:-python3}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

[ -r "$NET" ] || { echo "cannot read $NET" >&2; exit 1; }

# koti's busybox has usleep and koti-net's polling loops call it; a runner's
# busybox may not, and its `sleep` may not take a fraction. Probe rather than
# assume — a missing usleep would otherwise make every poll a no-op and turn
# the deadlines into spin loops.
if usleep 1000 2>/dev/null; then
	:
elif sleep 0.05 2>/dev/null; then
	usleep() { sleep 0.05; }
else
	usleep() { sleep 1; }
fi

fails=0; checks=0
ok() { checks=$((checks + 1)); }
bad() { checks=$((checks + 1)); fails=$((fails + 1)); echo "FAIL: $*"; }
eq() { if [ "$2" = "$3" ]; then ok; else bad "$1:
  expected: $(printf '%s' "$2" | od -c | head -20)
  got     : $(printf '%s' "$3" | od -c | head -20)"; fi; }

# --- pull the real functions out -------------------------------------------
awk '/^capture_reset\(\) \{/{p=1} /^cmd_wake\(\) \{/{p=0} p' "$NET"  > "$TMP/funcs.sh"
awk '/^link_up\(\) \{/{p=1}     /^cmd_time\(\) \{/{p=0} p' "$NET"   >> "$TMP/funcs.sh"
grep -q '^cmd_get() {' "$TMP/funcs.sh" || {
	echo "extraction failed — koti-net's function names moved" >&2; exit 1; }
grep -q '^send() {' "$TMP/funcs.sh" || {
	echo "extraction failed — send() is not in the extracted range" >&2; exit 1; }

DEV=$TMP/dev
CAP=$TMP/cap
PID=$TMP/pid
die() { echo "koti-net: $*" >&2; exit 1; }
reader_running() { :; }              # fake_esp.py writes $CAP itself
# shellcheck disable=SC1090
. "$TMP/funcs.sh"

start_mock() {
	: > "$DEV"; : > "$CAP"; rm -f "$DEV.stop"
	$PY "$HERE/fake_esp.py" "$DEV" "$CAP" --scenario "$1" \
		--timeout 300 \
		--report "$TMP/report.json" > "$TMP/mock.log" 2>&1 &
	MOCKPID=$!
	sleep 0.5
}
stop_mock() { touch "$DEV.stop"; wait "$MOCKPID" 2>/dev/null; }

PAGE='HTTP/1.1 200 OK
Content-Type: text/html
Date: Thu, 14 Aug 2026 08:11:52 GMT
Content-Length: 128
Connection: close
Server: ECAcc (dcd/7D5A)

<!doctype html>
<html>
<head>
<title>Example Domain</title>
</head>
<body>
<h1>Example Domain</h1>
<p>koti fetched this.</p>
</body>
</html>'

echo "== 1. the ordinary fetch, DHCP fighting back at every command boundary =="
start_mock ok
cmd_get http://example.com/ > "$TMP/out" 2> "$TMP/err"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/out")"
if grep -q 'KOTI' "$TMP/out"; then bad "a marker leaked into the page"; else ok; fi
if grep -q '>>>' "$TMP/out"; then bad "the REPL's echo leaked into the page"; else ok; fi
ovr=$($PY -c "import json,sys;print(len(json.load(open(sys.argv[1]))['overruns']))" "$TMP/report.json")
eq "bytes written while the far end was busy" 0 "$ovr"
rep=$($PY -c "import json,sys;d=json.load(open(sys.argv[1]));print(d['repairs'],d['connects'])" "$TMP/report.json")
eq "DNS repairs and connects" "1 1" "$rep"
[ -s "$TMP/err" ] && echo "  (stderr said: $(cat "$TMP/err"))"

echo "== 2. the same fetch with no DHCP fight (the repair must still be harmless) =="
start_mock no-dhcp
cmd_get http://example.com/ > "$TMP/out2" 2> "$TMP/err2"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/out2")"

echo "== 3. address + host, the form that fetched CERN by IP =="
start_mock ok
cmd_get http://188.184.67.127/ example.com > "$TMP/out3" 2> "$TMP/err3"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/out3")"

echo "== 4. not associated: it must refuse before dialling =="
start_mock not-associated
cmd_get http://example.com/ > "$TMP/out4" 2> "$TMP/err4"; rc=$?
stop_mock
eq "exit status" 1 "$rc"
eq "printed no page" "" "$(cat "$TMP/out4")"
if grep -q 'NOT ON A NETWORK' "$TMP/err4"; then ok; else bad "no clear diagnosis: $(cat "$TMP/err4")"; fi
if grep -q '1001' "$TMP/err4"; then ok; else bad "did not name the status"; fi

echo "== 5. the hostname loses a character in transit: retry, then fetch =="
start_mock garble
cmd_get http://example.com/ > "$TMP/out5" 2> "$TMP/err5"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/out5")"
if grep -q 'garbled in transit' "$TMP/err5"; then ok; else bad "retried silently: $(cat "$TMP/err5")"; fi
g=$($PY -c "import json,sys;print(json.load(open(sys.argv[1]))['garbles'])" "$TMP/report.json")
eq "the far end really was fed a short name" 2 "$g"

echo "== 6. the far end refuses the connection: say so, do not hang =="
start_mock refuse
t0=$(date +%s)
cmd_get http://example.com/ > "$TMP/out6" 2> "$TMP/err6"; rc=$?
t1=$(date +%s)
stop_mock
eq "exit status" 1 "$rc"
eq "printed no page" "" "$(cat "$TMP/out6")"
if grep -q 'could not connect' "$TMP/err6"; then ok; else bad "no diagnosis: $(cat "$TMP/err6")"; fi
if [ $((t1 - t0)) -lt 45 ]; then ok; else bad "took $((t1 - t0))s — it waited for a marker that cannot arrive"; fi

echo "== 7. a reply with no body at all =="
start_mock empty
cmd_get http://example.com/ > "$TMP/out7" 2> "$TMP/err7"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "headers only, nothing appended" 'HTTP/1.1 200 OK
Content-Type: text/html
Date: Thu, 14 Aug 2026 08:11:52 GMT
Content-Length: 0
Connection: close
Server: ECAcc (dcd/7D5A)' "$(cat "$TMP/out7")"

echo "== 8. a body that does not end in a newline =="
start_mock nonewline
cmd_get http://example.com/ > "$TMP/out8" 2> "$TMP/err8"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/out8")"

echo "== 9. no join has run this session: say that, do not blame the network =="
start_mock nojoin
cmd_get http://example.com/ > "$TMP/out9" 2> "$TMP/err9"; rc=$?
stop_mock
eq "exit status" 1 "$rc"
eq "printed no page" "" "$(cat "$TMP/out9")"
if grep -q "koti-net join" "$TMP/err9"; then ok; else bad "no diagnosis: $(cat "$TMP/err9")"; fi

echo "== 10. an ordinary router, whose resolver is already a resolver =="
start_mock gooddns
cmd_get http://example.com/ > "$TMP/outA" 2> "$TMP/errA"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/outA")"
r=$($PY -c "import json,sys;d=json.load(open(sys.argv[1]));print(d['repairs'],d['cfg'][3])" "$TMP/report.json")
eq "left a working resolver alone" "0 172.20.10.1" "$r"

echo "== 11. one silent answer from the link is not an answer =="
start_mock flakylink
cmd_get http://example.com/ > "$TMP/outB" 2> "$TMP/errB"; rc=$?
stop_mock
eq "exit status" 0 "$rc"
eq "the page, exactly" "$PAGE" "$(cat "$TMP/outB")"
if grep -q 'retrying' "$TMP/errB"; then ok; else bad "did not say it retried: $(cat "$TMP/errB")"; fi

echo "== 12. debris from a DEAD fetch in front of a live one =="
# The 2026-08-19 defect, as a unit test on the extraction itself rather than a
# scenario: capture_reset runs when a command starts, but the far end can still
# be flushing a previous transaction, so its markers land in front of this
# one's. The old pipeline anchored on the FIRST KOTI-BEGIN and printed from the
# corpse of the old fetch through the whole of the new one -- marker text in
# the page, which is exactly what the user saw on the machine.
PAGE2='HTTP/1.1 200 OK

<h1>hello</h1>'
live=$(printf 'zz KOTI-BEGIN\nHTTP/1.1 200 OK\n\n<h1>hello</h1>\nzz KOTI-END\n>>> ')

eq "no debris"            "$PAGE2" "$(printf '%s' "$live" | extract_page)"
eq "a dead pair in front" "$PAGE2" \
   "$(printf 'z KOTI-BEGIN\nzz KOTI-END\n>>> junk\n%s' "$live" | extract_page)"
eq "an UNTERMINATED dead BEGIN (the wedge shape)" "$PAGE2" \
   "$(printf 'z KOTI-BEGIN\nrubbish from a fetch that never ended\n%s' "$live" | extract_page)"
eq "two dead pairs" "$PAGE2" \
   "$(printf 'zz KOTI-BEGIN\nold1\nzz KOTI-END\nzz KOTI-BEGIN\nold2\nzz KOTI-END\n%s' "$live" | extract_page)"
# ...and an unterminated BEGIN with nothing after it is not a page at all.
eq "a wedge and nothing else yields nothing" "" \
   "$(printf 'zz KOTI-BEGIN\nhalf a page and then silence\n' | extract_page)"

echo
echo "$checks checks, $fails failures"
[ "$fails" -eq 0 ] || exit 1
