/*
*  File            :   simple_adder_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   Verilog
*  Description     :   This is testbench for simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale  1ns/1ns

module simple_adder_tb_v();

    localparam          W = 8,          // bus width
                        T = 10,         // Clock period in ns
                        repeat_n = 10;  // number of repeats 

    reg     [W-1 : 0]   x_0;
    reg     [W-1 : 0]   x_1;
    wire    [W-1 : 0]   result;

    simple_adder_v
    #(
        .W          ( W         )
    )
    simple_adder_v_0
    (
        .x_0        ( x_0       ),
        .x_1        ( x_1       ),
        .result     ( result    )
    );

    initial
    begin
        $display("Simulation start");
        x_0 = 0;
        x_1 = 0;
        repeat( repeat_n )
        begin
            x_0 = $random();
            x_1 = $random();
            #(T/2);
            $display("x_0 = %h, x_1 = %h, result = %h at time %tns", x_0, x_1, result, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : simple_adder_tb_v
