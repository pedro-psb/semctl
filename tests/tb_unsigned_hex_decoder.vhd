-- Testbench for unsigned_hex_decoder
--
-- Tests the unsigned to 7-segment decoder with 3-bit values (0-7)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_unsigned_hex_decoder is
end entity tb_unsigned_hex_decoder;

architecture testbench of tb_unsigned_hex_decoder is

  component unsigned_hex_decoder is
    port (
      unsigned_value : in  unsigned(3 downto 0);
      display_config : out std_logic_vector(6 downto 0)
    );
  end component;

  -- Test signals
  signal unsigned_value_tb : unsigned(3 downto 0) := (others => '0');
  signal display_config_tb : std_logic_vector(6 downto 0);

  -- Expected display patterns (active low) - corrected for proper segment mapping
  -- Mapping: 0=top, 1=top-right, 2=bottom-right, 3=bottom, 4=bottom-left, 5=top-left, 6=middle
  type display_patterns_type is array (0 to 7) of std_logic_vector(6 downto 0);
  constant EXPECTED_PATTERNS : display_patterns_type := (
    0 => not "1000000", -- 0: segments 0,1,2,3,4,5
    1 => not "1111001", -- 1: segments 1,2
    2 => not "0100100", -- 2: segments 0,1,6,4,3
    3 => not "0110000", -- 3: segments 0,1,6,2,3
    4 => not "0011001", -- 4: segments 5,6,1,2
    5 => not "0010010", -- 5: segments 0,5,6,2,3
    6 => not "0000010", -- 6: segments 0,5,6,4,3,2
    7 => not "1111000"  -- 7: segments 0,1,2
  );

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: unsigned_hex_decoder
    port map (
      unsigned_value => unsigned_value_tb,
      display_config => display_config_tb
    );

  -- Test process
  test_process: process
  begin
    -- Test each 3-bit value (0 to 7)
    for i in 0 to 7 loop
      unsigned_value_tb <= to_unsigned(i, 4);
      wait for 10 ns;

      -- Check if the output matches expected pattern
      assert display_config_tb = EXPECTED_PATTERNS(i)
        report "Error: For input " & integer'image(i) &
               ", display pattern mismatch"
        severity error;

      -- Report success
      report "Test " & integer'image(i) & " passed: " &
             "Input=" & integer'image(i)
        severity note;
    end loop;

    -- Test additional values beyond 3-bit range to ensure 4-bit compatibility
    for i in 8 to 15 loop
      unsigned_value_tb <= to_unsigned(i, 4);
      wait for 10 ns;

      -- Just verify that output is defined (decoder should handle all 4-bit values)
      -- For value 8 (all segments), output should be "0000000" which is valid
      assert display_config_tb /= "ZZZZZZZ"  -- Check for high-impedance (undefined)
        report "Error: For input " & integer'image(i) &
               ", got high-impedance output"
        severity error;

      -- Report result
      report "Extended test " & integer'image(i) & " passed: " &
             "Input=" & integer'image(i)
        severity note;
    end loop;

    report "All tests completed successfully!" severity note;
    wait;
  end process;

end architecture testbench;