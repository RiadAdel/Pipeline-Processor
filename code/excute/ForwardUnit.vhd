library ieee;
use ieee.std_logic_1164.all;

entity ForwardUnit is
  port (
      -- ID/EX Reg
      src1Exist,dst1Exist,src2Exist,dst2Exist:in std_logic;
      src1,dst1,src2,dst2:in std_logic_vector(2 downto 0);
      -- Memory forward
      MEM_WB_R1,MEM_WB_R2:in std_logic;
      MEM_WB_dst1,MEM_WB_dst2:in std_logic_vector (2 downto 0);
      -- ALU forward
      EX_MEM_Ex1,EX_MEM_Ex2:in std_logic;
      EX_MEM_dst1,EX_MEM_dst2:in std_logic_vector (2 downto 0);
      -- OUTPUT
      outA1,outB1,outC1,outD1,outA2,outB2,outC2,outD2,outE1,outF1,outG1,outH1,outE2,outF2,outG2,outH2:out std_logic; -- Alu signals
      MF,AluF:out std_logic
  ) ;
end ForwardUnit;

architecture ForwardUnitArch of ForwardUnit is
    signal A1,B1,C1,D1,A2,B2,C2,D2,E1,F1,G1,H1,E2,F2,G2,H2: std_logic;
begin
    -- Memory Forward
    outA1 <= A1;
    outB1 <= B1;
    outC1 <= C1;
    outD1 <= D1;
    outA2 <= A2;
    outB2 <= B2;
    outC2 <= C2;
    outD2 <= D2;
    MF <= A1 or B1 or C1 or D1 or A2 or B2 or C2 or D2;
    A_1:entity work.ForwardDesidor port map(MEM_WB_R1 , MEM_WB_dst1 , dst1 , dst1Exist , A1);
    B_1:entity work.ForwardDesidor port map(MEM_WB_R1 , MEM_WB_dst1 , dst2 , dst2Exist , B1);
    C_1:entity work.ForwardDesidor port map(MEM_WB_R1 , MEM_WB_dst1 , src1 , src1Exist , C1);
    D_1:entity work.ForwardDesidor port map(MEM_WB_R1 , MEM_WB_dst1 , src2 , src2Exist , D1);
    A_2:entity work.ForwardDesidor port map(MEM_WB_R2 , MEM_WB_dst2 , dst1 , dst1Exist , A2);
    B_2:entity work.ForwardDesidor port map(MEM_WB_R2 , MEM_WB_dst2 , dst2 , dst2Exist , B2);
    C_2:entity work.ForwardDesidor port map(MEM_WB_R2 , MEM_WB_dst2 , src1 , src1Exist , C2);
    D_2:entity work.ForwardDesidor port map(MEM_WB_R2 , MEM_WB_dst2 , src2 , src2Exist , D2);

    -- Alu forward
    outE1 <= E1; 
    outF1 <= F1; 
    outG1 <= G1; 
    outH1 <= H1; 
    outE2 <= E2; 
    outF2 <= F2; 
    outG2 <= G2; 
    outH2 <= H2; 
    AluF <= E1 or F1 or G1 or H1 or E2 or F2 or G2 or H2;
    E_1:entity work.ForwardDesidor port map(EX_MEM_Ex1 , EX_MEM_dst1 , dst1 , dst1Exist , E1);
    F_1:entity work.ForwardDesidor port map(EX_MEM_Ex1 , EX_MEM_dst1 , dst2 , dst2Exist , F1);
    G_1:entity work.ForwardDesidor port map(EX_MEM_Ex1 , EX_MEM_dst1 , src1 , src1Exist , G1);
    H_1:entity work.ForwardDesidor port map(EX_MEM_Ex1 , EX_MEM_dst1 , src2 , src2Exist , H1);
    E_2:entity work.ForwardDesidor port map(EX_MEM_Ex2 , EX_MEM_dst2 , dst1 , dst1Exist , E2);
    F_2:entity work.ForwardDesidor port map(EX_MEM_Ex2 , EX_MEM_dst2 , dst2 , dst2Exist , F2);
    G_2:entity work.ForwardDesidor port map(EX_MEM_Ex2 , EX_MEM_dst2 , src1 , src1Exist , G2);
    H_2:entity work.ForwardDesidor port map(EX_MEM_Ex2 , EX_MEM_dst2 , src2 , src2Exist , H2);
end ForwardUnitArch ; -- ForwardUnitArch