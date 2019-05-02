-- Created by : Riad Adel
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity excution is
  port (
    clk:in std_logic;-- clock
    flagIn:in std_logic_vector(2 downto 0); -- flag register
    ID_EX_src1Exist,ID_EX_dst1Exist,ID_EX_src2Exist,ID_EX_dst2Exist:in std_logic; -- exist or not
    ID_EX_src1,ID_EX_dst1,ID_EX_src2,ID_EX_dst2:in std_logic_vector(2 downto 0); -- reg code
    ID_EX_src1Data,ID_EX_dst1Data,ID_EX_src2Data,ID_EX_dst2Data:in std_logic_vector(15 downto 0); -- reg data
    ID_EX_aluSelector1,ID_EX_aluSelector2:in std_logic_vector(3 downto 0); -- alu selectors
    ID_EX_opCode1,ID_EX_opCode2:in std_logic; -- opcode
    ID_EX_R1,ID_EX_R2,ID_EX_W1,ID_EX_W2:in std_logic; -- read and write
    ID_EX_ex1,ID_EX_ex2:in std_logic; -- use alu or not

    -- for ALU forwarding
    EX_MEM_dst1,EX_MEM_dst2:in std_logic_vector(2 downto 0);
    EX_MEM_dst1Data,EX_MEM_dst2Data:in std_logic_vector(15 downto 0);
    EX_MEM_ex1,EX_MEM_ex2:in std_logic;

    -- for Memory forwarding
    MEM_WB_dst1,MEM_WB_dst2:in std_logic_vector(2 downto 0);
    MEM_WB_dst1Data,MEM_WB_dst2Data:in std_logic_vector(15 downto 0);
    MEM_WB_R1,MEM_WB_R2:in std_logic;

    -- outputs
    brashAddress:out std_logic_vector(31 downto 0); -- PC when branshing
    aluOut1,aluOut2:out std_logic_vector(15 downto 0); -- goes to EX_MEM_dst1Data,EX_MEM_dst2Data
    flagOut:out std_logic_vector(2 downto 0)
    ) ;
end excution;

architecture excutionArch of excution is

    -- forward unit signals
    signal A1,B1,C1,D1,A2,B2,C2,D2:std_logic;
    signal E1,F1,G1,H1,E2,F2,G2,H2:std_logic;
    signal aluForward,memryForward:std_logic;

    -- Alu signals
    signal alu1Inp1,alu1Inp2,alu2Inp1,alu2Inp2:std_logic_vector(15 downto 0);
    signal alu1Outp,alu2Outp:std_logic_vector(15 downto 0);
    signal alu1A_ALUforwarding,alu1A_MEMforwarding,alu1B_ALUforwarding,alu1B_MEMforwarding,alu2A_ALUforwarding,alu2A_MEMforwarding,alu2B_ALUforwarding,alu2B_MEMforwarding:std_logic_vector(15 downto 0);
    signal alu1Inp1Selector,alu1Inp2Selector, alu2Inp1Selector ,alu2Inp2Selector:std_logic_vector(1 downto 0);
begin

    -- Forward unit
    ForwardUnit: entity work.ForwardUnit port map(ID_EX_src1Exist,ID_EX_dst1Exist,ID_EX_src2Exist,ID_EX_dst2Exist
    ,ID_EX_src1,ID_EX_dst1,ID_EX_src2,EX_MEM_dst2
    ,MEM_WB_R1,MEM_WB_R2,MEM_WB_dst1,MEM_WB_dst2
    ,EX_MEM_ex1,EX_MEM_ex2,EX_MEM_dst1,EX_MEM_dst2
    ,A1,B1,C1,D1,A2,B2,C2,D2
    ,E1,F1,G1,H1,E2,F2,G2,H2
    ,aluForward,memryForward);
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
    
    Alu1:entity work.ALU port map(ID_EX_aluSelector1,alu1Inp1,alu1Inp2,alu1Outp);
    Alu2:entity work.ALU port map(ID_EX_aluSelector1,alu2inp2,alu2Inp2,alu2Outp);
    --------------------------------------------------------------
end excutionArch ; -- excutionArch
