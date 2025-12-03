-- Contador regresssivo dinamico
--
-- Tempo do contador pode ser configurado para aumentar ou diminuar
-- uma quantidade especificada pelo valor de entrada dinamico.
--
-- A nova configuração entra em vigor no proximo ciclo de contagem.
--
-- 
-- input:
--   increment: 1 bit   - Valor a ser acrecido ao volor da contagem
--   default: 1 bit     - Valor padrao para o semaforo
--   rst: 1 bit         - Reseta o contador para o valor inicial
--   clk: 1 bit
-- output:
--   count_done: 1 bit  - Sinaliza que o contador chegou ao fim
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity dynamic_countdown is
end entity;


architecture structural of dynamic_countdown is
begin
end architecture;
