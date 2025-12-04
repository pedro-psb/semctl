-- Registrador 1 bit
--
-- input:
--   data_in: 1 bit
--   clk: 1 bit
--   rst: 1 bit
-- output:
--   data_out: 1

library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;


entity reg is
  port (
    data_in, clk, rst: in  std_logic;
    data_out : out std_logic
  );
end entity;


architecture behavoral of reg  is
begin
  process(clk, rst) is
  begin
    if (rst = '1') then
      data_out <= '0';
    elsif (rising_edge(clk)) then
      data_out <= data_in;
    -- else -- mantem memoria inalterada (e.g, enable='0')
    end if;
  end process;
end architecture;


