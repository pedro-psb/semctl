-- Controle de Semáforo - Componente principal

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity semctl is
  port (
    -- sinais gerais
    clk, rst : in  std_logic;
    out_fsm : out  std_logic_vector(9 downto 0);

    -- sinais especificos
    in_mad, in_car1, in_car2 : in  std_logic;
    sem1 : out std_logic_vector(1 downto 0);
    sem2 : out std_logic_vector(1 downto 0);
    ped1 : out std_logic_vector(1 downto 0);
    ped2 : out std_logic_vector(1 downto 0);
    ped3 : out std_logic_vector(1 downto 0)
  );
end entity;


architecture structural of semctl is
  type fsm_estados is (
    INITIAL, MADR,
    ALL_CLOSED,
    PRE_SEM1_OPEN, PRE_SEM2_OPEN,
    SEM1_OPEN,     SEM2_OPEN,
    POS_SEM1_OPEN, POS_SEM2_OPEN
  );
  signal PS, NS : fsm_estados;
  signal X : STD_LOGIC;  -- sinaliza mudança de estado
  signal polaridade: std_logic; -- sinaliza ciclo. 0/esquerda, 1/direita
begin
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

  X <= '1'; -- para teste preliminar onde controlamos o clk com um switch

  fsm_comb: process(PS) is
    constant PISC : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant VERM : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant AMAR : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant VERD : STD_LOGIC_VECTOR(1 downto 0) := "11";
  begin
    case PS is
      -- especiais
      when INITIAL =>
        NS <= ALL_CLOSED;
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
        X <= '0';
        polaridade <= '1';
      when MADR =>
        if X = '1' then NS <= ALL_CLOSED; end if;
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
      when ALL_CLOSED =>
        if X = '1' then
          if polaridade = '0' then NS <= PRE_SEM1_OPEN;
          elsif polaridade = '1' then NS <= PRE_SEM2_OPEN;
          else NS <= INITIAL;
          end if;
        end if;
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERD;

      -- ciclo direita
      when PRE_SEM2_OPEN =>
        if X = '1' then NS <= SEM2_OPEN; end if;
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERM; ped2 <= AMAR;
        ped3 <= AMAR;
      when SEM2_OPEN =>
        if X = '1' then NS <= POS_SEM2_OPEN; end if;
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= VERD; ped2 <= VERM;
        ped3 <= VERM;
      when POS_SEM2_OPEN =>
        if X = '1' then NS <= ALL_CLOSED; end if;
        sem1 <= VERM; ped1 <= VERD;
        sem2 <= PISC; ped2 <= VERM;
        ped3 <= VERM;
        polaridade <= not polaridade;  -- inverte

      -- ciclo esquerda
      when PRE_SEM1_OPEN =>
        if X = '1' then NS <= SEM1_OPEN; end if;
        sem1 <= VERM; ped1 <= AMAR;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= AMAR;
      when SEM1_OPEN =>
        if X = '1' then NS <= POS_SEM1_OPEN; end if;
        sem1 <= VERD; ped1 <= VERM;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERM;
      when POS_SEM1_OPEN =>
        if X = '1' then NS <= ALL_CLOSED; end if;
        sem1 <= AMAR; ped1 <= VERM;
        sem2 <= VERM; ped2 <= VERD;
        ped3 <= VERM;
        polaridade <= not polaridade;  -- inverte

      -- Others
      when others =>
        if X = '1' then NS <= INITIAL; end if;
        sem1 <= PISC; ped1 <= PISC;
        sem2 <= PISC; ped2 <= PISC;
        ped3 <= PISC;
    end case;
  end process fsm_comb;
end architecture;
