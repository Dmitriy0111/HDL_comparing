/*
*  File            :   uart_transmitter_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.22
*  Language        :   SystemVerilog
*  Description     :   This uart transmitter module
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module uart_transmitter_sv
(
    // clock and reset
    input   logic   [0  : 0]    clk,
    input   logic   [0  : 0]    resetn,
    // control and data
    input   logic   [15 : 0]    comp,
    input   logic   [1  : 0]    stop_sel,
    input   logic   [0  : 0]    tr_en,
    input   logic   [7  : 0]    tx_data,
    input   logic   [0  : 0]    tx_req,
    output  logic   [0  : 0]    tx_req_ack,
    output  logic   [0  : 0]    uart_tx
);

    logic   [7  : 0]    tx_data_int;
    logic   [1  : 0]    stop_sel_int;
    logic   [15 : 0]    comp_int;
    logic   [15 : 0]    comp_c;
    logic   [3  : 0]    bit_c;

    logic   [0  : 0]    idle2start;
    logic   [0  : 0]    start2tr;
    logic   [0  : 0]    tr2stop;
    logic   [0  : 0]    stop2wait;
    logic   [0  : 0]    wait2idle;

    enum
    logic   [2  : 0]    { IDLE_s, START_s, TRANMIT_s, STOP_s, WAIT_s } state, next_state;

    assign idle2start   = tx_req == '1;
    assign start2tr     = comp_c >= comp_int;
    assign tr2stop      = (comp_c >= comp_int) && (bit_c == 7);
    assign stop2wait    = (comp_c >= ( comp_int >> 1 ) ) && (bit_c == stop_sel_int);
    assign wait2idle    = tx_req == '0;

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            state <= IDLE_s;
        else
            state <= tr_en ? next_state : IDLE_s;

    always_comb
    begin
        next_state = state;
        case( state )
            IDLE_s      : next_state = idle2start ? START_s   : state;
            START_s     : next_state = start2tr   ? TRANMIT_s : state;
            TRANMIT_s   : next_state = tr2stop    ? STOP_s    : state;
            STOP_s      : next_state = stop2wait  ? WAIT_s    : state;
            WAIT_s      : next_state = wait2idle  ? IDLE_s    : state;
            default     : next_state = IDLE_s;
        endcase
    end

    always_ff @(posedge clk, negedge resetn)
    begin
        if( !resetn )
        begin
            tx_data_int <= '0;
            stop_sel_int <= '0;
            comp_c <= '0;
            bit_c <= '0;
            tx_req_ack <= '0;
            uart_tx <= '1;
            comp_int <= '0;
        end
        else
        begin
            if( tr_en )
                case( state )
                    IDLE_s      :
                        begin
                            if( idle2start )
                            begin
                                stop_sel_int <= stop_sel;
                                tx_data_int <= tx_data;
                                comp_int <= comp;
                            end
                        end
                    START_s     :
                        begin
                            uart_tx <= '0;
                            comp_c <= comp_c + 1'b1;
                            if( start2tr )
                            begin
                                comp_c <= '0;
                            end
                        end
                    TRANMIT_s   :
                        begin
                            uart_tx <= tx_data_int[0];
                            comp_c <= comp_c + 1'b1;
                            if( comp_c >= comp_int )
                            begin
                                bit_c <= bit_c + 1'b1;
                                comp_c <= '0;
                                tx_data_int <= { 1'b0 , tx_data_int[7 : 1] };
                                if( tr2stop )
                                    bit_c <= '0;
                            end
                        end
                    STOP_s      :
                        begin
                            uart_tx <= '1;
                            comp_c <= comp_c + 1'b1;
                            if( comp_c >= ( comp_int >> 1 ) )
                            begin
                                bit_c <= bit_c + 1'b1;
                                comp_c <= '0;
                                if( stop2wait )
                                    bit_c <= '0;
                            end
                        end
                    WAIT_s      :
                        begin
                            tx_req_ack <= '1;
                            if( wait2idle )
                                tx_req_ack <= '0;
                        end
                    default     : ;
                endcase
            else
            begin
                tx_data_int <= '0;
                stop_sel_int <= '0;
                comp_c <= '0;
                bit_c <= '0;
                tx_req_ack <= '0;
                uart_tx <= '1;
                comp_int <= '0;
            end
        end
    end
    
endmodule : uart_transmitter_sv
