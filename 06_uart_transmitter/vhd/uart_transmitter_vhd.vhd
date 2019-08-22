--
-- File            :   uart_transmitter_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.22
-- Language        :   VHDL
-- Description     :   This uart transmitter module
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity uart_transmitter_vhd is
    port
    (
        -- reset and clock
        clk         : in    std_logic;
        resetn      : in    std_logic;
        -- control and data
        comp        : in    std_logic_vector(15 downto 0);
        stop_sel    : in    std_logic_vector(1  downto 0);
        tr_en       : in    std_logic_vector(0  downto 0);
        tx_data     : in    std_logic_vector(7  downto 0);
        tx_req      : in    std_logic_vector(0  downto 0);
        tx_req_ack  : out   std_logic_vector(0  downto 0);
        uart_tx     : out   std_logic_vector(0  downto 0)
    );
end uart_transmitter_vhd;

architecture rtl of uart_transmitter_vhd is
    signal tx_data_int  : std_logic_vector(7  downto 0);
    signal stop_sel_int : std_logic_vector(1  downto 0);
    signal comp_int     : std_logic_vector(15 downto 0);
    signal comp_c       : std_logic_vector(15 downto 0);
    signal bit_c        : std_logic_vector(3  downto 0);

    signal idle2start   : std_logic;                        -- idle to start
    signal start2tr     : std_logic;                        -- start to transmit
    signal tr2stop      : std_logic;                        -- transmit to stop
    signal stop2wait    : std_logic;                        -- stop to wait
    signal wait2idle    : std_logic;                        -- wait to idle
    
    -- fsm settings
    type   fsm_state is (IDLE_s , START_s , TRANSMIT_s , STOP_s , WAIT_s);
	attribute enum_encoding : string;
    attribute enum_encoding of fsm_state : type is "one-hot";
    signal state        : fsm_state;                        -- current state of fsm
    signal next_state   : fsm_state;                        -- next state for fsm
    function sel_st(logic_cond : std_logic; st_1 : fsm_state; st_0 : fsm_state) return fsm_state is
    begin
            if logic_cond then
                return st_1;
            else 
                return st_0;
            end if;
    end function;
    function bool2sl(bool_v : boolean) return std_logic is
    begin
            if bool_v then
                return '1';
            else 
                return '0';
            end if;
    end function;
begin

    idle2start <= bool2sl( tx_req = "1" );
    start2tr   <= bool2sl( comp_c >= comp_int );
    tr2stop    <= bool2sl( ( comp_c >= comp_int ) and ( bit_c = 4X"7" ) );
    stop2wait  <= bool2sl( ( comp_c >= ( '0' & comp_int(15 downto 1) ) ) and ( bit_c = stop_sel_int ) );
    wait2idle  <= bool2sl( tx_req = "0" );
    
    --FSM state change
    fsm_state_change_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            state <= IDLE_s;
        elsif( rising_edge(clk) ) then
            state <= sel_st( tr_en(0) , next_state , IDLE_s );
        end if;  
    end process;
    -- Finding next state for FSM
    find_next_state_proc : process(all)
    begin
        next_state <= state;
        case( state ) is
            when IDLE_s     => next_state <= sel_st( idle2start , START_s    , state );
            when START_s    => next_state <= sel_st( start2tr   , TRANSMIT_s , state );
            when TRANSMIT_s => next_state <= sel_st( tr2stop    , STOP_s     , state );
            when STOP_s     => next_state <= sel_st( stop2wait  , WAIT_s     , state );
            when WAIT_s     => next_state <= sel_st( wait2idle  , IDLE_s     , state );
            when others     => next_state <= IDLE_s;
        end case;
    end process;
    -- Other FSM sequence logic
    fsm_seq_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            tx_data_int <= (others => '0');
            stop_sel_int <= (others => '0');
            comp_c <= (others => '0');
            bit_c <= (others => '0');
            tx_req_ack <= (others => '0');
            uart_tx <= (others => '1');
            comp_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( tr_en(0) ) then
                case( state ) is
                    when IDLE_s     => 
                        if( idle2start ) then 
                            stop_sel_int <= stop_sel;
                            tx_data_int <= tx_data;
                            comp_int <= comp;
                        end if;
                    when START_s    => 
                        uart_tx <= (others => '0');
                        comp_c <= comp_c + 1;
                        if( start2tr ) then
                            comp_c <= (others => '0');
                        end if;
                    when TRANSMIT_s => 
                        uart_tx(0) <= tx_data_int(0);
                        comp_c <= comp_c + 1;
                        if( comp_c >= comp_int ) then
                            bit_c <= bit_c + 1;
                            comp_c <= (others => '0');
                            tx_data_int <= ( '0' & tx_data_int(7 downto 1) );
                            if( tr2stop ) then
                                bit_c <= (others => '0');
                            end if;
                        end if;
                    when STOP_s     => 
                        uart_tx <= (others => '1');
                        comp_c <= comp_c + 1;
                        if( comp_c >= ( '0' & comp_int(15 downto 1) ) ) then
                            bit_c <= bit_c + 1;
                            comp_c <= (others => '0');
                            if( stop2wait ) then
                                bit_c <= (others => '0');
                            end if;
                        end if;
                    when WAIT_s     => 
                        tx_req_ack <= (others => '1');
                        if( wait2idle ) then
                            tx_req_ack <= (others => '0');
                        end if;
                    when others     =>
                end case;
            else
                tx_data_int <= (others => '0');
                stop_sel_int <= (others => '0');
                comp_c <= (others => '0');
                bit_c <= (others => '0');
                tx_req_ack <= (others => '0');
                uart_tx <= (others => '1');
                comp_int <= (others => '0');
            end if;
        end if;
    end process;

end rtl; -- uart_transmitter_vhd
