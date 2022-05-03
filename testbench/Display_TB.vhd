---------------------------------------------------------------
-- Project:	YYYYY
-- HDL Name:	XXXXX_TB
-- Function:	Test Bench for Leading One Detector            

-- Status	Untested

---------------------------------------------------------------


---------------------------------------------------------------
-- Library Statements
---------------------------------------------------------------
--
library ieee;
library std;
--library std_developerskit;
--use std_developerskit.std_iopak;      
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_textio.all;
--use ieee.std_logic_arith.all;
use std.textio.all;
---------------------------------------------------------------
-- Entity Statement
---------------------------------------------------------------

entity 	TB_DISPLAY is
end 	   TB_DISPLAY;


---------------------------------------------------------------
-- TestBench Architecture
---------------------------------------------------------------

architecture behavior OF TB_DISPLAY is 


---------------------------------------------------------------
-- Component Description
---------------------------------------------------------------
component DISPLAY is
port (
	HEXA : in std_logic_vector(3 downto 0);
	HEXB : in std_logic_vector(3 downto 0);
	HEXC : in std_logic_vector(3 downto 0);
	HEXD : in std_logic_vector(3 downto 0);
	DE : in std_logic; --Display Enable coming from DIV50K, used for counting and enable
	CLK    : in std_logic;
	RST   	: in std_logic;		-- display clock, reset
	DIGIT	: out std_logic_vector(7 downto 0);		-- Output for  common cathoode//LED DISPLAY VALUE
	DIGEN	: out std_logic_vector(3 downto 0));		-- Output for common anode//LED DISPLAY ENABLE
end component;

---------------------------------------------------------------
-- Type definitions (if any)
---------------------------------------------------------------
 
 
 

---------------------------------------------------------------
-- TextIO declarations (if any)
---------------------------------------------------------------
---------------------------------------------------------------
-- signal declarations 
---------------------------------------------------------------

signal	HEXA : std_logic_vector(3 downto 0);
signal 	HEXB : std_logic_vector(3 downto 0);
signal 	HEXC : std_logic_vector(3 downto 0);
signal 	HEXD : std_logic_vector(3 downto 0);
signal 	DE : std_logic; --Display Enable coming from DIV50K, used for counting and enable
signal 	CLK    : std_logic := '0';
signal 	RST   	: std_logic:= '1';		-- display clock, reset
signal	DIGIT	: std_logic_vector(7 downto 0);		-- LED DISPLAY VALUE
signal	DIGEN	: std_logic_vector(3 downto 0); -- LED DISPLAY ENABLE

constant clk_period : time := 40 ns;
	
begin

---------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------
uut: DISPLAY

port map(
	HEXA => HEXA,
	HEXB  => HEXB,
	HEXC  => HEXC,
	HEXD  => HEXD,
	DE  => DE,
	CLK   => CLK,
	RST   	 => RST,
	DIGIT	 => DIGIT,
	DIGEN	 => DIGEN);      -- LEDs
    
 

CLK <= not(CLK) after 10 ns;

   tb : process
 
---------------------------------------------------------------
-- Variable definitions
---------------------------------------------------------------  
   
   begin

			wait for 20 ns;
         RST <= '0';
				
      wait; -- will wait forever

   end process;

	hex_pro : process
	begin
	wait for 40 ns;
	DE <= '1';
	HEXA <= "0001";
	HEXB <= "1000";
	HEXC <= "0111";
	HEXD <= "0110";
	wait for 400 ns;
	HEXA <= "0001";
	HEXB <= "1000";
	HEXC <= "0111";
	HEXD <= "0110";
	wait for 400 ns;
	HEXA <= "0101";
	HEXB <= "0110";
	HEXC <= "0101";
	HEXD <= "0111";
	end process;
end;
