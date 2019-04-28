LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Decoder is
	generic( n : integer := 3;
		 m : integer := 8
	);
	port(
		EN : IN STD_LOGIC;
		decIN : in  std_logic_vector(n-1 downto 0);
		decOUT: out std_logic_vector(m-1 downto 0)
	);
end Decoder;

ARCHITECTURE dec OF Decoder IS	
BEGIN
	loop0: FOR i IN 0 TO m-1 GENERATE
		decOUT(i)<= '1' WHEN (to_integer(unsigned(decIN)) = i) AND EN = '1' ELSE '0';
	END GENERATE;

END dec ;