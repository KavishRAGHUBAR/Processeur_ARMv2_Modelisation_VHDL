--TB de MAE

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

--  A testbench has no ports.
entity mae_tb is
end mae_tb;

architecture behav of mae_tb is
signal reset : std_logic ;
signal clk : std_logic;
signal ETAT : std_logic_vector(2 downto 0);
signal T1 : std_logic := '0';	
signal T2 : std_logic:= '0';	
signal T3 : std_logic:= '0';	
signal T4 : std_logic:= '0';
signal T5 : std_logic:= '0';	
signal T6 : std_logic:= '0';	
signal something : std_logic_vector(2 downto 0);	

begin

MAE: entity work.mae
port map(

		reset => reset,
		clk => clk,
		ETAT	=> ETAT,
		T1	=> T1,
		T2	=> T2,
		T3	=> T3,
		T4	=> T4,
		T5	=> T5,
		T6	=> T6,
		something => something);



reset <= '1' after 30 ns, '0' after 50 ns, '1' after 60 ns;

T1 <=   '1' after 20 ns, '0' after 30 ns , '1' after 40 ns, '0' after 50 ns , '1' after 60 ns,
	'1' after 70 ns, '0' after 80 ns , '1' after 90 ns, '0' after 100 ns , '1' after 110 ns,
	'1' after 120 ns, '0' after 130 ns , '1' after 140 ns, '0' after 150 ns , '1' after 160 ns,
	'1' after 170 ns, '0' after 180 ns , '1' after 190 ns, '0' after 200 ns , '1' after 210 ns,
	'1' after 220 ns, '0' after 230 ns , '1' after 240 ns, '0' after 250 ns , '1' after 260 ns,
	'1' after 270 ns, '0' after 280 ns , '1' after 290 ns, '0' after 300 ns ;

T2 <= '1' after 40 ns, '0' after 60 ns , '1' after 80 ns, '0' after 100 ns , '1' after 120 ns,
	'1' after 140 ns, '0' after 160 ns , '1' after 180 ns, '0' after 200 ns , '1' after 220 ns,
	'1' after 240 ns, '0' after 260 ns , '1' after 280 ns, '0' after 300 ns;

T3 <= '1' after 60 ns, '0' after 100 ns , '1' after 140 ns, '0' after 180 ns , '1' after 220 ns,
	'1' after 260 ns, '0' after 300 ns , '1' after 340 ns, '0' after 380 ns	;

T4 <= '1' after 80 ns, '0' after 140 ns , '1' after 200 ns, '0' after 260 ns;

T5 <= '1' after 100 ns, '0' after 140 ns , '1' after 180 ns, '0' after 220 ns , '1' after 250 ns, '0' after 290 ns;

T6 <= '1' after 120 ns, '0' after 140 ns , '1' after 160 ns, '0' after 180 ns , '1' after 200 ns, '1' after 220 ns,
	'1' after 240 ns, '0' after 260 ns , '1' after 280 ns, '0' after 300 ns , '1' after 320 ns;


proc : process
begin
boucle : for cpt IN 1 TO 100 loop
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
END loop;


wait; --on met le wait juste avant end process proc
end process proc;
end behav;


--A <= "0000", "0001" after 5 ns, "0010" after 10 ns;
--B <= "0000", "0001" after 10 ns, "0010" after 15 ns;
 -- FETCH : 000
 -- BRANCH : 001
 -- LINK : 010
 -- MTRANS : 011
 -- RUN : 100

  
