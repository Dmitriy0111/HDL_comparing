--
-- File            :   pipe_reg_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is pipeline register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_reg_vhd is
    generic
    (
        W       : integer := 8
    );
    port 
    (
        clk     : in    std_logic;
        resetn  : in    std_logic;
        clr     : in    std_logic;
        we      : in    std_logic;
        d_in    : in    std_logic_vector(W-1 downto 0);
        d_out   : out   std_logic_vector(W-1 downto 0)
    );
end pipe_reg_vhd;

architecture rtl of pipe_reg_vhd is
begin

    process(clk, resetn)
    begin
        if( not resetn ) then
            d_out <= (others => '0');
        elsif( rising_edge(clk)) then
            if( we ) then
                if( clr ) then
                    d_out <= (others => '0');
                else
                    d_out <= d_in;
                end if;
            end if;
        end if;
    end process;

end rtl; -- pipe_reg_vhd
