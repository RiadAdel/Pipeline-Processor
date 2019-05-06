library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  generic(n: integer := 16);
  port (
    s:in std_logic_vector (3 downto 0);
    A,B:in std_logic_vector(n-1 downto 0);
    outpu:out std_logic_vector(n-1 downto 0);
    C,Ni,Z:out std_logic
  );
end ALU;

architecture ALUArch of ALU is
  -- default signals
  signal zero: std_logic_vector(n-2 downto 0);
  signal one: std_logic_vector(n-1 downto 0);
  signal allOnes: std_logic_vector(n-1 downto 0);
  signal allZeros: std_logic_vector(n-1 downto 0);
  signal outp:std_logic_vector(n-1 downto 0);
  -- adder signals
signal op1,op2,adderOut: std_logic_vector(n-1 downto 0);
signal adderCarryIn,adderCarryOut: std_logic;
  
 -- shifter signals
signal shift: std_logic_vector(n-1 downto 0);
signal shifterCarryOut,direction: std_logic;


begin
  zero <= (others => '0');
  one <= zero & '1';
  allOnes <= (others => '1');
  allZeros <= (others => '0');

  -- adder
  op1 <= B;
  op2 <= (one) when s = "0010" -- inc
  else allOnes when s = "0011" -- dec
  else A when s = "0100" -- add
  else not(A) when s = "0101"
  else allZeros;

  adderCarryIn <= '1' when s = "0101"
  else '0';

  adder:entity work.my_nadder generic map(16)
        port map(op1,op2,adderCarryIn,adderOut,adderCarryOut);
  ----------------------------------------------------------------

  -- Shifter
  direction <= '1' when s = "1001" -- if shift left
  else '0';

  shifter: entity work.Shifter port map(direction,A(3 downto 0),B,shift,shifterCarryOut);
  ----------------------------------------------------------------

  -- ALU outout
  outpu <= outp;
  outp <= (others => '0') when s = "0000" -- reset
  else not(B) when s = "0001" -- not
  else adderOut when s = "0010" -- inc
  else adderOut when s = "0011" -- dec
  else adderOut when s = "0100" -- add
  else adderOut when s = "0101" -- sub
  else (A and B) when s = "0110" -- and
  else (A or B) when s = "0111" -- or
  else shift when s = "1000" -- shift left
  else shift when s = "1001" -- shift right
  else B when s = "1010" -- pass
  else (others => '0');

  C <= shifterCarryOut when s = "1000" or s = "1001"
  else adderCarryOut when s = "0010" or s = "0011" or s = "0100" or s = "0101"
  else '1' when s ="1011" -- set carry
  else '0' when s ="1100"; -- clear carry

  Z <= '1' when outp = "0000000000000000" and s /= "0000" and s /= "1010"
  else '0' when s /= "0000" and s /= "1010";

  Ni <= '1' when outp(15) = '0' and s /= "0000" and s /= "1010"
  else '0' when s /= "0000" and s /= "1010";
end ALUArch ;