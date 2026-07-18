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
  } > FLASH

  .data : {
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
