library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity DIV2 is
port ( mclk: in std_logic;
clk: out std_logic);
end DIV2;
  
architecture bhv of DIV2 is
signal tmp : std_logic := '0' ; -- The signal will be one at Power-on Reset 

--tmp is temporary space to store a bit datum
  
begin
  process(mclk) --sychronous circuit thus mclk is in sensitivity
    begin
	  if rising_edge(mclk) then 
		  tmp <= not tmp;--makes true or false while single duty cycle of input to be finished
  end if;
end process;
clk <= tmp;--assigns buffer signal into real output
end bhv;


