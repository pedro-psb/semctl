-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
--
-- map_range
-- Recebe uma entranda signed de N bits
-- Transforma em uma saida signed de M bits
-- C é a diferença abs de bits entre N e M
-- Idealmente, M tem 5 bits podendo influenciar em no máximo 16s o tempo do sinal
-- Vamos adotar o uso de  "generic"  para poder alterar esse valor conforme necessário
-- Da forma em que está escrito o código precisa de uma saida M de no mínimo 4 bits
  
-- map_range
-- Recebe uma entranda signed de N bits
-- Transforma em uma saida signed de M bits
-- Idealmente, M tem 5 bits podendo influenciar em no máximo 16s o tempo do sinal
-- Vamos adotar o uso de  "generic"  para poder alterar esse valor conforme necessário
-- Da forma em que está escrito o código precisa de uma saida M de no mínimo 4 bits
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity map_range is
  generic (
      N : integer := 7;
      M : integer := 5
    );

  port (
    a : in  signed(N-1 downto 0);          --entrada
    e0: in std_logic;                      --enable
    s : out signed(M-1 downto 0)           --saida
  );
end entity;


ARCHITECTURE Behavioral OF map_range IS
signal en0: signed(M-1 downto 0); --vetor do enable 
signal saida: std_logic_vector(M-1 downto 0);--signal para saida


BEGIN

  -- Caso os valores de M e N sejam alterados, substituir 2 pela diferença entre M e N
  saida <= std_logic_vector(a(N-1 downto 2));
  
  en0 <= (others => e0);     	--Enable em um código dataflow
  
  s <= 	signed(saida) when e0 = '1' else
  		signed(en0)	when e0 = '0';	
        
    
END ARCHITECTURE Behavioral;