library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY Tb_freq_calc IS
END Tb_freq_calc;

architecture Behavioral of Tb_freq_calc is
component frequency_calculator port ( 
    sw : in std_logic_vector(1 downto 0);    
    si :in std_logic;  
	  clk : in std_logic;
	  res : in std_logic;
	  leds : out std_logic_vector(1 downto 0);
    da : out std_logic_vector(3 downto 0);
    db : out std_logic_vector(3 downto 0);
    dc : out std_logic_vector(3 downto 0);
    dd : out std_logic_vector(3 downto 0);
	  de : out std_logic);
end component ;

signal sw : std_logic_vector(1 downto 0);    
signal si : std_logic := '0';  
signal clk : std_logic := '0';
signal res : std_logic := '0';
signal leds : std_logic_vector(1 downto 0);
signal da : std_logic_vector(3 downto 0);
signal db : std_logic_vector(3 downto 0);
signal dc : std_logic_vector(3 downto 0);
signal dd : std_logic_vector(3 downto 0);
signal de : std_logic;

constant clk_period : time := 40 ns;

begin
uut: frequency_calculator port map (
    sw => sw, 
    si => si,
	clk => clk,
	res => res, 
	leds => leds,
    da => da,
    db => db,
    dc => dc,
    dd => dd,
	de => de); --It will be RES or SI signal

--parallel process threading


sl_pro : process
begin
	si <= not si;
	wait for 1200 ns;
end process;

sw_pro : process
begin
	for i in 0 to 3 loop
  if i < 3 then -- because 32 is 6 power to 2, so must be 31
    sw<= std_logic_vector(to_unsigned(i,sw'length));
    --assign index i to input through data transform
    wait for 3*clk_period;
    end if;
	end loop;
end process;

clk_process :process
begin
clk <= not clk;
--keep switch 1 and 0
wait for clk_period/4;
end process;

END;