library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_semctl is
end entity tb_semctl;

architecture testbench of tb_semctl is


  component semctl is
    port (
      clk_10ms, rst : in  std_logic;
      out_fsm : out  std_logic_vector(9 downto 0);
      in_mad, in_car1, in_car2 : in  std_logic;
      sem1 : out std_logic_vector(1 downto 0);
      sem2 : out std_logic_vector(1 downto 0);
      ped1 : out std_logic_vector(1 downto 0);
      ped2 : out std_logic_vector(1 downto 0);
      ped3 : out std_logic_vector(1 downto 0);
      count_value : out unsigned(4 downto 0)
    );
  end component;

  component clock_converter is
    generic (
      DIV_FACTOR : integer := 50000
    );
    port (
      in_clk  : in  std_logic;
      out_clk : out std_logic;
      RST     : in  std_logic
    );
  end component;

  component unsigned_hex_decoder is
    port (
      unsigned_value : in  unsigned(3 downto 0);
      display_config : out std_logic_vector(6 downto 0)
    );
  end component;

  -- sinais to testbench
  signal clk_10ms, rst :  std_logic;
  signal clk_1s :  std_logic;
  signal out_fsm :  std_logic_vector(9 downto 0);
  signal in_mad, in_car1, in_car2 :  std_logic := '0';
  signal sem1 : std_logic_vector(1 downto 0);
  signal sem2 : std_logic_vector(1 downto 0);
  signal ped1 : std_logic_vector(1 downto 0);
  signal ped2 : std_logic_vector(1 downto 0);
  signal ped3 : std_logic_vector(1 downto 0);
  signal count_value : unsigned(4 downto 0);
  signal count_display : std_logic_vector(6 downto 0);

  -- sinais auxiliares
  signal clk_enable: std_logic := '1';
  constant CLK_PERIOD : time := 10 ms;

  -- Procedure to wait for specified number of clk_1s cycles
  procedure wait_for(cycles : in integer) is
  begin
    for i in 1 to cycles-1 loop
      wait until rising_edge(clk_1s);
    end loop;
  end procedure;

begin
  uut: semctl
    port map (
      clk_10ms  => clk_10ms,
      rst  => rst,
      out_fsm  => out_fsm,
      in_mad  => in_mad,
      in_car1  => in_car1,
      in_car2  => in_car2,
      sem1  => sem1,
      sem2  => sem2,
      ped1  => ped1,
      ped2  => ped2,
      ped3  => ped3,
      count_value => count_value
    );

  clk_process: process
  begin
    clk_10ms <= '0';
    wait for CLK_PERIOD/2;
    while clk_enable = '1' loop
      clk_10ms <= '0';
      wait for CLK_PERIOD/2;
      clk_10ms <= '1';
      wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;


  in_car_process : process
  begin
    while clk_enable = '1' loop
      in_car1 <= '0';
      wait for 0.1 sec;
      in_car1 <= '1';
      wait for 0.1 sec;
    end loop;
    wait;
  end process;

  -- Clock generation: 100Hz (10ms) -> 1Hz (1s)
  clk_conv_1s : clock_converter
    generic map(
      DIV_FACTOR => 50  -- 100Hz / (2 * 1Hz) = 50
    )
    port map(
      in_clk => clk_10ms,
      out_clk => clk_1s,
      RST => rst
    );

  -- Count display decoder for waveform visualization
  count_hex_decoder : unsigned_hex_decoder
    port map(
      unsigned_value => count_value(3 downto 0),
      display_config => count_display
    );

  test_process: process
  begin
    -- Initialize all inputs
    rst <= '1';
    in_mad <= '0';


    wait for 0.03 sec;
    rst <= '0';
    wait for 0.07 sec;
    assert out_fsm = "1000000000";

    -- roda duas vezes para garantir consistencia
    for i in 2 downto 1 loop
      -- ciclo polaridade=1 (para direita)
      wait until out_fsm = "0000001000";
      wait_for(7); -- Wait partial time to verify state stability
      assert out_fsm = "0000001000";

      wait until out_fsm = "0000000100";
      wait_for(7);
      assert out_fsm = "0000000100";

      wait until out_fsm = "0000000010";
      wait_for(7);
      assert out_fsm = "0000000010";

      wait until out_fsm = "0000000001";
      wait_for(7);
      assert out_fsm = "0000000001";

      -- ciclo polaridade=0 (para esquerda)
      wait until out_fsm = "0000001000";
      wait_for(7);
      assert out_fsm = "0000001000";

      wait until out_fsm = "0000010000";
      wait_for(7);
      assert out_fsm = "0000010000";

      wait until out_fsm = "0000100000";
      wait_for(7);
      assert out_fsm = "0000100000";

      wait until out_fsm = "0001000000";
      wait_for(7);
      assert out_fsm = "0001000000";
    end loop;

    -- Testando Modo Madrugada (commented out for basic test)
    in_mad <= '1';
    wait_for(7);
    assert out_fsm = "0000001000";

    wait_for(7);
    assert out_fsm = "0100000000";

    wait_for(7*3);
    assert out_fsm = "0100000000";
    in_mad <= '0';


    wait_for(7);
    assert out_fsm = "0000001000";

    report "Testbench executado com sucesso - sistema funcionando";
    clk_enable <= '0';
    wait;
  end process;
end architecture testbench;
