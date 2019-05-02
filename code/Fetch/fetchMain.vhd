LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY fetch IS
	PORT(   --address is 20 bits registers are 32 bits

		--inputs to fetch
		returnAddress,returnInterruptAddress,branchAdd: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		--second instruction fetched of previous cycle
		D2:IN STD_LOGIC_VECTOR(15 downto 0); 
		
		--selectors and other 1 bit inputs
		inturrupt,branch,S,reset,pcEnable,pcReset,clk: IN STD_LOGIC;
	
		--output to fetch/decoder buffer
		IR1Out,IR2Out: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		--pc address out
		PcPlus1:OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
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
Component Ram IS
	--n is the number of lines retrieved. ex => if n = 1 -> dataOut holds 16 bits
	--if n = 2 -> dataOut holds 32 bits and so on
	GENERIC(n : INTEGER := 1);
	PORT(
		CLK : IN std_logic;
		W,R : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		dataIn  : IN  std_logic_vector(15 DOWNTO 0);
		dataOut : OUT std_logic_vector(16*n-1 DOWNTO 0));
END component;

--Mux 2 component
Component MUX2x1 is
    generic (n: integer := 16);
    port (
        inp1,inp2:in std_logic_vector (n-1 downto 0);
        selector:in std_logic;
        outp:out std_logic_vector (n-1 downto 0) 
  ) ;
end component;

--signals
	SIGNAL ToPcOut,pcOut,pcOut1,pcOut2,F1:std_logic_vector(19 downto 0);
	SIGNAL dataOutRam:std_logic_vector(31 downto 0);
	SIGNAL dummy:std_logic_vector(15 downto 0);
	
	
BEGIN 
	instructionMemory:	Ram  generic map ( 2 )  port map (clk,'0','1',pcOut,dummy,dataOutRam);
	pcAndAdder:	pcAdders   port map (toPcOut,pcEnable,pcReset,clk,pcOut,pcOut1,pcOut2);
	
	IR1:	MUX2x1 port map(dataOutRam(15 downto 0),D2,S,IR1Out);
	IR2:	MUX2x1 port map(dataOutRam(31 downto 16),dataOutRam(15 downto 0),S,IR2Out);
	mux:	pcMux port map (F1,pcOut1,pcOut2,returnAddress,returnInterruptAddress,branchAdd,inturrupt,branch,S,reset,ToPcOut);


F1(15 downto 0) <= dataOutRam(15 downto 0);
F1(19 downto 16) <= (others => '0');
PcPlus1 <= pcOut1;
	
END ArchOfFetch;
