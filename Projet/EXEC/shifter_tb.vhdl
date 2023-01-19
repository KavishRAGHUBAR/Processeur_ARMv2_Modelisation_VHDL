library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

--  A testbench has no ports.
entity shifter_tb is
end shifter_tb;

architecture behav of shifter_tb is
signal  shift_lsl : Std_Logic:='0';
signal	shift_lsr : Std_Logic:='0';
signal	shift_asr : Std_Logic:='0'; 
signal	shift_ror : Std_Logic:='0'; 
signal	shift_rrx : Std_Logic:='0'; 
signal	shift_val : Std_Logic_Vector(4 downto 0) := "00111";--7
signal	din : Std_Logic_Vector(31 downto 0) := x"A56120BF" ;
signal	cin : Std_Logic := '0';
signal	dout : Std_Logic_Vector(31 downto 0);
signal	cout : Std_Logic;

signal	vdd : bit :='1';
signal	vss : bit := '0';

begin

calcul: entity work.shifter
port map(

		shift_lsl => shift_lsl,
		shift_lsr => shift_lsr,
		shift_asr	=> shift_asr,
		shift_ror	=> shift_ror,
		shift_rrx => shift_rrx,
		shift_val	=> shift_val,
		din	=> din,
		cin 	=> cin,
		dout 	=> dout,
		cout	=> cout,
		vdd 	=> vdd,
		vss	=> vss
		);

--op1 <= x"10007001" after 10 ns;
--op2 <= x"00001210" after 15 ns;
shift_lsl <= '0', '1' after 30 ns, '0' after 50 ns;
shift_lsr <= '0', '1' after 50 ns, '0' after 70 ns;
shift_asr <= '0', '1' after 70 ns, '0' after 90 ns;
shift_ror <= '0', '1' after 90 ns, '0' after 110 ns;
shift_rrx <= '0', '1' after 110 ns, '0' after 130 ns;

--proc : process
--begin
--boucle : for cpt IN 1 TO 16 loop
	--op1 <= op1 + op1; wait for 5 ns;
	--op2 <= op2 + op2; wait for 8 ns;

--END loop;
--wait; --on met le wait juste avant end process proc
--end process proc;
end behav;
