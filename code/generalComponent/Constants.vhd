library IEEE;
USE IEEE.std_logic_1164.all;
package constants is

-- write this line in your file to use the constants
--use work.constants.all;

-- one operand constants
constant NOP: std_logic_vector(4 downto 0)  :="00000";
constant SETC: std_logic_vector(4 downto 0) :="00001";
constant CLRC: std_logic_vector(4 downto 0) :="00010";
constant NNOT: std_logic_vector(4 downto 0) :="00011";
constant INC: std_logic_vector(4 downto 0)  :="00100";
constant DEC: std_logic_vector(4 downto 0)  :="00101";
constant OOUT: std_logic_vector(4 downto 0) :="00110";
constant IIN: std_logic_vector(4 downto 0)  :="00111";
--two operand constants
constant MOV: std_logic_vector(4 downto 0)  :="01000";
constant ADD: std_logic_vector(4 downto 0)  :="01001";
constant SUB: std_logic_vector(4 downto 0)  :="01010";
constant AAND: std_logic_vector(4 downto 0) :="01011";
constant OOR: std_logic_vector(4 downto 0)  :="01100";
constant SHL: std_logic_vector(4 downto 0)  :="01101";
constant SHR: std_logic_vector(4 downto 0) :="01110";

--- memory operations constants
constant PUSH: std_logic_vector(4 downto 0)  :="10000";
constant POP: std_logic_vector(4 downto 0)   :="10001";
constant LDM: std_logic_vector(4 downto 0)   :="10010";
constant LDD: std_logic_vector(4 downto 0)   :="10011";
constant SSTD: std_logic_vector(4 downto 0)  :="10100";

---- branch and change control constants

constant JZ: std_logic_vector(4 downto 0)    :="11000";
constant JN: std_logic_vector(4 downto 0)    :="11001";
constant JC: std_logic_vector(4 downto 0)    :="11010";
constant JMP: std_logic_vector(4 downto 0)   :="11011";
constant CALL: std_logic_vector(4 downto 0)  :="11100";
constant RET: std_logic_vector(4 downto 0)   :="11101";
constant RTI: std_logic_vector(4 downto 0)   :="11110";




end constants;
