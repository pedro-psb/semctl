-- Registrador de Deslocamento
-- 
-- generic:
--   N - Tamanho do registrador em bits
-- input:
--   in_car: 1 bit
--   clk: 1 bit
--   enable: 1 bit
--   rst: 1 bit
-- output:
--   output: N bits  (e.g  N=10,  0100001001)

library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;


entity reg_deslocamento is
  generic (N : integer := 4);
  port (
    in_car, clk, rst, enable : in  std_logic;
    output : out std_logic_vector(N-1 downto 0)
  );
end entity;


architecture behavoral of reg_deslocamento  is
begin
  process(clk, rst) is
    variable resized_in : STD_LOGIC_VECTOR(N-1 downto 0);
    variable shifted_out :  STD_LOGIC_VECTOR(N-1 downto 0);
  begin
    -- se enable = '0', mantem memoria inalterada
    if (rising_edge(clk) and enable = '1') then
      -- shift output antes e preenche com zero
      -- e.g, 1000 -> 0100, 0100 -> 0010
      shifted_out := output srl  1;   -- shift right logical (preenche com 0's)

      -- cria vetor com in_car como MSD
      -- e.g, '1' -> "1000", '0' -> "0000"
      resized_in :=     (others => '0');
      resized_in(N-1) := in_car;

      -- adiciona in_car no MSD e descarta LSD
      -- e.g (in_car=1) "1001" -> "1100"
      -- e.g (in_car=1) "0011" -> "1001"
      -- e.g (in_car=0) "1000" -> "0100"
      output <= shifted_out or resized_in;
    elsif (rst = '1') then
      output <= (others => '0');
    end if;
  end process;
end architecture;


