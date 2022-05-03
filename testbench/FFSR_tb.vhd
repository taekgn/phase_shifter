library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- entity for a testbench is empty, since it does not talk to outside world.
entity tb_FFSR is
end tb_FFSR ;

architecture Behavioral of tb_FFSR is
-- Declare the component.
component ffsr
port ( 
    d : in std_logic;    
    clk :in std_logic;  
	  res: in std_logic;  
    q : out  std_logic);
end component ;

-- Declare internal signals to match each signal in component
signal d : std_logic ;
signal clk : std_logic := '0' ; -- Preset clock to 0
signal res : std_logic := '1';
signal q : std_logic ;

begin

uut : ffsr port map (d=>d, clk=>clk ,res=>res, q=>q);

clk <= not clk after 20 ns; --50MHz frequency
process
  begin
  D <= '1' ;
  wait for 30 ns ;
  res <= '0';
  D <=  not d ;
  wait for 10 ns ;
  -- Jitter invoked while instant time
  D <= '1' ;
  wait for 5 ns ;
  D <= '0' ; res <= '1';
  wait for 1 ns ;
  D <= '1' ;
  wait for 10 ns ;
  D <= '0' ; res <= '0';
  wait for 40 ns ;
end process ;

end Behavioral;


