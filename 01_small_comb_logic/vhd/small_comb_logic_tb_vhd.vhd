--
-- File            :   small_comb_logic_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.18
-- Language        :   VHDL
-- Description     :   This is testbench for simple connect example
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

entity small_comb_logic_tb_vhd is
end small_comb_logic_tb_vhd;

architecture testbench of small_comb_logic_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant repeat_n   : integer   := 10;
    -- data signals
    signal   d_in       : std_logic_vector( 7 downto 0);    -- data input
    signal   d_out      : std_logic_vector( 7 downto 0);    -- data output
    -- 
    signal   d_f        : std_logic_vector( 0 downto 0 );
    signal   d_inv      : std_logic_vector( 0 downto 0 );
    signal   d_xor      : std_logic_vector( 1 downto 0 );
    signal   d_sum      : std_logic_vector( 1 downto 0 );
    signal   d_and      : std_logic_vector( 0 downto 0 );
    signal   d_or       : std_logic_vector( 0 downto 0 );
    -- simulation variables
    signal   rep_c      : integer   := 0;
begin

    -- creating one design under test
    small_comb_logic_0: entity work.small_comb_logic_vhd  
    port map(
                d_in => d_in, 
                d_out => d_out
            );

    d_f   <= d_out(0 downto 0);
    d_inv <= d_out(1 downto 1);
    d_xor <= d_out(3 downto 2);
    d_sum <= d_out(5 downto 4);
    d_and <= d_out(6 downto 6);
    d_or  <= d_out(7 downto 7);
            
    -- simulation process
    simulaton : process
        -- declare help variables
        variable seed1  : positive;
        variable seed2  : positive;
        variable rand   : real;
        variable term_line : line;
    -- process start
    begin
            rep_c <= rep_c + 1;
            uniform( seed1 , seed2 , rand );
            d_in <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** 8) - 1.0 ) ) ),8) );
            wait for ( 10 * timescale );
            write(term_line ,"d_in = 0x" & to_hstring(d_in) & ", d_out = 0x" & to_hstring(d_out) & " " & time'image(now));
            writeline(output, term_line);
            if( rep_c = repeat_n) then
                wait;
            end if;
    end process simulaton; 
    
end testbench; -- small_comb_logic_tb_vhd
