-- libraries
library ieee;
use ieee.std_logic_1164.all;


-- entity
entity top is
  port
  (
    clk_i      : in  std_logic;
    rst_n_i    : in  std_logic;
    in1_i      : in  std_logic_vector(2 downto 0);
    in2_i      : in  std_logic_vector(2 downto 0);
    sel_i      : in  std_logic_vector(1 downto 0);
    overflow_o : out std_logic;
    reg_out_o  : out std_logic_vector(5 downto 0)
  );
end entity top;

-- architecture
architecture rtl of top is

  -- components
  component adder_N is
    generic
    (
      N : integer
    );
    port
    (
      in1_i : in  std_logic_vector(N-1 downto 0);
      in2_i : in  std_logic_vector(N-1 downto 0);
      sum_o : out std_logic_vector(N   downto 0)
    );
  end component adder_N;

  -- signals
  signal adder_output_s    : std_logic_vector(3 downto 0);
  signal mux_output_s      : std_logic_vector(3 downto 0);
  signal ext_mux_output_s  : std_logic_vector(5 downto 0);
  signal acc_s             : std_logic_vector(6 downto 0);
  signal sum_s             : std_logic_vector(6 downto 0);

begin

  u_input_adder : adder_N
  generic map
  (
    N => 3
  )
  port map
  (
    in1_i => in1_i,
    in2_i => in2_i,
    sum_o => adder_output_s
  );


  u_mux :
  mux_output_s <= ("0" & in2_i)  when sel_i = "00" else
                  adder_output_s when sel_i = "01" else
                  ("0" & in1_i)  when sel_i = "10" else
                  "0000";

  ext_mux_output_s <= ("00" & mux_output_s);

  u_output_adder : adder_N
  generic map
  (
    N => 6
  )
  port map
  (
    in1_i => ext_mux_output_s,
    in2_i => acc_s(5 downto 0),
    sum_o => sum_s
  );


  u_register : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        acc_s <= (others => '0');
      else
        acc_s <= sum_s;
      end if;
    end if;
  end process;

  overflow_o <= acc_s(6);

  reg_out_o <= acc_s(5 downto 0);

end architecture rtl;
