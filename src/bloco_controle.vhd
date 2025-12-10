-- Bloco de controle do semctl (RTL)
--
--
-- == I/O Externo
--
-- input:
--   clk: 1 bit
--   rst: 1 bit
--   in_mad: 1 bit    - Ativa modo madrugada
-- output:
--   out_fsm: 10 bits - Saida da FSM (one-hot encoding)
--   sem1: 2 bits     - Saida para semaforo de carro 1
--   sem2: 2 bits     - Saida para semaforo de carro 2
--   ped1: 2 bits     - Saida para semaforo de pedestre 1
--   ped2: 2 bits     - Saida para semaforo de pedestre 2
--   ped3: 2 bits     - Saida para semaforo de pedestre 3
--
--
-- == I/O Interno
--
-- input:
--   count_done: 1 bit    - Sinaliza que o contador terminou a contagem
--
-- output:
--   car1_enable: 1 bits  - Enable para sensor de carro 1
--   car2_enable: 1 bits  - Enable para sensor de carro 2
--   polaridade: 1 bits   - Representa a polaridade do ciclo. 1 = ciclo em que sem2 abre
--
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity bloco_controle is
  port (
    -- I/O externo
    clk, rst : in  std_logic;
    in_mad, in_car1, in_car2 : in  std_logic;
    out_fsm : out  std_logic_vector(9 downto 0);
    sem1 : out std_logic_vector(1 downto 0);
    sem2 : out std_logic_vector(1 downto 0);
    ped1 : out std_logic_vector(1 downto 0);
    ped2 : out std_logic_vector(1 downto 0);
    ped3 : out std_logic_vector(1 downto 0);

    -- I/O interno
    count_done  : in std_logic;
    car1_enable : out std_logic;
    car2_enable : out std_logic;
    polaridade_out  : out std_logic
  );
end entity;


architecture structural of bloco_controle is
  type fsm_estados is (
    INITIAL, MADR,
    ALL_CLOSED,
    PRE_SEM1_OPEN, PRE_SEM2_OPEN,
    SEM1_OPEN,     SEM2_OPEN,
    POS_SEM1_OPEN, POS_SEM2_OPEN
  );
  signal PS, NS : fsm_estados;
  signal polaridade: std_logic;
begin
  polaridade_out <= polaridade;
  -- Externalizar estados
  with PS select
        out_fsm <=
            "0000000001" when POS_SEM2_OPEN,
            "0000000010" when SEM2_OPEN,
            "0000000100" when PRE_SEM2_OPEN,
            "0000001000" when ALL_CLOSED,
            "0000010000" when PRE_SEM1_OPEN,
            "0000100000" when SEM1_OPEN,
            "0001000000" when POS_SEM1_OPEN,

            "1000000000" when INITIAL,
            "0100000000" when MADR,
            "1111111111" when others
    ;

  -- Atualiza estado FSM
  fsm_sync: process(CLK, RST)
  begin
    if RST = '1' then
      PS <= INITIAL;
    elsif (rising_edge(CLK)) then
      PS <= NS;
    end if;
  end process fsm_sync;


  fsm_comb: process(PS, in_mad, count_done) is
    constant PISC : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant VERM : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant AMAR : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant VERD : STD_LOGIC_VECTOR(1 downto 0) := "11";
  begin
    -- Atribuições padrão
    NS <= PS;  -- Permanece no estado atual por padrão
    case PS is
      -- especiais
      when INITIAL =>
        NS <= ALL_CLOSED;
        car1_enable <= '0';
        car2_enable <= '0';
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
        polaridade <= '1';
      when MADR =>
        if in_mad = '1' then
          NS <= MADR;
        elsif count_done = '1' then
          NS <= ALL_CLOSED;
        end if;
        car1_enable <= '0';
        car2_enable <= '0';
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
      when ALL_CLOSED =>
        if count_done = '1' and in_mad = '1' then
          NS <= MADR;
        elsif count_done = '1' and polaridade = '0' then
          NS <= PRE_SEM1_OPEN;
        elsif count_done = '1' and polaridade = '1' then
          NS <= PRE_SEM2_OPEN;
        end if;
        car1_enable <= '0';
        car2_enable <= '0';
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERD;

      -- ciclo direita
      when PRE_SEM2_OPEN =>
        polaridade <= '0';
        if count_done = '1' then
          NS <= SEM2_OPEN;
        end if;
        car1_enable <= '0';
        car2_enable <= '0';
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERM; ped2 <= AMAR;
        ped3 <= AMAR;
      when SEM2_OPEN =>
        if count_done = '1' then
          NS <= POS_SEM2_OPEN;
        end if;
        car1_enable <= '1';
        car2_enable <= '0';
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERD; ped2 <= VERM;
        ped3 <= VERM;
      when POS_SEM2_OPEN =>
        if count_done = '1' then
          NS <= ALL_CLOSED;
        end if;
        car1_enable <= '1';
        car2_enable <= '0';
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= AMAR; ped2 <= VERM;
        ped3 <= VERM;

      -- ciclo esquerda
      when PRE_SEM1_OPEN =>
        polaridade <= '1';
        if count_done = '1' then
          NS <= SEM1_OPEN;
        end if;
        car1_enable <= '0';
        car2_enable <= '0';
        sem1 <= VERM; ped1 <= AMAR;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= AMAR;
      when SEM1_OPEN =>
        if count_done = '1' then
          NS <= POS_SEM1_OPEN;
        end if;
        car1_enable <= '0';
        car2_enable <= '1';
        sem1 <= VERD; ped1 <= VERM;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERM;
      when POS_SEM1_OPEN =>
        if count_done = '1' then
          NS <= ALL_CLOSED;
        end if;
        car1_enable <= '0';
        car2_enable <= '1';
        sem1 <= AMAR; ped1 <= VERM;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERM;

      -- Outros
      when others =>
        if count_done = '1' then NS <= INITIAL; end if;
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
    end case;
  end process fsm_comb;
end architecture;
