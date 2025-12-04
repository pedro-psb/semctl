-- Testbench for reg_deslocamento
-- Tests shift register functionality including reset and shifting operations
-- 
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_reg_deslocamento is
end tb_reg_deslocamento;

architecture testbench of tb_reg_deslocamento is
    -- Clock helpers
    constant CLK_PERIOD : time := 10 ns;
    signal clk_enable : boolean := true;

    -- Declaracao do componente
    constant N : integer := 4;
    component reg_deslocamento is
        generic (
            N : integer := 4
        );
        port (
            in_car, clk, rst : in  std_logic;
            reg_out : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Sinais internos do tb
    signal in_car_tb : std_logic := '0';
    signal clk_tb    : std_logic := '0';
    signal rst_tb    : std_logic := '0';
    signal output_tb : std_logic_vector(N-1 downto 0);


    -- Utilitario para assercoes
    procedure check_output(
        expected  : in std_logic_vector;
        actual    : in std_logic_vector;
        test_name : in string
    ) is
    begin
        if actual = expected then
            report test_name & " | PASSOU: saida";
        else
            report test_name & " | FALHA"
                severity failure;
        end if;
    end procedure;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: reg_deslocamento
        generic map (N => N)
        port map (
            in_car => in_car_tb,
            clk    => clk_tb,
            rst    => rst_tb,
            reg_out => output_tb
        );

    -- Processo do clock
    clk_process: process
    begin
        while clk_enable loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Estimulos
    test_process: process
    begin
        -- RESET
        report "Testando Reset";
        rst_tb <= '1';
        wait for CLK_PERIOD/2; -- clock up
        rst_tb <= '0';
        wait for CLK_PERIOD/2; -- clock down
        check_output("0000", output_tb, "Reset test");

        -- SEQUENCIA in_car de 10000
        report "";
        report "Testando sequencia 1-0-0-0-0";

        in_car_tb <= '1';
        wait for CLK_PERIOD;
        check_output("1000", output_tb, "Sequencia 10000");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0100", output_tb, "Sequencia 10000");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0010", output_tb, "Sequencia 10000");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0001", output_tb, "Sequencia 10000");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0000", output_tb, "Sequencia 10000");

        -- SEQUENCIA in_car de 11001
        report "";
        report "Testando sequencia 1-1-0-0-1";
        check_output("0000", output_tb, "Sequencia 11111");

        in_car_tb <= '1';
        wait for CLK_PERIOD;
        check_output("1000", output_tb, "Sequencia 11111");

        in_car_tb <= '1';
        wait for CLK_PERIOD;
        check_output("1100", output_tb, "Sequencia 11111");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0110", output_tb, "Sequencia 11111");

        in_car_tb <= '0';
        wait for CLK_PERIOD;
        check_output("0011", output_tb, "Sequencia 11111");

        in_car_tb <= '1';
        wait for CLK_PERIOD;
        check_output("1001", output_tb, "Sequencia 11111");

        -- ENABLE mantem valor congelado
        report "";
        report "Testando enable='0' mantem valor congelado";
        check_output("1001", output_tb, "Sequencia 11111");

        report "";
        report "All tests completed successfully!";
        clk_enable <= false;
        wait;

    end process;

end testbench;
