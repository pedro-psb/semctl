-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa
--arquivo correto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is 
    generic (
        N_BITS : integer := 8;
        M_BITS : integer := 4
    );
    port (
        data_in : in  std_logic_vector(N_BITS-1 downto 0);
        sum_out : out std_logic_vector(M_BITS-1 downto 0)
    );
end entity somador;

architecture dataflow of somador is

    -- Cria um "fio" para cada etapa da soma.
    -- Se tem 8 bits, precisamos de 9 estágios (do 0 ao 8).
    type t_array_somas is array (0 to N_BITS) of integer range 0 to N_BITS;
    signal s_somas : t_array_somas;

begin 

    -- 1. O começo da cadeia é sempre 0
    s_somas(0) <= 0;

    -- 2. O 'generate' substitui o loop do process
    --    Ele cria hardware físico para cada bit repetidamente
    gen_soma: for i in 0 to N_BITS-1 generate
        
        -- A lógica "if" vira um "when/else" concorrente
        -- O valor atual (i+1) é o valor anterior (i) + 1 (se o bit for '1')
        s_somas(i+1) <= s_somas(i) + 1 when data_in(i) = '1' else 
                        s_somas(i);
                        
    end generate gen_soma;

    -- 3. O resultado final é o último estágio da cadeia
    sum_out <= std_logic_vector(to_unsigned(s_somas(N_BITS), M_BITS));

end architecture dataflow;