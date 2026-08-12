#!/usr/bin/env python3
"""Own COM3 continuously; type into koti one character at a time, paced on echo.

⛔ ONE CHARACTER AT A TIME, AND THIS IS NOT CAUTION — IT IS THE HARDWARE.
src/koti_core.sv:1025 keeps the received byte in a SINGLE REGISTER with an
overflow flag (`rx_byte <= rx_data_w`), and hvc0's poll loop takes at most one
character per poll. Write "root\r" as one 5-byte burst at 115200 and the first
four bytes overwrite each other inside 350 us; the CR survives, busybox getty
sees an empty username, and it reprints the issue and the prompt. That looks
exactly like a console ignoring you, and nothing is wrong with the link.
Measured on this board 2026-08-12: four sends, four reprints, zero echo.

⛔ AND PACE ON THE ECHO, NOT ON A FIXED DELAY. Linux's hvc poll interval is
adaptive — MIN_TIMEOUT 10 ms after it finds data, doubling to MAX_TIMEOUT
2000 ms once the line goes quiet. So the first character of a command can take
two seconds to be noticed while the rest need ten milliseconds, and any single
fixed gap is either far too slow for the body of a line or too fast for its
first byte. Waiting for the character to come back solves both, and it is the
same lesson as tt-riscv's testbench: listen continuously, and let the far end
set the pace.

⚠️ DTR/RTS are forced low before opening. On the ULX3S the FT231X's DTR/RTS
reach the ESP32's auto-reset circuit; pyserial asserts them on open by default,
which would reset the very chip we are trying to drive.

  serve <log> <cmdfile>
Commands in <cmdfile>, one per line, consumed as they appear:
  anything        typed character by character, then CR
  #sleep N        wait N seconds
  #raw XX XX      send those hex bytes (Ctrl-C = 03), no echo wait
  #mark TEXT      write a marker into the log only
  #blind TEXT     type it without waiting for echo (password prompts)
"""
import sys
import threading
import time

import serial

log_path, cmd_path = sys.argv[2], sys.argv[3]

ser = serial.Serial()
ser.port = "COM3"
ser.baudrate = 115200
ser.timeout = 0.1
ser.dtr = False
ser.rts = False
ser.open()

log = open(log_path, "ab", buffering=0)
rx_count = 0


def reader():
    global rx_count
    while True:
        try:
            b = ser.read(4096)
        except Exception as e:  # port yanked = board unplugged
            log.write(b"\n[kdrive: read failed: %s]\n" % str(e).encode())
            return
        if b:
            rx_count += len(b)
            log.write(b)


threading.Thread(target=reader, daemon=True).start()


def type_line(text, blind=False, echo_wait=3.0):
    """Send one character at a time, each after the previous one came back."""
    for ch in text.encode() + b"\r":
        before = rx_count
        ser.write(bytes([ch]))
        if blind:
            time.sleep(0.12)
            continue
        deadline = time.time() + echo_wait
        while rx_count == before and time.time() < deadline:
            time.sleep(0.01)
        # A tick of settle even after the echo: the echo is proof the byte was
        # consumed, not proof the reader has gone back to polling.
        time.sleep(0.03)


open(cmd_path, "a").close()
consumed = 0
# Sacrifice a leading CR: the first character after opening is routinely lost.
ser.write(b"\r")
time.sleep(0.5)

while True:
    try:
        with open(cmd_path, "r", encoding="utf-8", errors="replace") as f:
            lines = f.read().split("\n")
    except OSError:
        time.sleep(0.2)
        continue
    # The last element is the unterminated tail; only act on complete lines.
    for line in lines[consumed:len(lines) - 1]:
        consumed += 1
        if line.startswith("#sleep "):
            time.sleep(float(line.split()[1]))
        elif line.startswith("#raw "):
            ser.write(bytes(int(x, 16) for x in line.split()[1:]))
            time.sleep(0.3)
        elif line.startswith("#mark "):
            log.write(("\n[kdrive: %s]\n" % line[6:]).encode())
        elif line.startswith("#blind "):
            log.write(b"\n[kdrive types blind]\n")
            type_line(line[7:], blind=True)
        else:
            log.write(("\n[kdrive types: %s]\n" % line).encode())
            type_line(line)
    time.sleep(0.2)
