// usbkbd.h — USB HID keyboard on US2. See usbkbd.c and src/usb_kbd.sv.
#ifndef KOTI_USBKBD_H
#define KOTI_USBKBD_H

// Non-blocking: returns the next character, or -1 if none is waiting or the key
// has no glyph. ⚠️ Consumes one queue entry per call when one is available.
int usb_getchar(void);

// True when a keyboard has enumerated. Reads USB_STAT, which has no side
// effects, so this is safe to call as often as you like.
int usb_kbd_present(void);

#endif
