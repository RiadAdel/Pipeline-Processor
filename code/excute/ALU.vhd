library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  generic(n: integer := 16);
  port (
    s:in std_logic_vector (3 downto 0);
    A,B:in std_logic_vector(n-1 downto 0);
    outp:out std_logic_vector(n-1 downto 0)
  );
end ALU;

architecture ALUArch of ALU is
  -- default signals
  signal zero: std_logic_vector(n-2 downto 0);
  signal one: std_logic_vector(n-1 downto 0);
  signal allOnes: std_logic_vector(n-1 downto 0);
  signal allZeros: std_logic_vector(n-1 downto 0);

  -- adder signals
signal op1,p2,adderOut: std_logic_vector(n-1 downto 0);
signal carry: std_logic;
  
 -- shifter signals
signal shift: std_logic_vector(n-1 downto 0);

begin
  one <= zero & '1';
  allOnes <= (others => '1');
  allZeros <= (others => '0');

  -- adder oprands
  op1 <= A;
  op2 <= (one) when s = "0010" -- inc
  else <= allOnes when s = "0011" -- dec
  else <= B when s = "0100" -- add
  else <= not(B) when s = "0101"
  else allZeros;

  carry <= '1' when s = "0101"
  else '0';
  
  -- ALU outout
  outp <= (others => '0') when s = "0000" -- reset
  else not(B) when s = "0001" -- not
  else adderOut when s = "0010" -- inc
  else adderOut when s = "0011" -- dec
  else adderOut when s = "0100" -- add
  else adderOut when s = "0101" -- sub
  else (A and B) when s = "0110" -- and
  else (A or B) when s = "0111" -- or
  else shiftLeft when s = "1000" -- shift left
  else shiftRight when s = "1001" -- shift right
  else B when s = "1010" -- pass
  else (others => 'Z');
end ALUArch ;