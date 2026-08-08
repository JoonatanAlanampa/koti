#!/usr/bin/env python3
"""Wait for COM3 to re-enumerate after a power cycle, then capture the boot.

⚠️ On the ULX3S the FT231X is bus-powered from the same USB, so pulling the
board's power REMOVES the COM port. A capture that holds the port open across a
power cycle dies with PermissionError, which looks like a crash and is not one.
Open AFTER the port comes back.
"""
import sys, time
import serial

port = sys.argv[1] if len(sys.argv) > 1 else "COM3"
secs = float(sys.argv[2]) if len(sys.argv) > 2 else 150.0
out = sys.argv[3] if len(sys.argv) > 3 else None

print(f"waiting for {port} to appear (power the board up now)...", flush=True)
ser = None
t0 = time.time()
while time.time() - t0 < 180:
    try:
        ser = serial.Serial(port, 115200, timeout=0.2)
        break
    except serial.SerialException:
        time.sleep(0.3)
if ser is None:
    sys.exit(f"{port} never came back")

print(f"{port} is back after {time.time()-t0:.1f}s — capturing", flush=True)
buf = b""
t1 = time.time()
with ser:
    ser.reset_input_buffer()
    while time.time() - t1 < secs:
        c = ser.read(4096)
        if c:
            buf += c
            sys.stdout.write(c.decode("utf-8", "replace"))
            sys.stdout.flush()
            if b"login:" in buf:
                time.sleep(0.5)
                buf += ser.read(4096)
                break

if out:
    open(out, "wb").write(buf)
printable = sum(1 for b in buf if 32 <= b < 127 or b in (10, 13, 9))
print(f"\n=== {len(buf)} bytes, {len(buf)-printable} non-printable ===")
