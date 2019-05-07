LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY registerFile IS
	PORT(
		CLK, RST 		 : IN  STD_LOGIC;
		src1exist, src2exist 	 : IN  STD_LOGIC;
		dst1exist, dst2exist	 : IN  STD_LOGIC;
		WB1,  WB2 		 : IN  STD_LOGIC;
		add1, add2 		 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		src1, src2 		 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		dst1, dst2 		 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		data1,data2 		 : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dataSrc1, dataSrc2 	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		dataDst1, dataDst2 	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		outR0 , outR1 , outR2 , outR3 , outR4 , outR5 , outR6 , outR7 : out STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY registerFile;

ARCHITECTURE archRegisterFile OF registerFile IS

	SIGNAL decWB1OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);	
	SIGNAL decWB2OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL decWBsORed: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL R0in , R1in , R2in , R3in , R4in , R5in , R6in , R7in  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
	--where to write decoders
	decWB1:entity work.Decoder generic map (n=>3, m=>8) port map(WB1, add1, decWB1OUT);
	decWB2:entity work.Decoder generic map (n=>3, m=>8) port map(WB2, add2, decWB2OUT);
	decWBsORed <= decWB1OUT OR decWB2OUT;
	outR0<= R0out;
	outR1<= R1out;
	outR2<= R2out;
	outR3<= R3out;
	outR4<= R4out;
	outR5<= R5out;
	outR6<= R6out;
	outR7<= R7out;



	--each registers input
	R0in <= data1 WHEN decWB1OUT(0) = '1' ELSE data2 WHEN decWB2OUT(0) = '1' ELSE (OTHERS => '0');
	R1in <= data1 WHEN decWB1OUT(1) = '1' ELSE data2 WHEN decWB2OUT(1) = '1' ELSE (OTHERS => '0');
	R2in <= data1 WHEN decWB1OUT(2) = '1' ELSE data2 WHEN decWB2OUT(2) = '1' ELSE (OTHERS => '0');
	R3in <= data1 WHEN decWB1OUT(3) = '1' ELSE data2 WHEN decWB2OUT(3) = '1' ELSE (OTHERS => '0');
	R4in <= data1 WHEN decWB1OUT(4) = '1' ELSE data2 WHEN decWB2OUT(4) = '1' ELSE (OTHERS => '0');
	R5in <= data1 WHEN decWB1OUT(5) = '1' ELSE data2 WHEN decWB2OUT(5) = '1' ELSE (OTHERS => '0');
	R6in <= data1 WHEN decWB1OUT(6) = '1' ELSE data2 WHEN decWB2OUT(6) = '1' ELSE (OTHERS => '0');
	R7in <= data1 WHEN decWB1OUT(7) = '1' ELSE data2 WHEN decWB2OUT(7) = '1' ELSE (OTHERS => '0');

	--Registers 0->7
	R0:entity work.nBitRegister generic map (16) port map (R0in, CLK, RST, decWBsORed(0), R0out);
	R1:entity work.nBitRegister generic map (16) port map (R1in, CLK, RST, decWBsORed(1), R1out);
	R2:entity work.nBitRegister generic map (16) port map (R2in, CLK, RST, decWBsORed(2), R2out);
	R3:entity work.nBitRegister generic map (16) port map (R3in, CLK, RST, decWBsORed(3), R3out);
	R4:entity work.nBitRegister generic map (16) port map (R4in, CLK, RST, decWBsORed(4), R4out);
	R5:entity work.nBitRegister generic map (16) port map (R5in, CLK, RST, decWBsORed(5), R5out);
	R6:entity work.nBitRegister generic map (16) port map (R6in, CLK, RST, decWBsORed(6), R6out);
	R7:entity work.nBitRegister generic map (16) port map (R7in, CLK, RST, decWBsORed(7), R7out);

	--registerFile outputs
	customMux0:entity work.customMUX port map(src1exist, src1, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, dataSrc1);
	customMux1:entity work.customMUX port map(src2exist, src2, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, dataSrc2);
	customMux2:entity work.customMUX port map(dst1exist, dst1, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, dataDst1);
	customMux3:entity work.customMUX port map(dst2exist, dst2, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, dataDst2);

END archRegisterFile;
