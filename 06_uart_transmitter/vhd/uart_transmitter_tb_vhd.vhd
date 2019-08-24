--
-- File            :   uart_transmitter_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.22
-- Language        :   VHDL
-- Description     :   This uart transmitter testbench
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use std.env.stop;


entity uart_transmitter_tb_vhd is
end uart_transmitter_tb_vhd;

architecture testbench of uart_transmitter_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant repeat_n   : integer   := 10;
    constant rst_delay  : integer   := 7;
    constant T          : integer   := 10;

    signal clk          : std_logic;
    signal resetn       : std_logic;
    signal comp         : std_logic_vector(15 downto 0);
    signal stop_sel     : std_logic_vector(1  downto 0);
    signal tr_en        : std_logic_vector(0  downto 0);
    signal tx_data      : std_logic_vector(7  downto 0);
    signal tx_req       : std_logic_vector(0  downto 0);
    signal tx_req_ack   : std_logic_vector(0  downto 0);
    signal uart_tx      : std_logic_vector(0  downto 0);
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;

    component uart_transmitter_vhd
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
    end component;
begin

    DUT: uart_transmitter_vhd
    port map
    (
        -- reset and clock
        clk         => clk,
        resetn      => resetn,
        -- control and data
        comp        => comp,
        stop_sel    => stop_sel,
        tr_en       => tr_en,
        tx_data     => tx_data,
        tx_req      => tx_req,
        tx_req_ack  => tx_req_ack,
        uart_tx     => uart_tx
    );

    -- generating clock
    clk_gen : process
    begin
        clk <= '0';
        wait for (T / 2 * timescale);
        clk <= '1';
        wait for (T / 2 * timescale);
    end process clk_gen;
    -- reset generation
    rst_gen : process
    begin
        if( rst_c /= rst_delay ) then
            resetn <= '0';
            rst_c <= rst_c + 1;
            wait until rising_edge(clk);
        else
            resetn <= '1';
            wait;
        end if;
    end process rst_gen;
            
    -- simulation process
    simulaton : process
        -- declare help variables
        variable seed1  : positive;
        variable seed2  : positive;
        variable rand   : real;
        variable term_line : line;
        variable rand_int : integer;

        -- task for sending symbol over uart to receive module
        procedure uart_write( gen : boolean ) is
            begin
                tx_req <= (others => '1');
                uniform( seed1 , seed2 , rand );
                stop_sel <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 2) - 1.0 ) ) ),2) );
                write(term_line ,"stop_sel = 0x" & to_hstring(stop_sel) & " ");
                uniform( seed1 , seed2 , rand );
                tx_data <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 8) - 1.0 ) ) ),8) );
                write(term_line ,"tx_data = 0x" & to_hstring(tx_data) & " ");
                uniform( seed1 , seed2 , rand );
                case( integer(round(rand * 5.0 ) ) ) is
                    when 1      => comp <= std_logic_vector( to_unsigned( 50_000_000 / 9600   , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 9600"   & " " & time'image(now));
                    when 2      => comp <= std_logic_vector( to_unsigned( 50_000_000 / 19200  , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 19200"  & " " & time'image(now));
                    when 3      => comp <= std_logic_vector( to_unsigned( 50_000_000 / 38400  , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 38400"  & " " & time'image(now));
                    when 4      => comp <= std_logic_vector( to_unsigned( 50_000_000 / 57600  , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 57600"  & " " & time'image(now));
                    when 5      => comp <= std_logic_vector( to_unsigned( 50_000_000 / 115200 , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 115200" & " " & time'image(now));
                    when others => comp <= std_logic_vector( to_unsigned( 50_000_000 / 9600   , 16 ) ); write(term_line ,"comp = 0x" & to_hstring(comp) & " baudrate = 9600"   & " " & time'image(now));
                end case;
                writeline(output, term_line);
                tr_en <= (others => '1');
                wait until rising_edge(tx_req_ack(0));
                tx_req <= (others => '0');
                wait until rising_edge(clk);
        end; -- uart_write
    -- process start
    begin
        if( rst_c /= rst_delay ) then
            tx_req <= (others => '0');
            stop_sel <= (others => '0');
            tx_data <= (others => '0');
            comp <= (others => '0');
            tr_en <= (others => '0');
            wait until rising_edge(clk);
        elsif( rst_c = rst_delay ) then
            if( rep_c < repeat_n ) then
                rep_c <= rep_c + 1; 
                uart_write(true);            
            elsif( rep_c = repeat_n ) then
                stop;
            end if;
        end if;
    end process simulaton; 
    
end testbench; -- uart_transmitter_tb_vhd
