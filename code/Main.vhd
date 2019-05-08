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
    signal CLKNOT : std_logic;
     ------ input and output signals from entity fetch-------------
    signal dummy:std_logic_vector(19 downto 0);
    signal D2: std_logic_vector(15 downto 0);
    signal flagRegister:std_logic_vector(2 downto 0);
    signal branshAddress:std_logic_vector(31 downto 0);
    signal jump1,jump2,flush:std_logic;
    -- IF/ID inputs
    signal IF_ID_in_src1Exist,IF_ID_in_src2Exist,IF_ID_in_dst1Exist,IF_ID_in_dst2Exist:std_logic;
    signal IF_ID_in_Opcode1,IF_ID_in_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_in_src1,IF_ID_in_dst1,IF_ID_in_src2,IF_ID_in_dst2:std_logic_vector(2 downto 0);
    signal fetchController:std_logic; -- S
    signal IF_ID_in_PcPlus1: STD_LOGIC_VECTOR(19 DOWNTO 0);
    signal IF_ID_in_dummy3bits1,IF_ID_in_dummy3bits2: std_logic_vector(2 downto 0);
    signal IF_ID_in_s:std_logic;
    -- IF/ID outputs
    signal IF_ID_out_src1Exist,IF_ID_out_src2Exist,IF_ID_out_dst1Exist,IF_ID_out_dst2Exist:std_logic;
    signal IF_ID_out_Opcode1,IF_ID_out_Opcode2:std_logic_vector(4 downto 0);
    signal IF_ID_out_src1,IF_ID_out_dst1,IF_ID_out_src2,IF_ID_out_dst2:std_logic_vector(2 downto 0);
    signal IF_ID_out_PcPlus1: STD_LOGIC_VECTOR(19 DOWNTO 0);
    signal IF_ID_out_dummy3bits1,IF_ID_out_dummy3bits2: std_logic_vector(2 downto 0);
    signal IF_ID_out_s:std_logic;
    -------------------------------------------------------------------------------------------------
    
      -- ID/EX inputs
    signal ID_EX_in_s:std_logic ;
    signal ID_EX_in_src1Exist,ID_EX_in_src2Exist,ID_EX_in_dst1Exist,ID_EX_in_dst2Exist:std_logic;
    signal ID_EX_in_Opcode1,ID_EX_in_Opcode2:std_logic_vector(4 downto 0);
    signal ID_EX_in_src1,ID_EX_in_dst1,ID_EX_in_src2,ID_EX_in_dst2:std_logic_vector(2 downto 0);
    signal ID_EX_in_src1Data,ID_EX_in_dst1Data,ID_EX_in_src2Data,ID_EX_in_dst2Data:std_logic_vector(15 downto 0);
    signal ID_EX_in_WB1,ID_EX_in_WB2,ID_EX_in_R1,ID_EX_in_W1,ID_EX_in_R2,ID_EX_in_W2:std_logic;
    signal ID_EX_in_ALUSelection1,ID_EX_in_ALUSelection2:std_logic_vector(3 downto 0);
    -- ID/EX outputs
    signal ID_EX_out_s: std_logic;
    signal ID_EX_out_src1Exist,ID_EX_out_src2Exist,ID_EX_out_dst1Exist,ID_EX_out_dst2Exist:std_logic;
    signal ID_EX_out_Opcode1,ID_EX_out_Opcode2:std_logic_vector(4 downto 0);
    signal ID_EX_out_src1,ID_EX_out_dst1,ID_EX_out_src2,ID_EX_out_dst2:std_logic_vector(2 downto 0);
    signal ID_EX_out_src1Data,ID_EX_out_dst1Data,ID_EX_out_src2Data,ID_EX_out_dst2Data:std_logic_vector(15 downto 0);
    signal ID_EX_out_WB1,ID_EX_out_WB2,ID_EX_out_R1,ID_EX_out_W1,ID_EX_out_R2,ID_EX_out_W2:std_logic;
    signal ID_EX_out_ALUSelection1,ID_EX_out_ALUSelection2:std_logic_vector(3 downto 0);
    -------------------------------------------------------------------------------------------------

    --EX/MEM inputs
    signal EX_MEM_in_src1Exist,EX_MEM_in_src2Exist,EX_MEM_in_dst1Exist,EX_MEM_in_dst2Exist:std_logic;
    signal EX_MEM_in_src1,EX_MEM_in_src2,EX_MEM_in_dst1,EX_MEM_in_dst2:std_logic_vector(2 downto 0);
    signal EX_MEM_in_src1Data,EX_MEM_in_src2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_in_dst1Data,EX_MEM_in_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_in_WB1,EX_MEM_in_WB2,EX_MEM_in_R1,EX_MEM_in_W1,EX_MEM_in_R2,EX_MEM_in_W2:std_logic;
    signal EX_MEM_in_ex1,EX_MEM_in_ex2:std_logic;
    
    -- EX/MEM outputs
    signal EX_MEM_out_src1Exist,EX_MEM_out_src2Exist,EX_MEM_out_dst1Exist,EX_MEM_out_dst2Exist:std_logic;
    signal EX_MEM_out_src1,EX_MEM_out_src2,EX_MEM_out_dst1,EX_MEM_out_dst2:std_logic_vector(2 downto 0);
    signal EX_MEM_out_src1Data,EX_MEM_out_src2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_out_dst1Data,EX_MEM_out_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_out_WB1,EX_MEM_out_WB2,EX_MEM_out_R1,EX_MEM_out_W1,EX_MEM_out_R2,EX_MEM_out_W2:std_logic;
    signal EX_MEM_out_ex1,EX_MEM_out_ex2:std_logic;
    -------------------------------------------------------------------------------------------------

    -- MEM/WB inputs
    signal MEM_WB_in_WB1,MEM_WB_in_WB2,MEM_WB_in_R1,MEM_WB_in_W1,MEM_WB_in_R2,MEM_WB_in_W2:std_logic;
    signal MEM_WB_in_dst1,MEM_WB_in_dst2:std_logic_vector(2 downto 0);
    signal MEM_WB_in_dst1Data,MEM_WB_in_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_in_opCode1,EX_MEM_in_opCode2:std_logic_vector(4 downto 0);
    -- MEM/WB outputs
    signal MEM_WB_out_WB1,MEM_WB_out_WB2,MEM_WB_out_R1,MEM_WB_out_W1,MEM_WB_out_R2,MEM_WB_out_W2:std_logic;
    signal MEM_WB_out_dst1,MEM_WB_out_dst2:std_logic_vector(2 downto 0);
    signal MEM_WB_out_dst1Data,MEM_WB_out_dst2Data:std_logic_vector(15 downto 0);
    signal EX_MEM_out_opCode1,EX_MEM_out_opCode2:std_logic_vector(4 downto 0);
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

    CLKNOT<=not clk;
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
    ,ID_EX_in_dst1Data,ID_EX_in_dst2Data ,reg1 , reg2 , reg3,reg4,reg5,reg6,reg7,reg8 );
  ---------------------------------------------------------------------------------------------------
  --Fetch Stage
	dummy<=  (others=>'0');
	D2<=IF_ID_out_Opcode2 &IF_ID_out_src2Exist&IF_ID_out_dst2Exist&IF_ID_out_dummy3bits2&IF_ID_out_src2&IF_ID_out_dst2;
  
