library ieee;
use ieee.std_logic_1164.all;

entity ForwardDesidor is
    generic (n: integer := 3);
    port (
        enable:in std_logic;
        inp1,inp2:in std_logic_vector (n-1 downto 0);
        in2exist:in std_logic;
        result:out std_logic
  ) ;
end ForwardDesidor;

architecture ForwardDesidorArch of ForwardDesidor is
    signal same:std_logic;
    begin
        result <= '1' when enable = '1' and same = '1'
        else '0';

        same <= '1' when inp1 = inp2 and in2exist = '1'
        else '0';
end ForwardDesidorArch ; -- MUX_4x1Arch