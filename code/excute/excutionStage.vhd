-- Created by : Riad Adel
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
entity excution is
  port (
    clk:in std_logic;-- clock
    rst:in std_logic;-- Reset for flag reg
    ID_EX_src1Exist,ID_EX_dst1Exist,ID_EX_src2Exist,ID_EX_dst2Exist:in std_logic; -- exist or not
    ID_EX_src1,ID_EX_dst1,ID_EX_src2,ID_EX_dst2:in std_logic_vector(2 downto 0); -- reg code
    ID_EX_src1Data,ID_EX_dst1Data,ID_EX_src2Data,ID_EX_dst2Data:in std_logic_vector(15 downto 0); -- reg data
    ID_EX_aluSelector1,ID_EX_aluSelector2:in std_logic_vector(3 downto 0); -- alu selectors
    ID_EX_opCode1,ID_EX_opCode2:in std_logic_vector(4 downto 0); -- opcode
    ID_EX_R1,ID_EX_R2,ID_EX_W1,ID_EX_W2:in std_logic; -- read and write
    ID_EX_WB1,ID_EX_WB2:in std_logic;
    -- for ALU forwarding
    EX_MEM_dst1,EX_MEM_dst2:in std_logic_vector(2 downto 0);
    EX_MEM_dst1Data,EX_MEM_dst2Data:in std_logic_vector(15 downto 0);
    EX_MEM_ex1,EX_MEM_ex2:in std_logic;

    -- for Memory forwarding
    MEM_WB_dst1,MEM_WB_dst2:in std_logic_vector(2 downto 0);
    MEM_WB_dst1Data,MEM_WB_dst2Data:in std_logic_vector(15 downto 0);
    MEM_WB_R1,MEM_WB_R2:in std_logic;

    -- in port
    inData:in std_logic_vector(15 downto 0);

    -- outputs
    branshAddress:out std_logic_vector(31 downto 0); -- PC when branshing
    aluOut1,aluOut2:out std_logic_vector(15 downto 0); -- goes to EX_MEM_dst1Data,EX_MEM_dst2Data
    flagOut:out std_logic_vector(2 downto 0);
    Ex1_out,Ex2_out:out std_logic;
    src1,src2:out std_logic_vector(15 downto 0);
    j1,j2,flush:out std_logic
    ) ;
end excution;

architecture excutionArch of excution is

    signal jmp1 , jmp2:std_logic;
    signal Ex1,Ex2:std_logic;
  -- flag Register signals
    signal carry1,zero1,negative1,carry2,zero2,negative2,regEn:std_logic;
    signal Cin,Nin,Zin,Cout,Nout,Zout:std_logic;
    signal flagRegIn,flagRegOut:std_logic_vector(2 downto 0);

    -- forward unit signals
    signal A1,B1,C1,D1,A2,B2,C2,D2:std_logic;
    signal E1,F1,G1,H1,E2,F2,G2,H2:std_logic;
    signal aluForward,memryForward:std_logic;

    -- Alu signals
    signal newAlu1Inp1,newAlu2Inp1:std_logic_vector(15 downto 0);
    signal alu1Inp1,alu1Inp2,alu2Inp1,alu2Inp2:std_logic_vector(15 downto 0);
    signal alu1Outp,alu2Outp:std_logic_vector(15 downto 0);
    signal alu1A_ALUforwarding,alu1A_MEMforwarding,alu1B_ALUforwarding,alu1B_MEMforwarding,alu2A_ALUforwarding,alu2A_MEMforwarding,alu2B_ALUforwarding,alu2B_MEMforwarding:std_logic_vector(15 downto 0);
    signal alu1Inp1Selector,alu1Inp2Selector, alu2Inp1Selector ,alu2Inp2Selector:std_logic_vector(1 downto 0);
	
	signal br1,br2:std_logic_vector(31 downto 0);
