library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_semctl is
end entity tb_semctl;

architecture testbench of tb_semctl is

    component semctl is
      port (
        clk, rst : in  std_logic;
        out_fsm : out  std_logic_vector(9 downto 0);
        in_mad, in_car1, in_car2 : in  std_logic;
        sem1 : out std_logic_vector(1 downto 0);
        sem2 : out std_logic_vector(1 downto 0);
        ped1 : out std_logic_vector(1 downto 0);
        ped2 : out std_logic_vector(1 downto 0);
        ped3 : out std_logic_vector(1 downto 0)
      );
    end component;

    -- sinais to testbench
    signal clk, rst :  std_logic;
    signal out_fsm :  std_logic_vector(9 downto 0);
    signal in_mad, in_car1, in_car2 :  std_logic := '0';
    signal sem1 : std_logic_vector(1 downto 0);
    signal sem2 : std_logic_vector(1 downto 0);
    signal ped1 : std_logic_vector(1 downto 0);
    signal ped2 : std_logic_vector(1 downto 0);
    signal ped3 : std_logic_vector(1 downto 0);

    -- sinais auxiliares
    signal clk_enable: std_logic := '1';
    constant CLK_PERIOD : time := 10 ns;
begin
    uut: semctl
        port map (
            clk  => clk,
            rst  => rst,
            out_fsm  => out_fsm,
            in_mad  => in_mad,
            in_car1  => in_car1,
            in_car2  => in_car2,
            sem1  => sem1,
            sem2  => sem2,
            ped1  => ped1,
            ped2  => ped2,
            ped3  => ped3
        );

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        while clk_enable = '1' loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    test_process: process
    begin
        -- Testando Reset
        rst <= '1';
        wait for CLK_PERIOD/2;
        assert out_fsm = "1000000000"; -- estado inicial

        wait for 1 * CLK_PERIOD; 
        assert out_fsm = "1000000000";
        rst <= '0';
        in_mad <= '1';

        -- Testando Modo Madrugada
        wait for 1 * CLK_PERIOD; 
        assert out_fsm = "0100000000"; -- estado madrugada

        wait for 3 * CLK_PERIOD; 
        assert out_fsm = "0100000000";
        in_mad <= '0';

        -- Agora que o modo madrugada foi desligado, comeca o ciclo normal
        -- Faz o loop duas vezes para garantir consistencia

        for i in 2 downto 1 loop

            -- ciclo polaridade=1 (para direita)
            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000001000";
        
            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000000100";

            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000000010";

            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000000001";

            -- ciclo polaridade=0 (para esquerda)
            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000001000";

            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000010000";

            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0000100000";

            wait for 1 * CLK_PERIOD;
            assert out_fsm = "0001000000";
        end loop;

        clk_enable <= '0'; 
        wait;
    end process;
end architecture testbench;
