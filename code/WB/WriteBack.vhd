LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY writeBack IS
	PORT(
		MEM_WB_WB1, MEM_WB_WB2 	 : IN  STD_LOGIC;
		MEM_WB_dst1, MEM_WB_dst2 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		MEM_WB_dataDst1, MEM_WB_dataDst2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		WB1, WB2   : OUT  STD_LOGIC;
		dst1, dst2 : OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		dataDst1, dataDst2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY writeBack;

ARCHITECTURE archWriteBack OF writeBack IS
	
BEGIN
	
	WB1 <= MEM_WB_WB1;
	WB2 <= MEM_WB_WB2;
	dst1 <= MEM_WB_dst1;
	dst2 <= MEM_WB_dst2;
	dataDst1 <= MEM_WB_dataDst1;
	dataDst2 <= MEM_WB_dataDst2;
	
END archWriteBack;