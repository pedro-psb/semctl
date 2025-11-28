-- Decoder estado do sinal para codigo do display de 7 segmentosi (D10)
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

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity d10_sem_hex_decoder is port (
  sem_state: in std_logic_vector(1 downto 0);
  display_config: out std_logic_vector(6 downto 0)
  );
end entity;


architecture dataflow of d10_sem_hex_decoder is
begin
  display_config <=
    -- in order: (6 5 ... 0)
    "1110011" when sem_state = "00" else
    "0000001" when sem_state = "01" else
    "1000000" when sem_state = "10" else
    "0001000" when sem_state = "11" else
    "0000000";
end architecture;
