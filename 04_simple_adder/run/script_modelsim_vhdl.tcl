
vlib work

set i_vhd +incdir+../vhd
set s_vhd ../vhd/

vcom -2008 ../vhd/simple_adder_vhd.vhd
vcom -2008 ../vhd/simple_adder_tb_vhd.vhd

vsim -novopt work.simple_adder_tb_vhd

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/simple_adder_tb_vhd/*

run -all

wave zoom full

#quit
