// usbkbd.c — HID usage codes to characters. Finnish layout by default.
//
// The other half of src/usb_kbd.sv. The gateware turns "these keys are held"
// into a queue of "this key went down"; this turns a key into a character.
//
// WHY A TABLE IN SOFTWARE, when the gateware could have done it: a keymap
// changes with layout and with taste, and it is the one part of a keyboard
// people genuinely want to change. In LUTs that is a place-and-route; in C it
// is a recompile. sw/ps2kbd.c made the same call for the same reason.
//
// ⚠️ HID USAGE CODES ARE NOT ASCII AND NOT PS/2 SCANCODES. They identify a
// PHYSICAL KEY POSITION, not a character — 0x38 is "the key right of period",
// which is `/` on a US board and `-` on a Finnish one. That is not a detail:
// koti typed `/` for `-` on 2026-08-07 with a US table and a Finnish keyboard,
// and the raw usage code in usbtest.c is what identified it in one keystroke
// instead of sending anyone hunting through the USB stack.
//
// FINNISH IS THE DEFAULT because that is the keyboard on the bench. Build with
// -DKOTI_KEYMAP_US for the US table.
//
// ⛔ LIMITS, stated rather than discovered later:
//   - Dead keys (´ ` ¨ ~ ^) return -1. Composition needs state and a second
//     keystroke; a dead key that emitted its own accent would be wrong rather
//     than merely absent.
//   - å ä ö § return LATIN-1 bytes (0xE5 0xE4 0xF6 0xA7). Linux's console is
//     UTF-8 by default, so they will not render as intended there, and koti's
//     40x30 font ROM only covers 0x20..0x7F. The KEY works; the ENCODING is a
//     separate piece of work.
//   - No caps lock, same as ps2kbd.c: the lock LEDs are host-driven and this
//     design cannot send a SET_REPORT, so a caps state would be koti's private
//     opinion that the keyboard's own LED would contradict.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"
#include "usbkbd.h"

#define USAGE_LO 0x04u
#define USAGE_HI 0x38u
// The ISO key between left shift and Z. It does not exist on a US board, which
// is why it sits outside the contiguous range — and on a Finnish board it
// carries `|`, so a shell is unusable without it.
#define USAGE_ISO 0x64u

#define DEAD '\0'                       // no character; see the limits above

#ifdef KOTI_KEYMAP_US

static const char base[] = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m',      // 04-10
    'n','o','p','q','r','s','t','u','v','w','x','y','z',      // 11-1D
    '1','2','3','4','5','6','7','8','9','0',                  // 1E-27
    '\n','\x1b','\b','\t',' ','-','=','[',']','\\',           // 28-31
    DEAD,                                                     // 32 non-US #
    ';','\'','`',',','.','/'                                  // 33-38
};
static const char shifted[] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    '!','@','#','$','%','^','&','*','(',')',
    '\n','\x1b','\b','\t',' ','_','+','{','}','|',
    DEAD,
    ':','"','~','<','>','?'
};
static const char altgr[] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,
    0,0,0,0,0,0
};
#define ISO_BASE  DEAD
#define ISO_SHIFT DEAD
#define ISO_ALTGR DEAD

#else   /* Finnish / Nordic — the keyboard on the bench */

// Positions are the US usage codes; the CHARACTERS are what a Finnish keyboard
// prints on those keys. Letters are unchanged (both are QWERTY); the number
// row's shifted forms and all the punctuation differ.
static const char base[] = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m',      // 04-10
    'n','o','p','q','r','s','t','u','v','w','x','y','z',      // 11-1D
    '1','2','3','4','5','6','7','8','9','0',                  // 1E-27
    '\n','\x1b','\b','\t',' ',                                // 28-2C
    '+',                                                      // 2D  (US -)
    DEAD,                                                     // 2E  ´ dead
    '\xE5',                                                   // 2F  å
    DEAD,                                                     // 30  ¨ dead
    '\'',                                                     // 31  (US \)
    DEAD,                                                     // 32  non-US #
    '\xF6',                                                   // 33  ö
    '\xE4',                                                   // 34  ä
    '\xA7',                                                   // 35  §
    ',','.',                                                  // 36-37
    '-'                                                       // 38  (US /)
};
static const char shifted[] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    '!','"','#','$','%','&','/','(',')','=',                  // 1E-27
    // ⚠️ shift+4 is ¤ on a real Finnish board. '$' is used instead because ¤ is
    // useless in a shell and $ is not, and AltGr+4 gives $ as well — so this is
    // a deliberate convenience, not a transcription error.
    '\n','\x1b','\b','\t',' ',
    '?',                                                      // 2D
    '`',                                                      // 2E
    '\xC5',                                                   // 2F  Å
    '^',                                                      // 30
    '*',                                                      // 31
    DEAD,                                                     // 32
    '\xD6',                                                   // 33  Ö
    '\xC4',                                                   // 34  Ä
    DEAD,                                                     // 35  ½
    ';',':',                                                  // 36-37
    '_'                                                       // 38
};
// AltGr (right alt). Without these a Finnish keyboard cannot produce @ $ { } [ ]
// or backslash at all, which rules out email addresses, shell braces and paths.
static const char altgr[] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,                                // a-m
    0,0,0,0,0,0,0,0,0,0,0,0,0,                                // n-z
    0,'@','\xA3','$',0,0,'{','[',']','}',                     // 1E-27
    0,0,0,0,0,                                                // 28-2C
    '\\',                                                     // 2D  AltGr++
    0,                                                        // 2E
    0,                                                        // 2F
    '~',                                                      // 30
    0,                                                        // 31
    0,                                                        // 32
    0,0,0,                                                    // 33-35
    0,0,                                                      // 36-37
    0                                                         // 38
};
#define ISO_BASE  '<'
#define ISO_SHIFT '>'
#define ISO_ALTGR '|'

