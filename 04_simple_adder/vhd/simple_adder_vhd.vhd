--
-- File            :   simple_adder_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is simple adder
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity simple_adder_vhd is
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
end simple_adder_vhd;

architecture rtl of simple_adder_vhd is
begin

    result <= x_0 + x_1;

end rtl; -- simple_adder_vhd