FetchStage:entity work.fetch   port map (returnAddress => dummy, branchAdd => branshAddress(19 downto 0)
  ,D2 => D2
  ,inturrupt => int , branch1 => jump1 , branch2 => jump2 , RTIandRET	=> '0' , S => fetchController , ID_EX_S=> ID_EX_out_s 
  ,reset => reset , Bubble => '0',clk => clk 

  ,IR1Out(15 downto 11) => IF_ID_in_Opcode1 
  ,IR1Out(10) => IF_ID_in_src1Exist , IR1Out(9) => IF_ID_in_dst1Exist
  ,IR1Out(8 downto 6) => IF_ID_in_dummy3bits1 
  ,IR1Out(5 downto 3) => IF_ID_in_src1 
  ,IR1Out(2 downto 0) => IF_ID_in_dst1

  ,IR2Out(15 downto 11) => IF_ID_in_Opcode2
  ,IR2Out(10) => IF_ID_in_src2Exist , IR2Out(9) => IF_ID_in_dst2Exist
  ,IR2Out(8 downto 6) => IF_ID_in_dummy3bits2
  ,IR2Out(5 downto 3) => IF_ID_in_src2
  ,IR2Out(2 downto 0) => IF_ID_in_dst2

  ,PcPlus1 => IF_ID_in_PcPlus1 );

