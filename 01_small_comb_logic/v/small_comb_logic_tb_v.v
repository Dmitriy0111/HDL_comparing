/*
*  File            :   small_comb_logic_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Verilog
*  Description     :   This is testbench for simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale  1ns/1ns

module small_comb_logic_tb_v();

    localparam      T = 10,         // Clock period in ns
                    repeat_n = 10;  // number of repeats 

    // data
    reg     [7 : 0]     d_in;   // data input
    wire    [7 : 0]     d_out;  // data output
    // 
    wire    [0 : 0]     d_f;
    wire    [0 : 0]     d_inv;
    wire    [1 : 0]     d_xor;
    wire    [1 : 0]     d_sum;
    wire    [0 : 0]     d_and;
    wire    [0 : 0]     d_or;

    assign d_f      = d_out[0];
    assign d_inv    = d_out[1];
    assign d_xor    = d_out[2 +: 2];
    assign d_sum    = d_out[4 +: 2];
    assign d_and    = d_out[6];
    assign d_or     = d_out[7];

    small_comb_logic_v
    small_comb_logic_v_0
    (
        .d_in   ( d_in      ),  // data input
        .d_out  ( d_out     )   // data output
    );

    initial
    begin
        $display("Simulation start");
        d_in = '0;
        repeat( repeat_n )
        begin
            d_in = $random();
            #(T);
            $display("d_in = %h, d_out = %h at time %tns", d_in, d_out, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : small_comb_logic_tb_v
