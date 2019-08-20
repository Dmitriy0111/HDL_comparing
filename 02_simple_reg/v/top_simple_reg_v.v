/*
*  File            :   top_simple_reg_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is top level for simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module top_simple_reg_v
(
    input   wire    [0  : 0]    clk,
    input   wire    [0  : 0]    resetn,
    input   wire    [8  : 0]    d_in_0,
    input   wire    [31 : 0]    d_in_1,
    output  wire    [8  : 0]    d_out_0,
    output  wire    [31 : 0]    d_out_1
);
    // creating one REG_8
    simple_reg_v
    simple_reg_v_8
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_0            ),
        .d_out          ( d_out_0           )
    );
    // creating one REG_32_0
    simple_reg_v
    simple_reg_v_32_0
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [0  +: 8]  ),
        .d_out          ( d_out_1[0  +: 8]  )
    );
    // creating one REG_32_1
    simple_reg_v
    simple_reg_v_32_1
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [8  +: 8]  ),
        .d_out          ( d_out_1[8  +: 8]  )
    );
    // creating one REG_32_2
    simple_reg_v
    simple_reg_v_32_2
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [16 +: 8]  ),
        .d_out          ( d_out_1[16 +: 8]  )
    );
    // creating one REG_32_3
    simple_reg_v
    simple_reg_v_32_3
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [24 +: 8]  ),
        .d_out          ( d_out_1[24 +: 8]  )
    );

endmodule // top_simple_reg_v
