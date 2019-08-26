/*
*  File            :   i2c_master_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.26
*  Language        :   SystemVerilog
*  Description     :   This i2c master module
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module i2c_master_sv
(
    // clock and reset
    input   logic   [0 : 0]     clk,
    input   logic   [0 : 0]     resetn,
    // control and data
    input   logic   [9 : 0]     comp,
    input   logic   [6 : 0]     chip_addr,
    input   logic   [7 : 0]     reg_addr,
    input   logic   [7 : 0]     tx_data,
    output  logic   [7 : 0]     rx_data,
    input   logic   [0 : 0]     tr_en,
    input   logic   [0 : 0]     tx_rx_req,
    output  logic   [0 : 0]     tx_rx_req_ack,
    input   logic   [0 : 0]     wr_rd,
    output  logic   [0 : 0]     scl,
    inout   wire    [0 : 0]     sda
);

    localparam          chip_addr_read_wr  = 3'b000,
                        reg_addr_read_wr   = 3'b001,
                        chip_addr_read_rd  = 3'b010,
                        reg_addr_read_rd   = 3'b011,
                        data_read          = 3'b100;

    localparam          chip_addr_write_wr = 3'b000,
                        reg_addr_write_wr  = 3'b001,
                        data_write         = 3'b010;

    logic   [7 : 0]     data_int;
    logic   [9 : 0]     comp_int;
    logic   [9 : 0]     comp_c;
    logic   [6 : 0]     chip_addr_int;
    logic   [7 : 0]     reg_addr_int;
    logic   [0 : 0]     scl_int;
    logic   [0 : 0]     sda_int;
    logic   [0 : 0]     wr_rd_int;
    logic   [3 : 0]     bit_c;
    logic   [0 : 0]     ack_nack;
    logic   [0 : 0]     sda_hiz;

    logic   [2 : 0]     pos_c;

    logic   [0 : 0]     idle2start;
    logic   [0 : 0]     start2read;
    logic   [0 : 0]     start2write;
    logic   [0 : 0]     read2data;
    logic   [0 : 0]     write2data;
    logic   [0 : 0]     read2start_r;
    logic   [0 : 0]     start_r2data;
    logic   [0 : 0]     data2read;
    logic   [0 : 0]     data2write;
    logic   [0 : 0]     data2stop;
    logic   [0 : 0]     stop2wait;
    logic   [0 : 0]     wait2idle;

    enum
    logic   [2 : 0]     { IDLE_s, START_s, START_R_s, READ_s, WRITE_s, DATA_s, STOP_s, WAIT_s } state, next_state;

    assign idle2start   = tx_rx_req == '1;
    assign start2read   = (comp_c >= 100) && (wr_rd_int == '0);
    assign start2write  = (comp_c >= 100) && (wr_rd_int == '1);
    assign start_r2data = (comp_c >= 100);
    assign stop2wait    = (comp_c >= 100);
    assign data2read    = (comp_c >= 100) && (bit_c == 8);
    assign data2write   = (comp_c >= 100) && (bit_c == 8);
    assign write2data   = '1;
    assign read2start_r = (pos_c == chip_addr_read_rd);
    assign wait2idle    = tx_rx_req == '0;
    assign data2stop    = (comp_c >= 100) && (bit_c == 8) && (ack_nack == '0);
    
    assign scl = scl_int;
    assign sda = sda_hiz ? 'z : sda_int;

    assign rx_data = data_int;

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            state <= IDLE_s;
        else
            state <= tr_en ? next_state : IDLE_s;

    always_comb
    begin
        next_state = state;
        case( state )
            IDLE_s      : next_state = idle2start   ? START_s   : state;
            START_s     : next_state = start2write  ? WRITE_s   :
                                       start2read   ? READ_s    : state;
            START_R_s   : next_state = start_r2data ? DATA_s    : state;

            READ_s      : next_state = read2start_r ? START_R_s : DATA_s;
            WRITE_s     : next_state = write2data   ? DATA_s    : state;
            DATA_s      : next_state = data2write   ? WRITE_s   :
                                       data2read    ? READ_s    :
                                       data2stop    ? STOP_s    : state;
            STOP_s      : next_state = stop2wait    ? WAIT_s    : state;
            WAIT_s      : next_state = wait2idle    ? IDLE_s    : state;
            default     : next_state = IDLE_s;
        endcase
    end

    always_ff @(posedge clk, negedge resetn)
    begin
        if( !resetn )
        begin
            sda_hiz <= '0;
            sda_int <= '1;
            scl_int <= '1;
            comp_int <= '0;
            comp_c <= '0;
            tx_rx_req_ack <= '0;
            data_int <= '0;
            comp_c <= '0;
            chip_addr_int <= '0;
            reg_addr_int <= '0;
            wr_rd_int <= '0;
            pos_c <= '0;
            bit_c <= '0;
            ack_nack <= '0;
        end
        else
        begin
            if( tr_en )
                case( state )
                    IDLE_s      : 
                        begin
                            if( idle2start )
                            begin
                                data_int <= tx_data;
                                wr_rd_int <= wr_rd;
                                comp_int <= comp;
                                chip_addr_int <= chip_addr;
                                reg_addr_int <= reg_addr;
                                ack_nack <= '0;
                            end
                        end
                    START_s     : 
                        begin
                            comp_c <= comp_c + 1'b1;
                            if( comp_c >= 30 )
                                sda_int <= '0;
                            if( comp_c >= 50 )
                                scl_int <= '0;
                            if( start2read || start2write )
                                comp_c <= '0;
                        end
                    START_R_s   : 
                        begin
                            sda_int <= '1;
                            scl_int <= '0;
                            if( comp_c >= 30 )
                                scl_int <= '0;
                            if( comp_c >= 60 )
                                sda_int <= '0;
                            if( start_r2data )
                                comp_c <= '0;
                        end
                    READ_s      : 
                        begin
                            sda_hiz <= '0;
                            pos_c <= pos_c + 1'b1;
                            if( pos_c == chip_addr_read_wr )
                                data_int <= { 1'b0 , chip_addr_int };
                            if( pos_c == reg_addr_read_wr )
                                data_int <= reg_addr_int;
                            if( pos_c == chip_addr_read_rd )
                                data_int <= { 1'b1 , chip_addr_int };
                            if( pos_c == reg_addr_read_rd )
                                data_int <= reg_addr_int;
                            if( pos_c == data_read )
                            begin
                                data_int <= '0;
                                sda_hiz <= '1;
                            end
                        end
                    WRITE_s     : 
                        begin
                            sda_hiz <= '0;
                            pos_c <= pos_c + 1'b1;
                            if( pos_c == chip_addr_write_wr )
                                data_int <= { 1'b0 , chip_addr_int };
                            if( pos_c == reg_addr_write_wr )
                                data_int <= reg_addr_int;
                            if( pos_c == data_write )
                                data_int <= tx_data;
                        end
                    DATA_s      : 
                        begin
                            
                            if( ( bit_c == 7 ) && ( comp_c >= 100 ) )
                                sda_hiz <= ~ sda_hiz;
                            comp_c <= comp_c + 1'b1;
                            sda_int <= data_int[7];
                            scl_int <= '0;
                            if( ( comp_c >= 20 ) && ( comp_c <= 80 ) )
                                scl_int <= '1;
                            if( comp_c >= 100 )
                            begin
                                { data_int , ack_nack } <= { data_int[6:0] , ack_nack , sda };
                                comp_c <= '0;
                                bit_c <= bit_c + 1'b1;
                            end
                            if( data2read || data2write )
                                bit_c <= '0;
                        end
                    STOP_s      : 
                        begin
                            comp_c <= comp_c + 1'b1;
                            if( comp_c >= 30 )
                                scl_int <= '1;
                            if( comp_c >= 60 )
                                sda_int <= '1;
                            if( stop2wait )
                                comp_c <= '0;
                        end
                    WAIT_s      : 
                        begin
                            tx_rx_req_ack <= '1;
                            if( wait2idle )
                                tx_rx_req_ack <= '0;
                        end
                    default     : ;
                endcase
            else
            begin
                sda_hiz <= '0;
                sda_int <= '1;
                scl_int <= '1;
                comp_int <= '0;
                comp_c <= '0;
                tx_rx_req_ack <= '0;
                data_int <= '0;
                comp_c <= '0;
                chip_addr_int <= '0;
                reg_addr_int <= '0;
                wr_rd_int <= '0;
                pos_c <= '0;
                bit_c <= '0;
                ack_nack <= '0;
            end
        end
    end
    
endmodule : i2c_master_sv
