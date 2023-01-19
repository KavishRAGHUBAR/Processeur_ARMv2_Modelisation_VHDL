------------------------------------------
--- tp 4
--- adder4

library IEEE;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;


entity adder4b IS
port (	A,B : IN std_logic_vector(3 downto 0);
		cin : IN std_logic;
        S	: OUT std_logic_vector(3 downto 0);
        cout: OUT std_logic );
end adder4b;

architecture archi of adder4b IS

component adder1b
	port ( A,B, cin : IN std_logic;
		S, cout : OUT std_logic );
end component;

signal carry : std_logic_vector(4 downto 0);

begin

carry(0)<=cin;
cout<=carry(4);

boucle: for i in 0 to 3 generate

adder1_inst : adder1b port map ( A=>A(i), B=>B(i), cin=>carry(i), S=>S(i), cout=>carry(i+1) );

end generate;

end archi;
