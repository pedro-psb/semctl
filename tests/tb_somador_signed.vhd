library ieee;
  use ieee.std_logic_1164.all;
  use  ieee.numeric_std.all;

entity tb_somador_signed is
end entity;

architecture testbench of tb_somador_signed is
  constant N : integer := 4;
  constant WAIT_TIME : time := 10 ns;
  signal a : signed(N-1 downto 0);
  signal b : signed(N-1 downto 0);
  signal output : signed(N downto 0);

  -- Utilitario para assercoes
  procedure check_output(
    actual    : in signed;
    i : in integer;
    j : in integer
  ) is
    variable result : signed(output'length-1 downto 0);
    variable i_signed : signed(a'length-1 downto 0);
    variable j_signed : signed(b'length-1 downto 0);
  begin
    result := TO_SIGNED(i+j, output'length);
    i_signed := TO_SIGNED(i, a'length);
    j_signed := TO_SIGNED(j, a'length);
    if not actual = result then
      report "FALHA: " & to_string(i_signed) & "+" & to_string(j_signed) & "!=" & to_string(output) & ". Esperava: " & to_string(result)
        severity error;
    else
    end if;
  end procedure;

begin
  UUT: entity work.somador_signed
    generic map ( N => N )
    port map (
      a => a,
      b => b,
      output => output
    );

  -- 4. Processo de estímulo
  stimulus_proc: process is
  begin
    report "Rodando testes...";
    for i in -8 to 7 loop
      for j in -8 to 7 loop
        a <= TO_SIGNED(i, a'length);
        b <= TO_SIGNED(j, b'length);
        wait for WAIT_TIME;
        check_output(output, i, j);
      end loop;
    end loop;
    report "Parabens, todos os tested passaram!";
    wait; -- Para a simulação indefinidamente
  end process stimulus_proc;
end architecture;
