# synth.ps1 — build the Koti-1 prototype bitstream for the ULX3S 85F.
#   powershell -File fpga\ulx3s\synth.ps1              # full flow -> koti.bit
#   powershell -File fpga\ulx3s\synth.ps1 -SynthOnly   # yosys only (fast check)
#
# USE -SynthOnly LOCALLY. Place-and-route on an 85F is the slow step by a wide
# margin and heavy compute does not belong on this machine (project policy,
# 2026-07-24) - CI does the real build. -SynthOnly stops after yosys, which is
# enough to catch an elaboration error, a missing source or a surprise in the
# cell count, in seconds rather than minutes.
#
# Output: fpga\ulx3s\build\koti.bit (full flow) or koti.json (synth only)
#
# Load a bitstream one of two ways - the difference matters:
#   openFPGALoader -b ulx3s    fpga\ulx3s\build\koti.bit   # SRAM: GONE at power-off
#   openFPGALoader -b ulx3s -f fpga\ulx3s\build\koti.bit   # SPI flash: survives
# Use the volatile load while iterating; -f once the board behaves.
#
# The bitstream contains the UNCHANGED tt_um_koti plus the harness-only pad
# logic (header permutation, straps, tristates) that silicon has no pins for.
# See ulx3s_top.sv for what is harness-only and why.
# -Bram builds the variant whose boot flash is fpga\ulx3s\bram_flash.sv - a
# QSPI device in fabric on the same eight uio wires - so the SoC boots with
# NOTHING plugged into J1. That is the only variant that can go on the board
# until the Cartridge Pmod arrives. CI builds both (matrix in
# .github\workflows\fpga-ulx3s.yaml); keep the two in step.
param([switch]$SynthOnly, [switch]$Bram)

$ErrorActionPreference = "Stop"
$oss = "$env:USERPROFILE\opt\oss-cad-suite"
if (-not (Test-Path $oss)) { throw "oss-cad-suite not found at $oss" }
$env:PATH = "$oss\bin;$oss\lib;" + $env:PATH

# Run from the repo root so the paths in sources.txt and `-I src` resolve.
Set-Location (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)
New-Item -ItemType Directory -Force fpga\ulx3s\build | Out-Null

$src = (Get-Content fpga\ulx3s\sources.txt |
        Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() -ne "" } |
        ForEach-Object { $_.Trim() }) -join " "
if (-not $src) { throw "fpga\ulx3s\sources.txt listed no sources" }

# The fabric flash is deliberately NOT in sources.txt: the pmod variant must not
# read it at all, because its $readmemh would then look for an image that build
# has no reason to generate. It is prepended here and in the CI workflow's
# variant branch - the two places that already know which variant they are.
$extra = ""
if ($Bram) {
    $src   = "fpga/ulx3s/bram_flash.sv " + $src
    $extra = "-DKOTI_FLASH_BRAM"
    python fpga\ulx3s\mkflashhex.py sw\hello.bin fpga\ulx3s\build\flash.hex
    if ($LASTEXITCODE -ne 0) { throw "mkflashhex.py failed - the image does not fit" }
}

# Constraints and RTL drift apart silently; check before spending any time.
python fpga\ulx3s\check_pins.py
if ($LASTEXITCODE -ne 0) { throw "check_pins.py failed - fix the pin plan first" }

# -DKOTI_FPGA builds the ULX3S variant: the RAM half of the memory map is
# served by the board's onboard 32 MB SDRAM instead of the QSPI Pmod's PSRAM.
# Without it the same sources build the QSPI machine, which is the fallback and
# the bisection base. Keep this in step with the CI workflow and run_fpga.py —
# all three must define it or the thing you test is not the thing you flash.
yosys -q -l fpga\ulx3s\build\yosys.log `
      -p "read_verilog -sv -DKOTI_FPGA $extra -I src $src; synth_ecp5 -top ulx3s_top -json fpga/ulx3s/build/koti.json"
if ($LASTEXITCODE -ne 0) { throw "yosys failed - see fpga\ulx3s\build\yosys.log" }
Write-Output "OK: fpga\ulx3s\build\koti.json"

if ($SynthOnly) { exit 0 }

Write-Warning "Running place-and-route locally. This is the slow step; CI is the intended place for it."

nextpnr-ecp5 --85k --package CABGA381 `
    --json fpga/ulx3s/build/koti.json `
    --lpf fpga/ulx3s/ulx3s.lpf `
    --textcfg fpga/ulx3s/build/koti.config
if ($LASTEXITCODE -ne 0) { throw "nextpnr-ecp5 failed (timing or placement)" }

ecppack fpga/ulx3s/build/koti.config fpga/ulx3s/build/koti.bit
if ($LASTEXITCODE -ne 0) { throw "ecppack failed" }
Write-Output "OK: fpga\ulx3s\build\koti.bit"
