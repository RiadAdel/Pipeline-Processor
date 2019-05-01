LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use work.constants.all;

ENTITY StageDecode IS
	PORT(
		IF_ID_SRC1Exist, IF_ID_SRC2Exist , IF_ID_DST1Exist,IF_ID_DST2Exist : IN  STD_LOGIC;
		IF_ID_OpCode1 , IF_ID_OpCode2 : IN  Std_logic_vector(4 downto 0);
		IF_ID_Src1 , IF_ID_Dst1 ,  IF_ID_Src2 , IF_ID_Dst2   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		Bubble : IN  std_logic;
		S, ID_EX_WB1 , ID_EX_WB2 , ID_EX_R1 ,ID_EX_R2 ,ID_EX_W1 ,ID_EX_W2 : OUT  STD_LOGIC;
		ID_EX_SRC1Exist, ID_EX_SRC2Exist ,ID_EX_DST1Exist,ID_EX_DST2Exist : out  STD_LOGIC;
		ID_EX_OpCode1 , ID_EX_OpCode2 : out  Std_logic_vector(4 downto 0)
	);
END ENTITY StageDecode;

ARCHITECTURE De OF StageDecode IS
	
BEGIN
ID_EX_SRC1Exist<=IF_ID_SRC1Exist;
ID_EX_SRC2Exist<=IF_ID_SRC2Exist;
ID_EX_DST1Exist<=IF_ID_DST1Exist;
ID_EX_DST1Exist<=IF_ID_DST1Exist;
ID_EX_OpCode1<=IF_ID_OpCode1;
ID_EX_OpCode2<=IF_ID_OpCode1;


ID_EX_R1 <= '1' when IF_ID_OpCode1 = POP  or IF_ID_OpCode1 = LDD or IF_ID_OpCode1 = RET or IF_ID_OpCode1=RTI else '0';
ID_EX_R2 <= '1' when IF_ID_OpCode2 = POP  or IF_ID_OpCode2 = LDD or IF_ID_OpCode2 = RET or IF_ID_OpCode2=RTI else '0';
ID_EX_W1 <= '1' when IF_ID_OpCode1 = PUSH or IF_ID_OpCode1 = SSTD or IF_ID_OpCode1 = CALL else '0';
ID_EX_W2 <= '1' when IF_ID_OpCode1 = PUSH or IF_ID_OpCode1 = SSTD or IF_ID_OpCode1 = CALL else '0';


ID_EX_WB1 <= '1' when  IF_ID_DST1Exist = '1' and  IF_ID_OpCode1 /= SSTD  else '0'; 
ID_EX_WB2 <= '1' when  IF_ID_DST2Exist = '1' and  IF_ID_OpCode2 /= SSTD  else '0'; 


S<= '1' when  ( IF_ID_Dst1 = IF_ID_Dst2   and IF_ID_DST1Exist = '1' and IF_ID_DST2Exist = '1' and IF_ID_OpCode2 /= IIN and IF_ID_OpCode2 /= POP and IF_ID_OpCode2 /= LDD  )  
or (IF_ID_Dst1 = IF_ID_Src2 and IF_ID_DST1Exist='1'  and IF_ID_SRC2Exist='1' )
or (IF_ID_OpCode2 = LDM ) 
or (IF_ID_OpCode1(4 downto 3) = "10" and IF_ID_OpCode2(4 downto 3) = "10" ) 
or ((IF_ID_OpCode1(4 downto 3) = "00" or IF_ID_OpCode1(4 downto 3) = "01"  ) and IF_ID_OpCode1 /= NOP and IF_ID_OpCode1 /= OOUT and IF_ID_OpCode1 /= MOV and IF_ID_OpCode2(4 downto 3 )= "11"   )
else '0';

	
END De;