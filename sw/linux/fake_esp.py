#!/usr/bin/env python3
"""fake_esp.py — a MicroPython-1.14-shaped far end for koti-net, off hardware.

koti-net's `get` has never been executed by anything but the bench: the shell
unit tests cover the calendar and the Date parser, and nothing runs `send`,
`link_up`, the hostname length check, the marker matching or the page
extraction. Every one of those was written from a measurement and none of them
has a gate. One wrong `sed` costs a 70-minute build plus one of the user's
evenings, so this stands in for the ESP32 well enough to run the whole command.

WHAT IT MODELS, and each of these is a measured property of the real link:

  * a line-oriented REPL that ECHOES what it is sent, then executes, then
    prints `>>> `;
  * THE FIRST CHARACTER OF EVERY BURST IS DESTROYED (the ESP32's TX shares a
    net with the FPGA's back to the FTDI) — this is why koti-net pads its
    markers with `zz` and matches `>>` rather than `>>>`;
  * NO FLOW CONTROL: anything written while the far end is executing is LOST,
    exactly as MicroPython 1.14's UART buffer loses it. That is recorded as an
    overrun so a regression in `send`'s pacing shows up as an error and not as
    a mysterious corrupted variable three lines later;
  * DHCP RE-APPLIES THE LEASE AT EVERY COMMAND BOUNDARY, putting the phone's
    IPv6-derived resolver back into the v4 slot, and reconfiguring the
    interface RESETS AN OPEN CONNECTION. This is what makes the one-exec
    transaction the only shape that works, and it is why splitting it must
    fail here too;
  * getaddrinfo() raises OSError(-202) on a broken resolver AND on a name that
    lost a character in transit — the two failures item 19 confused for months.

WHAT IT IS NOT: it is not an ESP32 and not MicroPython. It runs the sent lines
through CPython with fake `socket`/`sys`/`w` objects. It says nothing about
whether the real far end accepts a construct CPython does; it says everything
about whether koti-net's own logic works when the far end behaves as measured.

Usage:  python fake_esp.py DEV CAP [--scenario NAME] [--report FILE]
"""
import argparse
import json
import os
import sys
import time

HEADERS = (
    b"HTTP/1.1 200 OK\r\n"
    b"Content-Type: text/html\r\n"
    b"Date: Thu, 14 Aug 2026 08:11:52 GMT\r\n"
    b"Content-Length: 0\r\n"
    b"Connection: close\r\n"
    b"Server: ECAcc (dcd/7D5A)\r\n"
    b"\r\n"
)

RESPONSE = (
    b"HTTP/1.1 200 OK\r\n"
    b"Content-Type: text/html\r\n"
    b"Date: Thu, 14 Aug 2026 08:11:52 GMT\r\n"
    b"Content-Length: 128\r\n"
    b"Connection: close\r\n"
    b"Server: ECAcc (dcd/7D5A)\r\n"
    b"\r\n"
    b"<!doctype html>\n<html>\n<head>\n<title>Example Domain</title>\n"
    b"</head>\n<body>\n<h1>Example Domain</h1>\n<p>koti fetched this.</p>\n"
    b"</body>\n</html>\n"
)

KNOWN = {"example.com": "93.184.216.34", "188.184.67.127": "188.184.67.127"}

# A pause in the far end's transmission. Everything written after one of these
# is a fresh burst, and koti destroys the opening character of every burst.
BOUNDARY = object()

# The resolver the iPhone hands over: the first four bytes of an fe80:: address
# dropped into a v4 slot. 254 >= 224, so koti-net's repair fires on it.
BROKEN_DNS = "254.128.0.0"
GATEWAY = "172.20.10.1"


class Reset(Exception):
    pass


class Mock:
    def __init__(self, scenario):
        self.scenario = scenario
        # `gooddns` is an ordinary router rather than the iPhone: it hands over
        # a resolver that IS a resolver. The repair must then do nothing at
        # all, which is the case koti will meet on any normal network and the
        # one a repair written for a broken link can quietly break.
        dns = GATEWAY if scenario == "gooddns" else BROKEN_DNS
        self.cfg = ["172.20.10.2", "255.255.255.240", GATEWAY, dns]
        self.socks = []
        self.out = []
        self.overruns = []
        self.lines = []
        self.repairs = 0
        self.reverts = 0
        self.connects = 0
        self.garbles = 0
        self.interrupts = 0

    # --- the far end's own printing -------------------------------------
    def emit(self, *a, **kw):
        sep = kw.get("sep", " ")
        end = kw.get("end", "\n")
        self.out.append(sep.join(str(x) for x in a) + end)

    def write_raw(self, d):
        # MicroPython's sys.stdout.write takes the bytes through untouched.
        self.out.append(d.decode("latin1") if isinstance(d, bytes) else str(d))

    def boundary(self):
        """Stop transmitting. Whatever is written next opens a new burst."""
        self.out.append(BOUNDARY)

    # --- the interface --------------------------------------------------
    def ifconfig(self, t=None):
        if t is None:
            return tuple(self.cfg)
        self.cfg = list(t)
        if self.cfg[3] != BROKEN_DNS:
            self.repairs += 1
        self.reconfigured()
        return None

    def reconfigured(self):
        """Reconfiguring the interface tears down anything already open."""
        for s in self.socks:
            s.dead = True

    def dhcp_tick(self):
        """The lease comes back between commands. Only the DNS field moves."""
        if self.scenario in ("no-dhcp", "gooddns"):
            return
        if self.cfg[3] != BROKEN_DNS:
            self.reverts += 1
        self.cfg[3] = BROKEN_DNS
        self.reconfigured()

    def getaddrinfo(self, host, port):
        n = int(self.cfg[3].split(".")[0])
        if n == 0 or n >= 224:
            raise OSError(-202)          # the resolver is not a resolver
        if host not in KNOWN:
            raise OSError(-202)          # a name with a character missing
        return [(2, 1, 0, "", (KNOWN[host], port))]


