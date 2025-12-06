-- Bloco de operacional / Caminho de Dados (RTL)
--
--
-- == I/O Externo
--
-- input:
--   in_car1: 1 bits  - Enable para sensor de carro 1
--   in_car2: 1 bits  - Enable para sensor de carro 2
-- output: (nenhum)
--
--
-- == I/O Interno
--
-- input:
--   car1_enable: 1 bits  - Enable para sensor de carro 1
--   car2_enable: 1 bits  - Enable para sensor de carro 2
--   polaridade: 1 bits   - Representa a polaridade do ciclo. 1 = ciclo em que sem2 abre
-- output:
--   count_done: 1 bit    - Sinaliza que o contador terminou a contagem
--
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity bloco_operacional is
  generic (
    mem_size : integer;
    out_size : integer
  );
  port (
    -- Entradas dos sensores
    in_car1      : in  std_logic;
    in_car2      : in  std_logic;

    -- Controle do sistema
    car1_enable  : in  std_logic;
    car2_enable  : in  std_logic;
    polaridade   : in  std_logic;
    default_time : in  unsigned(4 downto 0);
    enable       : in  std_logic;
    rst          : in  std_logic;
    clk_1s       : in  std_logic;   -- 1s clock for dynamic_countdown
    clk_1000hz   : in  std_logic;   -- 1000Hz clock for sensor_processor

    -- Saídas do sistema
    count_done   : out std_logic;
    count_value  : out unsigned(4 downto 0)
  );
end entity;


architecture structural of bloco_operacional is

  signal sensor_output : signed(out_size-1 downto 0);

  component sensor_processor is
    generic (
      out_size : integer;
      mem_size : integer
    );
    port (
      car1_in     : in  std_logic;
      car1_enable : in  std_logic;
      car2_in     : in  std_logic;
      car2_enable : in  std_logic;
      rst         : in  std_logic;
      enable      : in  std_logic;
      polaridade  : in  std_logic;
      clk         : in  std_logic;
      data_out    : out signed(out_size-1 downto 0)
    );
  end component;

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

  sensor_inst : sensor_processor
    generic map (
      out_size => out_size,
      mem_size => mem_size
    )
    port map (
      car1_in     => in_car1,
      car1_enable => car1_enable,
      car2_in     => in_car2,
      car2_enable => car2_enable,
      rst         => rst,
      enable      => enable,
      polaridade  => polaridade,
      clk         => clk_1000hz,
      data_out    => sensor_output
    );

  countdown_inst : dynamic_countdown
    port map (
      clk          => clk_1s,
      rst          => rst,
      default_time => default_time,
      increment    => sensor_output,
      count_done   => count_done,
      count_value  => count_value
    );

end architecture;
