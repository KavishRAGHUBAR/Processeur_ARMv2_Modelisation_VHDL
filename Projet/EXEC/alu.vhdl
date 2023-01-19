------------------------------------------
--- tp 4
--- alu

library IEEE;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;


entity alu IS
port (	op1, op2 : IN std_logic_vector(31 downto 0);
	cin	 : IN std_logic;
        cmd 	 : IN std_logic_vector(1 downto 0);
        
        res 	 : OUT std_logic_vector(31 downto 0);
        cout 	 : OUT std_logic;
	n,z,v 	 : OUT std_logic;
        
        vdd, vss : IN bit );
end alu;

architecture archi of alu IS

component adder32b 
port (	A,B : IN std_logic_vector(31 downto 0);
		cin : IN std_logic;
        S	: OUT std_logic_vector(31 downto 0);
        cout: OUT std_logic );
end component ;


signal S	 : std_logic_vector(31 downto 0);
signal carryo	 : std_logic;

begin
  		
Add : adder32b --instanciation de adder 32b
port map(A=>op1, B=>op2, cin=>cin, S=>S, cout=>carryo);
 
--selection de res en fonction de cmd
WITH cmd SELECT res<=
	S WHEN "00",
	(op1 and op2) WHEN "01",
	(op1 or op2) WHEN "10",	
	(op1 xor op2) WHEN OTHERS;
      
 --mise a jour des flags
n<='1' when (S(31)='1' and cmd="00") else '0' ;
z<='1' when (S=x"00000000" and cmd="00") or 
	    ((op1 and op2)=x"00000000" and cmd="01" )or
            ((op1 or op2)=x"00000000" and cmd="10") or
	     ((op1 xor op2)=x"00000000" and cmd="11") 
		 else '0';
v<='1' when carryo='1' else '0';
 
 --affectation des sorties
cout<=carryo;

end archi;