begin
    -- Bransh
    j1 <= jmp1;
    j2 <= jmp2;
    jmp1 <= '1' when (ID_EX_opCode1 = JZ and Zout = '1') or (ID_EX_opCode1 = JN and Nout = '1') or (ID_EX_opCode1 = JC and Cout = '1') or (ID_EX_opCode1 = JMP)
    else '0';
    jmp2 <= '1' when (ID_EX_opCode2 = JZ and Zout = '1') or (ID_EX_opCode2 = JN and Nout = '1') or (ID_EX_opCode2 = JC and Cout = '1') or (ID_EX_opCode2 = JMP)
    else '0';
    
    flush <= jmp1 or jmp2;
	br1 <= "0000000000000000" & newAlu1Inp1;
	br2 <= "0000000000000000" & newAlu2Inp1;
    branshAddress <= br2 when jmp2 = '1'
    else br1 when jmp1 = '1'
    else (others => '0');
    --------------------------------------------------------------

    -- Ex signal
    Ex1 <= ID_EX_WB1 and (not ID_EX_R1);
    Ex2 <= ID_EX_WB2 and (not ID_EX_R2);
    Ex1_out <= Ex1;
    Ex2_out <= Ex2;
    --------------------------------------------------------------

    -- Flag Register
    Cin <= carry2 when (Ex2 = '1' and ID_EX_aluSelector2 /= ALUFEQUAL0 and ID_EX_aluSelector2 /= ALUFEQUALB and ID_EX_aluSelector2 /= ALUFEQUALA) or ID_EX_aluSelector2 = ALUSETC or ID_EX_aluSelector2 = ALUCLEARC
    else carry1 when (Ex1 = '1' and ID_EX_aluSelector1 /= ALUFEQUAL0 and ID_EX_aluSelector1 /= ALUFEQUALB and ID_EX_aluSelector1 /= ALUFEQUALA)   or ID_EX_aluSelector1 = ALUSETC or ID_EX_aluSelector1 = ALUCLEARC
    else '0' when rst = '1';

    Zin <= zero2 when Ex2 = '1' and ID_EX_aluSelector2 /= ALUFEQUAL0 and ID_EX_aluSelector2 /= ALUFEQUALB and ID_EX_aluSelector2 /= ALUFEQUALA
    else zero1 when Ex1 = '1' and ID_EX_aluSelector1 /= ALUFEQUAL0 and ID_EX_aluSelector1 /= ALUFEQUALB and ID_EX_aluSelector1 /= ALUFEQUALA
    else '0' when rst = '1';
    
    Nin <= negative2 when Ex2 = '1' and ID_EX_aluSelector2 /= ALUFEQUAL0 and ID_EX_aluSelector2 /= ALUFEQUALB and ID_EX_aluSelector2 /= ALUFEQUALA
    else negative1 when Ex1 = '1' and ID_EX_aluSelector1 /= ALUFEQUAL0 and ID_EX_aluSelector1 /= ALUFEQUALB and ID_EX_aluSelector1 /= ALUFEQUALA
    else '0' when rst = '1';
    
    regEn <= '1' when (Ex2 = '1' and ID_EX_aluSelector2 /= ALUFEQUAL0 and ID_EX_aluSelector2 /= ALUFEQUALB and ID_EX_aluSelector2 /= ALUFEQUALA) or
                      (Ex1 = '1' and ID_EX_aluSelector1 /= ALUFEQUAL0 and ID_EX_aluSelector1 /= ALUFEQUALB and ID_EX_aluSelector1 /= ALUFEQUALA)
    else '1' when ID_EX_aluSelector1 = ALUSETC or ID_EX_aluSelector1 = ALUCLEARC or ID_EX_aluSelector2 = ALUSETC or ID_EX_aluSelector2 = ALUCLEARC
    else '0';

    flagRegIn <= Cin & Nin & Zin;

    Cout <= flagRegOut(2);
    Nout <= flagRegOut(1);
    Zout <= flagRegOut(0);

    flagOut <= flagRegOut;
    flag_Register: entity work.nBitRegister generic map(3) port map(flagRegIn,clk,rst,regEn,flagRegOut);
    --------------------------------------------------------------

    -- Forward unit
    ForwardUnit: entity work.ForwardUnit port map(ID_EX_src1Exist,ID_EX_dst1Exist,ID_EX_src2Exist,ID_EX_dst2Exist
    ,ID_EX_src1,ID_EX_dst1,ID_EX_src2,ID_EX_dst2
    ,MEM_WB_R1,MEM_WB_R2,MEM_WB_dst1,MEM_WB_dst2
    ,EX_MEM_ex1,EX_MEM_ex2,EX_MEM_dst1,EX_MEM_dst2
    ,A1,B1,C1,D1,A2,B2,C2,D2
    ,E1,F1,G1,H1,E2,F2,G2,H2
    ,memryForward,aluForward);
    --------------------------------------------------------------  

    -- Two ALU
      -- First ALU (forward dst1 or dst2)
    alu1A1_ALUforward: entity work.MUX_2x1 port map(EX_MEM_dst1Data,EX_MEM_dst2Data,G2,alu1A_ALUforwarding);
    alu1A1_MEMforward: entity work.MUX_2x1 port map(MEM_WB_dst1Data,MEM_WB_dst2Data,C2,alu1A_MEMforwarding);
    alu1B1_ALUforward: entity work.MUX_2x1 port map(EX_MEM_dst1Data,EX_MEM_dst2Data,E2,alu1B_ALUforwarding);
    alu1B1_MEMforward: entity work.MUX_2x1 port map(MEM_WB_dst1Data,MEM_WB_dst2Data,A2,alu1B_MEMforwarding);
    
      -- Second ALU (forward dst1 or dst2)
    alu2A1_ALUforward: entity work.MUX_2x1 port map(EX_MEM_dst1Data,EX_MEM_dst2Data,H2,alu2A_ALUforwarding);
    alu2A1_MEMforward: entity work.MUX_2x1 port map(MEM_WB_dst1Data,MEM_WB_dst2Data,D2,alu2A_MEMforwarding);
    alu2B1_ALUforward: entity work.MUX_2x1 port map(EX_MEM_dst1Data,EX_MEM_dst2Data,F2,alu2B_ALUforwarding);
    alu2B1_MEMforward: entity work.MUX_2x1 port map(MEM_WB_dst1Data,MEM_WB_dst2Data,B2,alu2B_MEMforwarding);
    
       -- The last data to choose for ALUs
    alu1Inp1Selector <= (C1 or C2) & (G1 or G2);
    alu1Inp2Selector <= (A1 or A2) & (E1 or E2);
    alu2Inp1Selector <= (D1 or D2) & (H1 or H2);
    alu2Inp2Selector <= (B1 or B2) & (F1 or F2);

    aluA1: entity work.MUX_4x1 port map(ID_EX_src1Data,alu1A_ALUforwarding,alu1A_MEMforwarding, alu1A_ALUforwarding , alu1Inp1Selector ,alu1Inp1);
    aluB1: entity work.MUX_4x1 port map(ID_EX_dst1Data,alu1B_ALUforwarding,alu1B_MEMforwarding, alu1B_ALUforwarding , alu1Inp2Selector ,alu1Inp2);
    aluA2: entity work.MUX_4x1 port map(ID_EX_src2Data,alu2A_ALUforwarding,alu2A_MEMforwarding, alu2A_ALUforwarding , alu2Inp1Selector ,alu2Inp1);
    aluB2: entity work.MUX_4x1 port map(ID_EX_dst2Data,alu2B_ALUforwarding,alu2B_MEMforwarding, alu2B_ALUforwarding , alu2Inp2Selector ,alu2Inp2);

    aluOut1 <=alu1Outp;
    aluOut2 <=alu2Outp;
    src1 <= newAlu1Inp1;
    src2 <= newAlu2Inp1;
    newAlu1Inp1 <= inData when ID_EX_opCode1 = IIN
    else alu1Inp1;
    newAlu2Inp1 <= inData when ID_EX_opCode2 = IIN
    else alu2Inp1;
    Alu1:entity work.ALU port map(ID_EX_aluSelector1,newAlu1Inp1,alu1Inp2,alu1Outp,carry1,negative1,zero1);
    Alu2:entity work.ALU port map(ID_EX_aluSelector2,newAlu2Inp1,alu2Inp2,alu2Outp,carry2,negative2,zero2);
    --------------------------------------------------------------
end excutionArch ; -- excutionArch
