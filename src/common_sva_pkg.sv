`ifndef __COMMON_SVA_PKG_SV__
`define __COMMON_SVA_PKG_SV__

`ifdef COMMON_SVA_SUPPORT_UVM 
    import uvm_pkg::*;
    `include "uvm_macros.svh"
`endif

`define SVA_ERROR(ID, MSG) \
    `ifdef COMMON_SVA_SUPPORT_UVM \
        `uvm_error(ID, MSG) \
    `else \
        $error($sformatf("Error: %m: %s: %s", ID, MSG))
    `endif

`include "sequence_common.svh"
`include "property_timing.svh"
`include "property_clock.svh"
`include "property_reset.svh"
`include "property_scan.svh"

`endif  // __COMMON_SVA_PKG_SV__
