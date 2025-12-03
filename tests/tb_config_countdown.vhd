-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_config_countdown is
end tb_config_countdown;

architecture sim of tb_config_countdown is

    -- Instanciação do DUT
    component config_countdown is
        generic (
            WIDTH : integer := 16
        );
        port(
            clk   : in std_logic;
            reset : in std_logic;
            N     : in unsigned(WIDTH-1 downto 0);
            X     : out unsigned(WIDTH-1 downto 0)
        );
    end component;

    -- Sinais do testbench
    constant WIDTH      : integer := 8;
    constant CLK_PERIOD : time    := 10 ns;

    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal N_tb     : unsigned(WIDTH-1 downto 0) := (others => '0');
    signal X_tb     : unsigned(WIDTH-1 downto 0);

    -- Controle do clock
    signal clk_enable : boolean := true;

begin

    --------------------------------------------------------------------
    -- Instancia o DUT
    --------------------------------------------------------------------
    UUT : config_countdown
        generic map (WIDTH => WIDTH)
        port map (
            clk   => clk_tb,
            reset => reset_tb,
            N     => N_tb,
            X     => X_tb
        );

    --------------------------------------------------------------------
    -- Clock process
    --------------------------------------------------------------------
    clock_process : process
    begin
        while clk_enable loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    --------------------------------------------------------------------
    -- Stimulus process
    --------------------------------------------------------------------
    stim_proc : process
    begin
        report "=== INICIO DO TESTE ===";

        ----------------------------------------------------------------
        -- TESTE 1: Reset
        ----------------------------------------------------------------
        reset_tb <= '1';
        N_tb <= to_unsigned(10, WIDTH);
        wait for 2 * CLK_PERIOD;
        reset_tb <= '0';
        wait for CLK_PERIOD;

        ----------------------------------------------------------------
        -- TESTE 2: Contar até 0 e recarregar N = 10
        ----------------------------------------------------------------
        wait for 15 * CLK_PERIOD;  -- tempo suficiente para recarregar

        ----------------------------------------------------------------
        -- TESTE 3: Novo valor (N = 4)
        ----------------------------------------------------------------
        N_tb <= to_unsigned(4, WIDTH);
        wait for 10 * CLK_PERIOD;

        ----------------------------------------------------------------
        -- TESTE 4: Novo valor (N = 1)
        -- contador fica alternando entre 1 -> 0 -> 1
        ----------------------------------------------------------------
        N_tb <= to_unsigned(1, WIDTH);
        wait for 10 * CLK_PERIOD;

        ----------------------------------------------------------------
        -- Fim da simulação
        ----------------------------------------------------------------
        report "=== FIM DA SIMULACAO ===" severity note;
        clk_enable <= false;
        wait;
    end process;

end architecture;
