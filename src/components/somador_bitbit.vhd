library ieee;
use ieee.std_logic_1164.all;
use  ieee.numeric_std.all;

entity somador is 
	generic (
      N_BITS : integer := 7
      M_BITS : integer := 3
    );

    port (
      data_in : in std_logic_vector(N_BITS-1 downto 0);
      sum_out : out std_logic_vector(M_BITS-1 downto 0)
    );
end entity somador;

architecture behavioral of somador is
begin 
    contator_proc: process (data_in) is
    	variable v_contador : integer range 0 to N_BITS;
    begin
        v_contador := 0;
       
      	for i in data_in'range loop
          	if data_in(i) = '1' then
            	v_contador := v_contador + 1;
    		end if;
		end loop;
		sum_out <= std_logic_vector(to_unsigned(v_contador, M_BITS));
    end process contador_proc;
	
end architecture behavioral;