class Sock:
    def __init__(self, mock):
        self.m = mock
        self.timeout = None
        self.connected = False
        self.dead = False
        self.buf = b""
        self.pos = 0

    def settimeout(self, t):
        self.timeout = t

    def connect(self, addr):
        if self.dead:
            raise OSError(104)
        if self.m.scenario == "refuse":
            raise OSError(111)           # ECONNREFUSED
        self.connected = True
        self.m.connects += 1
        self.m.socks.append(self)

    def connect_body(self):
        if self.m.scenario == "empty":
            return HEADERS
        if self.m.scenario == "nonewline":
            return RESPONSE.rstrip(b"\n")
        return RESPONSE

    def send(self, data):
        if self.dead:
            raise OSError(104, "ECONNRESET")
        if not self.connected:
            raise OSError(128)           # ENOTCONN
        self.buf = self.connect_body()
        return len(data)

    def recv(self, n):
        if self.dead:
            raise OSError(104, "ECONNRESET")
        # ⛔ A recv IS A BURST BOUNDARY, and this is the whole reason the fetched
        # page used to lose its first character. Waiting for the network stops
        # the far end transmitting; whatever is written next opens a new burst
        # and koti destroys its opening byte. Measured on hardware 2026-08-14:
        # three fetches, three `'TTP/1.1 200 OK`.
        self.m.boundary()
        if not self.connected:
            # The measured wedge: recv on an unconnected socket BLOCKS, and
            # the socket timeout is the only thing that ends it.
            time.sleep(self.timeout or 20)
            raise OSError(110)           # ETIMEDOUT
        d = self.buf[self.pos:self.pos + n]
        self.pos += len(d)
        return d

    def close(self):
        self.connected = False


class SocketModule:
    def __init__(self, mock):
        self.m = mock

    def socket(self):
        return Sock(self.m)

    def getaddrinfo(self, host, port):
        return self.m.getaddrinfo(host, port)


