/* link_asic.ld — riscv-tests layout for the TinyRV32 ASIC memory map:
 * code in flash at 0 (the reset PC), data in PSRAM at 0x0100_0000.
 * The testbench loads .text into the flash model and .data into the
 * PSRAM model (on silicon a loader would do the copy). */
OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
  . = 0x00000000;
  .text : { *(.text.init) *(.text) }
  . = 0x01000000;
  .data : { *(.data) *(.rodata) *(.rodata.*) *(.sdata) *(.srodata*) }
}
