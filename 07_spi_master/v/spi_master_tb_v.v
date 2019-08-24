/*
*  File            :   spi_master_tb_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.23
*  Language        :   Verilog
*  Description     :   This spi master testbench
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module spi_master_tb_v();

    parameter           T = 10,
                        repeat_n = 10,
                        rst_delay = 7;

    // clock and reset
    reg     [0 : 0]     clk;
    reg     [0 : 0]     resetn;
    // control and data
    reg     [7 : 0]     comp;
    reg     [0 : 0]     cpol;
    reg     [0 : 0]     cpha;
    reg     [1 : 0]     tr_en;
    reg     [0 : 0]     msb_lsb;
    reg     [7 : 0]     tx_data;
    wire    [7 : 0]     rx_data;
    reg     [0 : 0]     tx_req;
    wire    [0 : 0]     tx_req_ack;
    wire    [0 : 0]     sck;
    wire    [0 : 0]     cs;
    wire    [0 : 0]     sdo;
    reg     [0 : 0]     sdi;

    spi_master_v
    spi_master_v_0 
    (
        // clock and reset
        .clk        ( clk           ),
        .resetn     ( resetn        ),
        // control and data
        .comp       ( comp          ),
        .cpol       ( cpol          ),
        .cpha       ( cpha          ),
        .tr_en      ( tr_en         ),
        .msb_lsb    ( msb_lsb       ),
        .tx_data    ( tx_data       ),
        .rx_data    ( rx_data       ),
        .tx_req     ( tx_req        ),
        .tx_req_ack ( tx_req_ack    ),
        .sck        ( sck           ),
        .cs         ( cs            ),
        .sdo        ( sdo           ),
        .sdi        ( sdi           )
    );

    initial
    begin
        clk = 1'b1;
        forever
            #(T/2)  clk = !clk;
    end
    initial
    begin
        resetn = 1'b0;
        repeat(rst_delay) @(posedge clk);
        resetn = 1'b1;
    end
    initial
    begin
        tx_req = 1'b0;
        cpha = 1'b0;
        cpol = 1'b0;
        tx_data = 8'b0;
        comp = 8'b0;
        tr_en = 1'b0;
        msb_lsb = 1'b0;
        @(posedge resetn);
        repeat(repeat_n)
        begin
            #100;
            spi_write();
        end
        $stop;
    end

    initial
    begin
        sdi = 1'b0;
        forever
        begin
            @(posedge sck);
            sdi = $urandom_range(0,1);
        end
    end

    task spi_write();
    begin
        tx_req = 1'b1;
        tx_data = $urandom_range(0,255);
        cpha = $urandom_range(0,1);
        cpol = $urandom_range(0,1);
        msb_lsb = $urandom_range(0,1);
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
        tr_en = 1'b1;
        @(posedge tx_req_ack);
        tx_req = 1'b0;
        @(posedge clk);
    end
    endtask // spi_write
    
endmodule // spi_master_tb_v
