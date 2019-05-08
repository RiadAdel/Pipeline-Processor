library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

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
  op2 <= (one) when s = ALUINC -- inc
  else allOnes when s = ALUDEC -- dec
  else A when s = ALUADD -- add
  else not(A) when s = ALUSUB
  else allZeros;

  adderCarryIn <= '1' when s = "0101"
  else '0';

  adder:entity work.my_nadder generic map(16)
        port map(op1,op2,adderCarryIn,adderOut,adderCarryOut);
  ----------------------------------------------------------------

  -- Shifter
  direction <= '1' when s = ALUSHR -- if shift right
  else '0';

  shifter: entity work.Shifter port map(direction,A(3 downto 0),B,shift,shifterCarryOut);
  ----------------------------------------------------------------

  -- ALU outout
  outpu <= outp;
  outp <= (others => '0') when s = ALUFEQUAL0 -- reset
  else not(B) when s = ALUNOT -- not
  else adderOut when s = ALUINC -- inc
  else adderOut when s = ALUDEC -- dec
  else adderOut when s = ALUADD -- add
  else adderOut when s = ALUSUB -- sub
  else (A and B) when s = ALUAND -- and
  else (A or B) when s = ALUOR -- or
  else shift when s = ALUSHL -- shift left
  else shift when s = ALUSHR -- shift right
  else B when s = ALUFEQUALB -- pass
  else A when s = ALUFEQUALA -- mov and in
  else (others => '0');

  C <= shifterCarryOut when s = ALUSHL or s = ALUSHR
  else adderCarryOut when s = ALUINC or s = ALUDEC or s = ALUADD or s = ALUSUB
  else '1' when s =ALUSETC -- set carry
  else '0' when s =ALUCLEARC; -- clear carry

  Z <= '1' when outp = "0000000000000000" and s /= ALUFEQUAL0 and s /= ALUFEQUALB and s /= ALUFEQUALA 
  else '0' when s /= ALUFEQUAL0 and s /= ALUFEQUALB and s /= ALUFEQUALA;

  Ni <= '1' when outp(15) = '1' and s /= ALUFEQUAL0 and s /= ALUFEQUALB and s /= ALUFEQUALA
  else '0' when s /= ALUFEQUAL0 and s /= ALUFEQUALB and s /= ALUFEQUALA;
end ALUArch ;