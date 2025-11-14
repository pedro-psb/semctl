-- map_range
-- Recebe uma entranda signed de N bits
-- Transforma em uma saida signed de M bits
-- A saida se relaciona proporcionalmente com a entrada
-- Idealmente, M tem 5 bits podendo influenciar em no máximo 16s o tempo do sinal
-- Vamos adotar o uso de  "generic"  para poder alterar esse valor conforme necessário

-- Da forma em que está escrito o código precisa de uma saida M de no mínimo 4 bits
  
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity map_range is
  generic (
      N : integer := 10;
      M : integer := 5
    );

  port (
    a : in  signed(N-1 downto 0);          --entrada
    e0: in std_logic;                      --enable
    s : out signed(M-1 downto 0)           --saida
  );
end entity;


architecture Behavioral of map_range is

    
    FUNCTION OR_Reduce (Vetor : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
        VARIABLE Result : STD_LOGIC := '0';
    BEGIN
        FOR i IN Vetor'RANGE LOOP
            Result := Result OR Vetor(i);
        END LOOP;
        RETURN Result;
    END FUNCTION OR_Reduce;

BEGIN   
  --preservar o sinal
  
  s(M-1) <= a(N-1);
    
  --definir o módulo  
  
  s(M-2) <= OR_Reduce(a ((N-2) DOWNTO ((3*N)/4)); 
    
  s(M-3) <= OR_Reduce(a ((3*N)/4) - 1) DOWNTO ((N/2));
      
  s(M-4) <= OR_Reduce(a ((N/2) - 1) DOWNTO (N/4);
  
  s(M-5) <= OR_Reduce(a ((N/4) - 1) DOWNTO 0); 

END ARCHITECTURE Dataflow;