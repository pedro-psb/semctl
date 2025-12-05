-- Decoder unsigned para display de 7 segmentos
--
-- Converte um número unsigned de 4 bits (0-15) para configuração
-- de display de 7 segmentos hexadecimal
--
-- Entradas:
--   unsigned_value: unsigned(3 downto 0) - valor de 0 a 15
--
-- Saídas:
--   display_config: std_logic_vector(6 downto 0) - configuração dos segmentos
--
-- Segmentos do display (active low):
--    0
--   ---
-- 5| 6 |1
--   ---
-- 4|   |2
--   ---
--    3
--

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity unsigned_hex_decoder is port (
    unsigned_value: in unsigned(3 downto 0);
    display_config: out std_logic_vector(6 downto 0)
  );
end entity;

architecture dataflow of unsigned_hex_decoder is
begin
  display_config <=
                    -- O vetor corresponde aos sinais (6 5 4 3 2 1 0) do display 7-segmentos
                    -- Mapeamento: 0=topo, 1=direita-superior, 2=direita-inferior, 3=fundo, 4=esquerda-inferior, 5=esquerda-superior, 6=meio
                    -- O pauzinho acende no valor '0'! (active low)
                    not "1000000" when unsigned_value = 0 else  -- 0: segments 0,1,2,3,4,5
                    not "1111001" when unsigned_value = 1 else  -- 1: segments 1,2
                    not "0100100" when unsigned_value = 2 else  -- 2: segments 0,1,6,4,3
                    not "0110000" when unsigned_value = 3 else  -- 3: segments 0,1,6,2,3
                    not "0011001" when unsigned_value = 4 else  -- 4: segments 5,6,1,2
                    not "0010010" when unsigned_value = 5 else  -- 5: segments 0,5,6,2,3
                    not "0000010" when unsigned_value = 6 else  -- 6: segments 0,5,6,4,3,2
                    not "1111000" when unsigned_value = 7 else  -- 7: segments 0,1,2
                    not "0000000" when unsigned_value = 8 else  -- 8: all segments
                    not "0010000" when unsigned_value = 9 else  -- 9: segments 0,1,2,3,5,6
                    not "0001000" when unsigned_value = 10 else -- A: segments 0,1,2,4,5,6
                    not "0000011" when unsigned_value = 11 else -- B: segments 5,6,4,3,2
                    not "1000110" when unsigned_value = 12 else -- C: segments 0,5,4,3
                    not "0100001" when unsigned_value = 13 else -- D: segments 1,6,4,3,2
                    not "0000110" when unsigned_value = 14 else -- E: segments 0,5,6,4,3
                    not "0001110" when unsigned_value = 15 else -- F: segments 0,5,6,4
                    not "1111111"; -- all off (default)
end architecture;
