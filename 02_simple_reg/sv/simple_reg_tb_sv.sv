/*
*  File            :   simple_reg_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is testbench for simple register
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_reg_tb_sv();

    timeprecision   1ns;
    timeunit        1ns;

    localparam      T = 10,         // Clock period in ns
                    rst_delay = 7,  // reset delay
                    repeat_n = 10;  // number of repeats 

    bit     [0  : 0]    clk;
    bit     [0  : 0]    resetn;
    logic   [8  : 0]    d_in_0;
    logic   [31 : 0]    d_in_1;
    logic   [8  : 0]    d_out_0;
    logic   [31 : 0]    d_out_1;

    top_simple_reg_sv
    top_simple_reg_sv_0
    (
        .clk        ( clk       ),
        .resetn     ( resetn    ),
        .d_in_0     ( d_in_0    ),
        .d_in_1     ( d_in_1    ),
        .d_out_0    ( d_out_0   ),
        .d_out_1    ( d_out_1   )
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
        d_in_0 = '0;
        d_in_1 = '0;
        @(posedge resetn);
        repeat( repeat_n )
        begin
            d_in_0 = $random();
            d_in_1 = $random();
            @(posedge clk);
            $display("d_in_0 = %h, d_out_0 = %h at time %tns", d_in_0, d_out_0, $time());
            $display("d_in_1 = %h, d_out_1 = %h at time %tns", d_in_1, d_out_1, $time());
        end
        $display("Simulation end");
        $stop;
    end

endmodule : simple_reg_tb_sv
