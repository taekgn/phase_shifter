library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY Tb_SEL IS
END Tb_SEL;

architecture Behavioral of tb_sel is
component sel is port (
      x1 :  in std_logic_vector(3 downto 0); -- output will go to sel 
      x10 :  in std_logic_vector(3 downto 0);
      x100 :  in std_logic_vector(3 downto 0);
      x1000 :  in std_logic_vector(3 downto 0);
      x10000 :  in std_logic_vector(3 downto 0);
      x100000 :  in std_logic_vector(3 downto 0);
      err : in std_logic;
      sl : in std_logic_vector(1 downto 0);
      da : out std_logic_vector(3 downto 0);
      db : out std_logic_vector(3 downto 0);
      dc : out std_logic_vector(3 downto 0);
      dd : out std_logic_vector(3 downto 0);
      led : out  std_logic_vector(1 downto 0)); --It will be RES or SI signal
end component ;

signal x1 : std_logic_vector(3 downto 0):="0000" ; -- output will go to sel 
signal x10 : std_logic_vector(3 downto 0):="0000";
signal x100 : std_logic_vector(3 downto 0):="0000";
signal x1000 : std_logic_vector(3 downto 0):="0000";
signal x10000 : std_logic_vector(3 downto 0):="0000";
signal x100000 : std_logic_vector(3 downto 0):="0000";
signal err : std_logic;
signal sl : std_logic_vector(1 downto 0);
signal da : std_logic_vector(3 downto 0);
signal db : std_logic_vector(3 downto 0);
signal dc : std_logic_vector(3 downto 0);
signal dd : std_logic_vector(3 downto 0);
signal led :  std_logic_vector(1 downto 0);

begin
uut: sel port map (
      x1 =>x1,
      x10  =>x10,
      x100  =>x100,
      x1000  =>x100,
      x10000  =>x1000,
      x100000  =>x100000,
      err  =>err,
      sl  =>sl,
      da  =>da,
      db  =>db,
      dc  =>dc,
      dd  =>dd,
      led  =>led); --It will be RES or SI signal

--parallel process threading

x_process :process
begin
  wait for 20 ns;
  if x1 = "1111" then
  x1 <= x"0"; 
  x10 <=x"0"; 
  x100 <= x"0"; 
  x1000 <=  x"0"; 
  x10000 <= x"0"; 
  x100000 <= x"0"; 
  end if;
  
  x1 <=x1 + x"1"; 
  x10 <= x10 + x"1"; 
  x100 <= x100 + x"1"; 
  x1000 <= x1000 + x"1"; 
  x10000 <= x1000 + x"1"; 
  x100000 <= x1000 + x"1"; 
  wait for 20 ns;
end process;

sl_pro : process
begin
   err <= '0';
   wait for 30 ns;
   sl <= "00";
   wait for 60 ns;
   sl <= "01";
   wait for 60 ns;
   sl <= "10";
   wait for 60 ns;
   sl <= "11";
   wait for 20 ns;
   err <= '1'; 
   wait for 80 ns;
end process;
END;