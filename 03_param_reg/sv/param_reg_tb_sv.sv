/*
*  File            :   param_reg_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   SystemVerilog
*  Description     :   This is testbench for register with parameters
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module param_reg_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam      W = 8,          // bus width
                    T = 10,         // Clock period in ns
                    rst_delay = 7,  // reset delay
                    repeat_n = 10;  // number of repeats 

    // clock and reset
    bit     [0   : 0]   clk;    // clock
    bit     [0   : 0]   resetn; // reset
    // data
    logic   [W-1 : 0]   d_in;   // data input
    logic   [W-1 : 0]   d_out;  // data output

    param_reg_sv
    #(
        .W          ( W         )
    )
    param_reg_sv_0
    (
        // clock and reset
        .clk        ( clk       ),  // clock
        .resetn     ( resetn    ),  // reset
        // data
        .d_in       ( d_in      ),  // data input
        .d_out      ( d_out     )   // data output
    );

    initial
        forever #(T/2) clk = ~ clk;
    
    initial
    begin
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end

    initial
    begin
        $display("Simulation start");
        d_in = '0;
        @(posedge resetn);
        repeat( repeat_n )
        begin
            d_in = $random();
            @(posedge clk);
            $display("d_in = %h, d_out = %h at time %tns", d_in, d_out, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : param_reg_tb_sv
