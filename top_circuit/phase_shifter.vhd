library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --to perform arithmetic maths function
use IEEE.STD_LOGIC_ARITH.ALL; --to control integer variable

entity phase_shift is
port ( 
    si : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  clk : in  std_logic ;
	  res : in  std_logic ;
	  phi_0 : out  std_logic;
    phi_90 : out  std_logic); --It will be RES or SI signal
end phase_shift ;

architecture Behavioral of phase_shift is

function ninety (t1 : std_logic; t2 : std_logic; t3 : std_logic)
--Function that produces PHI_90 output
return std_logic is
    variable rightangle : std_logic;
begin
if (t3 = 'U') or (t3 ='X') then
rightangle := (t1 or t2) xnor '1'; --input for bottom PHI_90 FF
else rightangle := (t1 or t2) xnor t3; --input for bottom PHI_90 FF
end if;
    return rightangle;
end function;

function oddeven (n : integer; token : std_logic)
--This function is very important for both counters
--Becuase it sovles 1 toggle cycle delay by dicriminating index number from counter
--Final counted value, if final value was odd number
--Then it will be filtered by this function
--Which makes PHI_90 to be located at right mid-point of SI signal

--------------------------------
--This function is imperfect, still has some trouble with ODD PERIOD TIME; E.g. when SI is 365 ns or 483 ns
--However, It does work fine on Oscilloscope.
--------------------------------
return integer is
    variable evennum : integer;
begin
if token = '1' then
	if (n rem 2) >= 1 then
	--to prevent 1 clock delay due to odd number from counter
	evennum := n -1;
	--report "subtract" severity failure;
	elsif (n rem 2) = 0 then
	evennum := n;
	--report "addition" severity failure;
	else report "Error occured" severity failure; --This is a similar like Try Catch statement in Java lang, used to debug error
	end if; --remainder theorem was applied
else evennum := n;
end if; --token if
return evennum;
end function;

signal toggle : std_logic := '0'; -- output for toggle signal

signal cea : std_logic; -- clock enable for counter A
signal count_a : integer := 0; --signal to state counter A numerically
signal tcu1 : std_logic := '0'; -- output from counter A
--
signal ceb : std_logic; -- clock enable for counter B
signal count_b : integer := 0; --signal to state counter B numerically
signal tcu2 : std_logic :='0'; -- output from counter B
--signal for phi parts
signal sibuf : std_logic; --buffer signal for SI to control entire circuit mechanism
signal rightout : std_logic; --signal to insert PHI_90

signal tokena : std_logic; --a key to execute oddnum function for counter a, It's for fist time use only
signal tokenb : std_logic; --a key to invoke oddnum mehtod for counter b, It's for fist time use only
--
begin
--Concurrent Field
cea <= (si and toggle) or (not si); --assigning cea values
ceb <= ((not si) and toggle) or si; --assigning ceb valvues
rightout <= ninety(tcu1,tcu2,sibuf); --input for bottom PHI_90 FF
phi_90 <= '1' when (rightout = '1') else
		  '0' when rightout = '0' else
		  '0';
--PHI_90 was declared in Coucurrent Field
--Due to delay and unexpected error from Sequential Field

  tog_counter_phi : process (clk)--synchronous process for counter
    begin
	--Sequential Field
		  if rising_edge(clk) then
		  --Below code is D-FF assignments
		  toggle <= not toggle;--Half clock divider from Toggle circuit
		  sibuf <= si; --This is a medium/buffer signal that goes into ninety function creates output for PHI_90 output in Concurrent Field
		  phi_0 <= si; --Synchronous PHI_0 output assignment
		  if res ='1' then
			--Synchronous reset
			    toggle <= '0';
			    count_a <= 0;
			    count_b <= 0;	
				tcu1 <= '0';
				tcu2 <= '0';
			    phi_0 <= '0';
				--phi_90 <= '0';
				--PHI_90 will not be directly reseted, Since PHI_90 was declared in Concurrent Field
				--Abandoning PHI_90 reseet was best choice
		   end if;				

		    if si ='1' then --counting up state
				tcu1 <= '0'; -- disable tcu1 when si is true
				tokena <= '1'; --Activtes token for ODD-EVEN discrimant function
				if cea = '1' then --Counter A up state
		        	count_a <= count_a + 1;
				end if; --cea if
				
				if ceb='1' then --Counter B down state
				if count_b = 1 then
				count_b <= 0;
				tcu2 <= '1';
				else count_b <= oddeven(count_b,tokenb) -1;
				--oddeven function discriminates final counter index number
				--If it's odd number then subtracts 1 internally and subtract 1 again by if statement
				--Otherwise returns Even number without modifying.
				tokenb <='0';
				end if;
				end if; --ceb if 
				
				if count_b = 0 then --zero state
					tcu2 <= '1';
					count_b <= 0;
				end if; --count if
				
		    elsif si = '0' then
				tcu2 <= '0'; --disable tcu2 when si is false
				tokenb <='1';
				if ceb='1' then --Counter B up state
				count_b <= count_b + 1;
				end if; --ceb if 
				
				if cea = '1' then -- Counter A down state
				if count_a = 1 then
				count_a <= 0;
				tcu1 <= '1';
				else count_a <= oddeven(count_a,tokena) -1;
				tokena <='0';
				end if;
				end if; -- cea if				
				
				if count_a = 0 then --zero state
					tcu1 <= '1';
					count_a <= 0;
				end if; --count if
				
		    end if; -- si if close	

		  end if; -- clk if	close  
    end process tog_counter_phi;
	
end Behavioral;
