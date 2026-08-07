// usbkbd.c — HID usage codes to characters, US layout.
//
// The other half of src/usb_kbd.sv. The gateware turns "these keys are held"
// into a queue of "this key went down"; this turns a key into a character.
//
// WHY A TABLE IN SOFTWARE, when the gateware could have done it: a keymap
// changes with layout and with taste, and it is the one part of a keyboard
// that people genuinely want to change. In LUTs that is a place-and-route; in
// C it is a recompile. sw/ps2kbd.c made the same call for the same reason.
//
// ⚠️ HID USAGE CODES ARE NOT ASCII AND NOT PS/2 SCANCODES. They are their own
// numbering: 0x04 is `a`, 0x1E is `1`, and the alphabet is contiguous, which is
// the one convenience the scheme offers. Nothing here can be shared with
// ps2kbd.c, which decodes scancode set 2 with its E0/F0 prefixes.
//
// US layout, no caps lock — same scope as ps2kbd.c, and for the same reason:
// the lock LEDs are host-driven and this design has no way to send a SET_REPORT
// back to the keyboard, so a caps-lock state would be koti's private opinion
// that the keyboard's own LED would contradict.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
#include "koti.h"
#include "usbkbd.h"

// 0x04..0x38, the printable span of the boot-protocol keyboard. Two tables
// rather than one plus arithmetic: the shifted forms of the number row and the
// punctuation are not derivable, and a `if (shift) c -= 0x20` style rule gets
// the letters right and everything else wrong.
static const char base[] = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m',      // 04-10
    'n','o','p','q','r','s','t','u','v','w','x','y','z',      // 11-1D
    '1','2','3','4','5','6','7','8','9','0',                  // 1E-27
    '\n','\x1b','\b','\t',' ','-','=','[',']','\\',           // 28-31
    '\0',                                                     // 32 (non-US #)
    ';','\'','`',',','.','/'                                  // 33-38
};

static const char shifted[] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    '!','@','#','$','%','^','&','*','(',')',
    '\n','\x1b','\b','\t',' ','_','+','{','}','|',
    '\0',
    ':','"','~','<','>','?'
};

#define USAGE_LO 0x04u
#define USAGE_HI 0x38u

// Reads USB_STAT, which has no side effects — safe to call as often as you like.
int usb_kbd_present(void) {
    return USB_TYP(USB_STAT) == 1u;
}

// Returns -1 when nothing is waiting. Non-blocking, because the legacy SBI
// console_getchar it feeds is specified that way, and because a blocking read
// in M-mode firmware would stop the machine on a keyboard that is unplugged.
int usb_getchar(void) {
    unsigned v = USB_KBD;              // ⚠️ this POPS when USB_AVAIL is set
    if (!(v & USB_AVAIL))
        return -1;

    unsigned usage = v & 0xFFu;
    if (usage < USAGE_LO || usage > USAGE_HI)
        return -1;                     // a real key, but not one with a glyph

    unsigned mods = USB_MODS(USB_STAT);
    unsigned i = usage - USAGE_LO;
    char c = (mods & USB_MOD_SHIFT) ? shifted[i] : base[i];
    if (c == '\0')
        return -1;

    // Ctrl folds the letters to 0x01..0x1A, which is what a shell wants for
    // ^C and ^D. Only the letters: ctrl with punctuation is not portable and
    // guessing would send characters nobody typed.
    if ((mods & USB_MOD_CTRL) && usage >= 0x04u && usage <= 0x1Du)
        return (int)(usage - 0x04u + 1u);

    return (int)(unsigned char)c;
}
