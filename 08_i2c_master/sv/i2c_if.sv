/*
*  File            :   i2c_if.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.27
*  Language        :   SystemVerilog
*  Description     :   This i2c interface
*  Copyright(c)    :   2019 Vlasov D.V.
*/

interface i2c_if ( input logic [0 : 0] clk , input logic [0 : 0] resetn );

    wire    [0 : 0]     sda;
    logic   [0 : 0]     scl;
    logic   [0 : 0]     sda_drv;
    logic   [0 : 0]     sda_mon;

    assign  sda = sda_drv;
    assign  sda_mon = sda;
    
endinterface : i2c_if
