/*
*  File            :   simple_reg_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_reg_sv
(
    // clock and reset
    input   logic   [0 : 0]     clk,    // clock
    input   logic   [0 : 0]     resetn, // reset
    // data
    input   logic   [7 : 0]     d_in,   // data input
    output  logic   [7 : 0]     d_out   // data output
);

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= '0;
        else    
            d_out <= d_in;

endmodule : simple_reg_sv
