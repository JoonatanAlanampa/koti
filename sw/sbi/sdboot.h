// sdboot.h — the microSD kernel transport. See sdboot.c for the on-card layout.
#ifndef KOTI_SDBOOT_H
#define KOTI_SDBOOT_H

// Loads a kernel image from the card into RAM at 0x0140_0000.
// Returns 1 if a valid, checksummed image is now in memory, 0 otherwise —
// and on 0 it has changed nothing, so the caller falls back exactly as before.
int sd_load_kernel(void);

#endif
