
vlib work

set i_sv +incdir+../sv
set s_sv ../sv/*.sv

vlog $i_sv $s_sv

vsim -novopt work.pipe_adder_tb_sv

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/pipe_adder_tb_sv/*
add wave -divider  "simple adders 3"
add wave -position insertpoint sim:/pipe_adder_tb_sv/pipe_adder_sv_0/simple_adder_sv_3/*
add wave -divider  "simple adders 2"
add wave -position insertpoint sim:/pipe_adder_tb_sv/pipe_adder_sv_0/simple_adder_sv_2/*
add wave -divider  "simple adders 1"
add wave -position insertpoint sim:/pipe_adder_tb_sv/pipe_adder_sv_0/simple_adder_sv_1/*
add wave -divider  "simple adders 0"
add wave -position insertpoint sim:/pipe_adder_tb_sv/pipe_adder_sv_0/simple_adder_sv_0/*

run -all

wave zoom full

#quit
