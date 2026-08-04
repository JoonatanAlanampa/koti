/* link.ld — SBI firmware at flash 0, payload entry pinned at 0x4000
 * (S-mode code may live anywhere — only the entry address is fixed).
 * No .data allowed: firmware state is .bss in PSRAM, written before
 * read. */
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  FLASH : ORIGIN = 0x00000000, LENGTH = 64K
  RAM   : ORIGIN = 0x01000000, LENGTH = 24K
}

SECTIONS {
  .text : {
    *(.text.init)
    *(.text*)
    *(.rodata*)
    *(.srodata*)
  } > FLASH

  .payload 0x4000 : { *(.payload) } > FLASH

  /* The devicetree blob. sbi.c reads it from 0x6000, validates the FDT magic
   * and copies `totalsize` bytes into RAM before entering a kernel. dtb.S
   * fills it by .incbin'ing ../linux/koti.dtb, and the address is pinned here
   * rather than left to the linker because 0x6000 is a constant compiled into
   * sbi.c as well: two files have to agree on it and only one can decide.
   * (Before dtb.S existed this section was empty, which was harmless rather
   * than broken -- unprogrammed flash reads 0xFF, the magic test failed and
   * the kernel was entered with a1 = 0 -- but no kernel survives that.) */
  .dtb 0x6000 : { *(.dtb) } > FLASH

  .data : { *(.data*) *(.sdata*) } > RAM AT > FLASH
  ASSERT(SIZEOF(.data) == 0, "no .data allowed in the firmware")

  .bss (NOLOAD) : {
    *(.bss*)
    *(.sbss*)
    *(COMMON)
  } > RAM
}
