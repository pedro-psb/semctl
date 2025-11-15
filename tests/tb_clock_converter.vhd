-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_clock_converter is
end entity tb_clock_converter;

architecture test of tb_clock_converter is
    constant C_DIV_FACTOR : integer := 50;
    constant C_CLK_PERIOD : time := 10 ns;
    constant C_SIM_TIME : time := 2550 ns;
    signal s_in_clk : std_logic := '0';
    signal s_out_clk : std_logic;
    signal s_rst : std_logic;
	
begin 
	UUT: entity work.clock_converter(behavioral)
    	generic map (
        	DIV_FACTOR => C_DIV_FACTOR
        )
        port map (
          	in_clk => s_in_clk,
    		out_clk => s_out_clk,
 			RST => s_rst
        );
        
    clock_gen_proc: process is
    begin
        while now < C_SIM_TIME loop 
            s_in_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            s_in_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait; 
    end process clock_gen_proc;
    
    
    estimulo_proc: process is
    begin
        
   		s_rst <= '1';
      	wait for 5*C_CLK_PERIOD;
      	s_rst <= '0';
		wait for 50*C_CLK_PERIOD;
 	 	-- s_rst <= '1';
		-- wait for 200*C_CLK_PERIOD;

  		report "Fim da simulação" severity note; 

		wait;
        
	end process estimulo_proc;
    
end architecture test;
