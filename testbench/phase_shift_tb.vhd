LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_phase_shift IS
END Tb_phase_shift;
 
ARCHITECTURE behavior OF Tb_phase_shift IS
 
component phase_shift is
port ( 
    si : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  clk : in  std_logic ;
	  res : in  std_logic ;
	  phi_0 : out  std_logic;
    phi_90 : out  std_logic); --It will be RES or SI signal
end component ;
 
--Inputs
signal si : std_logic := '0';
signal clk : std_logic := '0';
signal res : std_logic := '0';
 
--Outputs
signal phi_0 : std_logic;
signal phi_90 : std_logic;
 
 --€“ Clock period definitions
constant clk_period : time := 40 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
uut: phase_shift PORT MAP (
si => si,
clk => clk,
res => res,
phi_0 => phi_0,
phi_90 => phi_90
);

--parallel process threading
clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for clk_period/2;
end process;

si_process :process
begin
  si <= '1';
  wait for 480 ns;
  si <= '0';
  wait for 480 ns;
end process;

res_process : process
begin
  wait for 30 ns;
  res <= '0';
end process;
 
END;
