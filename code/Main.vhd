library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
entity main is
  port (
    clk,reset,int:in std_logic;
    InPort : in std_logic_vector(15 downto 0);
    reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8 , OutPort:out std_logic_vector(15 downto 0)
  ) ;
end main;
architecture mainArch of main is
     ------ input and output signals from entity fetch-------------
    signal dummy:std_logic_vector(19 downto 0);
    signal D2: std_logic_vector(15 downto 0);
    signal flagRegister:std_logic_vector(2 downto 0);
    signal branshAddress:std_logic_vector(31 downto 0);
    -- IF/ID inputs
    signal IF_ID_in_src1Exist,IF_ID_in_src2Exist,IF_ID_in_dst1Exist,IF_ID_in_dst2Exist:std_logic;
    signal IF_ID_in_Opcode1,IF_ID_in_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_in_src1,IF_ID_in_dst1,IF_ID_in_src2,IF_ID_in_dst2:std_logic_vector(2 downto 0);
    signal fetchController:std_logic; -- S
    signal IF_ID_in_PcPlus1: STD_LOGIC_VECTOR(19 DOWNTO 0);
    -- IF/ID outputs
    signal IF_ID_out_src1Exist,IF_ID_out_src2Exist,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist:std_logic;
    signal IF_ID_out_Opcode1,IF_ID_out_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_out_src1,IF_ID_out_dst1,IF_ID_out_src2,IF_ID_out_dst2:std_logic_vector(2 downto 0);
    signal IF_ID_out_PcPlus1: STD_LOGIC_VECTOR(19 DOWNTO 0);
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

    --EX/MEM inputs
    signal EX_MEM_in_dst1,EX_MEM_in_dst2:std_logic_vector(2 downto 0);
    signal EX_MEM_in_dst1Data,EX_MEM_in_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_in_WB1,EX_MEM_in_WB2,EX_MEM_in_R1,EX_MEM_in_W1,EX_MEM_in_R2,EX_MEM_in_W2:std_logic;
    signal EX_MEM_in_ex1,EX_MEM_in_ex2:std_logic;
    -- EX/MEM outputs
    signal EX_MEM_out_dst1,EX_MEM_out_dst2:std_logic_vector(2 downto 0);
    signal EX_MEM_out_dst1Data,EX_MEM_out_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_out_WB1,EX_MEM_out_WB2,EX_MEM_out_R1,EX_MEM_out_W1,EX_MEM_out_R2,EX_MEM_out_W2:std_logic;
    signal EX_MEM_out_ex1,EX_MEM_out_ex2:std_logic;
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

    -- data RAM Signals
    signal dataRam_W,dataRam_R : std_logic;
    signal dataRam_addressToMemory : std_logic_vector(19 downto 0);
    signal dataRam_dataToMemory : std_logic_vector(15 downto 0);
    signal dataRam_inputFromMemory : std_logic_vector(15 downto 0);
    -------------------------------------------------------------------------------------------------

    -- WB outputs
    signal WB_OUT_WB1, WB_OUT_WB2 : STD_LOGIC;
    signal WB_OUT_dst1, WB_OUT_dst2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal WB_OUT_dataDst1, WB_OUT_dataDst2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -------------------------------------------------------------------------------------------------

    -- Stack Pointer signals
    signal SPin, SPout : STD_LOGIC_VECTOR(19 DOWNTO 0);
    -------------------------------------------------------------------------------------------------

    -- Program Counter signals
    signal PCin, PCout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -------------------------------------------------------------------------------------------------

begin
    -- Register File
    theRegisterFile:entity work.registerFile port map(clk,reset
    ,IF_ID_out_src1Exist,IF_ID_out_src2Exist
    ,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist
    ,WB_OUT_WB1,WB_OUT_WB2
    ,WB_OUT_dst1,WB_OUT_dst2
    ,IF_ID_out_src1,IF_ID_out_src2
    ,IF_ID_out_dst1,IF_ID_out_dst2
    ,WB_OUT_dataDst1,WB_OUT_dataDst2
    ,ID_EX_in_src1Data,ID_EX_in_src2Data
    ,ID_EX_in_dst1Data,ID_EX_in_dst2Data);
