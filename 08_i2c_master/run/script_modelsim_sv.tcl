
vlib work

vlog -sv ../sv/i2c_master_sv.sv
vlog -sv ../sv/i2c_if.sv
vlog -sv ../sv/i2c_mem_slave_pkg.sv
vlog -sv ../sv/i2c_master_tb_sv.sv

vsim -novopt work.i2c_master_tb_sv

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/i2c_master_tb_sv/*
add wave -divider  "i2c interface signals"
add wave -position insertpoint sim:/i2c_master_tb_sv/i2c_if_0/*
add wave -divider  "i2c signals"
add wave -position insertpoint sim:/i2c_master_tb_sv/i2c_master_sv_0/*

run -all

wave zoom full

#quit
