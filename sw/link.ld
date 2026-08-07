/* link.ld — Koti-1 bare-metal layout: code+rodata execute in place
 * from flash; .data lives in PSRAM (copied by crt0 from its flash
 * load address); stack at the top of the first 64 KB of PSRAM (the
 * simulation models are 64 KB — silicon has 8 MB). */
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  FLASH : ORIGIN = 0x00000000, LENGTH = 64K
  RAM   : ORIGIN = 0x01000000, LENGTH = 32K
}

SECTIONS {
  .text : {
    *(.text.init)
    *(.text*)
    *(.rodata*)
    *(.srodata*)
    /* ⚠️ NOT COSMETIC. Without this the .data LOAD address is wherever .rodata
     * happened to stop — and .rodata ends on a string, so it is very rarely a
     * multiple of 4. crt0 copies .data with `lw`/`sw`, so a misaligned LMA
     * traps on the FIRST word, mtvec sends the core to 0, and the program
     * restarts forever: a board that clocks, blinks its heartbeat and never
     * prints a character. Found 2026-08-07 by sw/sdraw.c, the first image with
     * a non-empty .data — every earlier image had only .bss, which is zeroed in
     * place and never read from flash, so the bug could not fire. */
    . = ALIGN(4);
  } > FLASH

  .data : {
    . = ALIGN(4);
    __data_vma = .;
    *(.data*)
    *(.sdata*)
    . = ALIGN(4);
    __data_end = .;
  } > RAM AT > FLASH
  __data_lma = LOADADDR(.data);

  .bss (NOLOAD) : {
    . = ALIGN(4);
    __bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > RAM
}

PROVIDE(__stack_top = 0x01008000);   /* below the charbuf */
