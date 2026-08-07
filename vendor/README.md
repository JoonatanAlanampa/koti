# vendor/ — code from elsewhere, copied unchanged

Everything here is a **verbatim copy** of a file that is maintained in another
repository and is proven there. It is vendored rather than rewritten for the
reason this project keeps re-learning: a protocol someone else has already got
working on this exact board is not where original work belongs. Same call as
`console/vendor/gamepad_pmod.v`, and the same call as the TinyRV32 core in
`core/`.

⚠️ **Do not edit these files.** If one needs to change, change it upstream and
re-copy, so the two do not silently diverge — the copy that gets "just one small
fix" is the one that stops being the proven version.

| file | from | upstream commit | proven by |
| --- | --- | --- | --- |
| `sd_spi.sv` | `console/fpga/sd_spi.sv` | `b0bb8be` (2026-07-29) | ran on **this** ULX3S: console loaded games off a microSD card, 2026-08-07. Its own cocotb suite (`console/test/test_sdload.py`) covers a card that stays busy through several ACMD41s, a bad-magic image, a checksum mismatch, and no card at all |
| `spi_master.sv` | `console/fpga/spi_master.sv` | `b0bb8be` (2026-07-29) | same |

## What `sd_spi.sv` gives koti

A microSD card in SPI mode: the whole bring-up sequence (74 idle clocks, CMD0,
CMD8, CMD55+ACMD41 until ready, CMD58 for the OCR/CCS bit, CMD16 when the card
is not SDHC) and 512-byte block reads over CMD17, with SDSC/SDHC addressing
handled. koti drives it through `src/sd_ctrl.sv`, which is the thin adapter:
MMIO registers, plus a block buffer so software reads a word at a time instead
of racing the byte strobes.

**Why not write the protocol in C**, given koti has a CPU: because this exists,
works, and is 400 lines of state machine nobody has to debug twice. The C side
is then a dozen lines — write an LBA, poll a bit, read 128 words.
