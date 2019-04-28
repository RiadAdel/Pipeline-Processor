LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity customMUX is
	port(
		EN : IN STD_LOGIC;
		SEL : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		muxIN0, muxIN1, muxIN2, muxIN3, muxIN4, muxIN5, muxIN6, muxIN7 : in  std_logic_vector(15 downto 0);
		muxOUT: out std_logic_vector(15 downto 0)
	);
end customMUX;

ARCHITECTURE archCustomMux OF customMUX IS	
BEGIN
	
	muxOUT <= (OTHERS => 'Z') WHEN EN = '0'
	ELSE muxIN0 WHEN SEL = "000"
	ELSE muxIN1 WHEN SEL = "001"
	ELSE muxIN2 WHEN SEL = "010"
	ELSE muxIN3 WHEN SEL = "011"
	ELSE muxIN4 WHEN SEL = "100"
	ELSE muxIN5 WHEN SEL = "101"
	ELSE muxIN6 WHEN SEL = "110"
	ELSE muxIN7 WHEN SEL = "111";

END archCustomMux;