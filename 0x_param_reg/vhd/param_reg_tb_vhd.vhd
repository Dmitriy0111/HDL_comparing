--
-- File            :   param_reg_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.17
-- Language        :   VHDL
-- Description     :   This is testbench for register with parameters
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity param_reg_tb_vhd is
end param_reg_tb_vhd;

architecture testbench of param_reg_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant W          : integer   := 8;
    constant rst_delay  : integer   := 7;
    constant repeat_n   : integer   := 10;
    -- clock and reset signals
    signal   clk        : std_logic := '0';                 -- clock
    signal   resetn     : std_logic := '0';                 -- reset
    -- data signals
    signal   d_in       : std_logic_vector( W-1 downto 0);  -- data input
    signal   d_out      : std_logic_vector( W-1 downto 0);  -- data output
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;
begin

    -- creating one register under test
    REG_DUT: entity work.param_reg_vhd 
    generic map (
        W=> W 
        ) 
        port map    (
            clk => clk, 
            resetn => resetn, 
            d_in => d_in, 
            d_out => d_out
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
            d_in <= (others => '0');
            wait until rising_edge(clk);
        elsif( rst_c = rst_delay ) then
            rep_c <= rep_c + 1;
            uniform( seed1 , seed2 , rand );
            d_in <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** W) - 1.0 ) ) ),W) );
            wait until rising_edge(clk);
            write(term_line ,"d_in = 0x" & to_hstring(d_in) & ", d_out = 0x" & to_hstring(d_out) & " " & time'image(now));
            writeline(output, term_line);
            if( rep_c = repeat_n) then
                wait;
            end if;
        end if;
    end process simulaton; 
    
end testbench; -- param_reg_tb_vhd
