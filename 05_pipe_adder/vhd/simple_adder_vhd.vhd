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
        c_in    : in    std_logic_vector(0   downto 0);
        x_0     : in    std_logic_vector(W-1 downto 0);
        x_1     : in    std_logic_vector(W-1 downto 0);
        y       : out   std_logic_vector(W-1 downto 0);
        c_out   : out   std_logic_vector(0   downto 0)
    );
end simple_adder_vhd;

architecture rtl of simple_adder_vhd is
    signal int_res : std_logic_vector(W downto 0);
begin

    int_res  <= ( '0' & x_0 ) + ( '0' & x_1 ) + ( ( W-2 downto 0 => '0' ) & c_in );
    c_out(0) <= int_res(W); 
    y        <= int_res(W-1 downto 0);

end rtl; -- simple_adder_vhd
