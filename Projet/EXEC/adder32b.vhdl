------------------------------------------
--- tp 4
--- adder32

library IEEE;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;


entity adder32b IS
port (	A,B : IN std_logic_vector(31 downto 0);
		cin : IN std_logic;
        S	: OUT std_logic_vector(31 downto 0);
        cout: OUT std_logic );
end adder32b;

architecture archi of adder32b IS

component adder4b 
port (	A,B : IN std_logic_vector(3 downto 0);
		cin : IN std_logic;
        S	: OUT std_logic_vector(3 downto 0);
        cout: OUT std_logic );
end component ;

signal carry : std_logic_vector(8 downto 0);

begin

carry(0)<=cin;
cout<=carry(8);

boucle: for i in 0 to 7 generate

add4_inst : adder4b
		port map ( 	A=>A(4*i+3 downto 4*i), 
        			B=>B(4*i+3 downto 4*i), 
                    cin=>carry(i), 
                    S=>S(4*i+3 downto 4*i), 
                    cout=>carry(i+1) );

end generate;

end archi;
