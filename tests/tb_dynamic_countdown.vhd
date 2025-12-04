library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dynamic_countdown is
end entity;

architecture sim of tb_dynamic_countdown is

    constant CLK_PERIOD : time := 10 ns;

    -- Sinais do TB
    signal clk_tb          : std_logic := '0';
    signal rst_tb          : std_logic := '0';
    signal default_tb      : unsigned(4 downto 0) := (others => '0');
    signal increment_tb    : signed(4 downto 0)   := (others => '0');
    signal done_tb         : std_logic;
    signal count_tb        : unsigned(4 downto 0);

    signal clk_enable : boolean := true;

    -- DUT
    component dynamic_countdown is
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            default_time : in  unsigned(4 downto 0);
            increment    : in  signed(4 downto 0);
            count_done   : out std_logic;
            count_value  : out unsigned(4 downto 0)
        );
    end component;

begin

    DUT : dynamic_countdown
        port map (
            clk          => clk_tb,
            rst          => rst_tb,
            default_time => default_tb,
            increment    => increment_tb,
            count_done   => done_tb,
            count_value  => count_tb
        );

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    clock_gen : process
    begin
        while clk_enable loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    --------------------------------------------------------------------
    -- ESTIMULOS
    --------------------------------------------------------------------
    stim : process
    begin
        report "=== INICIO DO TESTE ===";

        -- Reset inicial
        rst_tb <= '1';
        wait for 2 * CLK_PERIOD;
        rst_tb <= '0';

        -- Configurando default_time = 10, increment = +1 -> tempo = 11
        default_tb   <= to_unsigned(10, 5);
        increment_tb <= to_signed(1, 5);
        wait for 20 * CLK_PERIOD;

        -- increment = -2 -> novo tempo = 8
        increment_tb <= to_signed(-2, 5);
        wait for 20 * CLK_PERIOD;

        -- increment = +3 -> novo tempo = 13
        increment_tb <= to_signed(3, 5);
        wait for 20 * CLK_PERIOD;

        report "=== FIM DA SIMULACAO ===" severity note;
        clk_enable <= false;
        wait;
    end process;

end architecture;
