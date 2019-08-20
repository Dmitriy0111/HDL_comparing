/*
*  File            :   pipe_adder_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is pipeline adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module pipe_adder_sv
(
    input   logic   [0  : 0]    clk,
    input   logic   [0  : 0]    resetn,
    // data
    input   logic   [0  : 0]    flush,
    input   logic   [0  : 0]    stall,
    input   logic   [0  : 0]    req,
    input   logic   [31 : 0]    x_0,
    input   logic   [31 : 0]    x_1,
    output  logic   [31 : 0]    result,
    output  logic   [0  : 0]    vld
);

    logic   [3 : 0][7 : 0]  x_0_3;
    logic   [3 : 0][7 : 0]  x_1_3;

    logic   [2 : 0][7 : 0]  x_0_2;
    logic   [2 : 0][7 : 0]  x_1_2;

    logic   [1 : 0][7 : 0]  x_0_1;
    logic   [1 : 0][7 : 0]  x_1_1;

    logic   [0 : 0][7 : 0]  x_0_0;
    logic   [0 : 0][7 : 0]  x_1_0;

    logic   [0 : 0][7 : 0]  res_3;
    logic   [1 : 0][7 : 0]  res_2;
    logic   [2 : 0][7 : 0]  res_1;
    logic   [3 : 0][7 : 0]  res_0;

    logic   [3 : 0]         carry;
    logic   [3 : 0]         carry_ff;

    logic   [31 : 0]        int_res;

    logic   [3  : 0]        vld_int;

    assign vld = vld_int[3];

    assign x_0_3[0] = x_0[24 +: 8];
    assign x_1_3[0] = x_1[24 +: 8];

    assign x_0_2[0] = x_0[16 +: 8];
    assign x_1_2[0] = x_1[16 +: 8];

    assign x_0_1[0] = x_0[8  +: 8];
    assign x_1_1[0] = x_1[8  +: 8];

    assign x_0_0[0] = x_0[0  +: 8];
    assign x_1_0[0] = x_1[0  +: 8];

    assign res_3[0] = int_res[24 +: 8];
    assign res_2[0] = int_res[16 +: 8];
    assign res_1[0] = int_res[8  +: 8];
    assign res_0[0] = int_res[0  +: 8];

    assign result[24 +: 8] = res_3[0];
    assign result[16 +: 8] = res_2[1];
    assign result[8  +: 8] = res_1[2];
    assign result[0  +: 8] = res_0[3];

    assign vld_int[0] = req;

    simple_adder_sv
    #(
        .W      ( 8                 )
    )
    simple_adder_sv_0
    (
        .c_in   ( '0                ),
        .x_0    ( x_0_0[0]          ),
        .x_1    ( x_1_0[0]          ),
        .y      ( int_res[0  +: 8]  ),
        .c_out  ( carry[0]          )
    );

    simple_adder_sv
    #(
        .W      ( 8                 )
    )
    simple_adder_sv_1
    (
        .c_in   ( carry_ff[0]       ),
        .x_0    ( x_0_1[1]          ),
        .x_1    ( x_1_1[1]          ),
        .y      ( int_res[8  +: 8]  ),
        .c_out  ( carry[1]          )
    );

    simple_adder_sv
    #(
        .W      ( 8                 )
    )
    simple_adder_sv_2
    (
        .c_in   ( carry_ff[1]       ),
        .x_0    ( x_0_2[2]          ),
        .x_1    ( x_1_2[2]          ),
        .y      ( int_res[16 +: 8]  ),
        .c_out  ( carry[2]          )
    );

    simple_adder_sv
    #(
        .W      ( 8                 )
    )
    simple_adder_sv_3
    (
        .c_in   ( carry_ff[2]       ),
        .x_0    ( x_0_3[3]          ),
        .x_1    ( x_1_3[3]          ),
        .y      ( int_res[24 +: 8]  ),
        .c_out  (                   )
    );

    genvar gen_3;
    genvar gen_2;
    genvar gen_1;
    genvar gen_0;
    genvar c_gen;
    genvar vld_gen;

    generate
        for( gen_3 = 0 ; gen_3 < 3 ; gen_3++ )
        begin : gen_reg_3
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_0_reg_3
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_0_3[gen_3]      ),
                .d_out      ( x_0_3[gen_3+1]    )
            );

            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_1_reg_3
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_1_3[gen_3]      ),
                .d_out      ( x_1_3[gen_3+1]    )
            );

        end
    endgenerate

    generate
        for( gen_2 = 0 ; gen_2 < 2 ; gen_2++ )
        begin : gen_reg_2
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_0_reg_2
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_0_2[gen_2]      ),
                .d_out      ( x_0_2[gen_2+1]    )
            );

            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_1_reg_2
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_1_2[gen_2]      ),
                .d_out      ( x_1_2[gen_2+1]    )
            );
        end
    endgenerate

    generate
        for( gen_1 = 0 ; gen_1 < 1 ; gen_1++ )
        begin : gen_reg_1
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_0_reg_1
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_0_1[gen_1]      ),
                .d_out      ( x_0_1[gen_1+1]    )
            );

            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            x_1_reg_1
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( x_1_1[gen_1]      ),
                .d_out      ( x_1_1[gen_1+1]    )
            );
        end
    endgenerate

    generate
        for( gen_2 = 0 ; gen_2 < 1 ; gen_2++ )
        begin : gen_res_2
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            res_reg_2
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( res_2[gen_2]      ),
                .d_out      ( res_2[gen_2+1]    )
            );
        end
    endgenerate

    generate
        for( gen_1 = 0 ; gen_1 < 2 ; gen_1++ )
        begin : gen_res_1
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            res_reg_1
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( res_1[gen_1]      ),
                .d_out      ( res_1[gen_1+1]    )
            );
        end
    endgenerate

    generate
        for( gen_0 = 0 ; gen_0 < 3 ; gen_0++ )
        begin : gen_res_0
            pipe_reg_sv
            #(
                .W          ( 8                 )
            )
            res_reg_1
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( res_0[gen_0]      ),
                .d_out      ( res_0[gen_0+1]    )
            );
        end
    endgenerate

    generate
        for( c_gen = 0 ; c_gen < 3 ; c_gen++ )
        begin : gen_carry_ff
            pipe_reg_sv
            #(
                .W          ( 1                 )
            )
            carry_ff_reg
            (
                .clk        ( clk               ),
                .resetn     ( resetn            ),
                .clr        ( flush             ),
                .we         ( !stall            ),
                .d_in       ( carry[c_gen]      ),
                .d_out      ( carry_ff[c_gen]   )
            );
        end
    endgenerate

    generate
        for( vld_gen = 0 ; vld_gen < 3 ; vld_gen++ )
        begin : gen_vld
            pipe_reg_sv
            #(
                .W          ( 1                     )
            )
            vld_reg
            (
                .clk        ( clk                   ),
                .resetn     ( resetn                ),
                .clr        ( flush                 ),
                .we         ( !stall                ),
                .d_in       ( vld_int[vld_gen]      ),
                .d_out      ( vld_int[vld_gen+1]    )
            );
        end
    endgenerate
    
endmodule : pipe_adder_sv
