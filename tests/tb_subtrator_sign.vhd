-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;

entity tb_subtrator_sign is
end entity;

architecture testbench of tb_subtrator_sign is
  constant N : integer := 4;
  constant WAIT_TIME : time := 10 ns;
  signal a : unsigned(N-1 downto 0);
  signal b : unsigned(N-1 downto 0);
  signal inverte : std_logic;
  signal output : signed(N downto 0);

  -- Utilitario para assercoes
  procedure check_output(
    actual    : in signed;
    i : in integer;
    j : in integer
  ) is
    variable expected : signed(output'length-1 downto 0);
    variable i_unsigned : unsigned(a'length-1 downto 0);
    variable j_unsigned : unsigned(b'length-1 downto 0);
  begin
    expected := TO_SIGNED(i-j, output'length);
    i_unsigned := TO_UNSIGNED(i, a'length);
    j_unsigned := TO_UNSIGNED(j, a'length);
    if not (actual = expected) then
      report "FALHA: " & to_string(i_unsigned) & "-" & to_string(j_unsigned) & "!=" & to_string(output) & ". Esperava: " & to_string(expected)
        severity failure;
    end if;
  end procedure;

begin
  UUT: entity work.subtrator_sign
    generic map ( N => N )
    port map (
      a => a,
      b => b,
      inverte => inverte,
      output => output
    );

  -- 4. Processo de estímulo
  stimulus_proc: process is
  begin
    report "Rodando testes...";
    for i in 0 to 2**N-1 loop
      for j in 0 to 2**N-1 loop
        a <= TO_UNSIGNED(i, a'length);
        b <= TO_UNSIGNED(j, b'length);

        -- tests o caso normal
        inverte <= '0';
        wait for WAIT_TIME;
        check_output(output, i, j);

        -- testa a flag de inverter
        inverte <= '1';
        wait for WAIT_TIME;
        check_output(output, j, i);
      end loop;
    end loop;
    wait; -- Para a simulação indefinidamente
  end process stimulus_proc;
end architecture;
