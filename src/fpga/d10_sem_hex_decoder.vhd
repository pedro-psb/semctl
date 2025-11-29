-- Decoder estado do sinal para codigo do display de 7 segmentosi (D10)
--
-- Os semaforos de carro (2) e de pedestre (3) serão representados por displays de
-- 7 segmentos da seguinte forma:
--
-- |   _    ||  _  |  _  |     |     | 0 - piscando
-- |  |_|   || |_| |     |  _  |     | 1 - fechado
-- |  |_|   || |   |     |     |  _  | 2 - amarelo
-- | -------||-----|-----|-----|-----| 3 - aberto
-- | estado || 00  | 01  | 10  | 11  |
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
    -- O vetor corresponde aos sinais (6 5 ... 0) do display 7-segmentos
    -- Os numeros 0..6 correspondem a pauzinhos especificos do display (ver documentacao)
    -- O pauzinho acende no valor '0'!
    not "1110011" when sem_state = "00" else
    not "0000001" when sem_state = "01" else
    not "1000000" when sem_state = "10" else
    not "0001000" when sem_state = "11" else
    not "0000000";
end architecture;
