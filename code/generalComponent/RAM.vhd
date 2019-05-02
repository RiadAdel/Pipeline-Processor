LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Ram IS
	--n is the number of lines retrieved. ex => if n = 1 -> dataOut holds 16 bits
	--if n = 2 -> dataOut holds 32 bits and so on
	GENERIC(n : INTEGER := 1);
	PORT(
		CLK : IN std_logic;
		W,R : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		dataIn  : IN  std_logic_vector(15 DOWNTO 0);
		dataOut : OUT std_logic_vector(16*n-1 DOWNTO 0));
END ENTITY Ram;

ARCHITECTURE syncrama OF Ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(CLK, W, R) IS
		VARIABLE k, j, adds:INTEGER;
			BEGIN
				k := -16;
				j := -1;
				IF rising_edge(CLK) THEN  
					IF W = '1' THEN
						ram(to_integer(unsigned(address))) <= dataIn;
					END IF;
				END IF;
				IF R = '1' THEN
					loop0: for i in 0 to n-1 loop
						k := k + 16;
						j := j + 16;
						adds := i + to_integer(unsigned(address));
						dataOut(j downto k) <= ram(adds);
					end loop;
				ELSE 
					dataOut <= (OTHERS=>'Z');
				END IF;
		END PROCESS;
		
END syncrama;
