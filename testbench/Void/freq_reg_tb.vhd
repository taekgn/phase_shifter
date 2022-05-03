library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; --to perform arithmetic maths function

ENTITY Tb_freq_reg IS
END Tb_freq_reg;

architecture Behavioral of Tb_freq_reg is
component freq_reg port
(
ld : in std_logic;
b1 : in std_logic_vector(3 downto 0); --input from div10
b10 : in std_logic_vector(3 downto 0);
b100 : in std_logic_vector(3 downto 0);
b1000 : in std_logic_vector(3 downto 0);
b10000 : in std_logic_vector(3 downto 0);
b100000 : in std_logic_vector(3 downto 0);
ovflow  : in std_logic; --overflow
clk : in std_logic;
res : in std_logic;
x1 :  out std_logic_vector(3 downto 0); -- output will go to sel 
x10 :  out std_logic_vector(3 downto 0);
x100 :  out std_logic_vector(3 downto 0);
x1000 :  out std_logic_vector(3 downto 0);
x10000 :  out std_logic_vector(3 downto 0);
x100000 :  out std_logic_vector(3 downto 0);
err : out std_logic);
end component;

signal ld : std_logic;
signal b1 : std_logic_vector(3 downto 0); --input from div10
signal b10 : std_logic_vector(3 downto 0);
signal b100 : std_logic_vector(3 downto 0);
signal b1000 : std_logic_vector(3 downto 0);
signal b10000 : std_logic_vector(3 downto 0);
signal b100000 : std_logic_vector(3 downto 0);
signal ovflow  : std_logic := '0'; --overflow
signal clk : std_logic := '0';
signal res : std_logic := '0';
signal x1 : std_logic_vector(3 downto 0); -- output will go to sel 
signal x10 : std_logic_vector(3 downto 0);
signal x100 : std_logic_vector(3 downto 0);
signal x1000 : std_logic_vector(3 downto 0);
signal x10000 : std_logic_vector(3 downto 0);
signal x100000 : std_logic_vector(3 downto 0);

constant clk_period : time := 40 ns;

begin
uut: freq_reg port map (
ld => ld,
b1 => b1,
b10 => b10,
b100 => b100,
b1000 => b1000,
b10000 => b10000,
b100000 => b10000,
ovflow => ovflow,
clk => clk,
res => res,
x1 => x1,
x10 => x10,
x100 => x100,
x1000 => x1000,
x10000 => x10000,
x100000 => x100000);

clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for clk_period/2;
end process;

x_process :process
begin
  wait for 20 ns;
  b1 <= "0000"; 
  b10 <= "0000";  
  b100 <= "0000"; 
  b1000 <= "0000"; 
  b10000 <= "0000"; 
  b100000 <= "0000"; 
  wait for 20 ns;
  b1 <= "1010"; 
  b10 <= "0110";  
  b100 <= "1000"; 
  b1000 <= "1111"; 
  b10000 <= "1100"; 
  b100000 <= "1001";
  wait for 20 ns;
  b1 <= "1110"; 
  b10 <= "0111";  
  b100 <= "1011"; 
  b1000 <= "1001"; 
  b10000 <= "0011"; 
  b100000 <= "0100";  
end process;

ov_pro : process
begin
wait for 120 ns;
ovflow<= '1';
wait for 60 ns;
ovflow <= '0';
end process;

ld_pro : process
begin
wait for 60 ns;
ld<= '1';
wait for 180 ns;
ld <= '0';
end process; 
 
end Behavioral;