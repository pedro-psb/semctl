-- Clock Converter (Divisor de Clock)
--
-- Arquitetura convertida para estilo dataflow/RTL:
--   - A lógica que calcula o próximo valor do contador e do clock dividido
--     é feita em sinais combinacionais (dataflow).
--   - O process contém apenas os registradores (flip-flops), sem lógica.
--   - Nomes de variáveis, sinais e estruturas foram mantidos.
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
-- arquivo correto

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_converter is
    generic (
        DIV_FACTOR : integer := 50000
    );
    port (
        in_clk  : in  std_logic;
        out_clk : out std_logic;
        RST     : in  std_logic
    );
end entity clock_converter;

architecture dataflow of clock_converter is

    -- Registradores (estado atual)
    signal s_contador_reg : integer range 0 to DIV_FACTOR-1 := 0;
    signal s_clk_out_reg  : std_logic := '0';

    -- Sinais combinacionais (próximo estado)
    signal s_contador_next : integer range 0 to DIV_FACTOR-1;
    signal s_clk_out_next  : std_logic;

begin

    -------------------------------------------------------------
    -- Lógica combinacional (DATAFLOW)
    -------------------------------------------------------------
    s_contador_next <= 0 when s_contador_reg = DIV_FACTOR-1 else
                       s_contador_reg + 1;

    s_clk_out_next  <= not s_clk_out_reg when s_contador_reg = DIV_FACTOR-1 else
                       s_clk_out_reg;

    -------------------------------------------------------------
    -- Registradores (flip-flops)
    -------------------------------------------------------------
    process (in_clk, RST)
    begin
        if RST = '1' then
            s_contador_reg <= 0;
            s_clk_out_reg  <= '0';

        elsif rising_edge(in_clk) then
            s_contador_reg <= s_contador_next;
            s_clk_out_reg  <= s_clk_out_next;
        end if;
    end process;

    -------------------------------------------------------------
    -- Saída
    -------------------------------------------------------------
    out_clk <= s_clk_out_reg;

end architecture dataflow;
