-- Somador Signed - Soma duas entradas signed e retorna signed
-- 
-- generic:
--   N - Tamanho do numero signed de entrada
-- input:
--   a: N bits
--   b: N bits
-- output:
--   output: N+1 bits
-- 
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;


entity somador_signed is
  generic (N : integer := 4);
  port (
    a, b : in  signed(N-1 downto 0);
    output : out signed(N downto 0)
  );
end entity;


architecture dataflow of somador_signed is
begin
  output <= RESIZE(a, output'length) + RESIZE(b, output'length);
end architecture;


