-- config_countdown
--
-- Arquitetura convertida para estilo dataflow/RTL:
--   - A logica combinacional que decide o proximo valor
--     do contador e o proximo valor de recarga fica fora do process,
--     usando sinais *_next.
--   - O process contem apenas os registradores (estado atual),
--     sem logica interna, sem decisoes.
--   - Os nomes dos sinais, portas e funcionamento original foram mantidos.
--
-- Funcionamento original preservado:
--   - rst = '1'  -> zera valor_atual e proximo_valor (reset sincrono)
--   - set = '1'  -> recarrega valor_atual e atualiza proximo_valor com N
--   - valor_atual = 0 -> reinicia o ciclo com proximo_valor
--   - caso contrario -> decrementa valor_atual
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
-- arquivo correto

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity config_countdown is
    generic (
        WIDTH : integer := 16
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        set : in  std_logic;
        N   : in  unsigned(WIDTH-1 downto 0);
        X   : out unsigned(WIDTH-1 downto 0)
    );
end entity;

architecture dataflow of config_countdown is

    -- Registradores (estado atual)
    signal valor_atual    : unsigned(WIDTH-1 downto 0) := (others => '0');
    signal proximo_valor  : unsigned(WIDTH-1 downto 0) := (others => '0');

    -- Proximo estado (logica combinacional)
    signal valor_atual_next   : unsigned(WIDTH-1 downto 0);
    signal proximo_valor_next : unsigned(WIDTH-1 downto 0);

begin

    --------------------------------------------------------------------
    -- LOGICA COMBINACIONAL (DATAFLOW)
    --------------------------------------------------------------------

    -- proximo_valor_next:
    -- set = '1' -> salva N como novo valor de recarga
    proximo_valor_next <= N when set = '1' else
                          proximo_valor;

    -- valor_atual_next:
    -- prioridade:
    --   1) set = '1' -> carrega N
    --   2) contador chegou em zero -> recarrega proximo_valor
    --   3) caso contrario -> decrementa
    valor_atual_next <= N when set = '1' else
                        proximo_valor when valor_atual = to_unsigned(0, WIDTH) else
                        valor_atual - 1;

    --------------------------------------------------------------------
    -- REGISTRADORES (somente flip-flops)
    --------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            -- reset sincrono
            if rst = '1' then
                valor_atual   <= (others => '0');
                proximo_valor <= (others => '0');
            else
                valor_atual   <= valor_atual_next;
                proximo_valor <= proximo_valor_next;
            end if;

        end if;
    end process;

    --------------------------------------------------------------------
    -- SAIDA
    --------------------------------------------------------------------
    X <= valor_atual;

end architecture dataflow;
