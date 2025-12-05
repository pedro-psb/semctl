-- Decoder estado do sinal para codigo do display de 7 segmentos (D10)
--
-- Os semaforos de carro (2) e de pedestre (3) serão representados por displays de
-- 7 segmentos da seguinte forma:
--
-- Este decoder agora aceita DOIS estados de semáforo e produz DOIS displays separados:
-- sem_state_up: estado do semáforo superior -> display_config_up
-- sem_state_down: estado do semáforo inferior -> display_config_down
--
-- |   _    ||     |     |  _  |     | 00 - piscando
-- |  |_|   || | | ||    |     |   | | 01 - fechado
-- |  |_|   || | | |   | |  _  | |   | 10 - amarelo
-- | -------||-----|-----|-----|-----| 11 - aberto
-- | est_up || 00  | 01  | 10  | 11  |
-- | est_dw || 00  | 11  | 10  | 11  |
--

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity d10_sem_hex_decoder is port (
  sem_state_up: in std_logic_vector(1 downto 0);
  sem_state_down: in std_logic_vector(1 downto 0);
  display_config_up: out std_logic_vector(6 downto 0);
  display_config_down: out std_logic_vector(6 downto 0)
  );
end entity;


architecture dataflow of d10_sem_hex_decoder is
begin
  -- Decode upper state to upper display
  display_config_up <=
    -- O vetor corresponde aos sinais (6 5 4 3 2 1 0) do display 7-segmentos
    -- Mapping: 0=top, 1=top-right, 2=bottom-right, 3=bottom, 4=bottom-left, 5=top-left, 6=middle
    -- O pauzinho acende no valor '0'! (active low)
    not "1111110" when sem_state_up = "00" else  -- 00 - piscando: top segment only
    not "1000001" when sem_state_up = "01" else  -- 01 - fechado: all except top and middle
    not "0111111" when sem_state_up = "10" else  -- 10 - amarelo: middle segment only
    not "0000000" when sem_state_up = "11" else  -- 11 - aberto: all segments
    not "1111111";  -- Default case (all off)

  -- Decode lower state to lower display
  display_config_down <=
    -- O vetor corresponde aos sinais (6 5 4 3 2 1 0) do display 7-segmentos
    -- Mapping: 0=top, 1=top-right, 2=bottom-right, 3=bottom, 4=bottom-left, 5=top-left, 6=middle
    -- O pauzinho acende no valor '0'! (active low)
    not "1111110" when sem_state_down = "00" else  -- 00 - piscando: top segment only
    not "1000001" when sem_state_down = "01" else  -- 01 - fechado: all except top and middle
    not "0111111" when sem_state_down = "10" else  -- 10 - amarelo: middle segment only
    not "0000000" when sem_state_down = "11" else  -- 11 - aberto: all segments
    not "1111111";  -- Default case (all off)
end architecture;
