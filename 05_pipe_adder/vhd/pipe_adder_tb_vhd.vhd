--
-- File            :   pipe_adder_tb_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.21
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

entity pipe_adder_tb_vhd is
end pipe_adder_tb_vhd;

architecture testbench of pipe_adder_tb_vhd is
    constant timescale  : time      := 1 ns;
    constant repeat_n   : integer   := 10;
    constant rst_delay  : integer   := 7;
    constant T          : integer   := 10;

    signal clk      : std_logic;
    signal resetn   : std_logic;
    signal flush    : std_logic_vector(0  downto 0);
    signal stall    : std_logic_vector(0  downto 0);
    signal req      : std_logic_vector(0  downto 0);
    signal x_0      : std_logic_vector(31 downto 0);
    signal x_1      : std_logic_vector(31 downto 0);
    signal result   : std_logic_vector(31 downto 0);
    signal vld      : std_logic_vector(0  downto 0);
    -- simulation variables
    signal   rst_c      : integer   := 0;
    signal   rep_c      : integer   := 0;

    component pipe_adder_vhd
        port
        (
            clk     : in    std_logic;
            resetn  : in    std_logic;
            flush   : in    std_logic_vector(0  downto 0);
            stall   : in    std_logic_vector(0  downto 0);
            req     : in    std_logic_vector(0  downto 0);
            x_0     : in    std_logic_vector(31 downto 0);
            x_1     : in    std_logic_vector(31 downto 0);
            result  : out   std_logic_vector(31 downto 0);
            vld     : out   std_logic_vector(0  downto 0)
        );
    end component;
begin

    DUT: pipe_adder_vhd
    port map    
    (
        clk         => clk,
        resetn      => resetn,
        flush       => flush,
        stall       => stall,
        req         => req,
        x_0         => x_0,
        x_1         => x_1,
        result      => result,
        vld         => vld
    );

    -- generating clock
    clk_gen : process
    begin
        clk <= '0';
        wait for (T / 2 * timescale);
        clk <= '1';
        wait for (T / 2 * timescale);
    end process clk_gen;
    -- reset generation
    rst_gen : process
    begin
        if( rst_c /= rst_delay ) then
            resetn <= '0';
            rst_c <= rst_c + 1;
            wait until rising_edge(clk);
        else
            resetn <= '1';
            wait;
        end if;
    end process rst_gen;
            
    -- simulation process
    simulaton : process
        
        -- declare help variables
        variable seed1  : positive;
        variable seed2  : positive;
        variable rand   : real;
        variable term_line : line;
        variable rand_int : integer;
    -- process start
    begin
        if( rst_c /= rst_delay ) then
            flush <= (others => '0');
            stall <= (others => '0');
            req <= (others => '0');
            x_0 <= (others => '0');
            x_1 <= (others => '0');
            wait until rising_edge(clk);
        elsif( rst_c = rst_delay ) then
            if( rep_c < repeat_n ) then
                rep_c <= rep_c + 1;
                req <= (others => '1');
                uniform( seed1 , seed2 , rand );
                if( ( rand * ( ( 2.0 ** 32 ) - 1.0 ) ) > 2.0 ** 31 ) then 
                    rand_int := integer(   ( rand * ( ( 2.0 ** 31 ) - 1.0 ) ) );
                else
                    rand_int := integer( - ( rand * ( ( 2.0 ** 31 ) - 1.0 ) ) );
                end if;
                x_0 <= std_logic_vector(to_signed(rand_int,x_0'length) );
                uniform( seed1 , seed2 , rand );
                if( ( rand * ( ( 2.0 ** 32 ) - 1.0 ) ) > 2.0 ** 31 ) then 
                    rand_int := integer(   ( rand * ( ( 2.0 ** 31 ) - 1.0 ) ) );
                else
                    rand_int := integer( - ( rand * ( ( 2.0 ** 31 ) - 1.0 ) ) );
                end if;
                x_1 <= std_logic_vector(to_signed(rand_int,x_1'length) );
                wait until rising_edge(clk);
                write(term_line ,"x_0 = 0x" & to_hstring(x_0) & " x_1 = 0x" & to_hstring(x_1) & " " & time'image(now));
                writeline(output, term_line);
            elsif( rep_c < repeat_n + 4 ) then
                rep_c <= rep_c + 1;
                req <= (others => '0');
                wait until rising_edge(clk);
            elsif( rep_c = repeat_n + 4 ) then
                stop;
            end if;
        end if;
    end process simulaton; 
    -- monitor process
    monitor : process
        variable term_line : line;
    begin
        wait until rising_edge(clk);
        if( vld(0) ) then
            write(term_line ,"result = 0x" & to_hstring(result) & " " & time'image(now));
            writeline(output, term_line);
        end if;
    end process monitor;
    
end testbench; -- pipe_adder_tb_vhd
