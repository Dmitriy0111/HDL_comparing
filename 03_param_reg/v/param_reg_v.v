/*
*  File            :   param_reg_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   Verilog
*  Description     :   This is register with parameters
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module param_reg_v
#(
    parameter                   W = 8
)(
    // clock and reset
    input   wire    [0   : 0]   clk,    // clock
    input   wire    [0   : 0]   resetn, // reset
    // data
    input   wire    [W-1 : 0]   d_in,   // data input
    output  reg     [W-1 : 0]   d_out   // data output
);

    always @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= {W { 1'b0 } };
        else    
            d_out <= d_in;

endmodule // param_reg_v
