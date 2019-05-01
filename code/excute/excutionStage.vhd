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
    ID_EX_aluSelector1,ID_EX_aluSelector2:in std_logic; -- alu selectors
    ID_EX_opCode1,ID_EX_opCode2:in std_logic; -- opcode
    ID_EX_R1,ID_EX_R2,ID_EX_W1,ID_EX_W2:in std_logic; -- read and write
    ID_EX_ex1,ID_EX_ex2:in std_logic; -- use alu or not

    -- for ALU forwarding
    EX_MEM_dst1,EX_MEM_dst2:in std_logic;
    EX_MEM_dst1Data,EX_MEM_dst2Data:in std_logic;
    EX_MEM_ex1,EX_MEM_ex2:in std_logic;

    -- for Memory forwarding
    MEM_WB_dst1,MEM_WB_dst2:in std_logic;
    MEM_WB_dst1Data,MEM_WB_dst2Data:in std_logic;
    MEM_WB_R1,MEM_WB_R2:in std_logic;

    -- outputs
    brashAddress:out std_logic_vector(31 downto 0); -- PC when branshing
    aluOut1,aluOut2:out std_logic_vector(15 downto 0); -- goes to EX_MEM_dst1Data,EX_MEM_dst2Data
    flagOut:out std_logic_vector(2 downto 0)
    ) ;
end excution;

architecture excutionArch of excution is
begin

end excutionArch ; -- excutionArch
