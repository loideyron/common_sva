/* 
 * Description: Properties to check signal timing behaviours 
 */
 `ifndef __PROPERTY_TIMING_SVH__
 `define __PROPERTY_TIMING_SVH__

// signal is asserted for 'n' cycles
property p_timing_ast_width(sig, width);
    $rose(sig) |-> ##0 s_vdelay(width) ##0 $fell(sig);
endproperty: p_timing_ast_width
// convenience macro for checker
`define SVA_CHECK_TIMING_AST_WIDTH(CLK, SIG, WIDTH) \
    CHECK_TIMING_AST_WIDTH_``SIG: assert property( @(posedge CLK) p_timing_ast_width(SIG, WIDTH) )\
    else `SVA_ERROR({"CHECK_TIMING_AST_WIDTH_", `"SIG`"}, $sformatf("width != %d", WIDTH))

// signal is negated for 'n' cycles
property p_timing_neg_width(sig, width);
    $fell(sig) |-> ##0 s_vdelay(width) ##0 $rose(sig);
endproperty: p_timing_neg_width
// convenience macro for checker
`define SVA_CHECK_TIMING_NEG_WIDTH(CLK, SIG, WIDTH) \
    CHECK_TIMING_NEG_WIDTH_``SIG: assert property( @(posedge CLK) p_timing_neg_width(SIG, WIDTH) )\
    else `SVA_ERROR({"CHECK_TIMING_NEG_WIDTH_", `"SIG`"}, $sformatf("width != %d", WIDTH))

// signal is asserted for 'n' time (based on timescale)
property p_timing_ast_time(sig, int exp_time, int timeout = 1000);
    realtime _rtime, _ftime;

    ( $rose(sig), _rtime = $realtime() ) |=> 
        first_match( ##[0:timeout] ($fell(sig), _ftime = $realtime()) ) ##0 
        ( (_ftime - _rtime) >= exp_time )                               ;
endproperty: p_timing_ast_time
// convenience macro for checker
`define SVA_CHECK_TIMING_AST_TIME(SIG, TIME, TOUT = 1000) \
    CHECK_TIMING_AST_TIME_``SIG: assert property( p_timing_ast_time(SIG, TIME, TOUT) )\
    else `SVA_ERROR({"CHECK_TIMING_AST_TIME_", `"SIG`"}, $sformatf("time != %d, timeout = %0d", TIME, TOUT))

// signal is negated for 'n' time (based on timescale)
property p_timing_neg_time(sig, int exp_time, int timeout = 1000);
    realtime _rtime, _ftime;
  
    ( $fell(sig), _ftime = $realtime() ) |=> 
        first_match( ##[0:timeout] ($rose(sig), _rtime = $realtime()) ) ##0 
        ( (_rtime - _ftime) >= exp_time )                               ;
endproperty: p_timing_neg_time
// convenience macro for checker
`define SVA_CHECK_TIMING_NEG_TIME(SIG, TIME, TOUT = 1000) \
    CHECK_TIMING_NEG_TIME_``SIG: assert property( p_timing_neg_time(SIG, TIME, TOUT) )\
    else `SVA_ERROR({"CHECK_TIMING_NEG_TIME_", `"SIG`"}, $sformatf("time != %d, timeout = %0d", TIME, TOUT))

`endif // __PROPERTY_TIMING_SVH__