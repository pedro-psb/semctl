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
    clk, rst : in  std_logic;
    out_fsm : out  std_logic_vector(9 downto 0);

    -- sinais especificos
    in_mad, in_car1, in_car2 : in  std_logic;
    sem1 : out std_logic_vector(1 downto 0);
    sem2 : out std_logic_vector(1 downto 0);
    ped1 : out std_logic_vector(1 downto 0);
    ped2 : out std_logic_vector(1 downto 0);
    ped3 : out std_logic_vector(1 downto 0)
  );
end entity;


architecture structural of semctl is
  -- componentes
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

  -- conexoes inter-componente
  signal count_done: std_logic := '1';
  signal car1_enable: std_logic;
  signal car2_enable: std_logic;
  signal polaridade_out: std_logic;
begin
  datapath : bloco_controle
  port map(
    clk => clk,
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
end architecture;
