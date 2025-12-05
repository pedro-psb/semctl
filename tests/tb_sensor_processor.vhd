-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_sensor_processor is
end tb_sensor_processor;

architecture sim of tb_sensor_processor is
  constant out_size : integer := 5;

  constant mem_size : integer := 60; -- tamanho do ciclo (em #clks) que memoria consegue gurdar
  constant max_count : integer := 20;  -- numero maximos de contagens em um "ciclo de memoria"

  constant clk_period : time := 10 ns;
  constant cycle_period : time := mem_size * clk_period;
  constant simulus_period : time := (mem_size / max_count)*clk_period/2;


  -- Instanciação do DUT
  component sensor_processor is
    generic (
      out_size : integer := out_size;
      mem_size : integer := mem_size
    );
    port (
      car1_in      : in std_logic;
      car1_enable  : in std_logic;
      car2_in      : in std_logic;
      car2_enable  : in std_logic;
      rst          : in std_logic;
      enable       : in std_logic;
      polaridade   : in std_logic;
      clk          : in std_logic;
      data_out     : out signed(out_size-1 downto 0)
    );
  end component;

  signal clk_tb         : std_logic := '0';
  signal mem_cycle      : std_logic := '0';
  signal rst_tb         : std_logic := '0';
  signal car1_in_tb     : std_logic := '0';
  signal car1_enable_tb : std_logic := '0';
  signal car2_in_tb     : std_logic := '0';
  signal car2_enable_tb : std_logic := '0';
  signal enable_tb      : std_logic := '1';
  signal polaridade_tb  : std_logic := '0';
  signal data_out_tb    : signed(out_size-1 downto 0);

  -- Controle do clock
  signal clk_enable : boolean := true;
  signal car_enable_polaridade : std_logic := '0';

begin

  -- Instancia o DUT
  UUT : sensor_processor
    generic map (
      out_size => out_size,
      mem_size => mem_size
    )
    port map (
      car1_in      => car1_in_tb,
      car1_enable  => car1_enable_tb,
      car2_in      => car2_in_tb,
      car2_enable  => car2_enable_tb,
      rst          => rst_tb,
      enable       => enable_tb,
      polaridade   => polaridade_tb,
      clk          => clk_tb,
      data_out     => data_out_tb
    );

  -- Clock process
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

  -- Mem cycle (referencia do tamanho da memoria)
  -- memsize_process : process
  -- begin
  --     while clk_enable loop
  --         mem_cycle <= '0';
  --         car1_enable_tb <= '0';
  --         car2_enable_tb <= '1';
  --         wait for cycle_period / 2;
  --         mem_cycle <= '1';
  --         car1_enable_tb <= '1';
  --         car2_enable_tb <= '0';
  --         wait for cycle_period / 2;
  --     end loop;
  --     wait;
  -- end process;

  -- Stimulus process
  stim_proc : process is

    -- Conta @car1_target vezes car1_in e @car2_target car2_in dentro de
    -- um ciclo completo de memoria do componente sensor_processor
    procedure count_cars(car1_target : integer; car2_target : integer) is
      variable car1_count : integer := 0;
      variable car2_count : integer := 0;
    begin
      -- car_enable_polaridade <= not car_enable_polaridade;
      -- Wait for falling edge to ensure we start at downclock
      wait until falling_edge(clk_tb);
      wait for simulus_period;

      -- A duracao deve alinhar com o tamanho de memoria do sensor_processor
      for cycle in max_count downto 1 loop
        -- Wait for falling edge before generating stimulus
        wait until falling_edge(clk_tb);

        -- Generate car1 pulse if we haven't reached the target
        if car1_count < car1_target then
          car1_in_tb <= '1';
          car1_count := car1_count + 1;
        else
          car1_in_tb <= '0';
        end if;

        -- Generate car2 pulse if we haven't reached the target
        if car2_count < car2_target then
          car2_in_tb <= '1';
          car2_count := car2_count + 1;
        else
          car2_in_tb <= '0';
        end if;

        wait for simulus_period/2;

        -- Set both signals to low for the second half of the period
        car1_in_tb <= '0';
        car2_in_tb <= '0';
        wait for simulus_period/2;
      end loop;
    end procedure;

  begin
    car1_enable_tb <= '0';
    car2_enable_tb <= '1';
    report "=== INICIO DO TESTE SENSOR_PROCESSOR ===";
    rst_tb <= '1';
    wait for clk_period;
    rst_tb <= '0';

    count_cars(15, 0);
    car1_enable_tb <= '1'; car2_enable_tb <= '0';
    count_cars(0, 15);
    car1_enable_tb <= '0'; car2_enable_tb <= '1';
    count_cars(15, 15);
    car1_enable_tb <= '1'; car2_enable_tb <= '0';
    count_cars(15, 3);
    car1_enable_tb <= '0'; car2_enable_tb <= '1';
    count_cars(11, 3);
    car1_enable_tb <= '1'; car2_enable_tb <= '0';
    count_cars(7, 3);

    report "=== FIM DA SIMULACAO SENSOR_PROCESSOR ===" severity note;
    clk_enable <= false;
    wait;
  end process;

end architecture;
