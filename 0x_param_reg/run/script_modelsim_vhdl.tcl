
vlib work

set i_vhd +incdir+../vhd
set s_vhd ../vhd/

vcom -2008 ../vhd/param_reg_vhd.vhd
vcom -2008 ../vhd/param_reg_tb_vhd.vhd

vsim -novopt work.param_reg_tb_vhd

add wave -divider  "rtl singals"
add wave -radix hexadecimal -position insertpoint sim:/param_reg_tb_vhd/REG_DUT/*
add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/param_reg_tb_vhd/*

run -all

wave zoom full

#quit
