library ieee;
use ieee.std_logic_1164.all;

entity MUX2x1 is
    generic (n: integer := 16);
    port (
        inp1,inp2:in std_logic_vector (n-1 downto 0);
        selector:in std_logic;
        outp:out std_logic_vector (n-1 downto 0) 
  ) ;
end MUX2x1;

architecture MUX2x1Arch of MUX2x1 is
    begin
        outp <= inp1 when selector = '0'
        else inp2;

end MUX2x1Arch ; -- MUX_4x1Arch