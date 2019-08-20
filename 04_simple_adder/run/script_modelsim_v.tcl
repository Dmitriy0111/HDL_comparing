
vlib work

set i_v +incdir+../v
set s_v ../v/*.v

vlog $i_v $s_v

vsim -novopt work.simple_adder_tb_v

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/simple_adder_tb_v/*

run -all

wave zoom full

#quit
