--
-- File            :   simple_reg_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is testbench for simple register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity simple_reg_tb_vhd is
end simple_reg_tb_vhd;

architecture testbench of simple_reg_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant rst_delay  : integer   := 7;
    constant repeat_n   : integer   := 10;
    -- clock and reset signals
    signal   clk        : std_logic := '0';
    signal   resetn     : std_logic := '0';
    -- data signals
    signal   d_in_0     : std_logic_vector(7  downto 0);
    signal   d_out_0    : std_logic_vector(7  downto 0);
    signal   d_in_1     : std_logic_vector(31 downto 0);
    signal   d_out_1    : std_logic_vector(31 downto 0);
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;

    component top_simple_reg_vhd
        port 
        (
            -- clock and reset
            clk     : in    std_logic;
            resetn  : in    std_logic;
            -- data
            d_in_0  : in    std_logic_vector(7  downto 0);
            d_in_1  : in    std_logic_vector(31 downto 0);
            d_out_0 : out   std_logic_vector(7  downto 0);
            d_out_1 : out   std_logic_vector(31 downto 0)
        );
    end component;
begin

    -- creating one register under test
    DUT: top_simple_reg_vhd
    port map    
    (
        clk         => clk, 
        resetn      => resetn, 
        d_in_0      => d_in_0,
        d_in_1      => d_in_1,
        d_out_0     => d_out_0,
        d_out_1     => d_out_1
    );
            
    -- generating clock
    clk_gen : process
    begin
        clk <= '0';
        wait for (10 / 2 * timescale);
        clk <= '1';
        wait for (10 / 2 * timescale);
        if( rep_c = repeat_n) then
            wait;
        end if;
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
    -- process start
    begin
        if( rst_c /= rst_delay ) then
            d_in_0 <= (others => '0');
            d_in_1 <= (others => '0');
            wait until rising_edge(clk);
        elsif( rst_c = rst_delay ) then
            rep_c <= rep_c + 1;
            uniform( seed1 , seed2 , rand );
            d_in_0 <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 8) - 1.0 ) ) ),8) );
            d_in_1 <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 32) - 1.0 ) ) ),32) );
            wait until rising_edge(clk);
            write(term_line ,"d_in_0 = 0x" & to_hstring(d_in_0) & ", d_out_0 = 0x" & to_hstring(d_out_0) & " " & time'image(now));
            writeline(output, term_line);
            write(term_line ,"d_in_1 = 0x" & to_hstring(d_in_1) & ", d_out_1 = 0x" & to_hstring(d_out_1) & " " & time'image(now));
            writeline(output, term_line);
            if( rep_c = repeat_n) then
                wait;
            end if;
        end if;
    end process simulaton; 
    
end testbench; -- simple_reg_tb_vhd
