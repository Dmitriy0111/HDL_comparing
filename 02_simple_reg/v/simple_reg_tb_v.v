/*
*  File            :   simple_reg_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is testbench for simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale  1ns/1ns

module simple_reg_tb_v();

    localparam      T = 10,         // Clock period in ns
                    rst_delay = 7,  // reset delay
                    repeat_n = 10;  // number of repeats 

    reg     [0  : 0]    clk;
    reg     [0  : 0]    resetn;
    reg     [8  : 0]    d_in_0;
    reg     [31 : 0]    d_in_1;
    wire    [8  : 0]    d_out_0;
    wire    [31 : 0]    d_out_1;


    top_simple_reg_v
    top_simple_reg_v_0
    (
        .clk        ( clk       ),
        .resetn     ( resetn    ),
        .d_in_0     ( d_in_0    ),
        .d_in_1     ( d_in_1    ),
        .d_out_0    ( d_out_0   ),
        .d_out_1    ( d_out_1   )
    );

    initial
    begin
        clk = 1'b0;
        forever #(T/2) clk = ~ clk;
    end
    
    initial
    begin
        resetn = 1'b0;
        repeat(rst_delay) @(posedge clk);
        resetn = 1'b1;
    end

    initial
    begin
        $display("Simulation start");
        d_in_0 = 8'b0;
        d_in_1 = 32'b0;
        @(posedge resetn);
        repeat( repeat_n )
        begin
            d_in_0 = $random();
            d_in_1 = $random();
            @(posedge clk);
            $display("d_in_0 = %h, d_out_0 = %h at time %tns", d_in_0, d_out_0, $time());
            $display("d_in_1 = %h, d_out_1 = %h at time %tns", d_in_1, d_out_1, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : simple_reg_tb_v
