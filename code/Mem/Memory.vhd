LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use work.constants.all;

ENTITY memory IS
	PORT(
		ID_EX_dataSrc1, ID_EX_dataSrc2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		ID_EX_dataDst1, ID_EX_dataDst2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		INSTR  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		R1, R2 : IN  STD_LOGIC;
		W1, W2 : IN  STD_LOGIC;
		R , W  : OUT STD_LOGIC;
		addressToMemory : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address size msh mazbot
		dataToMemory : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		inputFromMemory : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		MEM_WB_dataDst1, MEM_WB_dataDst2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY memory;

ARCHITECTURE archMemory OF memory IS
	SIGNAL muxSelection : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN 
	
	-- m7tag yt3ml lsa
	muxSelection(0) <= R1 AND (NOT R2);
	muxSelection(1) <= W1 AND (NOT W2);
	muxSelection(2) <= '1' WHEN (INSTR = PUSH OR INSTR = POP OR INSTR = PUSH OR INSTR = RET OR INSTR = RTI) ELSE '0';

	addressToMemory <= ID_EX_dataSrc1 WHEN muxSelection = "000" 
	ELSE ID_EX_dataSrc2 WHEN muxSelection = "001"
	ELSE ID_EX_dataDst1 WHEN muxSelection = "010"
	ELSE ID_EX_dataDst2 WHEN muxSelection = "011"
	ELSE SP WHEN muxSelection = "100";

	--	y-latch nafso wla la => a5ly tany condition else bs (all)
	dataToMemory <= ID_EX_dataSrc1 WHEN W2 = '0' ELSE ID_EX_dataSrc2 WHEN W2 = '1';
	
	R <= R1 OR  R2;
	W <= W1 AND W2;

	MEM_WB_dataDst1 <= ID_EX_dataDst1 WHEN R1 = '0' ELSE inputFromMemory WHEN R1 = '1';
	MEM_WB_dataDst2 <= ID_EX_dataDst2 WHEN R2 = '0' ELSE inputFromMemory WHEN R2 = '1';
	
END archMemory;