#endif

// ⚠️ THE ONE CHECK THESE TABLES CANNOT DO WITHOUT. They are 53 hand-written
// entries covering usage 0x04..0x38, and a single missing or extra comma shifts
// every key after it by one — which is not a crash, it is a keyboard that types
// plausible wrong characters. Exactly the failure that a US table on a Finnish
// board already produced once. This turns it into a build error.
#define KEYMAP_LEN (USAGE_HI - USAGE_LO + 1u)
_Static_assert(sizeof(base)    == KEYMAP_LEN, "base[] is not 0x04..0x38");
_Static_assert(sizeof(shifted) == KEYMAP_LEN, "shifted[] is not 0x04..0x38");
_Static_assert(sizeof(altgr)   == KEYMAP_LEN, "altgr[] is not 0x04..0x38");

// Reads USB_STAT, which has no side effects — safe to call as often as you like.
int usb_kbd_present(void) {
    return USB_TYP(USB_STAT) == 1u;
}

// Returns -1 when nothing is waiting. Non-blocking, because the legacy SBI
// console_getchar it feeds is specified that way, and because a blocking read
// in M-mode firmware would stop the machine on a keyboard that is unplugged.
#ifdef KOTI_PROFILE
// The RAW word of the last non-empty pop, for the M-mode profiler to print.
// This is the only place it can be recorded: reading USB_KBD POPS, so nothing
// else may look. Guarded so sbi_sd.bin stays byte-identical.
//
// WHY IT IS WORTH FOUR BYTES. On 2026-08-09 both consoles stopped showing
// characters at the same instant while the lamps proved keystrokes were still
// being enqueued and drained. Both consumers silently DROP usages they cannot
// map -- this returns -1 outside 0x04..0x38, and koti_kbd.c does `continue` --
// so a usage code that turns to junk, or merely shifts out of the letter range,
// silences both at once and looks exactly like a dead keyboard.
volatile unsigned prof_last_kbd;
#endif

int usb_getchar(void) {
    unsigned v = USB_KBD;              // ⚠️ this POPS when USB_AVAIL is set
    if (!(v & USB_AVAIL))
        return -1;
#ifdef KOTI_PROFILE
    prof_last_kbd = v;                 // AFTER the avail test: an empty pop is
                                       // not a keystroke and would erase one
#endif

    unsigned usage = v & 0xFFu;
    unsigned mods  = USB_MODS(USB_STAT);
    char c;

    if (usage == USAGE_ISO) {
        c = (mods & USB_MOD_RALT)  ? ISO_ALTGR
          : (mods & USB_MOD_SHIFT) ? ISO_SHIFT : ISO_BASE;
    } else if (usage >= USAGE_LO && usage <= USAGE_HI) {
        unsigned i = usage - USAGE_LO;
        // AltGr first: on this layout it is the only way to reach @ $ { } [ ] \,
        // and it is never a shifted form of anything.
        c = (mods & USB_MOD_RALT) ? altgr[i]
          : (mods & USB_MOD_SHIFT) ? shifted[i] : base[i];
        if ((mods & USB_MOD_RALT) && c == 0)
            return -1;                 // AltGr with a key that has no AltGr form
    } else {
        return -1;                     // a real key, but not one with a glyph
    }

    if (c == DEAD)
        return -1;

    // Ctrl folds the letters to 0x01..0x1A, which is what a shell wants for ^C
    // and ^D. Only the letters: ctrl with punctuation is not portable and
    // guessing would send characters nobody typed.
    if ((mods & USB_MOD_CTRL) && usage >= 0x04u && usage <= 0x1Du)
        return (int)(usage - 0x04u + 1u);

    return (int)(unsigned char)c;
}
