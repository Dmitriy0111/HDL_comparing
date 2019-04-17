/*
*  File            :   param_reg_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   SystemVerilog
*  Description     :   This is register with parameters
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module param_reg_sv
#(
    parameter                   W = 8
)(
    // clock and reset
    input   logic   [0   : 0]   clk,    // clock
    input   logic   [0   : 0]   resetn, // reset
    // data
    input   logic   [W-1 : 0]   d_in,   // data input
    output  logic   [W-1 : 0]   d_out   // data output
);

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= '0;
        else    
            d_out <= d_in;

endmodule : param_reg_sv
