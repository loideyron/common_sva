/* 
 * Description: Property/Sequences to check clock signal behaviour 
 */
`ifndef __PROPERTY_CLOCK_SVH__
`define __PROPERTY_CLOCK_SVH__

// clock signal is gated
property p_clock_gate(ref_clk, clk, clk_en, en_delay_min, en_delay_max);
    @(posedge ref_clk) 
    ( $fell(clk_en) ##0 s_vdelay_range(en_delay_min, en_delay_max) ##0 ~clk )
        |-> ( ~clk throughout clk_en[->1] );
endproperty: p_clock_gate

// clock signal is divided based on ref_clk
property p_clock_div(ref_clk, clk, divider);
    @(posedge ref_clk) $rose(clk) |=> s_vrep((~clk), (divider-1)) ##1 $rose(clk);
endproperty: p_clock_div

`endif // __PROPERTY_CLOCK_SVH__