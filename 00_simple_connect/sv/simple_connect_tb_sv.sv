/*
*  File            :   simple_connect_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   SystemVerilog
*  Description     :   This is testbench for simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_connect_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam      T = 10,         // Clock period in ns
                    repeat_n = 10;  // number of repeats 

    // data
    logic   [7 : 0]     d_in;   // data input
    logic   [7 : 0]     d_out;  // data output

    simple_connect_sv
    simple_connect_sv_0
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

endmodule : simple_connect_tb_sv
