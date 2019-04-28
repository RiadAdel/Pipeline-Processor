library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
  port (
    direction:in std_logic; -- zero for left and one for right shift
    numOfShift:in std_logic_vector(3 downto 0);
    inp:in std_logic_vector(15 downto 0);
    outp:out std_logic_vector(15 downto 0);
    carry:out std_logic
  ) ;
end Shifter;

architecture ShifterArch of Shifter is
    signal zero: std_logic_vector(15 downto 0);
begin
    zero <= (others => '0');

    -- shifter output
    outp <= (zero) when numOfShift = "0000"
    else inp((15 - to_integer(unsigned(numOfShift))) downto 0) & zero(to_integer(unsigned(numOfShift)) downto 1) when direction = '0'
    else zero(to_integer(unsigned(numOfShift)) downto 1) & inp(15 downto to_integer(unsigned(numOfShift)));

    -- Shifter carry 
    carry <= inp(15) when numOfShift = "0000"
    else inp(16 - to_integer(unsigned(numOfShift))) when direction = '0'
    else inp(to_integer(unsigned(numOfShift))-1);
    
end ShifterArch ; -- ShifterArch