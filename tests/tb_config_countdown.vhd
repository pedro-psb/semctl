-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
-- arquivo correto

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_config_countdown is
end entity;

architecture tb of tb_config_countdown is

    constant width : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    -- UUT signals
    signal clk_tb  : std_logic := '0';
    signal rst_tb  : std_logic := '0';
    signal set_tb  : std_logic := '0';
    signal N_tb    : unsigned(width-1 downto 0) := (others => '0');
    signal X_tb    : unsigned(width-1 downto 0);
	signal clk_enable : boolean := true;


begin

    -- Instancia do DUT

	UUT : entity work.config_countdown
        generic map (width => width)
        port map (
            clk => clk_tb,
            rst => rst_tb,
            set => set_tb,
            N   => N_tb,
            X   => X_tb
        );

    -- Clock
    
    clk_process : process
    begin
        while clk_enable loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;

        wait;  
    end process;
    
    -- Estímulos
    
    stim : process
    begin
        report "===== INICIO DO TESTE =====";

        -- RESET
        rst_tb <= '1';
        wait for CLK_PERIOD;
        rst_tb <= '0';
        wait for CLK_PERIOD;

        -- 1) Carregar N = 10
        N_tb   <= to_unsigned(10, width);
        set_tb <= '1';
        wait for CLK_PERIOD;
        set_tb <= '0';

        wait for 20*CLK_PERIOD;

        -- 2) Mudar valor para N = 4
        N_tb   <= to_unsigned(4, width);
        set_tb <= '1';
        wait for CLK_PERIOD;
        set_tb <= '0';

        wait for 15*CLK_PERIOD;

        -- 3) Outro teste
        N_tb   <= to_unsigned(15, width);
        set_tb <= '1';
        wait for CLK_PERIOD;
        set_tb <= '0';

        wait for 30*CLK_PERIOD;

        report "===== FIM DA SIMULACAO =====" severity note;

        clk_enable <= false;  -- ENCERRA O CLOCK
        wait for CLK_PERIOD;  -- dá tempo do clock parar

        wait;  

    end process;

end architecture;