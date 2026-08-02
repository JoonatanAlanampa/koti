// ps2kbd.h — PS/2 scancode set 2 -> ASCII, non-blocking.
#ifndef PS2KBD_H
#define PS2KBD_H

// Clear the decoder state. MUST be called before the first ps2_getchar().
//
// Not optional and not defensive: this firmware's .bss is NOLOAD in PSRAM and
// nothing zeroes it (see sw/sbi/link.ld — "firmware state is .bss in PSRAM,
// written before read"). An uninitialised `releasing` flag reads as garbage,
// and garbage-nonzero means every scancode is swallowed as a key release and
// the keyboard appears completely dead.
void ps2_init(void);

// Poll the keyboard. Returns the next character, or -1 if none is ready.
//
// Non-blocking on purpose: this is what SBI legacy console_getchar (EID 0x02)
// is specified to do, and a blocking version would deadlock any caller that
// polls the console from a timer path.
//
// One call consumes at most one scancode byte, so a keypress can take several
// calls to surface — a shift press, a release, or an 0xE0/0xF0 prefix each
// consume a byte and return -1. Callers must poll, not call once and conclude
// the keyboard is dead.
int ps2_getchar(void);

#endif
