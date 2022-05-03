LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_DIV10 IS
END Tb_DIV10;
 
ARCHITECTURE behavior OF Tb_DIV10 IS
 
 --€“ Component Declaration for the Unit Under Test (UUT)
 
component DIV10
port ( 	ce : in std_logic;
		clk : in std_logic;
		res : in std_logic;
		ovflow  : out std_logic; --overflow
		q: out std_logic_vector(3 downto 0));
end component;
 
--Inputs
signal clk : std_logic := '0';
signal ce : std_logic := '0';
signal res : std_logic := '0'; 
--Outputs
signal ovflow : std_logic;
signal q : std_logic_vector(3 downto 0);
 
 --€“ Clock period definitions
constant clk_period : time := 40 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
uut: DIV10 PORT MAP (
ce => ce,
clk => clk,
res => res,
ovflow => ovflow,
q => q);

--parallel process threading
clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for clk_period/2;
end process;

ce_process :process
begin
ce <= not ce;
--keep switch 1 and 0
wait for clk_period;
end process;
 
END;
