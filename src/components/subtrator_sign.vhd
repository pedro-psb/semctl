-- Subtrator Signed - Subtrai duas entradas unsigned e retorna signed
-- 
-- generic:
--   N - Tamanho dos numeros unsigned de entrada
-- input:
--   a: N bits
--   b: N bits
--   inverte: 1 bits - Quando inverte=1, faz b-a. Caso contrario, a-b
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


entity subtrator_sign is
  generic (N : integer := 6);
  port (
    a, b : in  unsigned(N-1 downto 0);
    inverte: in std_logic;
    output : out signed(N downto 0)
  );
end entity;


architecture dataflow of subtrator_sign is
begin
  output <=
    SIGNED(RESIZE(b, output'length) - RESIZE(a, output'length)) when inverte = '1' else
    SIGNED(RESIZE(a, output'length) - RESIZE(b, output'length));
end architecture;


