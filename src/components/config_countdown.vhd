-- Contador regressivo configurável
--
-- Funcionamento:
--  - rst = '1': zera o contador e o valor de recarga (reset síncrono)
--  - set = '1': salva N como o novo valor de recarga
--  - Quando o contador chega a zero, ele recarrega com "proximo_valor"
--
-- Entradas:
--   clk : clock
--   rst : quando '1', força a saída X a 0
--   N   : valor que será carregado quando rst='0'
--
-- Saída:
--   X   : valor atual do contador
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity config_countdown is
    generic (
        WIDTH : integer := 16
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        N     : in unsigned(WIDTH-1 downto 0);
        X     : out unsigned(WIDTH-1 downto 0)
    );
end config_countdown;

architecture simple of config_countdown is
    signal count : unsigned(WIDTH-1 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- zera contador
                count <= (others => '0');

            else
                -- comportamento do countdown sem SET:
                -- se chegou em zero -> recarrega N
                -- senao           -> decrementa
                if count = 0 then
                    count <= N;
                else
                    count <= count - 1;
                end if;

            end if;
        end if;
    end process;

    X <= count;

end architecture simple;
