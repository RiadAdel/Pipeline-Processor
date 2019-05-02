LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY fetch IS
	PORT(   --address is 20 bits registers are 32 bits

		--inputs to fetch
		Fetch1,pcAddressPlusOne,pcAddressPlusTwo,returnAddress,
		returnInterruptAddress,branchAdd,D2: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		
		--selectors and other 1 bit inputs
		inturrupt,branch,S,reset,pcEnable,pcReset,RamReset,clk: IN STD_LOGIC;
		
		--output to fetch/decoder buffer
		IR1Out,IR2Out,PcPlus1: OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END ENTITY fetch;

ARCHITECTURE ArchOfFetch OF fetch IS

--pcMux component
component pcMux IS
	PORT(
		--addresses entered to the mux
		Fetch1,pcAddressPlusOne,pcAddressPlusTwo,returnAddress,
		returnInterruptAddress,branchAdd: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		
		--selectors
		inturrupt,branch,S,reset: IN STD_LOGIC;
		
		--output to the pc
		ToPcOut: OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END component;

--pcAdders component
component pcAdders IS
	PORT(
		--input address to pc register
		PcIn: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		
		--enable to pc register(not bubble) enable always =1 ???
		enable,reset,clk: IN STD_LOGIC;
		
		--output from pc register
		PcOut: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		pcOutPlus1: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		pcOutPlus2: OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END component;


--ram component(instruction memory)
component RAM is
generic(X: integer := 28);
  	PORT(
   		 reset:in std_logic;
   		 CLK,W,R:in std_logic;
   		 address:in std_logic_vector(12 downto 0);
   		 dataIn:in std_logic_vector( 15 downto 0);
   	         dataOut:out std_logic_vector(((X*16)-1) downto 0);
   		 MFC:out std_logic;
    		 counterOut:out std_logic_vector(3 downto 0)
  ) ;
end component;

--Mux 2 component
Component MUX_2x1 is
    generic (n: integer := 16);
    port (
        inp1,inp2:in std_logic_vector (n-1 downto 0);
        selector:in std_logic;
        outp:out std_logic_vector (n-1 downto 0) 
  ) ;
end component;

--signals
	SIGNAL ToPcOut,pcOut,pcOut1,pcOut2,dummy:std_logic_vector(15 downto 0);
	SIGNAL dataOutRam:std_logic_vector(31 downto 0);
	SIGNAL mfc:std_logic;
	SIGNAL counterOut:std_logic_vector(3 downto 0);
BEGIN 
	
	mux:      pcMux    port map (Fetch1,pcAddressPlusOne,pcAddressPlusTwo,returnAddress,returnInterruptAddress,branchAdd,inturrupt,branch,S,reset,ToPcOut);
	pcAndAdder: pcAdders port map (toPcOut,pcEnable,pcReset,clk,pcOut,pcOut1,pcOut2);
	instructionMemoru:Ram  generic map ( 2 )  port map (ramReset,clk,'0','1',pcOut(9 downto 0),dummy,dataOutRam,mfc,counterout);
	IR1:MUX_2x1 port map(dataOutRam(15 downto 0),D2,S,IR1Out);
	IR2:MUX_2x1 port map(dataOutRam(31 downto 16),dataOutRam(15 downto 0),S,IR2Out);


PcPlus1 <= pcOut1;
	
END ArchOfFetch;
