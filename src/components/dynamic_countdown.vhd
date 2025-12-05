-- dynamic_countdown.vhd
--
-- Contador regressivo dinamico:
-- O tempo de recarga é definido pela soma:
--     default_time + increment
--
-- O somador_signed ajusta dinamicamente o próximo tempo.
-- O config_countdown realiza a contagem regressiva.
--
-- Entradas:
--   increment     : signed(4 downto 0) - valor que ajusta o tempo base
--   default_time  : unsigned(4 downto 0) - tempo padrao do semaforo
--   rst           : reset sincronizado
--   clk           : clock
--
-- Saidas:
--   count_done    : '1' quando o contador chega a zero
--   count_value   : valor atual do contador (opcional)
--
-- Guilherme Augusto
-- Pedro Armando
-- Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;

entity dynamic_countdown is
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    default_time : in  unsigned(4 downto 0);
    increment    : in  signed(4 downto 0);
    count_done   : out std_logic;
    count_value  : out unsigned(4 downto 0)
  );
end entity;

architecture structural of dynamic_countdown is

  -- Sinais internos
  signal adjusted_time : signed(5 downto 0);    -- soma tem 6 bits
  signal adjusted_u    : unsigned(4 downto 0);  -- versao reduzida p/ contador
  signal count_current : unsigned(4 downto 0);

  -- COMPONENTES
  component somador_signed is
    generic (N : integer := 4);
    port (
      a, b   : in  signed(N-1 downto 0);
      output : out signed(N downto 0)
    );
  end component;

  component config_countdown is
    generic (
      WIDTH : integer := 5
    );
    port(
      clk   : in std_logic;
      reset : in std_logic;
      N     : in unsigned(WIDTH-1 downto 0);
      X     : out unsigned(WIDTH-1 downto 0)
    );
  end component;

begin

  --------------------------------------------------------------------
  -- SOMA: adjusted_time = default_time + increment
  --------------------------------------------------------------------
  somador : somador_signed
    generic map (N => 5)
    port map (
      a      => signed(default_time), -- converter UNSIGNED para SIGNED
      b      => increment,
      output => adjusted_time
    );

  --------------------------------------------------------------------
  -- Converte resultado signed para unsigned (mantem 5 bits inferiores)
  --------------------------------------------------------------------
  adjusted_u <= unsigned(adjusted_time(4 downto 0));

  --------------------------------------------------------------------
  -- CONTADOR REGRESSIVO
  --------------------------------------------------------------------
  countdown_inst : config_countdown
    generic map (WIDTH => 5)
    port map (
      clk   => clk,
      reset => rst,
      N     => adjusted_u,
      X     => count_current
    );

  --------------------------------------------------------------------
  -- SAIDAS
  --------------------------------------------------------------------
  count_value <= count_current;
  count_done  <= '1' when count_current = 0 else '0';

end architecture structural;
