
vlib work

set i_vhd +incdir+../vhd
set s_vhd ../vhd/

vcom -2008 ../vhd/spi_master_vhd.vhd
vcom -2008 ../vhd/spi_master_tb_vhd.vhd

vsim -novopt work.spi_master_tb_vhd

add wave -divider  "testbench signals"
add wave -radix hexadecimal -position insertpoint sim:/spi_master_tb_vhd/*
add wave -divider  "spi master signals"
add wave -position insertpoint sim:/spi_master_tb_vhd/DUT/*

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full

#quit
