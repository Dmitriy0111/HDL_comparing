/*
*  File            :   top_simple_reg_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is top level for simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module top_simple_reg_sv
(
    input   logic   [0  : 0]    clk,
    input   logic   [0  : 0]    resetn,
    input   logic   [8  : 0]    d_in_0,
    input   logic   [31 : 0]    d_in_1,
    output  logic   [8  : 0]    d_out_0,
    output  logic   [31 : 0]    d_out_1
);
    // creating one REG_8
    simple_reg_sv
    simple_reg_sv_8
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_0            ),
        .d_out          ( d_out_0           )
    );
    // creating one REG_32_0
    simple_reg_sv
    simple_reg_sv_32_0
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [0  +: 8]  ),
        .d_out          ( d_out_1[0  +: 8]  )
    );
    // creating one REG_32_1
    simple_reg_sv
    simple_reg_sv_32_1
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [8  +: 8]  ),
        .d_out          ( d_out_1[8  +: 8]  )
    );
    // creating one REG_32_2
    simple_reg_sv
    simple_reg_sv_32_2
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [16 +: 8]  ),
        .d_out          ( d_out_1[16 +: 8]  )
    );
    // creating one REG_32_3
    simple_reg_sv
    simple_reg_sv_32_3
    (
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        .d_in           ( d_in_1 [24 +: 8]  ),
        .d_out          ( d_out_1[24 +: 8]  )
    );

endmodule : top_simple_reg_sv
