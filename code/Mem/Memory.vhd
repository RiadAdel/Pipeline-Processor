LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use work.constants.all;

ENTITY memory IS
	PORT(
		CLK : IN STD_LOGIC;
		EX_MEM_dataSrc1, EX_MEM_dataSrc2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		EX_MEM_dataDst1, EX_MEM_dataDst2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		SP : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		INSTR  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		R1, R2 : IN  STD_LOGIC;
		W1, W2 : IN  STD_LOGIC;
		MEM_WB_dataDst1, MEM_WB_dataDst2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY memory;

ARCHITECTURE archMemory OF memory IS
	SIGNAL muxSelection : STD_LOGIC_VECTOR(2 DOWNTO 0);
	-- data RAM Signals
    	signal dataRam_W,dataRam_R : std_logic;
    	signal dataRam_addressToMemory : std_logic_vector(19 downto 0);
    	signal dataRam_dataToMemory : std_logic_vector(15 downto 0);
    	signal dataRam_inputFromMemory : std_logic_vector(15 downto 0);
    	-------------------------------------------------------------------------------------------------

BEGIN 
	
	-- m7tag yt3ml lsa
	muxSelection(0) <= R1 AND (NOT R2);
	muxSelection(1) <= W1 AND (NOT W2);
	muxSelection(2) <= '1' WHEN (INSTR = PUSH OR INSTR = POP OR INSTR = PUSH OR INSTR = RET OR INSTR = RTI) ELSE '0';

	dataRam_addressToMemory <= ("0000" & EX_MEM_dataSrc1) WHEN muxSelection = "000" 
	ELSE ("0000" & EX_MEM_dataSrc2) WHEN muxSelection = "001"
	ELSE ("0000" & EX_MEM_dataDst1) WHEN muxSelection = "010"
	ELSE ("0000" & EX_MEM_dataDst2) WHEN muxSelection = "011"
	ELSE SP WHEN muxSelection = "100";

	--	y-latch nafso wla la => a5ly tany condition else bs (all)
	dataRam_dataToMemory <= EX_MEM_dataSrc1 WHEN W2 = '0' ELSE EX_MEM_dataSrc2 WHEN W2 = '1';
	
	dataRam_R <= R1 OR  R2;
	dataRam_W <= W1 OR W2;

	-- RAM data only
    	dataRam: entity work.Ram  generic map(1) port map(
      	CLK,
      	dataRam_W, dataRam_R,
     	dataRam_addressToMemory,
      	dataRam_dataToMemory,
      	dataRam_inputFromMemory);
    	-------------------------------------------------------------------------------------------------


	MEM_WB_dataDst1 <= EX_MEM_dataDst1 WHEN R1 = '0' ELSE dataRam_inputFromMemory WHEN R1 = '1';
	MEM_WB_dataDst2 <= EX_MEM_dataDst2 WHEN R2 = '0' ELSE dataRam_inputFromMemory WHEN R2 = '1';
	
END archMemory;