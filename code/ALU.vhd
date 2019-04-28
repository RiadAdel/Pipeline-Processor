library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
entity ALU is
  port (
    A,B:in std_logic_vector(31 downto 0);
    outp:out std_logic_vector(21 downto 0)
  );
end ALU;

architecture ALUArch of ALU is
begin
    
end ALUArch ;