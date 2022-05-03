Library ieee;
Use ieee.std_logic_1164.all;

entity Top_level is
port (
	SENSOR_IN : in std_logic;
	SW : in std_logic_vector(1 downto 0);
	MCLK : in std_logic;
	CLR : in std_logic; --Display Enable coming from DIV50K, used for counting and enable
	PHI_0    : out std_logic;
	PHI_90   	: out std_logic;		-- display clock, reset
	DIGIT	: out std_logic_vector(7 downto 0);		-- Output for  common cathoode//LED DISPLAY VALUE
	DIGEN	: out std_logic_vector(3 downto 0);
	LEDS : out std_logic_vector(1 downto 0));		-- Output for common anode//LED DISPLAY ENABLE
end Top_level;

architecture behav of Top_level is
COMPONENT DIV2
PORT(
mclk : IN std_logic;
clk : OUT std_logic
);
END COMPONENT;
component SYNC is
port ( 
      d : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  res : in  std_logic ;
	  clk : in  std_logic ;
      q : out  std_logic); --It will be RES or SI signal
end component;
component phase_shift is
port ( 
    si : in  std_logic ; --It will be CLR or SENSOR_IN signal
	  clk : in  std_logic ;
	  res : in  std_logic ;
	  phi_0 : out  std_logic;
    phi_90 : out  std_logic); --It will be RES or SI signal
end component ;
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

signal clk : std_logic := '0';
signal res : std_logic := '0';

signal SI : std_logic := '0';

signal DA : std_logic_vector(3 downto 0);
signal DB : std_logic_vector(3 downto 0);
signal DC : std_logic_vector(3 downto 0);
signal DD : std_logic_vector(3 downto 0);
signal DE : std_logic;

begin

uut: DIV2 PORT MAP (
mclk => mclk,
clk => clk
);


U_sync_res: SYNC port map(
    d => clr,
    res => res,
    clk => clk,  
    Q => res
  ) ;
   
U_sync_si: SYNC port map(
    d => SENSOR_IN,
    res => res,
    clk => clk,  
    Q => SI
  ) ;

u_fase: phase_shift PORT MAP (
si => si,
clk => clk,
res => res,
phi_0 => phi_0,
phi_90 => phi_90
);

u_freq: frequency_calculator port map (
    sw => sw, 
    si => si,
	clk => clk,
	res => res, 
	leds => leds,
    da => da,
    db => db,
    dc => dc,
    dd => dd,
	de => de);

u_disp: DISPLAY port map(
	HEXA => DA,
	HEXB  => DB,
	HEXC  => DC,
	HEXD  => DD,
	DE  => DE,
	CLK   => CLK,
	RST   	 => RES,
	DIGIT	 => DIGIT,
	DIGEN	 => DIGEN);

end behav;