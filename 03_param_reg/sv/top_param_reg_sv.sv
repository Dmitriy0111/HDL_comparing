/*
*  File            :   top_param_reg_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   SystemVerilog
*  Description     :   This is top level for register with parameter
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module top_param_reg_sv
(
    input   logic   [0  : 0]    clk,
    input   logic   [0  : 0]    resetn,
    input   logic   [31 : 0]    d_in,
    output  logic   [31 : 0]    d_out0,
    output  logic   [31 : 0]    d_out1
);
    // creating one REG_0
    param_reg_sv
    param_reg_sv_0
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [0  +: 8]   ),
        .d_out          ( d_out0[0  +: 8]   )
    );
    // creating one REG_1
    param_reg_sv
    param_reg_sv_1
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [8  +: 8]   ),
        .d_out          ( d_out0[8  +: 8]   )
    );
    // creating one REG_2
    param_reg_sv
    param_reg_sv_2
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [16 +: 8]   ),
        .d_out          ( d_out0[16 +: 8]   )
    );
    // creating one REG_3
    param_reg_sv
    param_reg_sv_3
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [24 +: 8]   ),
        .d_out          ( d_out0[24 +: 8]   )
    );
    // creating one REG_F   (FULL)
    param_reg_sv
    #(
        .W              ( 32                )
    )
    param_reg_sv_f
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in              ),
        .d_out          ( d_out1            )
    );

endmodule : top_param_reg_sv
