Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DISPLAY is
port (
	HEXA : in std_logic_vector(3 downto 0);
	HEXB : in std_logic_vector(3 downto 0);
	HEXC : in std_logic_vector(3 downto 0);
	HEXD : in std_logic_vector(3 downto 0);
	DE : in std_logic; --Display Enable coming from DIV50K, used for counting and enabling Anodes
	CLK    : in std_logic;
	RST   	: in std_logic;		-- display clock, reset
	DIGIT	: out std_logic_vector(7 downto 0);		-- Output for  common cathoode//LED DISPLAY VALUE
	DIGEN	: out std_logic_vector(3 downto 0));		-- Output for common anode//LED DISPLAY ENABLE
end DISPLAY;

architecture behav of Display is
function hex2seg (hexbin: std_logic_vector(3 downto 0))
--This is a Look up Table function for Hexadecimal conversion
--Maps Cathodes with respect to Anodes
return std_logic_vector is
    variable cathode: std_logic_vector(7 downto 0);
    --If it was only indicated digit then 6 downto 0 but 7 downto 0 since it indicates until decimal point
begin
    case hexbin is
    --"ZERO" means lit on (Enable segment) and "ONE" means tuned off (Disable a cathode element in segment)
    --Order from RIGHT to LEFT is:CA CB CC CD CE CF CG DP
	 --Thus, E.G. 11111110 will only turn on CA element because only CA is true.
    --Where C means Cathode and DP means Decimal Point
	--This notation applied to Anode
    when "0000" => cathode := "11000000"; -- "0"     
    when "0001" => cathode := "11111001"; -- "1" 
    when "0010" => cathode := "10100100"; -- "2" 
    when "0011" => cathode := "10110000"; -- "3" 
    when "0100" => cathode := "10011001"; -- "4" 
    when "0101" => cathode := "10010010"; -- "5" 
    when "0110" => cathode := "10000010"; -- "6" 
    when "0111" => cathode := "11111000"; -- "7" 
    when "1000" => cathode := "10000000"; -- "8"     
    when "1001" => cathode := "10010000"; -- "9" 
    when "1010" => cathode := "10100000"; -- "A"
    when "1011" => cathode := "10000011"; -- "B"
    when "1100" => cathode := "11000110"; -- "C"
    when "1101" => cathode := "10100001"; -- "D"
    when "1110" => cathode := "10000110"; -- "E"
    when "1111" => cathode := "10001110"; -- "F"
	--Below Meta-value declarations are buffers for error cases
	--But ignored on synthesize process.
	when "ZZZZ" => cathode := "01111111"; -- "."
	when "XXXX" => cathode := "01111111"; -- "."
	when "UUUU" => cathode := "01111111"; -- "."
	when "LLLL" => cathode := "01111111"; -- "."
	when "HHHH" => cathode := "01111111"; -- "."
	when "----" => cathode := "01111111"; -- "."
	when "WWWW" => cathode := "01111111"; -- "."
	when others => cathode := "01111111"; -- "."
	 --Others case is essential to prevent error
	 --When overflow was occured, the input of this function will be Z(High Impedance)
	 --Which will make only decimal point to be turned on.
	end case;
    return cathode;
end function;

  	--signal refreshrate : integer;
  	--Anode selects which segment to be inserted
  	signal anode	: integer range 0 to 3;
	signal DCE : std_logic;
	--Display Clock Enable signal
	
	begin
	
	interval_pro: process(CLK) is
		variable count : natural range 0 to 6400000;
	begin
		if clk='1' and clk'event then
				if rst='1' then
				DCE    <= '0';
				count := 0;
				elsif count=512 then
				--Counting 512 has showed almost 0.5 seconds interval time
				--of shifting/assigning 7 segment display to next
				--From RIGHT to LEFT; AN3 -> AN2 -> AN1 -> AN0
					DCE    <= '1';
					count := 0;
				else
				   DCE <= '0';
					count := count + 1;
				end if;
		end if;
	end process interval_pro;
	
	main_pro : process(clk) is
	begin
		 if clk='1' and clk'event then
			if rst='1' then
			DIGIT <= "00000011";
			DIGEN <= "1111";
		 	--elsif DCE = '1' then
			elsif DE = '1' then
			--anode <= anode + 1;
			case anode is
			when 0 =>
			digen <= "0111"; --only activate 1st Anode; AN0 : N16
			digit <=  hex2seg(HEXA);
			anode <= anode + 1;
			when 1 =>
			digen <= "1011"; --only activate 2nd Anode; AN1 : N15
			digit <=  hex2seg(HEXB);
			anode <= anode + 1;
			when 2 =>
			digen <= "1101"; --only activate 3rd Anode; AN2 : P18
			digit <=  hex2seg(HEXC);
			anode <= anode + 1;
			when 3 =>
			digen <= "1110"; --only actiavate 4th Anode; AN3 : P17
			digit <=  hex2seg(HEXD);
			anode <= 0;
			when  others =>
			anode <= 0;
			digen <= "1110"; --only activate 1st Segment Unit
			digit <=  hex2seg(HEXA);
			end case;
			--end if; --DCE if
			end if;
		end if;
	end process main_pro;
	
end behav;
