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

  .data : { *(.data*) *(.sdata*) } > RAM AT > FLASH
  ASSERT(SIZEOF(.data) == 0, "no .data allowed in the firmware")

  .bss (NOLOAD) : {
    *(.bss*)
    *(.sbss*)
    *(COMMON)
  } > RAM
}
