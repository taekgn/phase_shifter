library ieee;
use ieee.std_logic_1164.all;

entity SYNC is
port ( 
      d : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  res : in  std_logic ;
	  clk : in  std_logic ;
      q : out  std_logic); --It will be RES or SI signal
end SYNC ;

architecture Behavioral of SYNC is
-- imports ffsr library
component FFSR is 
port ( 
 d : in std_logic;
 clk : in STD_LOGIC;
 res : in STD_LOGIC;
 Q : out STD_LOGIC);
end component;

signal Qint : std_logic;
begin
--process is not required since it was built in ffsr objects  
  
--instantiate ffsr objects
uut_ffsr1: FFSR PORT MAP (d=> d, clk => clk,res => res, q => Qint);
uut_ffsr2: FFSR PORT MAP (d=> qint, clk => clk, res => res, q => q);

end Behavioral;