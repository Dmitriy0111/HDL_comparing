/*
*  File            :   i2c_master_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.26
*  Language        :   SystemVerilog
*  Description     :   This is i2c master testbench
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module i2c_master_tb_sv();

    import i2c_mem_slave_pkg::*;

    parameter           T = 10,
                        repeat_n = 10,
                        rst_delay = 7;

    // clock and reset
    logic   [0 : 0]     clk;
    logic   [0 : 0]     resetn;
    // control and data
    logic   [9 : 0]     comp;
    logic   [0 : 0]     start_gen;
    logic   [0 : 0]     stop_gen;
    logic   [0 : 0]     tr_gen;
    logic   [0 : 0]     rec_gen;
    logic   [7 : 0]     tx_data;
    logic   [7 : 0]     rx_data;
    logic   [0 : 0]     tr_en;
    logic   [0 : 0]     ack_nack;
    logic   [0 : 0]     ack_nack_f;
    logic   [0 : 0]     tx_rx_req;
    logic   [0 : 0]     tx_rx_req_ack;

    i2c_if
    i2c_if_0
    (
        .clk            ( clk               ),
        .resetn         ( resetn            )
    );
    
    i2c_mem_slave   
    #(
        .chip_addr      ( 48                ),
        .depth          ( 256               )
    )   
    i2c_slave_0;
    
    i2c_master_sv
    i2c_master_sv_0 
    (
        // clock and reset
        .clk            ( clk               ),
        .resetn         ( resetn            ),
        // control and data
        .comp           ( comp              ),
        .start_gen      ( start_gen         ),
        .stop_gen       ( stop_gen          ),
        .tr_gen         ( tr_gen            ),
        .rec_gen        ( rec_gen           ),
        .tx_data        ( tx_data           ),
        .rx_data        ( rx_data           ),
        .tr_en          ( tr_en             ),
        .ack_nack       ( ack_nack          ),
        .ack_nack_f     ( ack_nack_f        ),
        .tx_rx_req      ( tx_rx_req         ),
        .tx_rx_req_ack  ( tx_rx_req_ack     ),
        .scl            ( i2c_if_0.scl      ),
        .sda            ( i2c_if_0.sda      )
    );

    pullup 
    sda_pull            ( i2c_if_0.sda      );

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
        ack_nack = '0;
        tx_rx_req = '0;
        tx_data = '0;
        start_gen = '0;
        stop_gen = '0;
        rec_gen = '0;
        tr_gen = '0;
        comp = '0;
        tr_en = '0;
        @(posedge resetn);
        repeat(repeat_n)
        begin
            #10000;
            i2c_write_test();
        end
        $stop;
    end

    initial
    begin
        i2c_slave_0 = new(i2c_if_0);
        i2c_slave_0.run();
    end

    task i2c_start();
        tx_rx_req = '1;
        start_gen = '1;
        tr_gen = '0;
        rec_gen = '0;
        stop_gen = '0;
        comp = 128;
        tr_en = '1;
        @(posedge tx_rx_req_ack);
        tx_rx_req = '0;
        start_gen = '0;
        tr_gen = '0;
        rec_gen = '0;
        stop_gen = '0;
        @(posedge clk);
    endtask : i2c_start

    task i2c_stop();
        tx_rx_req = '1;
        start_gen = '0;
        tr_gen = '0;
        rec_gen = '0;
        stop_gen = '1;
        comp = 128;
        tr_en = '1;
        @(posedge tx_rx_req_ack);
        tx_rx_req = '0;
        start_gen = '0;
        tr_gen = '0;
        rec_gen = '0;
        stop_gen = '0;
        @(posedge clk);
    endtask : i2c_stop

    task i2c_write_data(logic [7 : 0] tr_data);
        tx_rx_req = '1;
        stop_gen = '0;
        start_gen = '0;
        tr_gen = '1;
        rec_gen = '0;
        tx_data = tr_data;
        comp = 128;
        tr_en = '1;
        @(posedge tx_rx_req_ack);
        tx_rx_req = '0;
        tr_gen = '0;
        stop_gen = '0;
        start_gen = '0;
        rec_gen = '0;
        @(posedge clk);
    endtask : i2c_write_data

    task i2c_write_test();
        i2c_start();
        i2c_write_data( 48 );
        if( ~ack_nack_f )
            i2c_write_data( $urandom_range(0,255) );
        if( ~ack_nack_f )
            i2c_write_data( $urandom_range(0,255) );
        i2c_stop();
    endtask : i2c_write_test
    
endmodule : i2c_master_tb_sv
