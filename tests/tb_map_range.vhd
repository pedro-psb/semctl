-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_map_range IS
END ENTITY tb_map_range;

ARCHITECTURE behavioral OF tb_map_range IS
    
    CONSTANT N_BITS_TB : INTEGER := 7;
    CONSTANT M_BITS_TB : INTEGER := 5;
    

    SIGNAL tb_done : BOOLEAN := FALSE;

    COMPONENT map_range
        GENERIC (
            N : INTEGER := 7;
            M : INTEGER := 5
        );
        PORT (
            a  : IN  SIGNED(N - 1 DOWNTO 0);
            e0 : IN  STD_LOGIC;
            s  : OUT SIGNED(M - 1 DOWNTO 0)
        );
    END COMPONENT map_range;

    SIGNAL a_tb  : SIGNED(N_BITS_TB - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL e0_tb : STD_LOGIC := '0';
    SIGNAL s_tb  : SIGNED(M_BITS_TB - 1 DOWNTO 0);

BEGIN

    UUT : ENTITY WORK.map_range
        GENERIC MAP (
            N => N_BITS_TB,
            M => M_BITS_TB
        )
        PORT MAP (
            a  => a_tb,
            e0 => e0_tb,
            s  => s_tb
        );
        
    stim : PROCESS
    BEGIN
        -- Estímulos para o teste
        e0_tb <= '0';
        a_tb <= "1000001";  -- -63
        wait for 10 ns;
        
        a_tb <= "0001111";  -- 15
        wait for 10 ns;
        
        a_tb <= "0111111";  -- 63
        wait for 10 ns;
        
        a_tb <= "0011110";  -- 30
        wait for 10 ns;
        
        a_tb <= "1100010";  -- -30
        wait for 10 ns;
        
        a_tb <= "1110001";  -- -15
        wait for 10 ns;
        
        -- Alteração do sinal e0_tb
        e0_tb <= '1';
        a_tb <= "1000001";  -- -63
        wait for 10 ns;
        
        a_tb <= "0001111";  -- 15
        wait for 10 ns;
        
        a_tb <= "0111111";  -- 63
        wait for 10 ns;
        
        a_tb <= "0011110";  -- 30
        wait for 10 ns;
        
        a_tb <= "1100010";  -- -30
        wait for 10 ns;
        
        a_tb <= "1110001";  -- -15
        wait for 10 ns;
        
        wait;
    END PROCESS stim;
END ARCHITECTURE behavioral;