class SysModule:
    def __init__(self, mock):
        class Out:
            def write(_s, d):
                mock.write_raw(d)
        self.stdout = Out()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dev")
    ap.add_argument("cap")
    ap.add_argument("--scenario", default="ok")
    ap.add_argument("--report", default="")
    ap.add_argument("--timeout", type=float, default=180.0)
    args = ap.parse_args()

    mock = Mock(args.scenario)
    ns = {
        "socket": SocketModule(mock),
        "sys": SysModule(mock),
        "print": mock.emit,
    }
    # `nojoin`: no join has run in this repl session, so `w` does not exist and
    # link_up's own print raises NameError. That is the honest answer to "have
    # you joined?" and koti-net has to translate it rather than dial anyway.
    if args.scenario != "nojoin":
        ns["w"] = mock
    # `w` is the WLAN object: the only methods koti-net calls on it.
    mock.isconnected = lambda: args.scenario != "not-associated"
    mock.status = lambda: 1010 if args.scenario != "not-associated" else 1001

    open(args.cap, "wb").close()
    open(args.dev, "wb").close()
    cap = open(args.cap, "ab")

    def burst(text):
        """One transmission from the far end — minus its first character."""
        if not text:
            return
        cap.write(text[1:].encode("latin1", "replace"))
        cap.flush()

    def take_line():
        try:
            with open(args.dev, "rb") as f:
                d = f.read()
        except OSError:
            return None
        if not d.endswith(b"\r\n"):
            return None
        with open(args.dev, "wb"):
            pass
        return d.decode("latin1").rstrip("\r\n")

    def eat_interrupt():
        """True if a Ctrl-C is waiting; consumes everything up to and past it.

        MicroPython's REPL raises KeyboardInterrupt on 0x03 even from inside a
        running exec(), which is the only thing that ends a blocked recv().
        koti-net's resync() depends on that, so the mock has to model it or the
        recovery path is untestable — and an untested recovery path is how the
        wedge came to be documented as needing a power cycle.
        """
        try:
            with open(args.dev, "rb") as f:
                d = f.read()
        except OSError:
            return False
        if b"\x03" not in d:
            return False
        rest = d.split(b"\x03", 1)[1]
        with open(args.dev, "wb") as f:
            f.write(rest)
        return True

    def busy(seconds):
        """Execute for a while. Anything written to us in here is LOST.

        Returns True if a Ctrl-C cut it short — the caller must then NOT run
        the command, exactly as a real KeyboardInterrupt would not.
        """
        end = time.time() + seconds
        while time.time() < end:
            if eat_interrupt():
                return True
            lost = take_line()
            if lost is not None:
                mock.overruns.append(lost)
            time.sleep(0.02)
        return False

    deadline = time.time() + args.timeout
    stop = args.dev + ".stop"
    while time.time() < deadline and not os.path.exists(stop):
        # A Ctrl-C arriving at an IDLE prompt is not an error and not a line:
        # it just gets a fresh prompt. resync() sends one unconditionally, so
        # this is the ordinary case, not the exceptional one.
        if eat_interrupt():
            mock.interrupts += 1
            burst("zz\r\n")
            burst(">>> ")
            continue
        line = take_line()
        if line is None:
            time.sleep(0.02)
            continue
        # `garble`: the far end RECEIVES a line with a character missing, the
        # measured burst fault that made every -202 truthful. It echoes what it
        # got — which is the only way this is ever visible from koti's side.
        if args.scenario == "garble" and mock.garbles < 2 and line[:2] in ("a=", "h="):
            mock.garbles += 1
            line = line[:5] + line[6:]
        # `flakylink`: the same fault, on the line link_up sends. A dropped
        # character there raises instead of printing the marker, and a check
        # that asks once then gives up turns a working network into a refusal.
        if args.scenario == "flakylink" and "KOTI'+'-UP" in line and not mock.garbles:
            mock.garbles += 1
            line = line.replace("isconnected", "isconnectd", 1)
        # `c1damage` / `c1damage-hard`: ONE character — the `+` of a `c1+=` —
        # is lost on the way in. The line stays valid Python and REPLACES the
        # fetch program with that fragment instead of appending to it, so
        # exec(c1) prints the BEGIN marker, raises NameError on `b`, and the
        # page and the END marker never come. That is markers-and-no-page, the
        # 2026-08-19 symptom, from a single dropped byte on a link this file
        # documents as dropping bytes. `hard` never lets go, to prove the
        # give-up path refuses rather than fetching half a page.
        if (args.scenario in ("c1damage", "c1damage-hard")
                and line.startswith("c1+=") and "-BEGIN" in line
                and (args.scenario == "c1damage-hard" or not mock.garbles)):
            mock.garbles += 1
            line = line.replace("c1+=", "c1=", 1)
        mock.lines.append(line)
        burst(line + "\r\n")             # the echo is its own burst
        mock.out = []

        # A command boundary: the DHCP client gets to run here and nowhere
        # else. This is the whole reason the transaction must be one exec.
        mock.dhcp_tick()

        # The far end is busy for a while, and deaf while it is.
        # `wedge`: it never finishes on its own. Only a Ctrl-C ends it, which
        # is the state cmd_get's own comments described as needing an off/wake
        # power cycle of the ESP32. It does not.
        if args.scenario == "wedge" and line.startswith("exec("):
            _b = 60.0
        else:
            _b = 1.2 if line.startswith("exec(") else 0.1
        if busy(_b):
            mock.out = []
            mock.interrupts += 1
            burst("zzKeyboardInterrupt\r\n")
            burst(">>> ")
            continue

        if line.startswith("import "):
            pass                          # the fakes are already in `ns`
        else:
            try:
                exec(line, ns)            # noqa: S102 - that is the point
            except Exception as e:        # a traceback, echoed back
                mock.emit("Traceback (most recent call last):")
                mock.emit('  File "<stdin>", line 1, in <module>')
                mock.emit("%s: %s" % (type(e).__name__, e))
        # One burst per uninterrupted run of output. A boundary in the middle
        # of a command's output is not a pause in the SHELL — it is the far end
        # blocking on the network, and the byte after it is the one that dies.
        seg = []
        for piece in mock.out:
            if piece is BOUNDARY:
                burst("".join(seg))
                seg = []
            else:
                seg.append(piece)
        burst("".join(seg))
        burst(">>> ")

    cap.close()
    if args.report:
        with open(args.report, "w") as f:
            json.dump({
                "lines": mock.lines,
                "overruns": mock.overruns,
                "repairs": mock.repairs,
                "reverts": mock.reverts,
                "connects": mock.connects,
                "garbles": mock.garbles,
                "interrupts": mock.interrupts,
                "cfg": mock.cfg,
            }, f, indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
