--
-- File            :   small_comb_logic_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.18
-- Language        :   VHDL
-- Description     :   This is simple connect with small combination logic
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity small_comb_logic_vhd is
    port 
    (
        d_in    : in    std_logic_vector( 7 downto 0);  -- data input
        d_out   : out   std_logic_vector( 7 downto 0)   -- data output
    );
end small_comb_logic_vhd;

architecture rtl of small_comb_logic_vhd is
begin

    process(d_in)
    begin
        d_out(0) <= d_in(0);
        d_out(1) <= not d_in(1);
        d_out(3 downto 2) <= d_in(1 downto 0) xor d_in(3 downto 2);
        d_out(5 downto 4) <= std_logic_vector(unsigned(d_in(1 downto 0)) + unsigned(d_in(3 downto 2)));
        d_out(6) <= d_in(6) and d_in(7);
        d_out(7) <= d_in(6) or d_in(7);
    end process;

end rtl; -- small_comb_logic_vhd

