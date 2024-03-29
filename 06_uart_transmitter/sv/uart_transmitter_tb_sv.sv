/*
*  File            :   uart_transmitter_tb_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.22
*  Language        :   SystemVerilog
*  Description     :   This uart transmitter testbench
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module uart_transmitter_tb_sv();

    parameter           T = 10,
                        repeat_n = 10,
                        rst_delay = 7;

    // clock and reset
    logic   [0  : 0]    clk;
    logic   [0  : 0]    resetn;
    // control and data
    logic   [15 : 0]    comp;
    logic   [1  : 0]    stop_sel;
    logic   [0  : 0]    tr_en;
    logic   [7  : 0]    tx_data;
    logic   [0  : 0]    tx_req;
    logic   [0  : 0]    tx_req_ack;
    logic   [0  : 0]    uart_tx;

    uart_transmitter_sv
    uart_transmitter_sv_0 
    (
        // clock and reset
        .clk            ( clk           ),
        .resetn         ( resetn        ),
        // control and data
        .comp           ( comp          ),
        .stop_sel       ( stop_sel      ),
        .tr_en          ( tr_en         ),
        .tx_data        ( tx_data       ),
        .tx_req         ( tx_req        ),
        .tx_req_ack     ( tx_req_ack    ),
        .uart_tx        ( uart_tx       )
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
        tx_req = '0;
        stop_sel = '0;
        tx_data = '0;
        comp = '0;
        tr_en = '0;
        @(posedge resetn);
        repeat(repeat_n)
        begin
            uart_write();
        end
        $stop;
    end

    task uart_write();
        tx_req = '1;
        tx_data = $urandom_range(0,255);
        stop_sel = $urandom_range(0,3);
        case( $urandom_range(0,4) )
            0       : comp = 50_000_000 / 9600;
            1       : comp = 50_000_000 / 19200;
            2       : comp = 50_000_000 / 38400;
            3       : comp = 50_000_000 / 57600;
            4       : comp = 50_000_000 / 115200;
            default : comp = 50_000_000 / 9600;
        endcase
        tr_en = '1;
        @(posedge tx_req_ack);
        tx_req = '0;
        @(posedge clk);
    endtask : uart_write
    
endmodule : uart_transmitter_tb_sv
