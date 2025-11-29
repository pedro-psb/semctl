library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_semctl is
end entity tb_semctl;

architecture testbench of tb_semctl is

    component semctl is
      port (
        clk, rst : in  std_logic;
        out_fsm : out  std_logic_vector(9 downto 0);
        in_mad, in_car1, in_car2 : in  std_logic;
        sem1 : out std_logic_vector(1 downto 0);
        sem2 : out std_logic_vector(1 downto 0);
        ped1 : out std_logic_vector(1 downto 0);
        ped2 : out std_logic_vector(1 downto 0);
        ped3 : out std_logic_vector(1 downto 0)
      );
    end component;

    signal clk, rst :  std_logic;
    signal out_fsm :  std_logic_vector(9 downto 0);
    signal in_mad, in_car1, in_car2 :  std_logic;
    signal sem1 : std_logic_vector(1 downto 0);
    signal sem2 : std_logic_vector(1 downto 0);
    signal ped1 : std_logic_vector(1 downto 0);
    signal ped2 : std_logic_vector(1 downto 0);
    signal ped3 : std_logic_vector(1 downto 0);
begin
    uut: semctl
        port map (
            clk  => clk,
            rst  => rst,
            out_fsm  => out_fsm,
            in_mad  => in_mad,
            in_car1  => in_car1,
            in_car2  => in_car2,
            sem1  => sem1,
            sem2  => sem2,
            ped1  => ped1,
            ped2  => ped2,
            ped3  => ped3
        );
end architecture testbench;
