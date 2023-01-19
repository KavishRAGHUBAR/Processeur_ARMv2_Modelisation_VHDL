library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

--  A testbench has no ports.
entity ALU_tb is
end ALU_tb;

architecture behav of ALU_tb is
signal op1 :  Std_Logic_Vector(31 downto 0) := x"00000000";
signal	op2 :  Std_Logic_Vector(31 downto 0):= x"00000000";
signal	cin :  Std_Logic := '0';
signal	cmd :  Std_Logic_Vector(1 downto 0) := "00";
signal	res :  Std_Logic_Vector(31 downto 0);
signal	cout : Std_Logic;
signal	z :  Std_Logic;
signal	n :  Std_Logic;
signal	v :  Std_Logic;
signal	vdd : bit := '1';
signal	vss : bit := '0';

begin

calcul: entity work.ALU
port map(

		op1 => op1,
		op2 => op2,
		cin	=> cin,
		cmd	=> cmd,
		res => res,
		cout => cout,
		z	=> z,
		n	=> n,
		v => v,
		vdd => vdd,
		vss	=> vss
		);


--A <= "0000", "0001" after 5 ns, "0010" after 10 ns;
--B <= "0000", "0001" after 10 ns, "0010" after 15 ns;
op1 <= x"10007001" after 10 ns;
op2 <= x"00001210" after 15 ns;
cmd <= "00", "01" after 50 ns, "10" after 75 ns, "11" after 100 ns, "00" after 150 ns;  
cin <= '0';


--proc : process
--begin
--boucle : for cpt IN 1 TO 16 loop
	--op1 <= op1 + op1; wait for 5 ns;
	--op2 <= op2 + op2; wait for 8 ns;

--END loop;
--wait; --on met le wait juste avant end process proc
--end process proc;
end behav;
