--
-- File            :   spi_master_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.23
-- Language        :   VHDL
-- Description     :   This spi master module
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity spi_master_vhd is
    port
    (
        -- clock and reset
        clk         : in    std_logic;
        resetn      : in    std_logic;
        -- control and data
        comp        : in    std_logic_vector(7 downto 0);
        cpol        : in    std_logic_vector(0 downto 0);
        cpha        : in    std_logic_vector(0 downto 0);
        tr_en       : in    std_logic_vector(1 downto 0);
        msb_lsb     : in    std_logic_vector(0 downto 0);
        tx_data     : in    std_logic_vector(7 downto 0);
        rx_data     : out   std_logic_vector(7 downto 0);
        tx_req      : in    std_logic_vector(0 downto 0);
        tx_req_ack  : out   std_logic_vector(0 downto 0);
        sck         : out   std_logic_vector(0 downto 0);
        cs          : out   std_logic_vector(0 downto 0);
        sdo         : out   std_logic_vector(0 downto 0);
        sdi         : in    std_logic_vector(0 downto 0)
    );
end spi_master_vhd;

architecture rtl of spi_master_vhd is
    signal data_int     : std_logic_vector(7 downto 0);
    signal cpol_int     : std_logic_vector(0 downto 0);
    signal cpha_int     : std_logic_vector(0 downto 0);
    signal comp_int     : std_logic_vector(7 downto 0);
    signal msb_lsb_int  : std_logic_vector(0 downto 0);
    signal comp_c       : std_logic_vector(7 downto 0);
    signal bit_c        : std_logic_vector(3 downto 0);
    signal sck_int      : std_logic_vector(0 downto 0);

    signal idle2tr      : std_logic;
    signal tr2post_tr   : std_logic;
    signal post_tr2wait : std_logic;
    signal wait2idle    : std_logic;

    -- fsm settings
    type   fsm_state is (IDLE_s , TRANSMIT_s , POST_TR_s , WAIT_s);
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
    function sel_slv(bool_v : boolean; slv_1 : std_logic_vector; slv_0 : std_logic_vector) return std_logic_vector is
    begin
        if bool_v then
            return slv_1;
        else 
            return slv_0;
        end if;
    end function;
    function sel_sl(bool_v : boolean; sl_1 : std_logic; sl_0 : std_logic) return std_logic is
        begin
            if bool_v then
                return sl_1;
            else 
                return sl_0;
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

    idle2tr      <= bool2sl( tx_req = "1" );
    tr2post_tr   <= bool2sl( (comp_c >= comp_int) and (bit_c = 15) );
    post_tr2wait <= bool2sl( (comp_c >= comp_int) );
    wait2idle    <= bool2sl( tx_req = "0" );

    sck <= sck_int xor cpol_int;
    rx_data <= data_int;

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
            when IDLE_s     => next_state <= sel_st( idle2tr      , TRANSMIT_s , state );
            when TRANSMIT_s  => next_state <= sel_st( tr2post_tr   , POST_TR_s , state );
            when POST_TR_s  => next_state <= sel_st( post_tr2wait , WAIT_s    , state );
            when WAIT_s     => next_state <= sel_st( wait2idle    , IDLE_s    , state );
            when others     => next_state <= IDLE_s;
        end case;
    end process;

    -- Other FSM sequence logic
    fsm_seq_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            data_int <= (others => '0');
            cpol_int <= (others => '0');
            cpha_int <= (others => '0');
            comp_int <= (others => '0');
            comp_c <= (others => '0');
            bit_c <= (others => '0');
            tx_req_ack <= (others => '0');
            sck_int <= (others => '0');
            cs <= (others => '1');
            sdo <= (others => '1');
            msb_lsb_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( tr_en(0) ) then
                case( state ) is
                    when IDLE_s     => 
                        if( idle2tr ) then 
                            cpol_int <= cpol;
                            cpha_int <= cpha;
                            data_int <= tx_data;
                            comp_int <= comp;
                            msb_lsb_int <= msb_lsb;
                        end if;
                    when TRANSMIT_s => 
                        cs <= (others => '0');
                        comp_c <= comp_c + 1;
                        if( ( cpha_int(0) = '0' ) and ( comp_c = "0" ) ) then
                            if( not bit_c(0) ) then
                                sdo(0) <= sel_sl( msb_lsb_int(0) = '1' , data_int(7) , data_int(0) );
                            else
                                data_int <= sel_slv( msb_lsb_int(0) = '1' , data_int(6 downto 0) & sdi(0) , sdi(0) & data_int(7 downto 1) );
                            end if;
                        elsif( ( cpha_int(0) = '1' ) and ( comp_c >= comp_int ) ) then
                            if( not bit_c(0) ) then
                                sdo(0) <= sel_sl( msb_lsb_int(0) = '1' , data_int(7) , data_int(0) );
                            else
                                data_int <= sel_slv( msb_lsb_int(0) = '1' , data_int(6 downto 0) & sdi(0) , sdi(0) & data_int(7 downto 1) );
                            end if;
                        end if;
                        if( comp_c >= comp_int ) then
                            sck_int <= not sck_int;
                            bit_c <= bit_c + 1;
                            comp_c <= (others => '0');
                            if( tr2post_tr ) then
                                bit_c <= (others => '0');
                            end if;
                        end if;
                    when POST_TR_s    => 
                        comp_c <= comp_c + 1;
                        if( post_tr2wait ) then
                            comp_c <= (others => '0');
                        end if;
                    when WAIT_s     => 
                        cs <= (others => '1');
                        tx_req_ack <= (others => '1');
                        if( wait2idle ) then
                            tx_req_ack <= (others => '0');
                        end if;
                    when others     =>
                end case;
            else
                data_int <= (others => '0');
                cpol_int <= (others => '0');
                cpha_int <= (others => '0');
                comp_int <= (others => '0');
                comp_c <= (others => '0');
                bit_c <= (others => '0');
                tx_req_ack <= (others => '0');
                sck_int <= (others => '0');
                cs <= (others => '1');
                sdo <= (others => '1');
                msb_lsb_int <= (others => '0');
            end if;
        end if;
    end process;
    
end rtl; -- spi_master_vhd
