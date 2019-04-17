/*
*  File            :   top_param_reg_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   Verilog
*  Description     :   This is top level for register with parameter
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

module top_param_reg_v
(
    input   wire    [0  : 0]    clk,
    input   wire    [0  : 0]    resetn,
    input   wire    [31 : 0]    d_in,
    output  wire    [31 : 0]    d_out0,
    output  wire    [31 : 0]    d_out1
);
    // creating one REG_0
    param_reg_v
    param_reg_v_0
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [0  +: 8]   ),
        .d_out          ( d_out0[0  +: 8]   )
    );
    // creating one REG_1
    param_reg_v
    param_reg_v_1
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [8  +: 8]   ),
        .d_out          ( d_out0[8  +: 8]   )
    );
    // creating one REG_2
    param_reg_v
    param_reg_v_2
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [16 +: 8]   ),
        .d_out          ( d_out0[16 +: 8]   )
    );
    // creating one REG_3
    param_reg_v
    param_reg_v_3
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in  [24 +: 8]   ),
        .d_out          ( d_out0[24 +: 8]   )
    );
    // creating one REG_F   (FULL)
    param_reg_v
    #(
        .W              ( 32                )
    )
    param_reg_v_f
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in              ),
        .d_out          ( d_out1            )
    );

endmodule // top_param_reg_v
