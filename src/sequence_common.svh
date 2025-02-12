/* 
 * Description: Sequences to support variability on the SVA delay operator
 *               because SV LRM requires that all delay values are constant during compile
 */

`ifndef __SEQUENCE_COMMON_SVH__
`define __SEQUENCE_COMMON_SVH__

// variable '##n'
//  opA |-> opB ##100 opC --> opA |-> opB ##0 s_vdelay(regVal) ##0 opC
sequence s_vdelay(v);
    shortint unsigned _cnt;
    
    (v >= 0 , _cnt = 0)              ##1 
    (_cnt < v, _cnt = _cnt+1)[*0:$]  ##0 
    (_cnt == v)                      ;
endsequence: s_vdelay

// variable '##[n:m]'
//  opA |-> opB ##[1:5] opC --> opA |-> opB ##0 s_vdelay_range(min,max) ##0 opC
sequence s_vdelay_range(min, max);
    shortint unsigned _cnt;
    
    (max >= 0 && max >= min, _cnt = 0)   ##1
    (_cnt < min, _cnt = _cnt+1)[*0:$]    ##0
    (_cnt == min)                        ##1
    (_cnt < max, _cnt=_cnt+1)[*0:$]      ;
endsequence: s_vdelay_range

// variable '[*n]'
//  opA |-> opB ##1 opC[*100] ##1 opD --> opA |-> opB ##1 s_vrep(opC, regVal) ##1 opD
sequence s_vrep(op, v);
    shortint unsigned _cnt;
    
    (v >= 1, _cnt = 0)                      ##0
    (op && _cnt < v, _cnt = _cnt+1)[*1:$]   ##0
    (_cnt == v)                             ;
endsequence: s_vrep

// variable '[*n:m]'
//  opA |-> opB ##1 opC[*1:10] ##1 opD --> opA |-> opB ##1 s_vrep_range(opC, min, max) ##1 opD
sequence s_vrep_range(op, min, max);
    shortint unsigned _cnt;

    (max >= 1 && max >= min, _cnt = 0)      ##0
    (op && _cnt < min, _cnt = _cnt+1)[*1:$] ##0
    (_cnt == min)                           ##1
    (op && _cnt < max, _cnt = _cnt+1)[*0:$] ;
endsequence: s_vrep_range

// variable '[->n]'
//  opA |-> opB ##1 opC[->100] ##1 opD --> opA |-> opB ##1 s_vgoto(opC, regVal) ##1 opD
sequence s_vgoto(op, v);
    shortint unsigned _cnt;

    (v >= 1, _cnt = 0)                          ##0
    (_cnt < v, _cnt = op ? _cnt+1 : _cnt)[*1:$] ##0
    (_cnt == v)                               ;
endsequence: s_vgoto

// variable '[->n:m]'
//  opA |-> opB ##1 opC[->1:10] ##1 opD --> opA |-> opB ##1 s_vgoto_range(opC, min, max) ##1 opD
sequence s_vgoto_range(op, min, max);
    shortint unsigned _cnt;

    (max >= 1 && max >= min, _cnt = 0)              ##0
    (_cnt < min, _cnt = op ? _cnt+1 : _cnt)[*1:$]   ##0
    (_cnt == min)                                   ##1
    (_cnt < max, _cnt = op ? _cnt+1 : _cnt)[*0:$]   ##0
    (op)                                            ;
endsequence: s_vgoto_range

// variable '[=n]'
//  opA |-> opB ##1 opC[=100] ##1 opD --> opA |-> opB ##1 s_vnoncons(opC, regVal) ##1 opD
sequence s_vnoncons(op, v);
    shortint unsigned _cnt;

    (v >= 1, _cnt = 0)                          ##0
    (_cnt < v, _cnt = op ? _cnt+1 : _cnt)[*1:$] ##0
    (_cnt == v)                                 ##1
    (!op)[*0:$]                                 ;
endsequence: s_vnoncons

// variable '[=n:m]'
//  opA |-> opB ##1 opC[=1:10] ##1 opD --> opA |-> opB ##1 s_vnoncons_range(opC, min, max) ##1 opD
sequence s_vnoncons_range(op, min, max);
    shortint unsigned _cnt;

    (max >= 1 && max >= min, _cnt = 0)              ##0
    (_cnt < min, _cnt = op ? _cnt+1 : _cnt)[*1:$]   ##0
    (_cnt == min)                                   ##1
    (_cnt < max, _cnt = op ? _cnt+1 : _cnt)[*0:$]   ##1
    (!op)[*0:$]                                     ;
endsequence: s_vnoncons_range

`endif  // __SEQUENCE_COMMON_SVH__

