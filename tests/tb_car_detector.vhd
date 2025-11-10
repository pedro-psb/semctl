library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_car_detector is
end entity tb_car_detector;

architecture testbench of tb_car_detector is

    constant CLK_PERIOD : time := 10 ns;
    signal clk_enable : boolean := true;

    component car_detector is
        port (
            In_Car  : in  std_logic;
            CLK     : in  std_logic;
            RST     : in  std_logic;
            Out_Car : out std_logic;
            SS      : out std_logic
        );
    end component;


    signal in_car_tb  : std_logic := '0';
    signal clk_tb     : std_logic := '0';
    signal rst_tb     : std_logic := '1';
    signal out_car_tb : std_logic := '0';
    signal ss_tb      : std_logic := '0';

begin

    uut: car_detector
        port map (
            In_Car  => in_car_tb,
            CLK     => clk_tb,
            RST     => rst_tb,
            Out_Car => out_car_tb,
            SS      => ss_tb
        );


    clk_process: process
    begin
        while clk_enable loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    test_process: process
    begin
        rst_tb <= '1';
        wait for 3 * CLK_PERIOD; 
        rst_tb <= '0';
        wait for 2 * CLK_PERIOD; 
        
        in_car_tb <= '1';
        wait for 1 * CLK_PERIOD; 
        
        in_car_tb <= '1';
        wait for 2 * CLK_PERIOD;
        
        in_car_tb <= '0';
        wait for 1 * CLK_PERIOD;
        
        in_car_tb <= '1'; 
        wait for 1 * CLK_PERIOD;
        
        in_car_tb <= '0';
        wait for 4 * CLK_PERIOD; 
        
        clk_enable <= false; 
        wait;
    end process;

end architecture testbench;
