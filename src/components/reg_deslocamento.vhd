-- Registrador de Deslocamento
--
-- generic:
--   N - Tamanho do registrador em bits
-- input:
--   in_car: 1 bit
--   clk: 1 bit
--   rst: 1 bit
-- output:
--   output: N bits  (e.g  N=10,  0100001001)
-- 
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;


entity reg_deslocamento is
  generic (N : integer := 64);
  port (
    in_car, clk, rst: in  std_logic;
    reg_out : out std_logic_vector(N-1 downto 0)
  );
end entity;


architecture behavoral of reg_deslocamento  is
  signal internal_reg : std_logic_vector(N-1 downto 0);
begin
  -- Connect internal signal to output
  reg_out <= internal_reg;

  process(clk, rst) is
    variable resized_in : STD_LOGIC_VECTOR(N-1 downto 0);
    variable shifted_out :  STD_LOGIC_VECTOR(N-1 downto 0);
  begin
    if (rst = '1') then
      internal_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      -- shift output antes e preenche com zero
      -- e.g, 1000 -> 0100, 0100 -> 0010
      shifted_out := std_logic_vector(unsigned(internal_reg) srl 1);   -- shift right logical (preenche com 0's)

      -- cria vetor com in_car como MSD
      -- e.g, '1' -> "1000", '0' -> "0000"
      resized_in :=     (others => '0');
      resized_in(N-1) := in_car;

      -- adiciona in_car no MSD e descarta LSD
      -- e.g (in_car=1) "1001" -> "1100"
      -- e.g (in_car=1) "0011" -> "1001"
      -- e.g (in_car=0) "1000" -> "0100"
      internal_reg <= shifted_out or resized_in;
    end if;
  end process;
end architecture;

