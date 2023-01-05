#Daniel Browne
#EECE 573 Final Project
#vivado -mode tcl -source run.tcl
source report_area.tcl

read_verilog arbiter2.v
set tm [find_top]

#List of state encodings
set en(0) "off"
set en(1) "one_hot"
set en(2) "sequential"
set en(3) "johnson"
set en(4) "gray"
set en(5) "auto"

for { set index 0 }  { $index < [array size en] }  { incr index } {
   synth_design -top $tm -part xc7a35tcpg236-1 -fsm_extraction $en($index)
   place_design
   route_design
   report_area $index
}