LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pcMux IS
	PORT(
		--addresses entered to the mux                  --- returnAddress --> from RET or RTI
		Fetch1,pcAddressPlusOne,pcAddressPlusTwo,returnAddress,
		branchAdd: IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		
		
		--selectors
		inturrupt, branch1 , branch2 , RTIandRET,S,reset , clk : IN STD_LOGIC;
		
		--output to the pc
		ToPcOut: OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
	);
END ENTITY pcMux;

ARCHITECTURE pcMuxArch OF pcMux IS
	SIGNAL latchedRst  , Branch: std_logic ;
	
BEGIN 
        Branch<= branch1 or branch2;
	latchedRst<= '1' when reset='1' and clk'event and clk = '0' else '0';
     



process (latchedRST,S,branch,RTIandRET,branch1,clk)
	
begin
	
	if latchedRst = '1' then
		ToPcOut <= Fetch1;
	elsif  (S = '1') AND (branch='0') AND (RTIandRET = '0') then
		ToPcOut <= pcAddressPlusOne;
	elsif  branch = '1' and  (RTIandRET = '0'   or (RTIandRET ='1' and branch1='1' ))  then
		ToPcOut <= branchAdd;
	elsif  RTIandRET ='1' and branch1='0' then
		ToPcOut <= returnAddress; 
	else 
		ToPcOut <= pcAddressPlusTwo;
	end if;
end process;


	
	
END pcMuxArch;
