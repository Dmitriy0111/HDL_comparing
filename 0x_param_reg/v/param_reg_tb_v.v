/*
*  File            :   param_reg_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.17
*  Language        :   Verilog
*  Description     :   This is testbench for register with parameters
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale  1ns/1ns

module param_reg_tb_v();

    localparam      W = 8,          // bus width
                    T = 10,         // Clock period in ns
                    rst_delay = 7,  // reset delay
                    repeat_n = 10;  // number of repeats 

    // clock and reset
    reg     [0   : 0]   clk;    // clock
    reg     [0   : 0]   resetn; // reset
    // data
    reg     [W-1 : 0]   d_in;   // data input
    wire    [W-1 : 0]   d_out;  // data output

    param_reg_v
    #(
        .W          ( W         )
    )
    param_reg_v_0
    (
        // clock and reset
        .clk        ( clk       ),  // clock
        .resetn     ( resetn    ),  // reset
        // data
        .d_in       ( d_in      ),  // data input
        .d_out      ( d_out     )   // data output
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

endmodule : param_reg_tb_v
