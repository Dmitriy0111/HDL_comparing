
vlib work

set i_sv +incdir+../sv
set s_sv ../sv/*.sv

vlog $i_sv $s_sv

vsim -novopt work.small_comb_logic_tb_sv

add wave -divider  "rtl singals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_sv/small_comb_logic_sv_0/*
add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_sv/*

run -all

wave zoom full

#quit
