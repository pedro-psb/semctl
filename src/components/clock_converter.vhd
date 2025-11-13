--contador simples de clock
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity clock_converter is
    generic (
        DIV_FACTOR : integer := 50000 --50000 valor default
    );
    port (
        in_clk  : in  std_logic;
        out_clk : out std_logic;
        RST     : in  std_logic
    );
end entity clock_converter;

architecture behavioral of clock_converter is
    signal s_contador_reg  : integer range 0 to DIV_FACTOR-1 := 0;
    signal s_clk_out_reg   : std_logic := '0'; --boa pratica, se conecta à saída
begin
    process (in_clk, RST) is
    begin
        if RST = '1' then
            s_contador_reg <= 0;
            s_clk_out_reg  <= '0';
            
        elsif rising_edge(in_clk) then
            if s_contador_reg = DIV_FACTOR-1 then
                s_contador_reg <= 0;
                s_clk_out_reg  <= not s_clk_out_reg;
            else              
                s_contador_reg <= s_contador_reg + 1;
            end if;
        end if;
    
    end process; 
    
    out_clk <= s_clk_out_reg;

end architecture behavioral;