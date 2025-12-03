-- Bloco de controle do semctl (RTL)
--
-- 
-- == I/O Externo
-- 
-- input:
--   clk: 1 bit
--   rst: 1 bit
--   in_mad: 1 bit    - Ativa modo madrugada
-- output:
--   out_fsm: 10 bits - Saida da FSM (one-hot encoding)
--   sem1: 2 bits     - Saida para semaforo de carro 1
--   sem2: 2 bits     - Saida para semaforo de carro 2
--   ped1: 2 bits     - Saida para semaforo de pedestre 1
--   ped2: 2 bits     - Saida para semaforo de pedestre 2
--   ped3: 2 bits     - Saida para semaforo de pedestre 3
-- 
-- 
-- == I/O Interno
-- 
-- input:
--   count_done: 1 bit    - Sinaliza que o contador terminou a contagem
--   
-- output:
--   car1_enable: 1 bits  - Enable para sensor de carro 1
--   car2_enable: 1 bits  - Enable para sensor de carro 2
--   polaridade: 1 bits   - Representa a polaridade do ciclo. 1 = ciclo em que sem2 abre
--
-- 
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity bloco_controle is
end entity;


architecture structural of bloco_controle is
begin
end architecture;
