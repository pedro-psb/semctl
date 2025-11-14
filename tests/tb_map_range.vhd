LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Define a precisão do tempo para o testbench
ENTITY tb_map_range IS
END ENTITY tb_map_range;

ARCHITECTURE behavioral OF tb_map_range IS

    -- Constantes para a DUT (Design Under Test)
    CONSTANT N_BITS_TB : INTEGER := 10;
    CONSTANT M_BITS_TB : INTEGER := 5;

    -- Sinal para finalizar a simulação
    SIGNAL tb_done : BOOLEAN := FALSE;

    -- Componente DUT (map_range)
    COMPONENT map_range
        GENERIC (
            N : INTEGER := 10;
            M : INTEGER := 5
        );
        PORT (
            a  : IN  SIGNED(N - 1 DOWNTO 0);
            e0 : IN  STD_LOGIC;
            s  : OUT SIGNED(M - 1 DOWNTO 0)
        );
    END COMPONENT map_range;

    -- Sinais para conectar à DUT
    SIGNAL a_tb  : SIGNED(N_BITS_TB - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL e0_tb : STD_LOGIC := '0';
    SIGNAL s_tb  : SIGNED(M_BITS_TB - 1 DOWNTO 0);

BEGIN

    -- Instanciação da DUT
    DUT : map_range
        GENERIC MAP (
            N => N_BITS_TB,
            M => M_BITS_TB
        )
        PORT MAP (
            a  => a_tb,
            e0 => e0_tb,
            s  => s_tb
        );

    -- Processo de Geração de Estímulos
    stim_proc : PROCESS
    BEGIN
        REPORT "Iniciando Testbench..." SEVERITY NOTE;

        -- --------------------------------------------------------
        -- TESTE 1: Estado Desabilitado (e0 = '0')
        -- Saída deve ser 0
        -- --------------------------------------------------------
        e0_tb <= '0';
        a_tb <= TO_SIGNED(511, N_BITS_TB); -- Entrada máxima
        WAIT FOR 10 ns;
        ASSERT (s_tb = (OTHERS => '0'))
            REPORT "ERRO 1: Saida nao zerou com e0='0'"
            SEVERITY ERROR;
        
        -- --------------------------------------------------------
        -- TESTE 2: Estado Habilitado (e0 = '1')
        -- --------------------------------------------------------
        e0_tb <= '1';
        WAIT FOR 10 ns;

        -- Caso A: Zero
        a_tb <= TO_SIGNED(0, N_BITS_TB);
        WAIT FOR 10 ns;
        ASSERT (s_tb = TO_SIGNED(0, M_BITS_TB))
            REPORT "ERRO 2A: Escalonamento de Zero"
            SEVERITY ERROR;

        -- Caso B: Máximo Positivo (511 -> 15)
        a_tb <= TO_SIGNED(511, N_BITS_TB);
        WAIT FOR 10 ns;
        ASSERT (s_tb = TO_SIGNED(15, M_BITS_TB))
            REPORT "ERRO 2B: Escalonamento de Maximo Positivo (Esperado 15)"
            SEVERITY ERROR;

        -- Caso C: Meio Positivo (256 -> 7)
        -- Valor de entrada: 256. Saida esperada: round(256 * 15 / 511) = 7.51 -> 8 (se arredondar) ou 7 (se truncar).
        -- Como o VHDL usa divisao de inteiros (truncamento), o resultado deve ser 7.
        a_tb <= TO_SIGNED(256, N_BITS_TB);
        WAIT FOR 10 ns;
        ASSERT (s_tb = TO_SIGNED(7, M_BITS_TB))
            REPORT "ERRO 2C: Escalonamento de Meio Positivo (Esperado 7)"
            SEVERITY ERROR;
            
        -- Caso D: Máximo Negativo (-512 -> -16)
        -- A faixa de N=10 vai de -512 a +511.
        -- O escalonamento de -512, se feito corretamente, deve ir para -16 (o M-bit Max Negativo).
        a_tb <= TO_SIGNED(-512, N_BITS_TB);
        WAIT FOR 10 ns;
        ASSERT (s_tb = TO_SIGNED(-16, M_BITS_TB))
            REPORT "ERRO 2D: Escalonamento de Maximo Negativo (Esperado -16)"
            SEVERITY ERROR;

        -- Caso E: Meio Negativo (-256 -> -7)
        -- Saída esperada: -round(256 * 15 / 511) -> -7 (truncado)
        a_tb <= TO_SIGNED(-256, N_BITS_TB);
        WAIT FOR 10 ns;
        ASSERT (s_tb = TO_SIGNED(-7, M_BITS_TB))
            REPORT "ERRO 2E: Escalonamento de Meio Negativo (Esperado -7)"
            SEVERITY ERROR;

        -- --------------------------------------------------------
        -- FIM DA SIMULAÇÃO
        -- --------------------------------------------------------
        REPORT "Testbench Finalizado com Sucesso." SEVERITY NOTE;
        tb_done <= TRUE;
        WAIT; 

    END PROCESS stim_proc;
    
    -- Termina a simulação quando tb_done for TRUE
    ASSERT NOT tb_done
        REPORT "Simulacao encerrada."
        SEVERITY NOTE;

END ARCHITECTURE behavioral;