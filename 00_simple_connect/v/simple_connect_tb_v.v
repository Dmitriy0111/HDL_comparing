/*
*  File            :   simple_connect_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Verilog
*  Description     :   This is testbench for simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale  1ns/1ns

module simple_connect_tb_v();

    localparam      T = 10,         // Clock period in ns
                    repeat_n = 10;  // number of repeats 

    // data
    reg     [7 : 0]     d_in;   // data input
    wire    [7 : 0]     d_out;  // data output

    simple_connect_v
    simple_connect_v_0
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

endmodule : simple_connect_tb_v
