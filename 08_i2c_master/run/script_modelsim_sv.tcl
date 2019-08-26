
vlib work

set i_sv +incdir+../sv
set s_sv ../sv/*.sv

vlog $i_sv $s_sv

vsim -novopt work.i2c_master_tb_sv

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/i2c_master_tb_sv/*
add wave -divider  "i2c signals"
add wave -position insertpoint sim:/i2c_master_tb_sv/i2c_master_sv_0/*

run -all

wave zoom full

#quit
