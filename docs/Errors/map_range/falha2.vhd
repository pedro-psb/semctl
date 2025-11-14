LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; -- Necessário para SHIFT_RIGHT e tipo SIGNED


ENTITY map_range IS
  GENERIC (
      N : INTEGER := 10; -- Tamanho da entrada (N_BITS)
      M : INTEGER := 5  -- Tamanho da saída (M_BITS)
    );

  PORT (
    a : IN  SIGNED(N-1 DOWNTO 0);          
    e0: IN STD_LOGIC;                      
    s : OUT SIGNED(M-1 DOWNTO 0)           
  );
END ENTITY map_range;


ARCHITECTURE Behavioral OF map_range IS
    -- 1. CORREÇÃO: Usar N e M
    CONSTANT SHIFT_AMOUNT : INTEGER := N - M;
    
    -- 2. CORREÇÃO: Usar N para o tamanho do sinal temporário
    -- O sinal temporário deve ter o mesmo tamanho da entrada 'a' para usar SHIFT_RIGHT
    SIGNAL temp_shifted : SIGNED(N - 1 DOWNTO 0);

BEGIN
    -- O enable (e0) não está sendo usado. Se for para controlar a saída, 
    -- precisaria de um IF/ELSE em um PROCESS. Assumindo lógica combinacional:
    
    -- Realiza o deslocamento aritmético (trunca N-M LSBs) para preservar o sinal.
    -- Esta é a operação de escalonamento proporcional (s = a / 2^(N-M))
    temp_shifted <= SHIFT_RIGHT(a, SHIFT_AMOUNT);
    
    -- Atribui a fatia mais significativa do resultado do deslocamento à saída 's'.
    s <= temp_shifted(M - 1 DOWNTO 0); 
    
    
END ARCHITECTURE Behavioral;