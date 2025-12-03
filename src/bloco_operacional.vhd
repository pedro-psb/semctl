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
end entity;


architecture structural of bloco_operacional is
begin
end architecture;
