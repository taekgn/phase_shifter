Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Tb_top_level is
end Tb_top_level;

architecture behav of Tb_top_level is
component Top_level port (
	SENSOR_IN : in std_logic;
	SW : in std_logic_vector(1 downto 0);
	MCLK : in std_logic;
	CLR : in std_logic; --Display Enable coming from DIV50K, used for counting and enable
	PHI_0    : out std_logic;
	PHI_90   	: out std_logic;		-- display clock, reset
	DIGIT	: out std_logic_vector(7 downto 0);		-- Output for  common cathoode//LED DISPLAY VALUE
	DIGEN	: out std_logic_vector(3 downto 0);
	LEDS : out std_logic_vector(1 downto 0));		-- Output for common anode//LED DISPLAY ENABLE
end component;

signal SENSOR_IN : std_logic := '0';
signal SW : std_logic_vector(1 downto 0);
signal MCLK : std_logic := '0';
signal CLR : std_logic := '0';

signal PHI_0 : std_logic := '0';
signal PHI_90 : std_logic := '0';

signal DIGIT : std_logic_vector(7 downto 0);
signal DIGEN : std_logic_vector(3 downto 0);
signal LEDS: std_logic_vector(1 downto 0);

constant clk_period : time := 40 ns;

begin
uut: Top_level port map (
	SENSOR_IN => SENSOR_IN,
	SW => SW,
	MCLK => MCLK,
	CLR => CLR,
	PHI_0 => PHI_0,
	PHI_90 => PHI_90,
	DIGIT => DIGIT,
	DIGEN => DIGEN,
	LEDS => LEDS);

MCLK <= not(MCLK) after 20 ns;

	
	res_pro : process
	begin
	wait for 20 ns;
         CLR <= '0';		
    wait; -- will wait forever
	end process;
	
	SW_pro : process
	begin
	for i in 0 to 3 loop
  if i < 3 then -- because 32 is 6 power to 2, so must be 31
    sw<= std_logic_vector(to_unsigned(i,sw'length));
    --assign index i to input through data transform
    wait for 3*clk_period;
    end if;
	end loop;
end process;

sl_pro : process
begin
	SENSOR_IN <= not SENSOR_IN;
	wait for 1200 ns;
end process;

end behav;