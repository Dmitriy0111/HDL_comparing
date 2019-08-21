/*
*  File            :   pipe_adder_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is testbench for simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module pipe_adder_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam          T = 10,         // Clock period in ns
                        rst_delay = 7,  // reset delay
                        repeat_n = 10;  // number of repeats 

    logic   [31 : 0]    x_0_q[$];
    logic   [31 : 0]    x_1_q[$];
    logic   [31 : 0]    res_q[$];

    logic   [0  : 0]    clk;
    logic   [0  : 0]    resetn;
    
    logic   [0  : 0]    flush;
    logic   [0  : 0]    stall;
    logic   [0  : 0]    req;
    logic   [31 : 0]    x_0;
    logic   [31 : 0]    x_1;
    logic   [31 : 0]    result;
    logic   [0  : 0]    vld;

    pipe_adder_sv 
    pipe_adder_sv_0 
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
            x_0_q.push_back(x_0);
            x_1_q.push_back(x_1);
            @(posedge clk);
            $display("x_0 = %h, x_1 = %h at time %tns", x_0, x_1, $time());
        end
        req = 0;
        repeat( 7 ) @(posedge clk);
        while( res_q.size() != 0 )
        begin
            if( res_q.pop_back() == ( x_0_q.pop_back() + x_1_q.pop_back() ) )
                $display("test Pass");
            else
                $display("test Fail");
        end
        $display("Simulation end");
        $stop;
    end

    initial
    begin
        forever
        begin
            @(posedge clk);
            if( vld )
            begin
                res_q.push_back(result);
                $display("result = %h at time %tns", result, $time());
            end
        end
    end

endmodule : pipe_adder_tb_sv
