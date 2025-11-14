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


ARCHITECTURE Behavioral OF map_range IS
BEGIN
    PROCESS(a, e0) 
        VARIABLE Max_SN_val : INTEGER;
        VARIABLE Max_SM_val : INTEGER;
        VARIABLE A_val      : INTEGER;
        VARIABLE S_val      : INTEGER;
    BEGIN
        
        IF e0 = '1' THEN -- calcula o resultado da saida
            
            -- Lógica de Escalonamento 
            A_val := TO_INTEGER(ABS(a)); 
            Max_SN_val := 2**(N-1) - 1; 
            Max_SM_val := 2**(M-1) - 1;
            
            IF Max_SN_val /= 0 THEN
                S_val := (A_val * Max_SM_val) / Max_SN_val;
            ELSE
                S_val := 0; 
            END IF;

            -- Atribuição de Sinal 
            IF a(N-1) = '1' THEN
                S <= TO_SIGNED(-S_val, M);
            ELSE
                S <= TO_SIGNED(S_val, M);
            END IF;

        ELSE --zera a saida
          S <= (OTHERS => '0'); 
            
        END IF;
        
    END PROCESS;
END ARCHITECTURE Behavioral;
