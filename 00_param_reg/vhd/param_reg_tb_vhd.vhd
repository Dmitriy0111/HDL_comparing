--
-- File            :   param_reg_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.04.17
-- Language        :   VHDL
-- Description     :   This is testbench for register with parameters
-- Copyright(c)    :   2018 - 2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.STANDARD.BOOLEAN;

entity param_reg_tb_vhd is
end param_reg_tb_vhd;

architecture testbench of param_reg_tb_vhd is
    constant timescale  : time      := 1ns;
    constant W          : integer   := 8;
    -- clock and reset signals
    signal   clk        : std_logic := '0';                 -- clock
    signal   resetn     : std_logic := '0';                 -- reset
    -- data signals
    signal   d_in       : std_logic_vector( W-1 downto 0);  -- data input
    signal   d_out      : std_logic_vector( W-1 downto 0);  -- data output

    begin
    -- generating clock    
    clk <= not clk after 10 / 2 * timescale;
    -- creating one register under test
    REG_DUT: entity work.param_reg_vhd 
    generic map (
                    W=> W 
                ) 
    port map    (
                    clk => clk, 
                    resetn => resetn, 
                    d_in => d_in, 
                    d_out => d_out
                );

    simulaton : process
    begin
        resetn <= '0';
        d_in <= "01010101";
        resetn <= '1';
        wait for 200ns;
        wait;
    end process simulaton; 
    
end testbench; -- param_reg_tb_vhd
