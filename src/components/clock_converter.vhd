-- Clock Converter (Divisor de Clock)
--
-- Este módulo divide a frequência de um clock de entrada, gerando um clock
-- mais lento na saída. A saída alterna entre '0' e '1' a cada DIV_FACTOR
-- ciclos do clock de entrada.
--
-- Fórmulas úteis:
--   * freq_out = freq_in / (2 * DIV_FACTOR)
--   * DIV_FACTOR = freq_in / (2 * freq_out)
-- 
-- generic:
--   DIV_FACTOR : integer
--       Fator de divisão.
--       Cada alternância do clock de saída ocorre a cada DIV_FACTOR ciclos.
--       OBS: A frequência final será dividida por 2 * DIV_FACTOR.
--
-- inputs:
--   in_clk : std_logic -  Clock de entrada.
--   RST : std_logic    -  Reset assíncrono. Quando '1', zera contador e saída.
--
-- outputs:
--   out_clk : std_logic -  Clock dividido.
--
-- Exemplos:
--
--   Suponha freq_in = 50 MHz → T_in = 20 ns
--
--   1) Gerar clock de 1 segundo (freq_out = 1 Hz)
--        DIV_FACTOR = freq_in / (2 * freq_out)
--                   = 50_000_000 / 2
--                   = 25_000_000
--
--   2) Gerar clock de 0,5 s (freq_out = 2 Hz)
--        DIV_FACTOR = 50_000_000 / (2 * 2)
--                   = 12_500_000
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity clock_converter is
  generic (
    DIV_FACTOR : integer := 50000 -- 50000 valor default
  );
  port (
    in_clk  : in  std_logic;
    out_clk : out std_logic;
    RST     : in  std_logic
  );
end entity clock_converter;

architecture behavioral of clock_converter is
  signal s_contador_reg  : integer range 0 to DIV_FACTOR-1 := 0;
  signal s_clk_out_reg   : std_logic := '0'; -- boa pratica, se conecta à saída
begin
  process (in_clk, RST) is
  begin
    if RST = '1' then
      s_contador_reg <= 0;
      s_clk_out_reg  <= '0';

    elsif rising_edge(in_clk) then
      if s_contador_reg = DIV_FACTOR-1 then
        s_contador_reg <= 0;
        s_clk_out_reg  <= not s_clk_out_reg;
      else
        s_contador_reg <= s_contador_reg + 1;
      end if;
    end if;

  end process;

  out_clk <= s_clk_out_reg;

end architecture behavioral;
