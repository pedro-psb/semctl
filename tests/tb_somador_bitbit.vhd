-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
-- arquivo correto

library ieee;
use ieee.std_logic_1164.all;
use  ieee.numeric_std.all;

entity tb_somador is
end entity tb_somador;

architecture test of tb_somador is
    constant C_N_BITS : integer := 8;
    constant C_M_BITS : integer := 4;
	constant C_WAIT_TIME : time := 10 ns;
    signal s_data_in : std_logic_vector(C_N_BITS-1 downto 0);
    signal s_sum_out : std_logic_vector(C_M_BITS-1 downto 0);

begin
	UUT: entity work.somador(dataflow)
        generic map (
            N_BITS => C_N_BITS,
            M_BITS => C_M_BITS
        )
        port map (
            data_in => s_data_in,
            sum_out => s_sum_out
        );
	
    -- 4. Processo de estímulo
    stimulus_proc: process is
    begin
        report "Iniciando teste do somador de N bits...";
        
        -- Caso 1: Tudo zero
        -- (others => '0') é um atalho para "00000000"
        s_data_in <= (others => '0');
        wait for C_WAIT_TIME; -- Espera 10 ns para o sinal propagar
        -- Na simulação, verifique se sum_out é "0000"

        -- Caso 2: Apenas um bit '1'
        -- (0 => '1') significa que o bit 0 é '1'
        s_data_in <= (0 => '1', others => '0'); -- "00000001"
        wait for C_WAIT_TIME;
        -- Na simulação, verifique se sum_out é "0001"

        -- Caso 3: Todos '1' (valor máximo)
        s_data_in <= (others => '1'); -- "11111111"
        wait for C_WAIT_TIME;
        -- Na simulação, verifique se sum_out é "1000" (que é 8)

        -- Caso 4: Um valor misto
        s_data_in <= "10110010"; -- 4 bits '1'
        wait for C_WAIT_TIME;
        -- Na simulação, verifique se sum_out é "0100" (que é 4)
        
        report "Teste concluído.";
        wait; -- Para a simulação indefinidamente
        
    end process stimulus_proc;
    
end architecture test;