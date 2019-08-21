--
-- File            :   simple_adder_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is testbench for simple adder
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use std.env.stop;

entity simple_adder_tb_vhd is
end simple_adder_tb_vhd;

architecture testbench of simple_adder_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant W          : integer   := 8;
    constant repeat_n   : integer   := 10;
    -- signals
    signal   x_0        : std_logic_vector(W-1 downto 0);
    signal   x_1        : std_logic_vector(W-1 downto 0);
    signal   result     : std_logic_vector(W-1 downto 0);
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;

    component simple_adder_vhd
        generic
        (
            W : integer := 8
        );
        port 
        (
            x_0     : in    std_logic_vector(W-1 downto 0);
            x_1     : in    std_logic_vector(W-1 downto 0);
            result  : out   std_logic_vector(W-1 downto 0) 
        );
    end component;
begin

    DUT: simple_adder_vhd
    generic map 
    (
        W   => W 
    ) 
    port map    
    (
        x_0     => x_0, 
        x_1     => x_1, 
        result  => result
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
        x_0 <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** W) - 1.0 ) ) ),W) );
        uniform( seed1 , seed2 , rand );
        x_1 <= std_logic_vector(to_unsigned(integer(round(rand * ( (2.0 ** W) - 1.0 ) ) ),W) );
        wait for (10 / 2 * timescale);
        write(term_line ,"x_0 = 0x" & to_hstring(x_0) & " " & "x_1 = 0x" & to_hstring(x_1) & ", result = 0x" & to_hstring(result) & " " & time'image(now));
        writeline(output, term_line);
        if( rep_c = repeat_n) then
            stop;
        end if;
    end process simulaton; 
    
end testbench; -- simple_adder_tb_vhd
