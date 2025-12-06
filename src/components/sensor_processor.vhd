-- Processador de sinais
--
-- Recebe sinal dos sensores de carro e calcula a diferença dentros
-- das especificações do projeto.
--
--
-- input:
--   car1_in: 1 bit       - Entrada do sensor carro 1
--   car1_enable: 1 bit   - Enable para carro 1
--   car2_in: 1 bit       - Entrada do sensor carro 2
--   car2_enable: 1 bit   - Enable para carro 2
--   rst: 1 bit           - Zera memoria interna (contagem de carros)
--   enable: 1 bit        - Habilita ou não a saida do map_range
--   polariadde: 1 bit    - Polaridade da saida
--   clk: 1 bit
-- output:
--   data_out: (-15 a 16) - Valor a ser incrementado no contador
--
-- Integrantes:
-- * Guilherme Augusto
-- * Pedro Armando
-- * Pedro Pessoa

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity sensor_processor is
  generic (
    -- Numero de bits da saida (signed)
    out_size : integer;
    -- Tamanho da memoria do registrador interno em relacao ao clk de entrada
    -- E.g, se o clk.periodo=1s e mem_size=5, o registrador guarda os ultimos 5 segundos
    mem_size : integer
  );
  port (
    car1_in    :  in std_logic;
    car1_enable  :  in std_logic;
    car2_in    :  in std_logic;
    car2_enable  :  in std_logic;
    rst      :  in std_logic;
    enable    :  in std_logic;
    polaridade  :  in std_logic;
    clk      :  in std_logic;
    data_out    :   out signed(out_size-1 downto 0)
  );
end entity;


architecture structural of sensor_processor is
  --================ CALC-FLUX  ===================================
  component car_detector is port (
      SET  : in  std_logic;
      CLK : in  std_logic;
      Q   : out std_logic
    );
  end  component;

  component reg_deslocamento is
    generic (N : integer := mem_size);
    port (
      in_car, clk, rst : in  std_logic;
      reg_out : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component somador_bitbit is
    generic (
      N_in : integer := mem_size;  -- Valor alterado aqui e no componente
      N_out : integer := 6  -- Valor alterado aqui e no componente
    );

    port (
      data_in : in std_logic_vector(N_in-1 downto 0);
      sum_out : out unsigned(N_out-1 downto 0)
    );
  end component;

  --================ MAP_RANGE  ===================================
  component map_range is
    generic (
      N : integer := 7;
      M : integer := out_size
    );

    port (
      a : in  signed(N-1 downto 0);  -- entrada
      e0: in std_logic;              -- enable
      s : out signed(M-1 downto 0)   -- saida
    );
  end component;


  --================ Subtrator  ===================================
  component subtrator_sign is
    generic (N : integer := 6);  -- Valor alterado aqui e no componente
    port (
      a, b : in  unsigned(N-1 downto 0);
      inverte: in std_logic;
      output : out signed(N downto 0)
    );
  end component;

  -- sinal auxiliar para mapeamento dos componentes
  -- signal sgn_resultado_slv   : std_logic_vector(5 downto 0);
  signal sgn_enable_car1 : std_logic;
  signal sgn_enable_car2 : std_logic;

  signal sgn_output_CD1   : std_logic;
  signal sgn_output_CD2   : std_logic;

  signal sgn_output_RG1   : std_logic_vector(mem_size-1 downto 0);  --Alterar esse valor para adequar ao sinal interno de calcflux
  signal sgn_output_RG2   : std_logic_vector(mem_size-1 downto 0);  --Alterar esse valor para adequar ao sinal interno de calcflux

  signal sgn_output_sm1   : unsigned(5 downto 0);      --Alterar esse valor para adequar ao sinal de saida de calcflux
  signal sgn_output_sm2   : unsigned(5 downto 0);      --Alterar esse valor para adequar ao sinal de saida de calcflux

  signal sgn_output_sub   : signed(6 downto 0);        --Alterar esse valor para adequar ao sinal de saida do subtrator

begin
  -- Otimizacao do registrador (no lugar de varias portas and internas)
  sgn_enable_car1 <= clk and car1_enable;
  sgn_enable_car2 <= clk and car2_enable;
  -- sgn_enable_car1 <= clk;
  -- sgn_enable_car2 <= clk;

  --=============== CALC_FLUX =====================
  car1_detector :  car_detector port map(
      SET    =>  car1_in,
      CLK    => clk,
      Q    =>  sgn_output_CD1
    );

  car2_detector :  car_detector port map(
      SET    =>  car2_in,
      CLK    =>  clk,
      Q    =>  sgn_output_CD2
    );


  reg_D1 : reg_deslocamento port map(
      in_car  =>  sgn_output_CD1,
      clk    =>  clk,
      rst    =>  rst,
      reg_out  =>  sgn_output_RG1

    );

  reg_D2 : reg_deslocamento port map(
      in_car  =>  sgn_output_CD2,
      clk    =>  clk,
      rst    =>  rst,
      reg_out  =>  sgn_output_RG2

    );

  som1 : somador_bitbit port map(
      data_in => sgn_output_RG1,
      sum_out => sgn_output_sm1
    );

  som2 : somador_bitbit port map(
      data_in => sgn_output_RG2,
      sum_out => sgn_output_sm2
    );

  --=============== SUBTRATOR =====================
  sub : subtrator_sign port map(
      a    =>  sgn_output_sm1,
      b    =>  sgn_output_sm2,
      inverte  =>  polaridade,
      output   =>  sgn_output_sub

    );

  M_range :  map_range port map(
      a    => sgn_output_sub,
      e0    => enable,
      s    => data_out

    );


end architecture;
