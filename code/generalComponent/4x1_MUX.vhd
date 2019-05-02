library ieee;
use ieee.std_logic_1164.all;

entity MUX_4x1 is
    generic (n: integer := 16);
    port (
        inp1,inp2,inp3,inp4:in std_logic_vector (n-1 downto 0);
        selector:in std_logic_vector (1 downto 0);
        outp:out std_logic_vector (n-1 downto 0) 
  ) ;
end MUX_4x1;

architecture MUX_4x1Arch of MUX_4x1 is
    begin
        outp <= inp1 when selector = "00"
        else inp2 when selector = "01"
        else inp3 when selector = "10"
        else inp4;

end MUX_4x1Arch ; -- MUX_4x1Arch