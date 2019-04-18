--
-- File            :   simple_connect_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.18
-- Language        :   VHDL
-- Description     :   This is simple connect example
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_connect_vhd is
    port 
    (
        d_in    : in    std_logic_vector( 7 downto 0);  -- data input
        d_out   : out   std_logic_vector( 7 downto 0)   -- data output
    );
end simple_connect_vhd;

architecture rtl of simple_connect_vhd is
begin

    process(d_in)
    begin
        d_out <= d_in;
    end process;

end rtl; -- simple_connect_vhd
