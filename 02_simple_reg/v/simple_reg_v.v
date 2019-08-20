/*
*  File            :   simple_reg_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_reg_v
(
    // clock and reset
    input   wire    [0 : 0]     clk,    // clock
    input   wire    [0 : 0]     resetn, // reset
    // data
    input   wire    [7 : 0]     d_in,   // data input
    output  reg     [7 : 0]     d_out   // data output
);

    always @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= 8'b0;
        else    
            d_out <= d_in;

endmodule // simple_reg_v
