/*
*  File            :   i2c_master_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.26
*  Language        :   SystemVerilog
*  Description     :   This i2c master testbench
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module i2c_master_tb_sv();

    parameter           T = 10,
                        repeat_n = 10,
                        rst_delay = 7;

    // clock and reset
    logic   [0 : 0]     clk;
    logic   [0 : 0]     resetn;
    // control and data
    logic   [9 : 0]     comp;
    logic   [6 : 0]     chip_addr;
    logic   [7 : 0]     reg_addr;
    logic   [7 : 0]     tx_data;
    logic   [7 : 0]     rx_data;
    logic   [0 : 0]     tr_en;
    logic   [0 : 0]     tx_rx_req;
    logic   [0 : 0]     tx_rx_req_ack;
    logic   [0 : 0]     wr_rd;
    logic   [0 : 0]     scl;
    wire    [0 : 0]     sda;

    logic   [0 : 0]     sda_test;

    assign sda = sda_test;

    i2c_master_sv
    i2c_master_sv_0 
    (
        // clock and reset
        .clk            ( clk           ),
        .resetn         ( resetn        ),
        // control and data
        .comp           ( comp          ),
        .chip_addr      ( chip_addr     ),
        .reg_addr       ( reg_addr      ),
        .tx_data        ( tx_data       ),
        .rx_data        ( rx_data       ),
        .tr_en          ( tr_en         ),
        .tx_rx_req      ( tx_rx_req     ),
        .tx_rx_req_ack  ( tx_rx_req_ack ),
        .wr_rd          ( wr_rd         ),
        .scl            ( scl           ),
        .sda            ( sda           )
    );

    initial
    begin
        clk = '1;
        forever
            #(T/2)  clk = !clk;
    end
    initial
    begin
        resetn = '0;
        repeat(rst_delay) @(posedge clk);
        resetn = '1;
    end
    initial
    begin
        sda_test = 'z;
        tx_rx_req = '0;
        tx_data = '0;
        comp = '0;
        tr_en = '0;
        chip_addr = '0;
        reg_addr = '0;
        wr_rd = '0;
        @(posedge resetn);
        repeat(repeat_n)
        begin
            #100;
            i2c_write();
        end
        $stop;
    end

    task i2c_write();
        tx_rx_req = '1;
        wr_rd = $urandom_range(0,1);
        chip_addr = $urandom_range(0,2**7-1);
        reg_addr = $urandom_range(0,2**8-1);
        tx_data = $urandom_range(0,255);
        case( $urandom_range(0,9) )
            0       : comp = 0;
            1       : comp = 1;
            2       : comp = 2;
            3       : comp = 4;
            4       : comp = 8;
            5       : comp = 16;
            6       : comp = 32;
            7       : comp = 64;
            8       : comp = 128;
            9       : comp = 255;
            default : comp = 0;
        endcase
        tr_en = '1;
        @(posedge tx_rx_req_ack);
        tx_rx_req = '0;
        @(posedge clk);
    endtask : i2c_write
    
endmodule : i2c_master_tb_sv
