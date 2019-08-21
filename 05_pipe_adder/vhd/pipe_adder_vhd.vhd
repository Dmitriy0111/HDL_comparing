--
-- File            :   pipe_adder_vhd.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.20
-- Language        :   VHDL
-- Description     :   This is pipeline adder
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pipe_adder_vhd is
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
end pipe_adder_vhd;

architecture rtl of pipe_adder_vhd is
    type    logic_va is array(natural range <>) of std_logic_vector;

    signal int_res  : std_logic_vector(31 downto 0);

    signal carry    : logic_va(3 downto 0)(0 downto 0);
    signal carry_ff : logic_va(3 downto 0)(0 downto 0);
    signal vld_int  : logic_va(3 downto 0)(0 downto 0);

    signal x_0_3    : logic_va(3 downto 0)(7 downto 0);
    signal x_1_3    : logic_va(3 downto 0)(7 downto 0);

    signal x_0_2    : logic_va(2 downto 0)(7 downto 0);
    signal x_1_2    : logic_va(2 downto 0)(7 downto 0);

    signal x_0_1    : logic_va(1 downto 0)(7 downto 0);
    signal x_1_1    : logic_va(1 downto 0)(7 downto 0);

    signal x_0_0    : logic_va(0 downto 0)(7 downto 0);
    signal x_1_0    : logic_va(0 downto 0)(7 downto 0);

    signal res_3    : logic_va(0 downto 0)(7 downto 0);
    signal res_2    : logic_va(1 downto 0)(7 downto 0);
    signal res_1    : logic_va(2 downto 0)(7 downto 0);
    signal res_0    : logic_va(3 downto 0)(7 downto 0);
    -- simple_adder_vhd
    component simple_adder_vhd
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
    end component;
    -- pipe_reg_vhd
    component pipe_reg_vhd
        generic
        (
            W       : integer := 8
        );
        port 
        (
            clk     : in    std_logic;
            resetn  : in    std_logic;
            clr     : in    std_logic_vector(0   downto 0);
            we      : in    std_logic_vector(0   downto 0);
            d_in    : in    std_logic_vector(W-1 downto 0);
            d_out   : out   std_logic_vector(W-1 downto 0)
        );
    end component;
begin

    vld <= vld_int(3);

    x_0_3(0) <= x_0(31 downto 24);
    x_1_3(0) <= x_1(31 downto 24);

    x_0_2(0) <= x_0(23 downto 16);
    x_1_2(0) <= x_1(23 downto 16);

    x_0_1(0) <= x_0(15 downto  8);
    x_1_1(0) <= x_1(15 downto  8);

    x_0_0(0) <= x_0(7  downto  0);
    x_1_0(0) <= x_1(7  downto  0);

    res_3(0) <= int_res(31 downto 24);
    res_2(0) <= int_res(23 downto 16);
    res_1(0) <= int_res(15 downto  8);
    res_0(0) <= int_res(7  downto  0);

    result(31 downto 24) <= res_3(0);
    result(23 downto 16) <= res_2(1);
    result(15 downto  8) <= res_1(2);
    result(7  downto  0) <= res_0(3);

    vld_int(0) <= req;

    simple_adder_vhd_0: simple_adder_vhd
    generic map
    (
        W       => 8 
    )
    port map
    (
        c_in    => "0",
        x_0     => x_0_0(0),
        x_1     => x_1_0(0),
        y       => int_res(7  downto  0),
        c_out   => carry(0)
    );

    simple_adder_vhd_1: simple_adder_vhd
    generic map
    (
        W       => 8 
    )
    port map
    (
        c_in    => carry_ff(0),
        x_0     => x_0_1(1),
        x_1     => x_1_1(1),
        y       => int_res(15 downto  8),
        c_out   => carry(1)
    );

    simple_adder_vhd_2: simple_adder_vhd
    generic map
    (
        W       => 8 
    )
    port map
    (
        c_in    => carry_ff(1),
        x_0     => x_0_2(2),
        x_1     => x_1_2(2),
        y       => int_res(23 downto 16),
        c_out   => carry(2)
    );

    simple_adder_vhd_3: simple_adder_vhd
    generic map
    (
        W       => 8 
    )
    port map
    (
        c_in    => carry_ff(2),
        x_0     => x_0_3(3),
        x_1     => x_1_3(3),
        y       => int_res(31 downto 24),
        c_out   => open
    );

    gen_reg_3:
    for gen_3 in 0 to 2 generate
        x_0_reg_3: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_0_3(gen_3),
            d_out       => x_0_3(gen_3+1)
        );

        x_1_reg_3: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_1_3(gen_3),
            d_out       => x_1_3(gen_3+1)
        );
    end generate gen_reg_3;

    gen_reg_2:
    for gen_2 in 0 to 1 generate
        x_0_reg_2: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_0_2(gen_2),
            d_out       => x_0_2(gen_2+1)
        );

        x_1_reg_2: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_1_2(gen_2),
            d_out       => x_1_2(gen_2+1)
        );
    end generate gen_reg_2;

    gen_reg_1: 
    for gen_1 in 0 to 0 generate
        x_0_reg_1: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_0_1(gen_1),
            d_out       => x_0_1(gen_1+1)
        );

        x_1_reg_1: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => x_1_1(gen_1),
            d_out       => x_1_1(gen_1+1)
        );
    end generate gen_reg_1;

    gen_res_2:
    for gen_2 in 0 to 0 generate
        res_reg_2: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => res_2(gen_2),
            d_out       => res_2(gen_2+1)
        );
    end generate gen_res_2;

    gen_res_1:
    for gen_1 in 0 to 1 generate
        res_reg_1: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => res_1(gen_1),
            d_out       => res_1(gen_1+1)
        );
    end generate gen_res_1;

    gen_res_0:
    for gen_0 in 0 to 2 generate
        res_reg_1: pipe_reg_vhd
        generic map
        (
            W           => 8
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => res_0(gen_0),
            d_out       => res_0(gen_0+1)
        );
    end generate gen_res_0;

    gen_carry_ff:
    for c_gen in 0 to 2 generate
        carry_ff_reg: pipe_reg_vhd
        generic map
        (
            W           => 1
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => carry(c_gen),
            d_out       => carry_ff(c_gen)
        );
    end generate gen_carry_ff;

    gen_vld:
    for vld_gen in 0 to 2 generate
        vld_reg: pipe_reg_vhd
        generic map
        (
            W           => 1
        )
        port map
        (
            clk         => clk,
            resetn      => resetn,
            clr         => flush,
            we          => not stall,
            d_in        => vld_int(vld_gen),
            d_out       => vld_int(vld_gen+1)
        );
    end generate gen_vld;

end rtl; -- pipe_adder_vhd
