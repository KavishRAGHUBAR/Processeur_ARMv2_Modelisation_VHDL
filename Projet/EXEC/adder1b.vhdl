------------------------------------------
--- tp 4
--- add1bit

library IEEE;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;


entity adder1b IS
port ( A,B, cin : IN std_logic;
		S, cout : OUT std_logic );
end adder1b;

architecture archi of adder1b is

begin
	S<= A xor B xor cin;
    cout<= (A and B) or (cin and (A xor B));
end archi;
