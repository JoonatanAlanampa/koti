// ps2kbd.c — PS/2 scancode set 2 -> ASCII.
//
// The hardware below this (src/ps2_rx.sv) hands over raw, validated frame
// bytes: start/parity/stop are already checked and bad frames are dropped.
// What is left is the protocol, which is three things:
//
//   * a key press is one byte (the "make" code),
//   * a key release is 0xF0 followed by that same byte,
//   * some keys prefix 0xE0 (arrows, right ctrl/alt, keypad /, ...).
//
// Set 2 is the power-on default of every PS/2 keyboard, and we cannot change
// it: selecting set 1 or 3 requires sending a command TO the keyboard, and
// this design is receive-only by construction — `ui` is input-only on the
// chip, so ps2_rx has no transmit path. Set 2 it is.
//
// The same constraint costs the lock LEDs: caps/num/scroll are host-driven
// (command 0xED), so the keys can be tracked in software but the lights on
// the keyboard will never come on. Caps lock is deliberately NOT implemented
// here for that reason — a caps state you can toggle but not see is worse
// than none. Use shift.
//
// LAYOUT IS US. Scancodes identify a physical key position, not a legend, so
// a Nordic keyboard works but produces the US character for each position
// (the key labelled Ä sends what US calls ' ). Remapping means a second table,
// not a protocol change.

#include <stdint.h>
#include "koti.h"
#include "ps2kbd.h"

// Indexed by set-2 make code. 0 = no character (modifier, unknown, or a key
// with no ASCII meaning). Everything past 0x84 is unused by the main block.
static const char base[0x84] = {
    [0x1C] = 'a', [0x32] = 'b', [0x21] = 'c', [0x23] = 'd', [0x24] = 'e',
    [0x2B] = 'f', [0x34] = 'g', [0x33] = 'h', [0x43] = 'i', [0x3B] = 'j',
    [0x42] = 'k', [0x4B] = 'l', [0x3A] = 'm', [0x31] = 'n', [0x44] = 'o',
    [0x4D] = 'p', [0x15] = 'q', [0x2D] = 'r', [0x1B] = 's', [0x2C] = 't',
    [0x3C] = 'u', [0x2A] = 'v', [0x1D] = 'w', [0x22] = 'x', [0x35] = 'y',
    [0x1A] = 'z',

    [0x45] = '0', [0x16] = '1', [0x1E] = '2', [0x26] = '3', [0x25] = '4',
    [0x2E] = '5', [0x36] = '6', [0x3D] = '7', [0x3E] = '8', [0x46] = '9',

    [0x0E] = '`', [0x4E] = '-', [0x55] = '=', [0x5D] = '\\', [0x54] = '[',
    [0x5B] = ']', [0x4C] = ';', [0x52] = '\'', [0x41] = ',', [0x49] = '.',
    [0x4A] = '/',

    [0x29] = ' ', [0x5A] = '\r', [0x66] = '\b', [0x0D] = '\t', [0x76] = 27,
};

// Shifted forms. Letters are handled arithmetically; only the symbol row and
// the punctuation keys need a table.
static const char shifted[0x84] = {
    [0x45] = ')', [0x16] = '!', [0x1E] = '@', [0x26] = '#', [0x25] = '$',
    [0x2E] = '%', [0x36] = '^', [0x3D] = '&', [0x3E] = '*', [0x46] = '(',

    [0x0E] = '~', [0x4E] = '_', [0x55] = '+', [0x5D] = '|', [0x54] = '{',
    [0x5B] = '}', [0x4C] = ':', [0x52] = '"', [0x41] = '<', [0x49] = '>',
    [0x4A] = '?',
};

#define SC_LSHIFT 0x12
#define SC_RSHIFT 0x59

// .bss lives in PSRAM and is NOLOAD — nothing zeroes it (sw/sbi/link.ld). Every
// one of these must be written before it is read, which is what ps2_init is
// for. Skipping it does not degrade gracefully: a garbage-nonzero `releasing`
// eats every scancode as a key release and the keyboard looks dead.
static uint8_t releasing;      // the last byte was 0xF0
static uint8_t extended;       // the last byte was 0xE0
static uint8_t lshift, rshift;

void ps2_init(void) {
    releasing = 0;
    extended  = 0;
    lshift    = 0;
    rshift    = 0;
}

int ps2_getchar(void) {
    uint32_t r = PS2_DATA;     // {ovf[9], avail[8], scancode[7:0]}, read-to-clear

    if (r & 0x200u) {
        // A byte was dropped before this one. `releasing` and `extended`
        // describe a sequence that no longer exists, and carrying them
        // forward is how one lost byte becomes a stream of wrong characters:
        // a lost 0xF0 makes the next real press register as a release, and a
        // byte lost after 0xE0 leaves us treating an ordinary key as extended.
        //
        // There is no way to recover the missing byte and no way to know where
        // in a sequence we are, so discard the state AND the byte that came
        // with the overrun — it may itself be the tail of a sequence whose
        // head is gone. One character is lost instead of the decode staying
        // wrong indefinitely.
        releasing = 0;
        extended  = 0;
        return -1;
    }

    if (!(r & 0x100u))
        return -1;

    uint8_t sc = (uint8_t)(r & 0xFFu);

    if (sc == 0xF0u) {         // release prefix
        releasing = 1;
        return -1;
    }
    if (sc == 0xE0u) {         // extended prefix
        extended = 1;
        return -1;
    }

    if (releasing) {
        releasing = 0;
        // Shift release must be tracked even when extended, or a shift stuck
        // down survives until the next press and silently upper-cases
        // everything typed after it.
        if (!extended) {
            if (sc == SC_LSHIFT) lshift = 0;
            if (sc == SC_RSHIFT) rshift = 0;
        }
        extended = 0;
        return -1;             // releases produce no character
    }

    if (extended) {            // arrows, right ctrl/alt, keypad / — no ASCII
        extended = 0;
        return -1;
    }

    if (sc == SC_LSHIFT) { lshift = 1; return -1; }
    if (sc == SC_RSHIFT) { rshift = 1; return -1; }

    if (sc >= 0x84u)
        return -1;

    int shift = lshift || rshift;
    char c = base[sc];
    if (!c)
        return -1;

    if (shift) {
        if (c >= 'a' && c <= 'z')
            c = (char)(c - 'a' + 'A');
        else if (shifted[sc])
            c = shifted[sc];
    }
    return (unsigned char)c;
}
