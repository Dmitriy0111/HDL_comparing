/*
*  File            :   simple_adder_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is testbench for simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_adder_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam          W = 8,          // bus width
                        T = 10,         // Clock period in ns
                        repeat_n = 10;  // number of repeats 

    logic   [W-1 : 0]   x_0;
    logic   [W-1 : 0]   x_1;
    logic   [W-1 : 0]   result;

    simple_adder_sv
    #(
        .W          ( W         )
    )
    simple_adder_sv_0
    (
        .x_0        ( x_0       ),
        .x_1        ( x_1       ),
        .result     ( result    )
    );

    initial
    begin
        $display("Simulation start");
        x_0 = '0;
        x_1 = '0;
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

endmodule : simple_adder_tb_sv
