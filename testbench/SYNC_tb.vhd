library ieee;
use ieee.std_logic_1164.all;


entity tb_SYNC is
end tb_SYNC ;

architecture Behavioral of tb_SYNC is

-- Declare the component.
component SYNC is
port ( 
      d : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  res : in  std_logic ;
	  clk : in  std_logic ;
      q : out  std_logic); --It will be RES or SI signal
end component;

-- Declare internal signals to match each signal in component
signal clk : std_logic := '0' ; -- Preset clock to 0
signal D : std_logic := '0';
signal res : std_logic := '1';
signal Q : std_logic ;

begin

U_sync: SYNC port map(
    d => d,
    res => res,
    clk => clk,  
    Q => Q
  ) ;

--clk <= not clk after 20 ns;

d_proc : process
  begin
  D <= '1' ;
  wait for 40 ns ;
  D <= '0';
  wait for 20 ns ;
end process ;

clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for 20 ns;
end process;

res_process :process
begin
wait for 20 ns;
res <= '0';
wait for 120 ns;
res <= '1';
wait for 20 ns;
end process;

end Behavioral;


