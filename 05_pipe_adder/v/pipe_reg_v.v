/*
*  File            :   pipe_reg_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is pipeline register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module pipe_reg_v
#(
    parameter                   W = 8
)(
    input   wire    [0   : 0]   clk,
    input   wire    [0   : 0]   resetn,
    input   wire    [0   : 0]   clr,
    input   wire    [0   : 0]   we,
    input   wire    [W-1 : 0]   d_in,
    output  reg     [W-1 : 0]   d_out
);

    always @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= '0;
        else if( we )
            d_out <= clr ? '0 : d_in;

endmodule // pipe_reg_v
