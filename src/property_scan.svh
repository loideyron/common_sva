/* 
 * Description: Properties/Seqeucens to check scan isolation behaviour 
 */
`ifndef __PROPERTY_SCAN_SVH__
`define __PROPERTY_SCAN_SVH__

// signal value compared to isolation value
property p_scan_iso_value(clk, condition, iso_sig, iso_val);
    @(posedge clk) (condition) |-> (iso_sig === iso_val);
endproperty: p_scan_iso_value
// convenience macro for checker
`define SVA_CHECK_SCAN_ISO_VAL(CLK, COND, SIG, VAL) \
    CHECK_SCAN_ISO_VAL_``SIG: assert property( p_scan_iso_value(CLK, COND, SIG, VAL) )\
    else `SVA_ERROR({"CHECK_SCAN_ISO_VAL_". `"SIG`"}, $sformatf("0x%0x != 0x%0x", $sampled(SIG), VAL))

`endif // __PROPERTY_SCAN_SVH__