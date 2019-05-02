LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pcMux IS
	PORT(
		--addresses entered to the mux
		Fetch1,pcAddressPlusOne,pcAddressPlusTwo,returnAddress,
		returnInterruptAddress,branchAdd: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		
		--selectors
		inturrupt,branch,S,reset: IN STD_LOGIC;
		
		--output to the pc
		ToPcOut: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY pcMux;

ARCHITECTURE pcMuxArch OF pcMux IS
	SIGNAL selection : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN 
	selection(0) <= reset;
	selection(1) <= inturrupt or branch;
	selection(2) <= inturrupt or (not branch and S);

--mux logic to be added ( i guess we need 1 more selection)
	

	
	
END pcMuxArch;
