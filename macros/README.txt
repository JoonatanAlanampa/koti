DFFRF_2R1W — 32x32 two-read-one-write register file macro
==========================================================

Vendored (unchanged) from the AUCOHL/DFFRAM project.

  Source:   https://github.com/AUCOHL/DFFRAM
  Release:  2025.11.10
  Asset:    merged-artifacts.tgz
            https://github.com/AUCOHL/DFFRAM/releases/download/2025.11.10/merged-artifacts.tgz
  Design:   DFFRF_2R1W  (dffram.py -p sky130A -s sky130_fd_sc_hd -b ::rf -v 2R1W, size 32x32)
  PDK/SCL:  sky130A / sky130_fd_sc_hd
  License:  Apache-2.0  (SPDX-License-Identifier: Apache-2.0)
            Copyright (c) 2020-2025 The American University in Cairo and DFFRAM contributors.

The DFFRAM flow is signoff-clean (DRC/LVS) per the project's own CI; these
artifacts are its released output, not regenerated here.

Files
-----
  DFFRF_2R1W.gds                          layout (merged GDS)
  DFFRF_2R1W.lef                          abstract for P&R  (SIZE 358.340 x 176.800 um; power pins VPWR/VGND)
  DFFRF_2R1W.nl.v                         mapped gate netlist (LVS / synthesis reference)
  DFFRF_2R1W.pnl.v                        powered gate netlist (post-layout gate-level sim, VPWR/VGND)
  DFFRF_2R1W.lib/<corner>/...lib          Liberty timing, 9 corners (min/nom/max x ss/tt/ff)
  DFFRF_2R1W.{min_,nom_,max_}.spef        parasitics per interconnect corner

Interface (DFFRF_2R1W): CLK, WE, RA[4:0], RB[4:0], RW[4:0], DW[31:0] -> DA[31:0], DB[31:0]
  - synchronous WRITE (posedge CLK, when WE), COMBINATIONAL read (DA/DB track the array)
  - R0_ZERO=1: register 0 always reads 0; writes to RW==0 are discarded

Integration
-----------
  * src/DFFRF_2R1W.v   behavioural black-box model (/// sta-blackbox) for synth + sim
  * src/regfile.sv     USE_MACRO branch instantiates this macro and registers DA/DB to
                       recover Koti-1's registered read-first regfile timing
  * src/config.json    MACROS + EXTRA_VERILOG_MODELS + VERILOG_DEFINES=USE_MACRO (hardening)
