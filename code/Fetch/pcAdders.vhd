LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pcAdders IS
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
END ENTITY pcAdders;

ARCHITECTURE pcAddersArch OF pcAdders IS

--register component
Component nBitRegister IS
	generic( n : integer := 16);
	PORT(	D: IN std_logic_vector(n-1 downto 0);	
		CLK,RST,EN : IN std_logic;
		Q : OUT std_logic_vector(n-1 downto 0));
END component;
--nadder component
Component my_nadder IS

Generic ( n : integer := 16);
PORT(a, b : in std_logic_vector(n-1 downto 0);
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END component;
---signals

SIGNAL cout1,cout2:std_logic;
SIGNAL registerIn,RegisterOut:std_logic_vector(31 downto 0);


BEGIN 

	pc: nBitRegister  generic map ( 32 )  port map (registerIn,clk,reset,enable,registerOut); --"0000000000000001"
	add1: my_nadder   generic map ( 20 )  port map (pcIn,"00000000000000000001",'0',pcOutPlus1,cout1);
	add2: my_nadder   generic map ( 20 )  port map (pcIn,"00000000000000000010",'0',pcOutPlus2,cout2);
		
registerIn(19 downto 0) <= pcin;
registerIn(31 downto 20) <= (others => '0');
pcOut <= registerOut(19 downto 0);




END pcAddersArch;
