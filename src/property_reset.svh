/* 
 * Description: Properties/Sequences to check signal reset behaviour 
 */
`ifndef __PROPERTY_RESET_SVH__
`define __PROPERTY_RESET_SVH__

// sequence to ensure checking of reset value at correct time slot
sequence s_resetn(rstn_sig);
    @(negedge rstn_sig) 1;
endsequence: s_resetn

// signal value during async reset (immediate assertion implementation)
`define SVA_CHECK_ASYNC_RESET_VALUE(RSTN, SIG, VAL) \
    always @( s_resetn(RSTN) ) begin \
        CHECK_ASYNC_RESET_VALUE_``SIG: assert(SIG === (VAL)) \
        else `SVA_ERROR({"CHECK_ASYNC_RESET_VALUE_", `"SIG`"}, $sformatf("0x%0x != 0x%0x", SIG, VAL)) \
    end

// signal value during sync reset 
`define SVA_CHECK_SYNC_RESET_VALUE(CLK, RSTN, SIG, VAL) \
    CHECK_SYNC_RESET_VALUE_``SIG: assert property( @(posedge CLK) (RSTN === 0) |-> (SIG === VAL) ) \
    else `SVA_ERROR({"CHECK_SYNC_RESET_VALUE_", `"SIG`"}, $sformatf("0x%0x != 0x%0x", $sampled(SIG), VAL))

// signal value does not toggle during reset
property p_reset_notoggle(rstn_sig, sig, val = 0);
    @(sig) $fell(sig === val) |-> (rstn_sig === 1);
endproperty: p_reset_notoggle
// convenience macro for checker
`define SVA_CHECK_RESET_NOTOGGLE(RSTN, SIG, VAL = 0) \
    CHECK_RESET_NOTOGGLE_``SIG: assert property ( p_reset_notoggle(RSTN, SIG, VAL) ) \
    else `SVA_ERROR({"CHECK_RESET_NOTOGGLE_", `"SIG`"}, $sformatf("value toggled: %0x => 0x%0x", VAL, $sampled(SIG)))

// signal value is not unknown after reset
property p_reset_defined(rstn_sig, sig);
    @(posedge rstn_sig) !$isunknown(sig);
endproperty: p_reset_defined
// convenience macro for checker
`define SVA_CHECK_RESET_DEFINED(RSTN, SIG) \
    CHECK_RESET_DEFINED_``SIG: assert property( p_reset_defined(RSTN, SIG) ) \
    else `SVA_ERROR({"CHECK_RESET_DEFINED_", `"SIG`"}, $sformatf("value unknown: %0v", $sampled(SIG)))

`endif // __PROPERTY_RESET_SVH__