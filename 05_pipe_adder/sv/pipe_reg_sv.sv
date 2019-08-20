/*
*  File            :   pipe_reg_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is pipeline register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module pipe_reg_sv
#(
    parameter                   W = 8
)(
    input   logic   [0   : 0]   clk,
    input   logic   [0   : 0]   resetn,
    input   logic   [0   : 0]   clr,
    input   logic   [0   : 0]   we,
    input   logic   [W-1 : 0]   d_in,
    output  logic   [W-1 : 0]   d_out
);

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            d_out <= '0;
        else if( we )
            d_out <= clr ? '0 : d_in;

endmodule : pipe_reg_sv
