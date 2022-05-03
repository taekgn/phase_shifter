library ieee;
use ieee.std_logic_1164.all;

entity ffsr is
port ( 
    d : in std_logic;    
    clk :in std_logic;  
	  res: in std_logic;  
    q : out  std_logic);
end ffsr ;

architecture Behavioral of ffsr is
begin
  process (clk) --synchronous reset flipflop
    begin
    if rising_edge(clk) then
		if res='1' then 
		q <= '0';
		else 
		q <= d; --synchronous output update
		end if;
    end if;  
    end process ;
end Behavioral;