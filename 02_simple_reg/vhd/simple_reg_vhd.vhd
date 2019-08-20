--
-- File            :   simple_reg_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is simple register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_reg_vhd is
    port 
    (
        -- clock and reset
        clk     : in    std_logic;                      -- clock
        resetn  : in    std_logic;                      -- reset
        -- data
        d_in    : in    std_logic_vector(7 downto 0);   -- data input
        d_out   : out   std_logic_vector(7 downto 0)    -- data output
    );
end simple_reg_vhd;

architecture rtl of simple_reg_vhd is
begin

    process(clk, resetn)
    begin
        if( not resetn ) then
            d_out <= (others => '0');
        elsif( rising_edge(clk)) then
            d_out <= d_in;
        end if;
    end process;

end rtl; -- simple_reg_vhd
