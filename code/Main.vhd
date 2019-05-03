library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
entity main is
  port (
    clk,reset,int:in std_logic;
    reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8:out std_logic_vector(15 downto 0)
  ) ;
end main;
architecture maniArch of main is
    -- IF/ID inputs
    signal IF_ID_in_src1Exist,IF_ID_in_src2Exist,IF_ID_in_dst1Exist,IF_ID_in_dst2Exist:std_logic;
    signal IF_ID_in_Opcode1,IF_ID_in_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_in_src1,IF_ID_in_dst1,IF_ID_in_src2,IF_ID_in_dst2:std_logic_vector(2 downto 0);
    signal fetchController:std_logic; -- S
    -- IF/ID outputs
    signal IF_ID_out_src1Exist,IF_ID_out_src2Exist,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist:std_logic;
    signal IF_ID_out_Opcode1,IF_ID_out_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_out_src1,IF_ID_out_dst1,IF_ID_out_src2,IF_ID_out_dst2:std_logic_vector(2 downto 0);
    -------------------------------------------------------------------------------------------------
    
      -- ID/EX inputs
    signal ID_EX_in_src1Exist,ID_EX_in_src2Exist,ID_EX_in_dst1Exist,ID_EX_in_dst2Exist:std_logic;
    signal ID_EX_in_Opcode1,ID_EX_in_Opcode2:std_logic_vector(4 downto 0);
    signal ID_EX_in_src1,ID_EX_in_dst1,ID_EX_in_src2,ID_EX_in_dst2:std_logic_vector(2 downto 0);
    signal ID_EX_in_src1Data,ID_EX_in_dst1Data,ID_EX_in_src2Data,ID_EX_in_dst2Data:std_logic_vector(15 downto 0);
    signal ID_EX_in_WB1,ID_EX_in_WB2,ID_EX_in_R1,ID_EX_in_W1,ID_EX_in_R2,ID_EX_in_W2:std_logic;
    signal ID_EX_in_ALUSelection1,ID_EX_in_ALUSelection2:std_logic_vector(3 downto 0);
    -- ID/EX outputs
    signal ID_EX_out_src1Exist,ID_EX_out_src2Exist,ID_EX_out_dst1Exist,ID_EX_out_dst2Exist:std_logic;
    signal ID_EX_out_Opcode1,ID_EX_out_Opcode2:std_logic_vector(4 downto 0);
    signal ID_EX_out_src1,ID_EX_out_dst1,ID_EX_out_src2,ID_EX_out_dst2:std_logic_vector(2 downto 0);
    signal ID_EX_out_src1Data,ID_EX_out_dst1Data,ID_EX_out_src2Data,ID_EX_out_dst2Data:std_logic_vector(15 downto 0);
    signal ID_EX_out_WB1,ID_EX_out_WB2,ID_EX_out_R1,ID_EX_out_W1,ID_EX_out_R2,ID_EX_out_W2:std_logic;
    signal ID_EX_out_ALUSelection1,ID_EX_out_ALUSelection2:std_logic_vector(3 downto 0);
    -------------------------------------------------------------------------------------------------

    -- EX/MEM outputs
    -------------------------------------------------------------------------------------------------

    -- MEM/WB inputs
    signal MEM_WB_in_WB1,MEM_WB_in_WB2,MEM_WB_in_R1,MEM_WB_in_W1,MEM_WB_in_R2,MEM_WB_in_W2:std_logic;
    signal MEM_WB_in_dst1,MEM_WB_in_dst2:std_logic_vector(2 downto 0);
    signal MEM_WB_in_dst1Data,MEM_WB_in_dst2Data:std_logic_vector(15 downto 0);
    -- MEM/WB outputs
    signal MEM_WB_out_WB1,MEM_WB_out_WB2,MEM_WB_out_R1,MEM_WB_out_W1,MEM_WB_out_R2,MEM_WB_out_W2:std_logic;
    signal MEM_WB_out_dst1,MEM_WB_out_dst2:std_logic_vector(2 downto 0);
    signal MEM_WB_out_dst1Data,MEM_WB_out_dst2Data:std_logic_vector(15 downto 0);
    -------------------------------------------------------------------------------------------------

begin
    -- Register File
    theRegisterFile:entity work.registerFile port map(clk,reset
    ,IF_ID_out_src1Exist,IF_ID_out_src2Exist
    ,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist
    ,MEM_WB_out_WB1,MEM_WB_out_WB2
    ,MEM_WB_out_dst1,MEM_WB_out_dst2
    ,IF_ID_out_src1,IF_ID_out_src2
    ,IF_ID_out_dst1,IF_ID_out_dst2
    ,MEM_WB_out_dst1Data,MEM_WB_out_dst2Data
    ,ID_EX_in_src1Data,ID_EX_in_src2Data
    ,ID_EX_in_dst1Data,ID_EX_in_dst1Data);
    -------------------------------------------------------------------------------------------------

    -- Fetch Stage
    -------------------------------------------------------------------------------------------------

    -- IF/ID register
    IF_ID_Register: entity work.nBitRegister generic map(26) port map(
      D(0) => IF_ID_in_src1Exist, D(1) => IF_ID_in_src2Exist, D(2) => IF_ID_in_dst1Exist, D(3) => IF_ID_in_dst2Exist       -- 4 bit
      , D(8 downto 4) => IF_ID_in_Opcode1, D(13 downto 9) => IF_ID_in_Opcode2                                                -- 10 bit
      , D(16 downto 14) => IF_ID_in_src1, D(19 downto 17) => IF_ID_in_dst1, D(22 downto 20) => IF_ID_in_src2, D(25 downto 23) => IF_ID_in_dst2                          -- 12 bit
      ,clk => clk                                                                              
      ,rst => reset                                                                            
      ,en => '1'                                                                              
      ,Q(0) => IF_ID_out_src1Exist, Q(1) => IF_ID_out_src2Exist, Q(2) => IF_ID_out_dst1Exist, Q(3) => IF_ID_out_dst2Exist 
      ,Q(8 downto 4) => IF_ID_out_Opcode1, Q(13 downto 9) => IF_ID_out_Opcode2 
      ,Q(16 downto 14) => IF_ID_out_src1, Q(19 downto 17) => IF_ID_out_dst1, Q(22 downto 20) => IF_ID_out_src2, Q(25 downto 23) => IF_ID_out_dst2
      );
    -------------------------------------------------------------------------------------------------

    -- Decode Stage
    Decode: entity work.StageDecode port map(IF_ID_out_src1Exist,IF_ID_out_src2Exist,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist
    ,IF_ID_out_Opcode1,IF_ID_out_Opcode2
    ,IF_ID_out_src1,IF_ID_out_dst1,IF_ID_out_src2,IF_ID_out_dst2
    ,'0' -- Bubble to do
    ,fetchController,ID_EX_in_WB1,ID_EX_in_WB2,ID_EX_in_R1,ID_EX_in_R2,ID_EX_in_W1,ID_EX_in_W2
    ,ID_EX_in_src1Exist,ID_EX_in_src2Exist,ID_EX_in_dst1Exist,ID_EX_in_dst2Exist
    ,ID_EX_in_Opcode1,ID_EX_in_Opcode2
    ,ID_EX_in_ALUSelection1,ID_EX_in_ALUSelection2);
    -------------------------------------------------------------------------------------------------

    -- Excute Stage
    -------------------------------------------------------------------------------------------------
end maniArch ; -- maniArch