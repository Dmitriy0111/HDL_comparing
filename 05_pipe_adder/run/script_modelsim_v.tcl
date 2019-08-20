
vlib work

set i_v +incdir+../v
set s_v ../v/*.v

vlog $i_v $s_v

vsim -novopt work.pipe_adder_tb_v

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/pipe_adder_tb_v/*
add wave -divider  "simple adders 3"
add wave -position insertpoint sim:/pipe_adder_tb_v/pipe_adder_v_0/simple_adder_v_3/*
add wave -divider  "simple adders 2"
add wave -position insertpoint sim:/pipe_adder_tb_v/pipe_adder_v_0/simple_adder_v_2/*
add wave -divider  "simple adders 1"
add wave -position insertpoint sim:/pipe_adder_tb_v/pipe_adder_v_0/simple_adder_v_1/*
add wave -divider  "simple adders 0"
add wave -position insertpoint sim:/pipe_adder_tb_v/pipe_adder_v_0/simple_adder_v_0/*

run -all

wave zoom full

#quit
