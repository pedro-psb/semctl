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
  use  ieee.numeric_std.all;

entity car_detector is port
(
    SET  : in  std_logic;
    CLK : in  std_logic;
    Q   : out std_logic
  );
end entity;


architecture Behavioral of car_detector is
  signal tmp : std_logic := '0';
  signal prev_set : std_logic := '0';
begin
  Q <= tmp;
  process(CLK)
  begin
    if (rising_edge(CLK)) then
      if (prev_set = '0' and SET = '1') then
        tmp <= '1';
      else
        tmp <= '0';
      end if;
      prev_set <= SET;
    end if;
  end process;
end architecture;
