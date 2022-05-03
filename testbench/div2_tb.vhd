LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_DIV2 IS
END Tb_DIV2;
 
ARCHITECTURE behavior OF Tb_DIV2 IS
 
 --€“ Component Declaration for the Unit Under Test (UUT)
 
COMPONENT DIV2
PORT(
mclk : IN std_logic;
clk : OUT std_logic
);
END COMPONENT;
 
--Inputs
signal mclk : std_logic := '0';
 
--Outputs
signal clk : std_logic;
 
 --€“ Clock period definitions
constant clk_period : time := 40 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
uut: DIV2 PORT MAP (
mclk => mclk,
clk => clk
);

--parallel process threading
clk_process :process
begin
mclk <= not mclk;
--keep switch 1 and 0
wait for clk_period/2;
end process;

 
END;
