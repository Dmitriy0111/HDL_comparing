
vlib work

set i_sv +incdir+../sv
set s_sv ../sv/*.sv

vlog $i_sv $s_sv

vsim -novopt work.uart_transmitter_tb_sv

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/uart_transmitter_tb_sv/*

run -all

wave zoom full

#quit
