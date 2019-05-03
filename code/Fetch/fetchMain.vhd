LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY fetch IS
	PORT(   --address is 20 bits registers are 32 bits

		--inputs to fetch
		returnAddress,branchAdd: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		--second instruction fetched of previous cycle
		D2:IN STD_LOGIC_VECTOR(15 downto 0); 
		
		--selectors and other 1 bit inputs
		inturrupt,branch1 , branch2 ,RTIandRET ,S , ID_EX_S,reset,Bubble,clk: IN STD_LOGIC;
	
		--output to fetch/decoder buffer
		IR1Out,IR2Out: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		--pc address out
		PcPlus1:OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END ENTITY fetch;

ARCHITECTURE ArchOfFetch OF fetch IS



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
	SIGNAL pcEnable : std_logic;
	SIGNAL pcReset : std_logic;


BEGIN 
	pcReset<= reset ;
	pcEnable<= (not Bubble) ;
	instructionMemory: entity work.Ram  generic map ( 2 )  port map (clk,'0','1',pcOut,dummy,dataOutRam);
	pcAndAdder:entity work.pcAdders   port map (toPcOut,pcEnable,pcReset,clk,pcOut,pcOut1,pcOut2);
	
	IR1:	MUX2x1 port map(dataOutRam(15 downto 0),D2,S,IR1Out);
	IR2:	MUX2x1 port map(dataOutRam(31 downto 16),dataOutRam(15 downto 0),S,IR2Out);
	mux:entity work.pcMux port map (F1,pcOut1,pcOut2,returnAddress,branchAdd,inturrupt,branch1 , branch2 ,RTIandRET,ID_EX_S,reset , clk,ToPcOut);


F1(15 downto 0) <= dataOutRam(15 downto 0);
F1(19 downto 16) <= (others => '0');
PcPlus1 <= pcOut1;
	
END ArchOfFetch;