--    -------------------------------------------------------------------------------------------------
--	dummy<=  (others=>'0');
--    -- port map (returnAddress,branchAdd , D2 ,inturrupt,branch1 , branch2 ,RTIandRET ,S , ID_EX_S,reset,Bubble,clk,IR1Out,IR2Out,PcPlus1 )  
--    -- Fetch Stage
--	D2<=IF_ID_out_Opcode2 &IF_ID_out_src2Exist&IF_ID_out_dst2Exist&IF_ID_out_src2&IF_ID_out_dst2;
--	FetchStage:entity work.fetch   port map (dummy,dummy, D2 , int , '0' , '0' , '0' , fetchController , '0' , reset , '0' , clk , 
--	  IF_ID_in_Opcode1&IF_ID_in_src1Exist&IF_ID_in_dst1Exist&IF_ID_in_src1&IF_ID_in_dst1,
--	  IF_ID_in_Opcode2&IF_ID_in_src2Exist&IF_ID_in_dst2Exist&IF_ID_in_src2&IF_ID_in_dst2  , IF_ID_in_PcPlus1 );
--
--    -------------------------------------------------------------------------------------------------

    -- IF/ID register
    IF_ID_Register: entity work.nBitRegister generic map(46) port map(
      D(0) => IF_ID_in_src1Exist, D(1) => IF_ID_in_src2Exist, D(2) => IF_ID_in_dst1Exist, D(3) => IF_ID_in_dst2Exist       -- 4 bit
      , D(8 downto 4) => IF_ID_in_Opcode1, D(13 downto 9) => IF_ID_in_Opcode2                                                -- 10 bit
      , D(16 downto 14) => IF_ID_in_src1, D(19 downto 17) => IF_ID_in_dst1, D(22 downto 20) => IF_ID_in_src2, D(25 downto 23) => IF_ID_in_dst2  
      , D(45 downto 26) => IF_ID_in_PcPlus1                       -- 12 bit
      ,clk => clk                                                                              
      ,rst => reset                                                                            
      ,en => '1'                                                                              
      ,Q(0) => IF_ID_out_src1Exist, Q(1) => IF_ID_out_src2Exist, Q(2) => IF_ID_out_dst1Exist, Q(3) => IF_ID_out_dst2Exist 
      ,Q(8 downto 4) => IF_ID_out_Opcode1, Q(13 downto 9) => IF_ID_out_Opcode2 
      ,Q(16 downto 14) => IF_ID_out_src1, Q(19 downto 17) => IF_ID_out_dst1, Q(22 downto 20) => IF_ID_out_src2, Q(25 downto 23) => IF_ID_out_dst2
      ,Q(45 downto 26) => IF_ID_out_PcPlus1
      );
	    -------------------------------------------------------------------------------------------------
    -- Decode Stage
    DecodeEntity: entity work.StageDecode port map(IF_ID_out_src1Exist,IF_ID_out_src2Exist,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist
    ,IF_ID_out_Opcode1,IF_ID_out_Opcode2
    ,IF_ID_out_src1,IF_ID_out_dst1,IF_ID_out_src2,IF_ID_out_dst2
    ,'0' -- Bubble to do
    ,fetchController,ID_EX_in_WB1,ID_EX_in_WB2,ID_EX_in_R1,ID_EX_in_R2,ID_EX_in_W1,ID_EX_in_W2
    ,ID_EX_in_src1Exist,ID_EX_in_src2Exist,ID_EX_in_dst1Exist,ID_EX_in_dst2Exist
    ,ID_EX_in_Opcode1,ID_EX_in_Opcode2
    ,ID_EX_in_ALUSelection1,ID_EX_in_ALUSelection2);
    -- passing data
    ID_EX_in_src1 <= IF_ID_out_src1; 
    ID_EX_in_dst1 <= IF_ID_out_dst1;
    ID_EX_in_src2 <= IF_ID_out_src2;
    ID_EX_in_dst2 <= IF_ID_out_dst2;
    -------------------------------------------------------------------------------------------------

    -- ID/EX register
    ID_EX_Register: entity work.nBitRegister generic map(104) port map(
      D(0) => ID_EX_in_src1Exist, D(1) => ID_EX_in_src2Exist, D(2) => ID_EX_in_dst1Exist, D(3) => ID_EX_in_dst2Exist       -- 4 bit
      , D(8 downto 4) => ID_EX_in_Opcode1, D(13 downto 9) => ID_EX_in_Opcode2                                                -- 10 bit
      , D(16 downto 14) => ID_EX_in_src1, D(19 downto 17) => ID_EX_in_dst1, D(22 downto 20) => ID_EX_in_src2, D(25 downto 23) => ID_EX_in_dst2                          -- 12 bit
      ,D(26) => ID_EX_in_WB1, D(27) => ID_EX_in_WB2, D(28) => ID_EX_in_R1, D(29) => ID_EX_in_R2,D(30) => ID_EX_in_W1, D(31) => ID_EX_in_W2
      ,D(47 downto 32) => ID_EX_in_src1Data,D(63 downto 48) => ID_EX_in_src2Data
      ,D(79 downto 64) => ID_EX_in_dst1Data,D(95 downto 80) => ID_EX_in_dst1Data
      ,D(99 downto 96) => ID_EX_in_ALUSelection1,D(103 downto 100) => ID_EX_in_ALUSelection2
      ,clk => clk                                                                              
      ,rst => reset                                                                            
      ,en => '1'                                                                              
      ,Q(0) => ID_EX_out_src1Exist, Q(1) => ID_EX_out_src2Exist, Q(2) => ID_EX_out_dst1Exist, Q(3) => ID_EX_out_dst2Exist 
      ,Q(8 downto 4) => ID_EX_out_Opcode1, Q(13 downto 9) => ID_EX_out_Opcode2 
      ,Q(16 downto 14) => ID_EX_out_src1, Q(19 downto 17) => ID_EX_out_dst1, Q(22 downto 20) => ID_EX_out_src2, Q(25 downto 23) => ID_EX_out_dst2
      ,Q(26) => ID_EX_out_WB1, Q(27) => ID_EX_out_WB2, Q(28) => ID_EX_out_R1, Q(29) => ID_EX_out_R2,Q(30) => ID_EX_out_W1, Q(31) => ID_EX_out_W2
      ,Q(47 downto 32) => ID_EX_out_src1Data,Q(63 downto 48) => ID_EX_out_src2Data
      ,Q(79 downto 64) => ID_EX_out_dst1Data,Q(95 downto 80) => ID_EX_out_dst2Data
      ,Q(99 downto 96) => ID_EX_out_ALUSelection1,Q(103 downto 100) => ID_EX_out_ALUSelection2
      );
    -------------------------------------------------------------------------------------------------


    -- Excute Stage
    ExcutionStage: entity work.excution port map(
      clk,reset
      ,ID_EX_out_src1Exist,ID_EX_out_dst1Exist,ID_EX_out_src2Exist,ID_EX_out_dst2Exist
      ,ID_EX_out_src1,ID_EX_out_dst1,ID_EX_out_src2,ID_EX_out_dst2
      ,ID_EX_out_src1Data,ID_EX_out_dst1Data,ID_EX_out_src2Data,ID_EX_out_dst2Data
      ,ID_EX_out_ALUSelection1,ID_EX_out_ALUSelection2
      ,ID_EX_out_opCode1,ID_EX_out_opCode2
      ,ID_EX_out_R1,ID_EX_out_R2,ID_EX_out_W1,ID_EX_out_W2
      ,ID_EX_out_WB1,ID_EX_out_WB2

      ,EX_MEM_out_dst1,EX_MEM_out_dst2
      ,EX_MEM_out_dst1Data,EX_MEM_out_dst2Data
      ,EX_MEM_out_ex1,EX_MEM_out_ex2

      ,MEM_WB_out_dst1,MEM_WB_out_dst2
      ,MEM_WB_out_dst1Data,MEM_WB_out_dst2Data
      ,MEM_WB_out_R1,MEM_WB_out_R2

      ,branshAddress
      ,EX_MEM_in_dst1Data,EX_MEM_in_dst2Data
      ,flagRegister
      ,EX_MEM_in_ex1,EX_MEM_in_ex2
    );
    -- passing data
    EX_MEM_in_dst1 <= ID_EX_out_dst1;
    EX_MEM_in_dst2 <= ID_EX_out_dst2;
    -------------------------------------------------------------------------------------------------


