LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_DIV50K IS
END Tb_DIV50K;
 
ARCHITECTURE behavior OF Tb_DIV50K IS
 
 --€“ Component Declaration for the Unit Under Test (UUT)
 
component DIV50K port
( 	clk : in std_logic;
		res : in std_logic;
		q: out std_logic);
end component;
 
--Inputs
signal clk : std_logic := '0';
signal res : std_logic := '0'; 
--Outputs
signal q : std_logic;
 
 --€“ Clock period definitions
constant clk_period : time := 40 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
uut: DIV50K PORT MAP (
clk => clk,
res => res,
q => q);

--parallel process threading
clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for clk_period/2;
end process;
 
END;
