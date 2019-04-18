
vlib work

set i_v +incdir+../v
set s_v ../v/*.v

vlog $i_v $s_v

vsim -novopt work.small_comb_logic_tb_v

add wave -divider  "rtl singals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_v/small_comb_logic_v_0/*
add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_v/*

run -all

wave zoom full

#quit
