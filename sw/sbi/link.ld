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

  /* The devicetree blob, if one has been built. sbi.c reads it from 0x6000,
   * validates the FDT magic and copies `totalsize` bytes into RAM before
   * entering a kernel. Nothing emits a .dtb section yet -- there is no dtc on
   * the build host -- and that is deliberately harmless: unprogrammed flash
   * reads 0xFF, the magic test fails, and the kernel is entered with a1 = 0.
   * To fill it, build koti.dts and pull the blob in with a stub that does
   *   .section .dtb, "a"
   *   .incbin "koti.dtb"
   * which is why the address is pinned here rather than left to the linker. */
  .dtb 0x6000 : { *(.dtb) } > FLASH

  .data : { *(.data*) *(.sdata*) } > RAM AT > FLASH
  ASSERT(SIZEOF(.data) == 0, "no .data allowed in the firmware")

  .bss (NOLOAD) : {
    *(.bss*)
    *(.sbss*)
    *(COMMON)
  } > RAM
}
