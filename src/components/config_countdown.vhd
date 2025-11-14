-- Contador regressivo configurável
--
-- Funcionamento:
--  - rst = '1': zera o contador e o valor de recarga (reset síncrono)
--  - set = '1': salva N como o novo valor de recarga
--  - Quando o contador chega a zero, ele recarrega com "proximo_valor"
--
-- Entradas:
--   clk : clock
--   rst : reset síncrono
--   set : quando '1', grava N como o valor de recarga
--   N   : valor que será carregado quando set='1'
--
-- Saída:
--   X   : valor atual do contador
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity config_countdown is
	generic (
    	WIDTH : integer := 16 --16 nesse caso é a largura de N (entrada)
    );
    port (
    	clk : in std_logic;
        rst : in std_logic;
        set : in std_logic;
        N : in  unsigned(WIDTH-1 downto 0);
        X : out  unsigned(WIDTH-1 downto 0) --saida
    );
end entity;

architecture rtl of config_countdown is 
	signal valor_atual : unsigned(WIDTH-1 downto 0) := (others => '0');
   	signal proximo_valor : unsigned(WIDTH-1 downto 0) := (others => '0');
begin 
	
    process(clk) 
    begin
    	if rising_edge(clk) then 
        	-- O RST sincronizado: limpa tudo:
            if rst = '1' then
            	valor_atual <= (others => '0');
                proximo_valor <= (others => '0');
          	else
            
                -- SET sincronizado: atualiza próximo valor
                if set = '1' then 
                    proximo_valor <= N;
                    valor_atual   <= N;
                end if;

                -- comportamento do contador regressivo
                if valor_atual = to_unsigned(0, width) then
                    valor_atual <= proximo_valor; --reinicia o ciclo com o valor armazenado em proximo_valor
                else
                    valor_atual <= valor_atual - 1; --decrementa
                end if;
                
            end if;
            
        end if;
	end process;
    
X <= valor_atual;     

end architecture;    
