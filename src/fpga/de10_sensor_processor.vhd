-- Sensor Processor
--
-- DE10-Lite FPGA Board Template
-- ==============================
--
-- * 50 MHz clock
-- * 2 push buttons (KEY)
-- * 10 slide switches (SW)
-- * 10 red LEDs (LEDR)
-- * 6 seven-segment displays (HEX0-HEX5)
--
-- Saida dos semaforos
-- ==============================
--
-- Os semaforos de carro (2) e de pedestre (3) serão representados por displays de
-- 7 segmentos da seguinte forma:
--
-- |   _    ||  _  |  _  |     |     | 0 - piscando
-- |  |_|   || |_| |     |  _  |     | 1 - fechado
-- |  |_|   || |   |     |     |  _  | 2 - amarelo
-- | -------||-----|-----|-----|-----| 3 - aberto
-- | estado || 0   | 1   | 2   | 3   |
--
-- Há 6 displays. O layour ficará assim:
-- * ( sem1 ped1 | sem2 ped2 | ped3 ped3 )
--   ( HEX5 HEX4 | HEX3 HEX2 | HEX1 HEX0 )
--
-- Saida da FSM (debugging)
-- ==============================
--
-- Há 10 leds dispostos horizontalmente.
-- Os estados são numerados de 0 a 8. Cada estado terá uma posição correspondete
-- que ficará ligada quando o estado estiver ativo. Eles serão dispostos na ordem:
-- * fsm  ( - 8 7 6 5 4 3 2 1 0 )
--   LEDR ( 9 8 7 6 5 4 3 2 1 0 )
--
-- Entradas
-- ==============================
--
-- As entradas serão mapeadas:
-- * Keys:
--     * KEY0 (de cima)    -> in_car1
--     * KEY1 (de cima)    -> in_car2
-- * Switches: (clk rst ... in_mad)
--     * SW0 (da esquerda) -> in_mad
--     * SW9 (da direita)  -> clk (quando no modo manual)
--     * SW8 (penultimo)   -> rst
--

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity de10_sensor_processor is port (
    CLOCK_50 : in  std_logic;                -- Clock 50MHz
    KEY : in std_logic_vector(1 downto 0);   -- Push buttons (active low)
    SW : in std_logic_vector(9 downto 0);    -- Slide switches
    LEDR : out std_logic_vector(9 downto 0); -- Red LEDs
    HEX0 : out std_logic_vector(6 downto 0);  -- Display 7-segumentos
    HEX1 : out std_logic_vector(6 downto 0);  -- Display 7-segumentos
    HEX2 : out std_logic_vector(6 downto 0);  -- Display 7-segumentos
    HEX3 : out std_logic_vector(6 downto 0);  -- Display 7-segumentos
    HEX4 : out std_logic_vector(6 downto 0);  -- Display 7-segumentos
    HEX5 : out std_logic_vector(6 downto 0)   -- Display 7-segumentos
  ); end entity;


architecture structural of de10_sensor_processor
is
  -- Components
  component sensor_processor is
    generic (
      out_size : integer := 4;
      mem_size : integer := 10
    );
    port (
      car1_in    :  in std_logic;
      car1_enable  :  in std_logic;
      car2_in    :  in std_logic;
      car2_enable  :  in std_logic;
      rst      :  in std_logic;
      enable    :  in std_logic;
      polaridade  :  in std_logic;
      clk      :  in std_logic;
      data_out    :   out signed(out_size-1 downto 0)
    );
  end component;

  component clock_converter is
      generic (
          DIV_FACTOR : integer := 50000 --50000 valor default
      );
      port (
          in_clk  : in  std_logic;
          out_clk : out std_logic;
          RST     : in  std_logic
      );
  end component clock_converter;
  -- Internal signals
      constant out_size : integer := 4;
      signal car1_in    : std_logic;
      signal car1_enable  : std_logic;
      signal car2_in    : std_logic;
      signal car2_enable  : std_logic;
      signal rst      : std_logic;
      signal enable    : std_logic;
      signal polaridade  : std_logic;
      signal clk      : std_logic;
      signal data_out    : signed(out_size-1 downto 0);
      signal resized_clock : STD_LOGIC;
begin

  clock_converter_inst: clock_converter
   generic map(
      DIV_FACTOR => 5000000 -- 1s
  )
   port map(
      in_clk => CLOCK_50,
      out_clk => resized_clock,
      RST => RST
  );
  -- COMPONENTE PRINCIPAL
  main_ins: sensor_processor
    port map (
      -- sinais gerais
      clk => clock_50,
      rst => rst,
      enable => enable,
      polaridade => polaridade,
      -- sinais especificos
      car1_in => car1_in,
      car1_enable => car1_enable,
      car2_in => car2_in,
      car2_enable => car2_enable,
      data_out => data_out
    );

    car1_enable <= SW(0);
    car2_enable <= SW(1);
    car1_in <= KEY(0);
    car2_in <= KEY(1);
    enable <= SW(9); -- na ponta esquerda
    rst <= SW(8);
    polaridade <= SW(7);
    LEDR(3 downto 0) <= STD_LOGIC_VECTOR(data_out);


end architecture;

