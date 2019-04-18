--
-- File            :   simple_connect_tb_vhd.vhd
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

entity simple_connect_tb_vhd is
end simple_connect_tb_vhd;

architecture testbench of simple_connect_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant repeat_n   : integer   := 10;
    -- data signals
    signal   d_in       : std_logic_vector( 7 downto 0);    -- data input
    signal   d_out      : std_logic_vector( 7 downto 0);    -- data output
    -- simulation variables
    signal   rep_c      : integer   := 0;
begin

    -- creating one design under test
    simple_connect_0: entity work.simple_connect_vhd  
    port map(
                d_in => d_in, 
                d_out => d_out
            );
            
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
    
end testbench; -- simple_connect_tb_vhd
