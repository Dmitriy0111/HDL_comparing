
vlib work

set i_vhd +incdir+../vhd
set s_vhd ../vhd/

vcom -2008 ../vhd/small_comb_logic_vhd.vhd
vcom -2008 ../vhd/small_comb_logic_tb_vhd.vhd

vsim -novopt work.small_comb_logic_tb_vhd

add wave -divider  "rtl singals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_vhd/small_comb_logic_0/*
add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/small_comb_logic_tb_vhd/*

run -all

wave zoom full

#quit
