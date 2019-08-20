/*
*  File            :   pipe_adder_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is testbench for simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

`timescale 1ns/1ns

module pipe_adder_tb_v();

    localparam          W = 8,          // bus width
                        T = 10,         // Clock period in ns
                        rst_delay = 7,  // reset delay
                        repeat_n = 10;  // number of repeats 

    reg     [0  : 0]    clk;
    reg     [0  : 0]    resetn;
    
    reg     [0  : 0]    flush;
    reg     [0  : 0]    stall;
    reg     [0  : 0]    req;
    reg     [31 : 0]    x_0;
    reg     [31 : 0]    x_1;
    wire    [31 : 0]    result;
    wire    [0  : 0]    vld;

    pipe_adder_v 
    pipe_adder_v_0 
    (
        .clk        ( clk       ),
        .resetn     ( resetn    ),
        // data
        .flush      ( flush     ),
        .stall      ( stall     ),
        .req        ( req       ),
        .x_0        ( x_0       ),
        .x_1        ( x_1       ),
        .result     ( result    ),
        .vld        ( vld       )
    );

    initial
    begin
        clk = '0;
        forever
            #(T/2) clk = ! clk;
    end

    initial
    begin
        resetn = '0;
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end
    initial
    begin
        $display("Simulation start");
        x_0 = '0;
        x_1 = '0;
        stall = '0;
        flush = '0;
        req = '0;
        @(posedge resetn);
        repeat( repeat_n )
        begin
            req = '1;
            x_0 = $random();
            x_1 = $random();
            @(posedge clk);
            $display("x_0 = %h, x_1 = %h at time %tns", x_0, x_1, $time());
        end
        req = 0;
        $display("Simulation end");
        $stop;
    end

    initial
    begin
        forever
        begin
            @(posedge clk);
            if( vld )
                $display("result = %h at time %tns", result, $time());
        end
    end

endmodule : pipe_adder_tb_v
