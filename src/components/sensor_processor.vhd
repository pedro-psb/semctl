-- Processador de sinais
--
-- Recebe sinal dos sensores de carro e calcula a diferença dentros
-- das especificações do projeto.
--
-- 
-- input:
--   car1_in: 1 bit       - Entrada do sensor carro 1
--   car1_enable: 1 bit   - Enable para carro 1
--   car2_in: 1 bit       - Entrada do sensor carro 2
--   car2_enable: 1 bit   - Enable para carro 2
--   rst: 1 bit           - Zera memoria interna (contagem de carros)
--   enable: 1 bit        - Ativa ou congela contador
--   polariadde: 1 bit    - Polaridade da saida
--   clk: 1 bit
-- output:
--   data_out: (-15 a 16) - Valor a ser incrementado no contador
-- 
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity sensor_processor is
end entity;


architecture structural of sensor_processor is
begin
end architecture;
