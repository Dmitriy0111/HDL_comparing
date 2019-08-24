/*
*  File            :   spi_master_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.23
*  Language        :   Verilog
*  Description     :   This spi master module
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module spi_master_v
(
    // clock and reset
    input   wire    [0 : 0]     clk,
    input   wire    [0 : 0]     resetn,
    // control and data
    input   wire    [7 : 0]     comp,
    input   wire    [0 : 0]     cpol,
    input   wire    [0 : 0]     cpha,
    input   wire    [1 : 0]     tr_en,
    input   wire    [0 : 0]     msb_lsb,
    input   wire    [7 : 0]     tx_data,
    output  wire    [7 : 0]     rx_data,
    input   wire    [0 : 0]     tx_req,
    output  reg     [0 : 0]     tx_req_ack,
    output  wire    [0 : 0]     sck,
    output  reg     [0 : 0]     cs,
    output  reg     [0 : 0]     sdo,
    input   wire    [0 : 0]     sdi
);

    localparam          IDLE_s = 3'b000,
                        TRANSMIT_s = 3'b001,
                        POST_TR_s = 3'b010,
                        WAIT_s = 3'b011;

    reg     [7 : 0]     data_int;
    reg     [0 : 0]     cpol_int;
    reg     [0 : 0]     cpha_int;
    reg     [7 : 0]     comp_int;
    reg     [0 : 0]     msb_lsb_int;
    reg     [7 : 0]     comp_c;
    reg     [3 : 0]     bit_c;
    reg     [0 : 0]     sck_int;

    wire    [0 : 0]     idle2tr;
    wire    [0 : 0]     tr2post_tr;
    wire    [0 : 0]     post_tr2wait;
    wire    [0 : 0]     wait2idle;

    reg     [2 : 0]     state;
    reg     [2 : 0]     next_state;

    assign idle2tr      = tx_req == 1'b1;
    assign tr2post_tr   = (comp_c >= comp_int) && (bit_c == 15);
    assign post_tr2wait = (comp_c >= comp_int);
    assign wait2idle    = tx_req == 1'b0;

    assign sck = sck_int ^ cpol_int;
    assign rx_data = data_int;

    always @(posedge clk, negedge resetn)
        if( !resetn )
            state <= IDLE_s;
        else
            state <= tr_en ? next_state : IDLE_s;

    always @(*)
    begin
        next_state = state;
        case( state )
            IDLE_s      : next_state = idle2tr      ? TRANSMIT_s : state;
            TRANSMIT_s  : next_state = tr2post_tr   ? POST_TR_s  : state;
            POST_TR_s   : next_state = post_tr2wait ? WAIT_s     : state;
            WAIT_s      : next_state = wait2idle    ? IDLE_s     : state;
            default     : next_state = IDLE_s;
        endcase
    end

    always @(posedge clk, negedge resetn)
    begin
        if( !resetn )
        begin
            data_int <= 8'b0;
            cpol_int <= 1'b0;
            cpha_int <= 1'b0;
            comp_int <= 8'b0;
            comp_c <= 8'b0;
            bit_c <= 4'b0;
            tx_req_ack <= 1'b0;
            sck_int <= 1'b0;
            cs <= 1'b1;
            sdo <= 1'b1;
            msb_lsb_int <= 1'b0;
        end
        else
        begin
            if( tr_en )
                case( state )
                    IDLE_s      :
                        begin
                            if( idle2tr )
                            begin
                                cpol_int <= cpol;
                                cpha_int <= cpha;
                                data_int <= tx_data;
                                comp_int <= comp;
                                msb_lsb_int <= msb_lsb;
                            end
                        end
                    TRANSMIT_s  :
                        begin
                            cs <= 1'b0;
                            comp_c <= comp_c + 1'b1;
                            if( ( ~ cpha_int ) && ( comp_c == 8'b0 ) )
                            begin
                                if( ~bit_c[0] )
                                    sdo <= msb_lsb_int ? data_int[7] : data_int[0];
                                else
                                    data_int <= msb_lsb_int ? { data_int[6 : 0] , sdi } : { sdi , data_int[7 : 1] };
                            end
                            else if( cpha_int && ( comp_c >= comp_int ) )
                            begin
                                if( ~bit_c[0] )
                                    sdo <= msb_lsb_int ? data_int[7] : data_int[0];
                                else
                                    data_int <= msb_lsb_int ? { data_int[6 : 0] , sdi } : { sdi , data_int[7 : 1] };
                            end
                            if( comp_c >= comp_int )
                            begin
                                sck_int <= ~ sck_int;
                                bit_c <= bit_c + 1'b1;
                                comp_c <= 8'b0;
                                if( tr2post_tr )
                                    bit_c <= 4'b0;
                            end
                        end
                    POST_TR_s   :
                        begin
                            comp_c <= comp_c + 1'b1;
                            if( post_tr2wait )
                            begin
                                comp_c <= 8'b0;
                            end
                        end
                    WAIT_s      :
                        begin
                            cs <= 1'b1;
                            tx_req_ack <= 1'b1;
                            if( wait2idle )
                                tx_req_ack <= 1'b0;
                        end
                    default     : ;
                endcase
            else
            begin
                data_int <= 8'b0;
                cpol_int <= 1'b0;
                cpha_int <= 1'b0;
                comp_int <= 8'b0;
                comp_c <= 8'b0;
                bit_c <= 4'b0;
                tx_req_ack <= 1'b0;
                sck_int <= 1'b0;
                cs <= 1'b1;
                sdo <= 1'b1;
                msb_lsb_int <= 1'b0;
            end
        end
    end
    
endmodule // spi_master_v
