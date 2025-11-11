-- Somador Bit a Bit - Conta a quantidade de 1's em um vetor binário.
--
-- generic:
--   N_in  - Tamanho do vetor de entrada
--   N_out - Tamanho do unsigned de saida
-- input:
--   data_in: N_in bits - Vetor binário
-- output:
--   sum_out: N_out bits - Numero (sem sinal) de 1s em @data_in

library ieee;
use ieee.std_logic_1164.all;
use  ieee.numeric_std.all;

entity somador_bitbit is
	generic (
      N_in : integer := 8;
      N_out : integer := 4
    );

    port (
      data_in : in std_logic_vector(N_in-1 downto 0);
      sum_out : out unsigned(N_out-1 downto 0)
    );
end entity somador_bitbit;

architecture behavioral of somador_bitbit is
begin 
    contador_proc: process (data_in) is
        variable v_contador : integer range 0 to N_in;
    begin
        v_contador := 0;
       
      	for i in data_in'range loop
          	if data_in(i) = '1' then
            	v_contador := v_contador + 1;
    		end if;
		end loop;
		sum_out <= to_unsigned(v_contador, N_out);
    end process contador_proc;
	
end architecture behavioral;
