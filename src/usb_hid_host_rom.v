// usb_hid_host_rom.v — the microcode ROM for vendor/usb_hid_host.v.
//
// ⚠️ THIS IS KOTI'S, NOT VENDORED, and it is the ONE piece of that core not
// taken verbatim. Upstream's wrapper reads the microcode with
//
//     initial $readmemh("usb_hid_host_rom.hex", mem);
//
// which is a RELATIVE path. koti runs its simulators from `test/` and yosys
// from the repo root, so no single relative path is right for both — and the
// failure mode is silent, because a $readmemh that cannot open its file is a
// warning. The ROM would fill with x, the core's microcode would never run, and
// the bench symptom would be a keyboard that never enumerates, with a green
// build and nothing to read.
//
// The contents are still the vendored ones, byte for byte: tools/mkusbrom.py
// turns vendor/usb_hid_host_rom.hex into src/usb_hid_rom.svh, and both builders
// already pass `-I src`. Exactly the pattern font_rom.svh uses, for exactly the
// same reason.
//
// The port list matches upstream's, because vendor/usb_hid_host.v instantiates
// this by name (`usb_hid_host_rom ukprom(...)`) and must not be edited.
//
// Copyright (c) 2026 Joonatan Alanampa
// SPDX-License-Identifier: Apache-2.0
module usb_hid_host_rom(clk, adr, data);
    input clk;
    input [13:0] adr;
    output [3:0] data;
    reg [3:0] data;
    reg [3:0] mem [0:535];

`include "usb_hid_rom.svh"

    always @(posedge clk) data <= mem[adr];
endmodule
