-- Controle de Semáforo - Componente principal
--
--
-- input:
--   clk: 1 bit
--  rst: 1 bit       - Reseta para estado inicial
--   in_car1: 1 bits  - Enable para sensor de carro 1
--   in_car2: 1 bits  - Enable para sensor de carro 2
--   in_mad:  1 bits  - Ativa modo madrugada
-- output:
--   sem1: 2 bits     - Saida para semaforo de carros 1
--   sem2: 2 bits     - Saida para semaforo de carros 2
--   ped1: 2 bits     - Saida para semaforo de pedrestres 1
--   ped2: 2 bits     - Saida para semaforo de pedrestres 2
--   ped3: 2 bits     - Saida para semaforo de pedrestres 3
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity semctl is
  port (
    -- sinais gerais
    clk_10ms, rst : in  std_logic;
    out_fsm : out  std_logic_vector(9 downto 0);

    -- sinais especificos
    in_mad, in_car1, in_car2 : in  std_logic;
    sem1 : out std_logic_vector(1 downto 0);
    sem2 : out std_logic_vector(1 downto 0);
    ped1 : out std_logic_vector(1 downto 0);
    ped2 : out std_logic_vector(1 downto 0);
    ped3 : out std_logic_vector(1 downto 0);

    -- contador exposto para exibir no display
    count_value : out unsigned(4 downto 0)
  );
end entity;


architecture structural of semctl is
  -- componentes
  component clock_converter is
    generic (
      DIV_FACTOR : integer := 50000
    );
    port (
      in_clk  : in  std_logic;
      out_clk : out std_logic;
      RST     : in  std_logic
    );
  end component;

  component bloco_controle is
    port (
      clk, rst : in  std_logic;
      in_mad, in_car1, in_car2 : in  std_logic;
      out_fsm : out  std_logic_vector(9 downto 0);
      sem1 : out std_logic_vector(1 downto 0);
      sem2 : out std_logic_vector(1 downto 0);
      ped1 : out std_logic_vector(1 downto 0);
      ped2 : out std_logic_vector(1 downto 0);
      ped3 : out std_logic_vector(1 downto 0);

      count_done  : in std_logic;
      car1_enable : out std_logic;
      car2_enable : out std_logic;
      polaridade_out  : out std_logic
    );
  end component;

  component bloco_operacional is
    generic (
      mem_size : integer := 60;
      out_size : integer := 5
    );
    port (
      in_car1      : in  std_logic;
      in_car2      : in  std_logic;
      car1_enable  : in  std_logic;
      car2_enable  : in  std_logic;
      polaridade   : in  std_logic;
      default_time : in  unsigned(4 downto 0);
      enable       : in  std_logic;
      rst          : in  std_logic;
      clk_1s       : in  std_logic;
      clk_1000hz   : in  std_logic;
      count_done   : out std_logic;
      count_value  : out unsigned(4 downto 0)
    );
  end component;

  -- conexoes inter-componente
  signal count_done: std_logic;
  signal count_value_internal: unsigned(4 downto 0);
  signal car1_enable: std_logic;
  signal car2_enable: std_logic;
  signal polaridade_out: std_logic;

  -- sinais de clock
  signal clk_1s: std_logic;        -- 1 Hz (1s period)
  signal clk_10ms_sig: std_logic;  -- 100 Hz (0.01s period) - same as input

  -- constante para tempo padrão
  constant default_time_const : unsigned(4 downto 0) := "00111"; -- 7s


begin
  -- Instâncias dos conversores de clock
  -- Clock de 1s (1 Hz) para bloco_operacional e bloco_controle
  clk_conv_1s : clock_converter
  generic map(
    DIV_FACTOR => 50  -- 100Hz / (2 * 1Hz) = 50
  )
  port map(
    in_clk => clk_10ms,
    out_clk => clk_1s,
    RST => rst
  );

  -- Clock de 10ms (100 Hz) - pass through input clock (no conversion needed)
  clk_10ms_sig <= clk_10ms;

  controle_inst : bloco_controle
  port map(
    clk => clk_1s,
    rst => rst,
    in_mad => in_mad,
    in_car1 => in_car1,
    in_car2 => in_car2,
    out_fsm => out_fsm,
    sem1 => sem1,
    sem2 => sem2,
    ped1 => ped1,
    ped2 => ped2,
    ped3 => ped3,
    count_done => count_done,
    car1_enable => car1_enable,
    car2_enable => car2_enable,
    polaridade_out => polaridade_out
  );

  operacional_inst : bloco_operacional
  generic map(
    mem_size => 60,
    out_size => 5
  )
  port map(
    in_car1 => in_car1,
    in_car2 => in_car2,
    car1_enable => car1_enable,
    car2_enable => car2_enable,
    polaridade => polaridade_out,
    default_time => default_time_const,
    enable => '1',
    rst => rst,
    clk_1s => clk_1s,
    clk_1000hz => clk_10ms_sig,
    count_done => count_done,
    count_value => count_value_internal
  );

  -- Connect internal signal to output port
  count_value <= count_value_internal;

end architecture;
