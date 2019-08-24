--
-- File            :   File            :   spi_master_tb_vhd.vhd
-- Autor           :   Autor           :   Vlasov D.V.
-- Data            :   Data            :   2019.08.23
-- Language        :   Language        :   VHDL
-- Description     :   Description     :   This spi master testbench
-- Copyright(c)    :   Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use std.env.stop;


entity spi_master_tb_vhd is
end spi_master_tb_vhd;

architecture testbench of spi_master_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant repeat_n   : integer   := 10;
    constant rst_delay  : integer   := 7;
    constant T          : integer   := 10;

    signal clk          : std_logic;
    signal resetn       : std_logic;

    signal comp         : std_logic_vector(7 downto 0);
    signal cpol         : std_logic_vector(0 downto 0);
    signal cpha         : std_logic_vector(0 downto 0);
    signal tr_en        : std_logic_vector(1 downto 0);
    signal msb_lsb      : std_logic_vector(0 downto 0);
    signal tx_data      : std_logic_vector(7 downto 0);
    signal rx_data      : std_logic_vector(7 downto 0);
    signal tx_req       : std_logic_vector(0 downto 0);
    signal tx_req_ack   : std_logic_vector(0 downto 0);
    signal sck          : std_logic_vector(0 downto 0);
    signal cs           : std_logic_vector(0 downto 0);
    signal sdo          : std_logic_vector(0 downto 0);
    signal sdi          : std_logic_vector(0 downto 0);
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;

    component spi_master_vhd
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
    end component;
begin

    DUT: spi_master_vhd
    port map
    (
        -- clock and reset
        clk         => clk,
        resetn      => resetn,
        -- control and data
        comp        => comp,
        cpol        => cpol,
        cpha        => cpha,
        tr_en       => tr_en,
        msb_lsb     => msb_lsb,
        tx_data     => tx_data,
        rx_data     => rx_data,
        tx_req      => tx_req,
        tx_req_ack  => tx_req_ack,
        sck         => sck,
        cs          => cs,
        sdo         => sdo,
        sdi         => sdi
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
        procedure spi_write( gen : boolean ) is
            begin
                tx_req <= (others => '1');
                uniform( seed1 , seed2 , rand );
                cpha <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 1) - 1.0 ) ) ),1) );
                write(term_line ,"cpha = 0x" & to_hstring(cpha) & " ");
                uniform( seed1 , seed2 , rand );
                cpol <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 1) - 1.0 ) ) ),1) );
                write(term_line ,"cpol = 0x" & to_hstring(cpol) & " ");
                uniform( seed1 , seed2 , rand );
                msb_lsb <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 1) - 1.0 ) ) ),1) );
                write(term_line ,"msb_lsb = 0x" & to_hstring(msb_lsb) & " ");
                uniform( seed1 , seed2 , rand );
                tx_data <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 8) - 1.0 ) ) ),8) );
                write(term_line ,"tx_data = 0x" & to_hstring(tx_data) & " ");
                uniform( seed1 , seed2 , rand );
                case( integer(round(rand * 10.0 ) ) ) is
                    when 1      => comp <= std_logic_vector(to_unsigned( 0   , 8 ) );
                    when 2      => comp <= std_logic_vector(to_unsigned( 1   , 8 ) );
                    when 3      => comp <= std_logic_vector(to_unsigned( 2   , 8 ) );
                    when 4      => comp <= std_logic_vector(to_unsigned( 4   , 8 ) );
                    when 5      => comp <= std_logic_vector(to_unsigned( 8   , 8 ) );
                    when 6      => comp <= std_logic_vector(to_unsigned( 16  , 8 ) );
                    when 7      => comp <= std_logic_vector(to_unsigned( 32  , 8 ) );
                    when 8      => comp <= std_logic_vector(to_unsigned( 64  , 8 ) );
                    when 9      => comp <= std_logic_vector(to_unsigned( 128 , 8 ) );
                    when 10     => comp <= std_logic_vector(to_unsigned( 255 , 8 ) );
                    when others => comp <= std_logic_vector(to_unsigned( 0   , 8 ) );
                end case;
                write(term_line ,"comp = 0x" & to_hstring(comp) & " " & time'image(now));
                writeline(output, term_line);
                tr_en <= (others => '1');
                wait until rising_edge(tx_req_ack(0));
                tx_req <= (others => '0');
                wait until rising_edge(clk);
        end; -- spi_write
    -- process start
    begin
        if( rst_c /= rst_delay ) then
            --sdi <= (others => '0');
            tx_req <= (others => '0');
            cpha <= (others => '0');
            cpol <= (others => '0');
            tx_data <= (others => '0');
            comp <= (others => '0');
            tr_en <= (others => '0');
            msb_lsb <= (others => '0');
            wait until rising_edge(clk);
        elsif( rst_c = rst_delay ) then
            if( rep_c < repeat_n ) then
                rep_c <= rep_c + 1; 
                spi_write(true);            
            elsif( rep_c = repeat_n ) then
                stop;
            end if;
        end if;
    end process simulaton; 

    sdi_proc : process
        -- declare help variables
        variable seed1  : positive;
        variable seed2  : positive;
        variable rand   : real;
        variable test_slv : std_logic_vector(0 downto 0);
    begin
        wait until rising_edge(sck(0));
        uniform( seed1 , seed2 , rand );
        test_slv := std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 1) - 1.0 ) ) ),1) );
        sdi <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 1) - 1.0 ) ) ),1) );     
    end process sdi_proc;
    
end testbench; -- spi_master_tb_vhd
