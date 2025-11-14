-- Detector de transição 0/1
--
-- input:
--  In_Car: 1 bit - Entrada da fms
--   clk: 1 bit - Entrada do clock
-- output:
--   Out_Car: 1 bit - Saida 
--   ss: 1 bit - Saida do estado interno
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
use IEEE.std_logic_1164.all;


entity car_detector is port (
    In_Car, CLK, RST : in std_logic; 
    Out_Car : out std_logic;
    SS : out std_logic
); end entity;


architecture car_detector of car_detector is
    signal PS, NS : std_logic;
begin
    -- Processo sequencial
    sync_proc: process(CLK, RST)
begin
    if RST = '1' then
        PS <= '0'; -- Define o estado inicial ('0') no reset
    elsif (rising_edge(CLK)) then 
        PS <= NS;
    end if;
end process sync_proc;

    -- Externalizar estados
    SS <= PS;

    -- Processo combinacional
    comb_proc: process(PS, In_Car) begin
      case PS is
          when '0' =>
              if (In_Car='1') then Out_Car<='1'; NS <= '1';
              else Out_Car<='0'; NS <= PS;
              end if;
          when '1' =>
              if (In_Car='1') then Out_Car<='0'; NS <= PS;
              else Out_Car<='0'; NS <= '0';
              end if;
          when others =>  
            NS <= '0';     
            Out_Car <= 'X'; 
          
      end case;
    end process comb_proc;
end car_detector;

--OBS.:RST tem é uma das variáveis que devem ser inicializadas no projeto completo
