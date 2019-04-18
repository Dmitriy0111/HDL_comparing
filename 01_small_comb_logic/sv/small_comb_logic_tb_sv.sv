/*
*  File            :   small_comb_logic_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   SystemVerilog
*  Description     :   This is testbench for simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module small_comb_logic_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam      T = 10,         // Clock period in ns
                    repeat_n = 10;  // number of repeats 

    // data
    logic   [7 : 0]     d_in;   // data input
    logic   [7 : 0]     d_out;  // data output
    // 
    logic   [0 : 0]     d_f;
    logic   [0 : 0]     d_inv;
    logic   [1 : 0]     d_xor;
    logic   [1 : 0]     d_sum;
    logic   [0 : 0]     d_and;
    logic   [0 : 0]     d_or;

    assign d_f      = d_out[0];
    assign d_inv    = d_out[1];
    assign d_xor    = d_out[2 +: 2];
    assign d_sum    = d_out[4 +: 2];
    assign d_and    = d_out[6];
    assign d_or     = d_out[7];

    small_comb_logic_sv
    small_comb_logic_sv_0
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
            #( T );
            $display("d_in = %h, d_out = %h at time %tns", d_in, d_out, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : small_comb_logic_tb_sv
