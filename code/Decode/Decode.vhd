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
		ID_EX_OpCode1 , ID_EX_OpCode2 : out  Std_logic_vector(4 downto 0);
		ID_EX_ALUSelection1 , ID_EX_ALUSelection2:out std_logic_vector (3 downto 0)
	);
END ENTITY StageDecode;

ARCHITECTURE De OF StageDecode IS
	signal ID_EX_ALUSel1 , ID_EX_ALUSel2: std_logic_vector (3 downto 0);
	signal Semi_S : std_logic;
BEGIN

S<= Semi_S;

ID_EX_SRC1Exist<=IF_ID_SRC1Exist and (not Bubble );
ID_EX_SRC2Exist<=IF_ID_SRC2Exist when Bubble = '0' and Semi_S= '0' and IF_ID_OpCode1 /= LDM  else '0';
ID_EX_DST1Exist<=IF_ID_DST1Exist and (not Bubble );
ID_EX_DST2Exist<=IF_ID_DST2Exist when Bubble = '0' and Semi_S = '0' and IF_ID_OpCode1 /= LDM  else '0';
ID_EX_OpCode1<=IF_ID_OpCode1  when Bubble = '0' else "00000";
ID_EX_OpCode2<=IF_ID_OpCode2 when Bubble = '0' and Semi_S = '0' and IF_ID_OpCode1 /= LDM  else "00000";


ID_EX_R1 <= '1' when (IF_ID_OpCode1 = POP  or IF_ID_OpCode1 = LDD or IF_ID_OpCode1 = RET or IF_ID_OpCode1=RTI ) and ( Bubble = '0' ) else '0';
ID_EX_R2 <= '1' when (IF_ID_OpCode2 = POP  or IF_ID_OpCode2 = LDD or IF_ID_OpCode2 = RET or IF_ID_OpCode2=RTI ) and ( Bubble = '0' and Semi_S= '0' and IF_ID_OpCode1 /= LDM  ) else '0';
ID_EX_W1 <= '1' when (IF_ID_OpCode1 = PUSH or IF_ID_OpCode1 = SSTD or IF_ID_OpCode1 = CALL )and ( Bubble = '0') else '0';
ID_EX_W2 <= '1' when (IF_ID_OpCode2 = PUSH or IF_ID_OpCode2 = SSTD or IF_ID_OpCode2 = CALL) and ( Bubble = '0' and Semi_S = '0' and IF_ID_OpCode1 /= LDM  ) else '0';


ID_EX_WB1 <= '1' when  (IF_ID_DST1Exist = '1' and  IF_ID_OpCode1 /= SSTD ) and ( Bubble = '0' )  else '0'; 
ID_EX_WB2 <= '1' when  (IF_ID_DST2Exist = '1' and  IF_ID_OpCode2 /= SSTD) and ( Bubble = '0' and Semi_S = '0' and IF_ID_OpCode1 /= LDM  ) else '0'; 


Semi_S<= '1' when  ( IF_ID_Dst1 = IF_ID_Dst2   and IF_ID_DST1Exist = '1' and IF_ID_DST2Exist = '1' and IF_ID_OpCode2 /= IIN and IF_ID_OpCode2 /= POP and IF_ID_OpCode2 /= LDD  )  
or (IF_ID_Dst1 = IF_ID_Src2 and IF_ID_DST1Exist='1'  and IF_ID_SRC2Exist='1' )
or (IF_ID_OpCode2 = LDM ) 
or (IF_ID_OpCode1(4 downto 3) = "10" and IF_ID_OpCode2(4 downto 3) = "10" ) 
or ((IF_ID_OpCode1(4 downto 3) = "00" or IF_ID_OpCode1(4 downto 3) = "01"  ) and IF_ID_OpCode1 /= NOP and IF_ID_OpCode1 /= OOUT and IF_ID_OpCode1 /= MOV and IF_ID_OpCode2(4 downto 3 )= "11"   )
or (IF_ID_OpCode1 = OOUT and IF_ID_OpCode2 = OOUT)
or (IF_ID_OpCode1 = IIN and IF_ID_OpCode1 = IIN )
else '0';



ID_EX_ALUSel1 <= ALUFEQUAL0 when IF_ID_OpCode1 = NOP or IF_ID_OpCode1=OOUT or IF_ID_OpCode1 = IIN or IF_ID_OpCode1 = MOV or IF_ID_OpCode1(4 downto 3) = "10" or IF_ID_OpCode1 = RTI or IF_ID_OpCode1 = RET 
else  ALUSETC when IF_ID_OpCode1 = SETC 
else ALUCLEARC when IF_ID_OpCode1 = CLRC
else ALUNOT when IF_ID_OpCode1 = NNOT
else ALUINC when IF_ID_OpCode1 = INC
else ALUDEC when IF_ID_OpCode1 = DEC
else ALUADD when IF_ID_OpCode1 = ADD
else ALUSUB when IF_ID_OpCode1 = SSUB
else ALUAND when IF_ID_OpCode1 = AAND
else ALUOR when IF_ID_OpCode1 = OOR
else ALUSHL when IF_ID_OpCode1 = SHL
else ALUSHR when IF_ID_OpCode1 = SHR  
else ALUFEQUALA when IF_ID_OpCode1= IIN or IF_ID_OpCode1 = MOV or IF_ID_OpCode1 = OOUT
else ALUFEQUALB when IF_ID_OpCode1 = JZ or IF_ID_OpCode1 = JN or IF_ID_OpCode1 = JC or IF_ID_OpCode1 = CALL or IF_ID_OpCode1 = JMP
else ALUFEQUAL0;

ID_EX_ALUSelection1<= ID_EX_ALUSel1 when Bubble = '0' else ALUFEQUAL0;

ID_EX_ALUSel2 <= ALUFEQUAL0 when IF_ID_OpCode2 = NOP or IF_ID_OpCode2=OOUT or IF_ID_OpCode2 = IIN or IF_ID_OpCode2 = MOV or IF_ID_OpCode2(4 downto 3) = "10" or IF_ID_OpCode2 = RTI or IF_ID_OpCode2 = RET 
else  ALUSETC when IF_ID_OpCode2 = SETC 
else ALUCLEARC when IF_ID_OpCode2 = CLRC
else ALUNOT when IF_ID_OpCode2 = NNOT
else ALUINC when IF_ID_OpCode2 = INC
else ALUDEC when IF_ID_OpCode2 = DEC
else ALUADD when IF_ID_OpCode2 = ADD
else ALUSUB when IF_ID_OpCode2 = SSUB
else ALUAND when IF_ID_OpCode2 = AAND
else ALUOR when IF_ID_OpCode2 = OOR
else ALUSHL when IF_ID_OpCode2 = SHL
else ALUSHR when IF_ID_OpCode2 = SHR  
else ALUFEQUALA when IF_ID_OpCode2= IIN or IF_ID_OpCode1 = MOV or IF_ID_OpCode1 = OOUT
else ALUFEQUALB when IF_ID_OpCode2 = JZ or IF_ID_OpCode2 = JN or IF_ID_OpCode2 = JC or IF_ID_OpCode2 = CALL or IF_ID_OpCode2 = JMP
else ALUFEQUAL0 ;


ID_EX_ALUSelection2<= ID_EX_ALUSel2 when Bubble = '0' and Semi_S = '0' and IF_ID_OpCode1 /= LDM  else ALUFEQUAL0;
	
END De;