--    -------------------------------------------------------------------------------------------------

    -- IF/ID register
    IF_ID_Register: entity work.nBitRegister generic map(53) port map(
      D(0) => IF_ID_in_src1Exist, D(1) => IF_ID_in_src2Exist, D(2) => IF_ID_in_dst1Exist, D(3) => IF_ID_in_dst2Exist       -- 4 bit
      , D(8 downto 4) => IF_ID_in_Opcode1, D(13 downto 9) => IF_ID_in_Opcode2                                                -- 10 bit
      , D(16 downto 14) => IF_ID_in_src1, D(19 downto 17) => IF_ID_in_dst1, D(22 downto 20) => IF_ID_in_src2, D(25 downto 23) => IF_ID_in_dst2  
      , D(45 downto 26) => IF_ID_in_PcPlus1                       -- 12 bit
      , D(48 downto 46) => IF_ID_in_dummy3bits1
      , D(51 downto 49) => IF_ID_in_dummy3bits2
      , D(52) => IF_ID_in_s
      ,clk =>CLKNOT                                                                              
      ,rst => reset                                                                            
      ,en => '1'                                                                              
      ,Q(0) => IF_ID_out_src1Exist, Q(1) => IF_ID_out_src2Exist, Q(2) => IF_ID_out_dst1Exist, Q(3) => IF_ID_out_dst2Exist 
      ,Q(8 downto 4) => IF_ID_out_Opcode1, Q(13 downto 9) => IF_ID_out_Opcode2 
      ,Q(16 downto 14) => IF_ID_out_src1, Q(19 downto 17) => IF_ID_out_dst1, Q(22 downto 20) => IF_ID_out_src2, Q(25 downto 23) => IF_ID_out_dst2
      ,Q(45 downto 26) => IF_ID_out_PcPlus1
      ,Q(48 downto 46) => IF_ID_out_dummy3bits1
      ,Q(51 downto 49) => IF_ID_out_dummy3bits2
      ,Q(52) => IF_ID_out_s
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
      ID_EX_in_s <= fetchController;
    -------------------------------------------------------------------------------------------------

    -- ID/EX register
    ID_EX_Register: entity work.nBitRegister generic map(105) port map(
      D(0) => ID_EX_in_src1Exist, D(1) => ID_EX_in_src2Exist, D(2) => ID_EX_in_dst1Exist, D(3) => ID_EX_in_dst2Exist       -- 4 bit
      , D(8 downto 4) => ID_EX_in_Opcode1, D(13 downto 9) => ID_EX_in_Opcode2                                                -- 10 bit
      , D(16 downto 14) => ID_EX_in_src1, D(19 downto 17) => ID_EX_in_dst1, D(22 downto 20) => ID_EX_in_src2, D(25 downto 23) => ID_EX_in_dst2                          -- 12 bit
      ,D(26) => ID_EX_in_WB1, D(27) => ID_EX_in_WB2, D(28) => ID_EX_in_R1, D(29) => ID_EX_in_R2,D(30) => ID_EX_in_W1, D(31) => ID_EX_in_W2
      ,D(47 downto 32) => ID_EX_in_src1Data,D(63 downto 48) => ID_EX_in_src2Data
      ,D(79 downto 64) => ID_EX_in_dst1Data,D(95 downto 80) => ID_EX_in_dst1Data
      ,D(99 downto 96) => ID_EX_in_ALUSelection1,D(103 downto 100) => ID_EX_in_ALUSelection2
      ,D(104)=>ID_EX_in_s
      ,clk => CLKNOT                                                                              
      ,rst => reset                                                                            
      ,en => '1'                                                                              
      ,Q(0) => ID_EX_out_src1Exist, Q(1) => ID_EX_out_src2Exist, Q(2) => ID_EX_out_dst1Exist, Q(3) => ID_EX_out_dst2Exist 
      ,Q(8 downto 4) => ID_EX_out_Opcode1, Q(13 downto 9) => ID_EX_out_Opcode2 
      ,Q(16 downto 14) => ID_EX_out_src1, Q(19 downto 17) => ID_EX_out_dst1, Q(22 downto 20) => ID_EX_out_src2, Q(25 downto 23) => ID_EX_out_dst2
      ,Q(26) => ID_EX_out_WB1, Q(27) => ID_EX_out_WB2, Q(28) => ID_EX_out_R1, Q(29) => ID_EX_out_R2,Q(30) => ID_EX_out_W1, Q(31) => ID_EX_out_W2
      ,Q(47 downto 32) => ID_EX_out_src1Data,Q(63 downto 48) => ID_EX_out_src2Data
      ,Q(79 downto 64) => ID_EX_out_dst1Data,Q(95 downto 80) => ID_EX_out_dst2Data
      ,Q(99 downto 96) => ID_EX_out_ALUSelection1,Q(103 downto 100) => ID_EX_out_ALUSelection2
      ,Q(104)=>ID_EX_out_s
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
      ,MEM_WB_out_WB1,MEM_WB_out_WB2

      ,InPort

      ,branshAddress
      ,EX_MEM_in_dst1Data,EX_MEM_in_dst2Data
      ,flagRegister
      ,EX_MEM_in_ex1,EX_MEM_in_ex2
      ,EX_MEM_in_src1Data,EX_MEM_in_src2Data
      ,jump1,jump2,flush
    );
    -- passing data
    EX_MEM_in_opCode1 <= ID_EX_out_Opcode1;
    EX_MEM_in_opCode2 <= ID_EX_out_Opcode2;
    EX_MEM_in_src1 <= ID_EX_out_src1;
    EX_MEM_in_src2 <= ID_EX_out_src2;
    EX_MEM_in_dst1 <= ID_EX_out_dst1;
    EX_MEM_in_dst2 <= ID_EX_out_dst2;
    EX_MEM_in_src1Exist <= ID_EX_out_src1Exist;
    EX_MEM_in_src2Exist <= ID_EX_out_src2Exist;
    EX_MEM_in_dst1Exist <= ID_EX_out_dst1Exist;
    EX_MEM_in_dst2Exist <= ID_EX_out_dst2Exist;
    EX_MEM_in_WB1 <= ID_EX_out_WB1;  EX_MEM_in_WB2 <= ID_EX_out_WB2;
    EX_MEM_in_R1 <= ID_EX_out_R1; EX_MEM_in_W1 <= ID_EX_out_W1; EX_MEM_in_R2 <= ID_EX_out_R2; EX_MEM_in_W2 <=ID_EX_out_W2;

    -------------------------------------------------------------------------------------------------
  
    
    -- EX/MEM register
    EX_MEM_Register: entity work.nBitRegister generic map(98) port map(
      D(0) => EX_MEM_in_src1Exist, D(1) => EX_MEM_in_src2Exist, D(2) => EX_MEM_in_dst1Exist, D(3) => EX_MEM_in_dst2Exist       -- 4 bit
      ,D(8 downto 4) => EX_MEM_in_Opcode1, D(13 downto 9) => EX_MEM_in_Opcode2                                                -- 10 bit
      ,D(16 downto 14) => EX_MEM_in_src1, D(19 downto 17) => EX_MEM_in_dst1, D(22 downto 20) => EX_MEM_in_src2, D(25 downto 23) => EX_MEM_in_dst2                          -- 12 bit
      ,D(26) => EX_MEM_in_WB1, D(27) => EX_MEM_in_WB2, D(28) => EX_MEM_in_R1, D(29) => EX_MEM_in_R2,D(30) => EX_MEM_in_W1, D(31) => EX_MEM_in_W2
      ,D(47 downto 32) => EX_MEM_in_src1Data,D(63 downto 48) => EX_MEM_in_src2Data
      ,D(79 downto 64) => EX_MEM_in_dst1Data,D(95 downto 80) => EX_MEM_in_dst2Data
      ,D(96) => EX_MEM_in_ex1 ,D(97) => EX_MEM_in_ex2
     
     ,clk =>CLKNOT                                                                              
     ,rst => reset                                                                            
     ,en => '1'    

      ,Q(0) => EX_MEM_out_src1Exist, Q(1) => EX_MEM_out_src2Exist, Q(2) => EX_MEM_out_dst1Exist, Q(3) => EX_MEM_out_dst2Exist       -- 4 bit
      ,Q(8 downto 4) => EX_MEM_out_Opcode1, Q(13 downto 9) => EX_MEM_out_Opcode2                                                -- 10 bit
      ,Q(16 downto 14) => EX_MEM_out_src1, Q(19 downto 17) => EX_MEM_out_dst1, Q(22 downto 20) => EX_MEM_out_src2, Q(25 downto 23) => EX_MEM_out_dst2                          -- 12 bit
      ,Q(26) => EX_MEM_out_WB1, Q(27) => EX_MEM_out_WB2, Q(28) => EX_MEM_out_R1, Q(29) => EX_MEM_out_R2,Q(30) => EX_MEM_out_W1, Q(31) => EX_MEM_out_W2
      ,Q(47 downto 32) => EX_MEM_out_src1Data,Q(63 downto 48) => EX_MEM_out_src2Data
      ,Q(79 downto 64) => EX_MEM_out_dst1Data,Q(95 downto 80) => EX_MEM_out_dst2Data
      ,Q(96) => EX_MEM_out_ex1 ,Q(97) => EX_MEM_out_ex2
    );
  
     OutPort <= EX_MEM_out_dst1Data    when EX_MEM_out_Opcode1=OOUT 
      else  EX_MEM_out_dst2Data        when EX_MEM_out_Opcode2=OOUT ;

    -- Memory Stage
    MemoryStage:entity work.Memory port map (clk
    ,EX_MEM_out_src1Data,EX_MEM_out_src2Data
    ,EX_MEM_out_dst1Data,EX_MEM_out_dst2Data
    ,SPout
    ----------TODO-----------------
    ,EX_MEM_out_Opcode1
    ,EX_MEM_out_Opcode2
    ,EX_MEM_out_R1, EX_MEM_out_R2
    ,EX_MEM_out_W1, EX_MEM_out_W2
    -------------------------------
    ,MEM_WB_in_dst1Data, MEM_WB_in_dst2Data
    );

  -- passing 
    MEM_WB_in_WB1 <= EX_MEM_out_WB1; MEM_WB_in_WB2 <= EX_MEM_out_WB2;
    MEM_WB_in_R1 <= EX_MEM_out_R1; MEM_WB_in_W1 <= EX_MEM_out_W1; MEM_WB_in_R2 <= EX_MEM_out_R2; MEM_WB_in_W2 <=EX_MEM_out_W2;
    MEM_WB_in_dst1 <= EX_MEM_out_dst1;
    MEM_WB_in_dst2 <= EX_MEM_out_dst2;
  
    -------------------------------------------------------------------------------------------------
      
-- MEM/WB register
    MEM_WB_Register: entity work.nBitRegister generic map(44) port map(
      D(0) => MEM_WB_in_WB1, D(1) => MEM_WB_in_WB2, D(2) => MEM_WB_in_R1
      ,D(3) => MEM_WB_in_W1,  D(4) => MEM_WB_in_R2,  D(5) => MEM_WB_in_W2
      ,D(8 downto 6) => MEM_WB_in_dst1,D(11 downto 9) => MEM_WB_in_dst2
      ,D(27 downto 12) => MEM_WB_in_dst1Data,D(43 downto 28) => MEM_WB_in_dst2Data
      ,clk =>CLKNOT                                                                              
      ,rst => reset                                                                            
      ,en => '1'   

      ,Q(0) => MEM_WB_out_WB1, Q(1) => MEM_WB_out_WB2, Q(2) => MEM_WB_out_R1
      ,Q(3) => MEM_WB_out_W1,  Q(4) => MEM_WB_out_R2,  Q(5) => MEM_WB_out_W2
      ,Q(8 downto 6) => MEM_WB_out_dst1,Q(11 downto 9) => MEM_WB_out_dst2
      ,Q(27 downto 12) => MEM_WB_out_dst1Data,Q(43 downto 28) => MEM_WB_out_dst2Data
    );
--    -------------------------------------------------------------------------------------------------
--
   -- WriteBack Stage
    WriteBackStage:entity work.WriteBack port map (
      MEM_WB_out_WB1, MEM_WB_out_WB2,
      MEM_WB_out_dst1, MEM_WB_out_dst2,
      MEM_WB_out_dst1Data, MEM_WB_out_dst2Data,
      WB_OUT_WB1, WB_OUT_WB2,
      WB_OUT_dst1, WB_OUT_dst2,
      WB_OUT_dataDst1, WB_OUT_dataDst2
    );
    -------------------------------------------------------------------------------------------------
--


end mainArch ; -- mainArch