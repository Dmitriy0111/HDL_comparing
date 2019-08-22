
vlib work

set i_vhd +incdir+../vhd
set s_vhd ../vhd/

vcom -2008 ../vhd/uart_transmitter_vhd.vhd
vcom -2008 ../vhd/uart_transmitter_tb_vhd.vhd

vsim -novopt work.uart_transmitter_tb_vhd

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/uart_transmitter_tb_vhd/*

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full

#quit