--    -- EX/MEM register
--    --EX_MEM_Register: entity work.nBitRegister generic map(96) port map();
--
--    -- RAM data only
--    dataRam: entity work.Ram  generic map(1) port map(
--      clk,
--      dataRam_W, dataRam_R,
--      dataRam_addressToMemory,
--      dataRam_dataToMemory,
--      dataRam_inputFromMemory);
--    -------------------------------------------------------------------------------------------------
--
--    -- Stack Pointer (SP) register
--    stackPointer: entity work.nBitRegister generic map(20) port map(SPin,clk,reset,'1',SPout); --lsa msh gahez
--    -------------------------------------------------------------------------------------------------
--
--    -- Program Counter (PC) register
--    programCounter: entity work.nBitRegister generic map(32) port map(PCin,clk,reset,'1',PCout); --lsa msh gahez
--    -------------------------------------------------------------------------------------------------
--
--    -- Memory Stage
--    MemoryStage:entity work.Memory port map (
--      ID_EX_out_src1Data,ID_EX_out_src2Data,
--      ID_EX_out_dst1Data,ID_EX_out_dst2Data,
--      SPout, 
--      ----------TODO-----------------
--      INSTR,
--      R1, R2,
--      W1, W2,
--      -------------------------------
--      dataRam_R, dataRam_W,
--      dataRam_addressToMemory,
--      dataRam_dataToMemory,
--      dataRam_inputFromMemory,
--      MEM_WB_in_dst1Data, MEM_WB_in_dst2Data
--    );
--    -------------------------------------------------------------------------------------------------
--
--    
--    
--    -- MEM/WB register
--    MEM_WB_Register: entity work.nBitRegister generic map(10) port map(
--      D(0) => MEM_WB_in_WB1, D(1) => MEM_WB_in_WB2, D(2) => MEM_WB_in_R1,
--      D(3) => MEM_WB_in_W1,  D(4) => MEM_WB_in_R2,  D(5) => MEM_WB_in_W2,
--      D(6) => MEM_WB_in_dst1,D(7) => MEM_WB_in_dst2,D(8) => MEM_WB_in_dst1Data,
--      D(9) => MEM_WB_in_dst2Data,
--      clk,                                                        
--      reset,                                                      
--      en => '1',
--      Q(0) => MEM_WB_out_WB1, Q(1) => MEM_WB_out_WB2, Q(2) => MEM_WB_out_R1,
--      Q(3) => MEM_WB_out_W1,  Q(4) => MEM_WB_out_R2,  Q(5) => MEM_WB_out_W2
--      Q(6) => MEM_WB_out_dst1,Q(7) => MEM_WB_out_dst2,Q(8) => MEM_WB_out_dst1Data,
--      Q(9) => MEM_WB_out_dst2Data
--    );
--    -------------------------------------------------------------------------------------------------
--
--    -- WriteBack Stage
--    WriteBackStage:entity work.WriteBack port map (
--      MEM_WB_out_WB1, MEM_WB_out_WB2,
--      MEM_WB_out_dst1, MEM_WB_out_dst2,
--      MEM_WB_out_dst1Data, MEM_WB_out_dst2Data,
--      WB_OUT_WB1, WB_OUT_WB2,
--      WB_OUT_dst1, WB_OUT_dst2,
--      WB_OUT_dataDst1, WB_OUT_dataDst2
--    );
--    -------------------------------------------------------------------------------------------------
--


end mainArch ; -- mainArch