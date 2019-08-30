/*
*  File            :   i2c_master_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.26
*  Language        :   SystemVerilog
*  Description     :   This is i2c master module
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module i2c_master_sv
(
    // clock and reset
    input   logic   [0 : 0]     clk,
    input   logic   [0 : 0]     resetn,
    // control and data
    input   logic   [9 : 0]     comp,
    input   logic   [0 : 0]     start_gen,
    input   logic   [0 : 0]     stop_gen,
    input   logic   [0 : 0]     tr_gen,
    input   logic   [0 : 0]     rec_gen,
    input   logic   [7 : 0]     tx_data,
    output  logic   [7 : 0]     rx_data,
    input   logic   [0 : 0]     tr_en,
    input   logic   [0 : 0]     ack_nack,
    output  logic   [0 : 0]     ack_nack_f,
    input   logic   [0 : 0]     tx_rx_req,
    output  logic   [0 : 0]     tx_rx_req_ack,
    output  logic   [0 : 0]     scl,
    inout   wire    [0 : 0]     sda
);

    logic   [7 : 0]     data_int;
    logic   [9 : 0]     comp_int;
    logic   [9 : 0]     comp_c;
    logic   [0 : 0]     scl_int;
    logic   [0 : 0]     sda_int;
    logic   [3 : 0]     bit_c;
    logic   [0 : 0]     ack_nack_int;
    logic   [0 : 0]     sda_hiz;

    logic   [2 : 0]     pos_c;

    logic   [0 : 0]     idle2start;
    logic   [0 : 0]     idle2data;
    logic   [0 : 0]     idle2stop;
    logic   [0 : 0]     start2wait;
    logic   [0 : 0]     start_r2wait;
    logic   [0 : 0]     data2wait;
    logic   [0 : 0]     stop2wait;
    logic   [0 : 0]     wait2idle;

    enum
    logic   [2 : 0]     { IDLE_s, START_s, READ_s, WRITE_s, DATA_s, STOP_s, WAIT_s } state, next_state;

    assign idle2start   = (tx_rx_req == '1) && (start_gen == '1);
    assign idle2stop    = (tx_rx_req == '1) && (stop_gen == '1);
    assign idle2data    = (tx_rx_req == '1) && ( (tr_gen == '1) || (rec_gen == '1) );
    assign start2wait   = (comp_c >= 100);
    assign start_r2wait = (comp_c >= 100);
    assign data2wait    = (comp_c >= 100) && (bit_c == 8);
    assign stop2wait    = (comp_c >= 100);
    assign wait2idle    = tx_rx_req == '0;
    
    assign scl = scl_int;
    assign sda = sda_hiz ? 'z : sda_int;

    assign rx_data = data_int;
    assign ack_nack_f = ack_nack_int;

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            state <= IDLE_s;
        else
            state <= tr_en ? next_state : IDLE_s;

    always_comb
    begin
        next_state = state;
        case( state )
            IDLE_s      : next_state = idle2start   ? START_s   : 
                                       idle2data    ? DATA_s    : 
                                       idle2stop    ? STOP_s    : state;
            START_s     : next_state = start2wait   ? WAIT_s    : state;
            DATA_s      : next_state = data2wait    ? WAIT_s    : state;
            STOP_s      : next_state = stop2wait    ? WAIT_s    : state;
            WAIT_s      : next_state = wait2idle    ? IDLE_s    : state;
            default     : next_state = IDLE_s;
        endcase
    end

    always_ff @(posedge clk, negedge resetn)
    begin
        if( !resetn )
        begin
            sda_hiz <= '1;
            sda_int <= '1;
            scl_int <= '1;
            comp_int <= '0;
            comp_c <= '0;
            tx_rx_req_ack <= '0;
            data_int <= '0;
            comp_c <= '0;
            pos_c <= '0;
            bit_c <= '0;
            ack_nack_int <= '0;
        end
        else
        begin
            if( tr_en )
                case( state )
                    IDLE_s      : 
                        begin
                            if( idle2data )
                            begin
                                data_int <= tx_data;
                                comp_int <= comp;
                                ack_nack_int <= ack_nack;
                                if( tr_gen )
                                    sda_hiz <= '0;
                                if( rec_gen )
                                    sda_hiz <= '1;
                            end
                            if( idle2start )
                                sda_hiz <= '0;
                        end
                    START_s     : 
                        begin
                            comp_c <= comp_c + 1'b1;
                            sda_int <= '1;
                            scl_int <= '1;
                            if( comp_c >= 30 )
                                sda_int <= '0;
                            if( comp_c >= 50 )
                                scl_int <= '0;
                            if( start2wait )
                                comp_c <= '0;
                        end
                    DATA_s      : 
                        begin
                            if( ( bit_c == 7 ) && ( comp_c >= 100 ) )
                                sda_hiz <= ~ sda_hiz;
                            comp_c <= comp_c + 1'b1;
                            if( comp_c == '0 )
                                sda_int <= data_int[7];
                            scl_int <= '0;
                            if( ( comp_c >= 20 ) && ( comp_c <= 80 ) )
                                scl_int <= '1;
                            if( comp_c == 100 >> 1)
                                { data_int , ack_nack_int } <= { data_int[6:0] , ack_nack_int , sda };
                            if( comp_c >= 100 )
                            begin
                                comp_c <= '0;
                                bit_c <= bit_c + 1'b1;
                            end
                            if( data2wait )
                            begin
                                bit_c <= '0;
                                sda_hiz <= '0;
                            end
                        end
                    STOP_s      : 
                        begin
                            comp_c <= comp_c + 1'b1;
                            if( comp_c >= 30 )
                                scl_int <= '1;
                            if( comp_c >= 60 )
                                sda_int <= '1;
                            if( stop2wait )
                            begin
                                comp_c <= '0;
                                sda_hiz <= '1;
                            end
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
                sda_hiz <= '1;
                sda_int <= '1;
                scl_int <= '1;
                comp_int <= '0;
                comp_c <= '0;
                tx_rx_req_ack <= '0;
                data_int <= '0;
                comp_c <= '0;
                pos_c <= '0;
                bit_c <= '0;
                ack_nack_int <= '0;
            end
        end
    end
    
endmodule : i2c_master_sv
