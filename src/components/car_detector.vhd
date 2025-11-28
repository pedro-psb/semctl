-- Detector de transição 0/1
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
--
-- input:
--   CLK: 	1 bit - Entrada do clock
--   SET: 	1 bit - Entrada do sensor
-- output:
--    Q: 	1 bit - Saida 
--

library IEEE;
use IEEE.std_logic_1164.all;

entity car_detector is port (
        SET	: in  std_logic;
        CLK : in  std_logic;
        Q 	: out std_logic
        ); 
end entity;


architecture Behavioral of car_detector is
    
begin

    process(CLK, Set)
    begin
        -- Set assíncrono (segunda prioridade)
        if (Set'event and Set = '1') then
            Q <= '1';
        -- Lógica síncrona dependente do clock
        elsif (CLK'event and CLK = '1') then  -- Reset      
                Q <= '0';
        end if;
    end process;
end architecture;