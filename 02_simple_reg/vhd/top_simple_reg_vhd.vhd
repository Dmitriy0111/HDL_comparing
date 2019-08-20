--
-- File            :   top_simple_reg_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is top level for simple register
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_simple_reg_vhd is
    port 
    (
        -- clock and reset
        clk     : in    std_logic;
        resetn  : in    std_logic;
        -- data
        d_in_0  : in    std_logic_vector(7  downto 0);
        d_in_1  : in    std_logic_vector(31 downto 0);
        d_out_0 : out   std_logic_vector(7  downto 0);
        d_out_1 : out   std_logic_vector(31 downto 0)
    );
end top_simple_reg_vhd;

architecture rtl of top_simple_reg_vhd is

component simple_reg_vhd
    port 
    (
        -- clock and reset
        clk     : in    std_logic;                      -- clock
        resetn  : in    std_logic;                      -- reset
        -- data
        d_in    : in    std_logic_vector(7 downto 0);   -- data input
        d_out   : out   std_logic_vector(7 downto 0)    -- data output
    );
end component;

begin
    -- creating one REG_8
    REG_8: simple_reg_vhd 
    port map    
    (
        clk     => clk, 
        resetn  => resetn, 
        d_in    => d_in_0, 
        d_out   => d_out_0
    );
    -- creating one REG_32_0
    REG_32_0: simple_reg_vhd 
    port map    
    ( 
        clk     => clk,
        resetn  => resetn,
        d_in    => d_in_1   (7 downto  0), 
        d_out   => d_out_1  (7 downto  0)
    );
    -- creating one REG_32_1
    REG_32_1: simple_reg_vhd 
    port map    
    ( 
        clk     => clk,
        resetn  => resetn,
        d_in    => d_in_1   (15 downto  8), 
        d_out   => d_out_1  (15 downto  8)
    );
    -- creating one REG_32_2
    REG_32_2: simple_reg_vhd 
    port map    
    ( 
        clk     => clk,
        resetn  => resetn,
        d_in    => d_in_1   (23 downto 16), 
        d_out   => d_out_1  (23 downto 16)
    );
    -- creating one REG_32_3
    REG_32_3: simple_reg_vhd
    port map    
    ( 
        clk     => clk,
        resetn  => resetn,
        d_in    => d_in_1   (31 downto 24), 
        d_out   => d_out_1  (31 downto 24)
    );

end rtl; -- top_simple_reg_vhd
