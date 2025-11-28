-- Implementação do semctl para FPGA DE10
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


entity de10_semctl is port (
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


architecture structural of de10_semctl
is
  -- Components
  component d10_sem_hex_decoder is
    port (
      in_sem : in  std_logic_vector(1 downto 0);
      hex_config : out std_logic_vector(6 downto 0)
    );
  end component;

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

  -- Internal signals
  signal clk, rst: std_logic;
  signal out_fsm : STD_LOGIC_VECTOR(9 downto 0);
  signal in_mad, in_car1, in_car2: std_logic;
  signal sem1, sem2, ped1, ped2, ped3 : STD_LOGIC_VECTOR(1 downto 0);

  constant N : integer := 3;
  signal a, b, sum : std_logic_vector(N-1 downto 0);
  signal cout : std_logic;
begin
  -- COMPONENTE PRINCIPAL
  main: semctl
    port map (
      -- sinais gerais
      clk => clk,
      rst => rst,
      out_fsm => out_fsm,
      -- sinais especificos
      in_mad => in_mad,
      in_car1 => in_car1,
      in_car2 => in_car2,
      sem1 => sem1,
      sem2 => sem2,
      ped1 => ped1,
      ped2 => ped2,
      ped3 => ped3
    );

  -- INPUTS
  -- clk <= CLOCK_50;
  clk <= SW(9); -- clock manual
  rst <= SW(8);

  in_car1 <= KEY(0);
  in_car2 <= KEY(1);
  in_mad <= SW(0);

  -- OUTPUTS
  LEDR <= out_fsm;

  -- sem1 + ped1
  dec0 : d10_sem_hex_decoder
    port map(
      in_sem => sem1,
      hex_config => HEX5
    );
  dec1 : d10_sem_hex_decoder
    port map(
      in_sem => ped1,
      hex_config => HEX4
    );

  -- sem2 + ped2
  dec2 : d10_sem_hex_decoder
    port map(
      in_sem => sem2,
      hex_config => HEX3
    );
  dec3 : d10_sem_hex_decoder
    port map(
      in_sem => sem2,
      hex_config => HEX2
    );

  -- ped3
  dec4 : d10_sem_hex_decoder
    port map(
      in_sem => ped3,
      hex_config => HEX1
    );
  dec5 : d10_sem_hex_decoder
    port map(
      in_sem => ped3,
      hex_config => HEX0
    );

end architecture;

