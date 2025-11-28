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
    in_car, clk, rst, enable : in  std_logic;
    output : out std_logic_vector(N-1 downto 0)
  );
end entity;


architecture structural of reg_deslocamento  is
  component reg is
    port (
      data_in, clk, rst, enable : in  std_logic;
      data_out : out std_logic
    );
  end component;

  -- sinal auxiliar para mapeamento dos registradores
  signal tmp_reg : std_logic_vector(N downto 0);
begin
  tmp_reg(N) <= in_car;
  output <= tmp_reg(N-1 downto 0);
  instance_regs : for i in 0 to N-1 generate
    reg_i : reg port map (
        data_in => tmp_reg(i+1),
        data_out => tmp_reg(i),
        clk => clk,
        enable => enable,
        rst => rst
      );
  end generate;

end architecture;


