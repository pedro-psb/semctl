-- Testbench for car_detector connected to reg_deslocamento
--
-- Tests the integration of car_detector with shift register
-- car_detector generates pulses which are shifted through reg_deslocamento
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity tb_car_detector_reg is
end tb_car_detector_reg;

architecture sim of tb_car_detector_reg is
  -- Constants
  constant reg_size : integer := 8;  -- Small memory size for reg_deslocamento
  constant clk_period : time := 10 ns;

  -- Component declarations
  component car_detector is
    port (
      SET : in std_logic;
      CLK : in std_logic;
      Q   : out std_logic
    );
  end component;

  component reg_deslocamento is
    generic (N : integer := 64);
    port (
      in_car, clk, rst : in std_logic;
      reg_out : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component reg is
    port (
      data_in, clk, rst : in std_logic;
      data_out : out std_logic
    );
  end component;

  -- Signals
  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal set_tb : std_logic := '0';

  -- Connection between car_detector and reg_deslocamento
  signal detector_out : std_logic;
  signal reg_out_tb : std_logic_vector(reg_size-1 downto 0);

  -- Clock control
  signal clk_enable : boolean := true;

begin

  -- Instantiate car_detector
  car_det_inst : car_detector
    port map (
      SET => set_tb,
      CLK => clk_tb,
      Q   => detector_out
    );

  -- Instantiate reg_deslocamento
  shift_reg_inst : reg_deslocamento
    generic map (N => reg_size)
    port map (
      in_car  => detector_out,
      clk     => clk_tb,
      rst     => rst_tb,
      reg_out => reg_out_tb
    );

  -- Clock process
  clock_process : process
  begin
    while clk_enable loop
      clk_tb <= '0';
      wait for clk_period / 2;
      clk_tb <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
    report "=== INICIO DO TESTE CAR_DETECTOR + REG_DESLOCAMENTO ===";

    -- Reset the system
    rst_tb <= '1';
    wait for clk_period * 2;
    rst_tb <= '0';
    wait for clk_period;

    -- Test 1: Generate a few rising edges and observe shift register behavior
    report "Teste 1: Gerando transições 0->1";
    for i in 1 to 3 loop
      set_tb <= '0';
      wait for clk_period;
      set_tb <= '1';
      wait for clk_period * 2;  -- Keep high for a bit
      set_tb <= '0';
      wait for clk_period * 2;  -- Wait between transitions

      report "Rising edge " & integer'image(i) & " generated";
    end loop;

    -- Test 2: Generate rapid rising edges
    report "Teste 2: Gerando transições rápidas";
    for i in 1 to 5 loop
      set_tb <= '0';
      wait for clk_period / 2;
      set_tb <= '1';
      wait for clk_period;
      set_tb <= '0';
      wait for clk_period;  -- Shorter wait
    end loop;

    -- Wait to see the shift register clear out
    wait for clk_period * reg_size;
    report "Shift register clearing completed";

    -- Test 3: Reset during operation
    report "Teste 3: Reset durante operação";
    -- Generate some rising edges
    for i in 1 to 3 loop
      set_tb <= '0';
      wait for clk_period / 2;
      set_tb <= '1';
      wait for clk_period;
      set_tb <= '0';
      wait for clk_period;
    end loop;

    -- Reset
    rst_tb <= '1';
    wait for clk_period;
    rst_tb <= '0';
    wait for clk_period;
    report "Reset completed, register cleared";

    report "=== FIM DA SIMULACAO CAR_DETECTOR + REG_DESLOCAMENTO ===";
    clk_enable <= false;
    wait;
  end process;

end architecture;
