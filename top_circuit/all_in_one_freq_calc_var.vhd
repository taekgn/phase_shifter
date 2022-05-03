library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity frequency_calculator is
port ( 
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
end frequency_calculator ;

architecture Behavioral of frequency_calculator is
type enumerate is (sync, stay, overflow, reset);--enumerate class declaration
--It contains customized data type using enumerate class

--sync: Syncrhonizes data from all DIV10s, when LOAD signal was changed to True from DIV50K.
--stay: State that REGISTER stays same without synchronising data with DIV10s, when LOAD signal is false state.
--overflow: Pads ONE to fill all signal, when ERROR signal was triggered from 6th DIV10.
--reset: Pads ZERO to wipe out stored data, when reset signal was triggered.

signal reg_handler : enumerate := stay;--dormant state is used to set default state
--It controls Register with respect to enumerate class.
--Enumerate gives better result than if-else statement
--Thus, It used in this circuit.

function vec2hex (vecin: std_logic_vector(3 downto 0))
--Function converts Vector to Hexadecimal
--This function declared for SEL circuit's HEX conversion
return std_logic_vector is
    variable hexout: std_logic_vector(3 downto 0);
begin
    case vecin is
    when "0000" =>
      hexout := x"0";
    when "0001" =>
      hexout := x"1";
    when "0010" =>
      hexout := x"2";
    when "0011" =>
      hexout := x"3";
    when "0100" =>
      hexout := x"4";
    when "0101" =>
      hexout := x"5";
    when "0110" =>
      hexout := x"6";
    when "0111" =>
      hexout := x"7";
    when "1000" =>
      hexout := x"8";
    when "1001" =>
      hexout := x"9";
    when "1010" =>
      hexout := x"A";
    when "1011" =>
      hexout := x"B";
    when "1100" =>
      hexout := x"C";
    when "1101" =>
      hexout := x"D";
    when "1110" =>
      hexout := x"E";
    when "1111" =>
      hexout := x"F";
    when others =>
      --report "Error occured" severity failure;
	  --This is a similar like Try Catch statement in Java lang, used to debug error
	  hexout := vecin;
    end case;
    return hexout;
end function;

function errflow (eflow: std_logic)
--This function declared to catch error
--When 6th DIV10 reached overflow
--This function can be used for another 7th DIV10
--However in this this circuit, It used to make special output
--Something like Z(High Impedance) or W(Weak Signal)
return std_logic_vector is
    variable thouthou : std_logic_vector(3 downto 0);
begin
  if eflow = '1' then
  thouthou :="ZZZZ";
  elsif eflow = '0' then
  thouthou := "WWWW";
  end if;
  return thouthou;
end function;

signal ff_si : std_logic; --Output signal from D-FlipFlops

signal count50k : integer range 0 to 49999 := 0 ; -- Counting Integer for DIV50K
signal ld : std_logic := '0'; -- LOAD signal enables REGISTER

signal count1 : integer range 0 to 9 := 0 ; -- Counting Integer for 1st DIV10
signal q1 : std_logic_vector(3 downto 0):=(others => '0'); --Binary output
signal of1 : std_logic := '0'; --Overflow carry bit will be transferred to next DIV10

signal count2 : integer range 0 to 9 := 0 ;  -- Counting Integer for 2nd DIV10
signal q2 : std_logic_vector(3 downto 0):=(others => '0');
signal of2 : std_logic := '0';

signal count3 : integer range 0 to 9 := 0 ;  -- Counting Integer for 3rd DIV10
signal q3 : std_logic_vector(3 downto 0):=(others => '0');
signal of3 : std_logic := '0';

signal count4 : integer range 0 to 9 := 0 ;  -- Counting Integer for 4th DIV10
signal q4 : std_logic_vector(3 downto 0):=(others => '0');
signal of4 : std_logic := '0';

signal count5 : integer range 0 to 9 := 0 ;  -- Counting Integer for 5th DIV10
signal q5 : std_logic_vector(3 downto 0):=(others => '0');
signal of5 : std_logic := '0';

signal count6 : integer range 0 to 9 := 0 ;  -- Counting Integer for 6th DIV10
signal q6 : std_logic_vector(3 downto 0):=(others => '0');
signal of6 : std_logic := '0';

signal x1 : std_logic_vector(3 downto 0); -- output will go to SEL from REGISTER
signal x10 : std_logic_vector(3 downto 0);
signal x100 : std_logic_vector(3 downto 0);
signal x1000 : std_logic_vector(3 downto 0);
signal x10000 : std_logic_vector(3 downto 0);
signal x100000 : std_logic_vector(3 downto 0);
signal err : std_logic;


signal ha : std_logic_vector(3 downto 0);
signal hb : std_logic_vector(3 downto 0);
signal hc : std_logic_vector(3 downto 0);
signal hd : std_logic_vector(3 downto 0);


begin

	ff_div50k_10_reg_pro : process(clk) is
	
	variable vce1 : std_logic := '0';
	--Signal reacts slowly, so it was not able to trigger 1st DIV10.
	--Howver, Variable reacts instantly thus variable was used to interconnect
	--CE (Latch connection) and 1st DIV10.
	
	variable vof1 : std_logic := '0';
	variable vof2 : std_logic := '0';
	variable vof3 : std_logic := '0';
	variable vof4 : std_logic := '0';
	variable vof5 : std_logic := '0';
	variable vof6 : std_logic := '0';
	--Due to "signal" showed poor result on waveform
	--They were replaced by "variable" and showed better waveform
	
	--However, each count and of signals were kept
	--Since, they appear on waveform unlike "variable" parameters
	--Which gives some helps to track down error of circuit
	
	begin
	
	vce1 := (not ff_si) and si;
	if rising_edge(clk) then
		ff_si <= si; --FF output signal which goes into latch of 1st CE signal 
		de <= ld; --Display Enable signal goes to DISPLAY_INTEFACE circuit		
		
		case reg_handler is
		when sync =>
		x1 <= q1;
		x10 <= q2;
		x100 <= q3;
		x1000 <= q4;
		x10000 <= q5;
		x100000 <= q6;
		err <= '0';
		when stay =>
		--Does nothing, Just No Synchronisation
		when overflow =>
		x1 <= "1111";
        x10 <= "1111";
        x100 <= "1111";
        x1000 <= "1111";
        x10000 <= "1111";
        x100000 <= "1111";
		when reset =>
		x1 <= "0000";
        x10 <= "0000";
        x100 <= "0000";
        x1000 <= "0000";
        x10000 <= "0000";
        x100000 <= "0000";
    end case;
		
		if count50k = 49999 then --DIV50K that produces LOAD signal for REGISTER
		count50k <= 0;--reseting count number
		ld <= '1'; --Make LOAD signal to be true, to enable REGISTER
		if vof6 = '0' then reg_handler <= sync; end if; --vof6 if close
		else count50k <= count50k + 1; ld <= '0';  if vof6 = '0' then reg_handler <= stay; end if; --vof6 if close
		end if; --50K if close
		
		if res ='1' then
		count50k<=0;
		ld <= '0';
		
		ff_si <= '0';
		de <= '0';
		
		count1<=0;
		q1 <= "0000";
		of1 <= '0';
		count2<=0;
		q2 <= "0000";
		of2 <= '0';
		count3<=0;
		q3 <= "0000";
		of3 <= '0';
		count4<=0;
		q4 <= "0000";
		of4 <= '0';
		count5<=0;
		q5 <= "0000";
		of5 <= '0';
		count6<=0;
		q6 <= "0000";
		of6 <= '0';
		
	    err <= '0';
		reg_handler <= reset;		
		end if; --res if
		
		--From here, below declarations are 6 of DIV10
		--When their Q reached 10 (1001), roll back to 0
		--Count from 0 again and produces Overflow signal
		--To transfer carry bit to next DIV10
		if vce1 = '1' then
			if q1 = "1001" then--count = 9 then
			count1 <= 0;--reseting count number
			of1 <= '1'; vof1 := '1';
			q1 <= "0000";
			
			if q2 = "1001" then--count = 9 then
			q2 <= "0000"; count2 <= 0;
			of2 <= '1'; vof2 := '1';
			
			if q3 = "1001" then--count = 9 then
			q3 <= "0000"; count3 <= 0;
			of3 <= '1'; vof3 := '1';
			
			if q4 = "1001" then-- if q4
			q4 <= "0000"; count4 <= 0;--reseting count number
			of4 <= '1'; vof4 := '1';
			
			if q5 = "1001" then--count = 9 then
			q5 <= "0000"; count5 <= 0;--reseting count number
			of5 <= '1'; vof5 := '1';
			
			if q6 = "1001" then--count = 9 then
			q6 <= "0000"; count6 <= 0;--reseting count number
			of6 <= '1'; vof6 := '1';
			err <= vof6;

			reg_handler <= overflow;
			else of6 <= '0'; vof6 := '0'; q6 <= q6 + vof5; count6 <= count6 + 1; err <='0';
			end if; -- if q6
			
			else of5 <= '0'; vof5 := '0'; q5 <= q5 + 1; count5 <= count5 + 1;
			end if; -- if q5
			
			else of4 <= '0'; vof4 := '0'; q4 <= q4 + vof3; count4 <= count4 + 1;
			end if; -- if q4
			
			else of3 <= '0'; vof3 := '0'; q3 <= q3 + vof2; count3 <= count3 + 1;
			end if; -- if q3
			
			else of2 <= '0'; vof2 := '0'; q2 <= q2 + vof1; count2 <= count2 + 1;
			end if; -- if q2
			
			else of1 <= '0'; vof1 := '0';
			count1 <= count1 + 1;
			q1 <= q1 + 1;
			end if; -- if q1
		end if; --vce1 if
	elsif falling_edge(clk) then
	--Nothing
	end if; --clk if
	end process ff_div50k_10_reg_pro;
	
--ce1  <= (not ff_si) and si;
--This concurrent latch statement doesn't work
--So, this was relocated in Sequential Field as Variable
leds <= sw;

--Belows declarations are equivalent to Multiplexer
--Switches output with respect to SW (SL) input signal 
with sw select
ha <= vec2hex(x1) when "00",
vec2hex(x10) when "01",
vec2hex(x100) when "10",
vec2hex(x1000) when "11",
"0000" when others;

with sw select
hb <= vec2hex(x10) when "00",
vec2hex(x100) when "01",
vec2hex(x1000) when "10",
vec2hex(x10000) when "11",
"0000" when others;

with sw select
hc <= vec2hex(x100) when "00",
vec2hex(x1000) when "01",
vec2hex(x10000) when "10",
vec2hex(x100000) when "11",
"0000" when others;

with sw select
hd <= vec2hex(x1000) when "00",
vec2hex(x10000) when "01",
vec2hex(x100000) when "10",
errflow(err) when "11",
"0000" when others;

da <= ha;
db <= hb;
dc <= hc;
dd <= hd;
	
end Behavioral;
