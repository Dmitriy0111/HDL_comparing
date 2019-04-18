--
-- File            :   top_param_reg_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.17
-- Language        :   VHDL
-- Description     :   This is top level for register with parameter
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_param_reg_vhd is
    port 
    (
        -- clock and reset
        clk     : in    std_logic;                      -- clock
        resetn  : in    std_logic;                      -- reset
        -- data
        d_in    : in    std_logic_vector( 31 downto 0); -- data input
        d_out1  : out   std_logic_vector( 31 downto 0); -- data output 2
        d_out0  : out   std_logic_vector( 31 downto 0)  -- data output
    );
end top_param_reg_vhd;

architecture rtl of top_param_reg_vhd is

component param_reg_vhd
    generic
    (
        W       : integer := 8
    );
    port 
    (
        -- clock and reset
        clk     : in    std_logic;                          -- clock
        resetn  : in    std_logic;                          -- reset
        -- data
        d_in    : in    std_logic_vector( W-1 downto 0);    -- data input
        d_out   : out   std_logic_vector( W-1 downto 0)     -- data output
    );
end component;

begin
    -- creating one REG_0
    REG_0: param_reg_vhd 
    port map    (
                    clk => clk, 
                    resetn => resetn, 
                    d_in => d_in    (7  downto  0), 
                    d_out => d_out0 (7  downto  0)
                );
    -- creating one REG_1
    REG_1: param_reg_vhd 
    port map    ( 
                    clk => clk,
                    resetn => resetn,
                    d_in => d_in    (15 downto  8), 
                    d_out => d_out0 (15 downto  8)
                );
    -- creating one REG_2
    REG_2: param_reg_vhd 
    port map    ( 
                    clk => clk,
                    resetn => resetn,
                    d_in => d_in    (23 downto 16), 
                    d_out => d_out0 (23 downto 16)
                );
    -- creating one REG_3
    REG_3: param_reg_vhd
    port map    ( 
                    clk => clk,
                    resetn => resetn,
                    d_in => d_in    (31 downto 24), 
                    d_out => d_out0 (31 downto 24)
                );
    -- creating one REG_F   (FULL)
    REG_F: param_reg_vhd 
    generic map (
                    W=> 32 
                ) 
    port map    (
                    clk => clk, 
                    resetn => resetn, 
                    d_in => d_in, 
                    d_out => d_out1 
                );

end rtl; -- top_param_reg_vhd
