--nous allons écrire notre shift left (sans utiliser de librarie shift_left)
--on utilisera le même composant pour arithmetic shift left.

library ieee;
use ieee.std_logic_1164.all;


entity lsl is  --left shift logical
	port(din : in std_logic_vector(31 downto 0) ;
	shift_val : in std_logic_vector(4 downto 0);
	dout : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	vdd		: in bit;
    	vss		: in bit 
    	);
end lsl;


architecture behav of lsl is
begin

process(din,shift_val) --sensible à din et shift_val.
	variable c_var : std_logic ; --mis à jour de cout par c_var hors process
	variable din_var : std_logic_vector(31 downto 0); --update dout ouside the process with din_var

begin
c_var := '0'; 
din_var := din; 
--c'est din var qu'on va modifier dans le process en fonction de la valeur du shift_val
--il faut aussi savoir que le carry out (cout) est le "bit 32" après le décalage
--mtn on test bit par bit de notre shift_val et on décale par 2^(bit) si le bit correspondant vaut 1

	if(shift_val(0) = '1') then
		c_var := din_var(31) ;
		din_var := din_var(30 downto 0) & '0';
	end if;
	if(shift_val(1) = '1') then
		c_var := din_var(30) ;
		din_var := din_var(29 downto 0) & "00" ; 
	end if;
	if(shift_val(2) = '1') then
		c_var := din_var(28) ;
		din_var := din_var(27 downto 0) & x"0" ; --x"0" veut dire qu'on décale par 4 ->0b0000
	end if;
	if(shift_val(3) = '1') then
		c_var := din_var(24) ;
		din_var := din_var(23 downto 0) & x"00" ;
	end if;
	if(shift_val(4) = '1') then
		c_var := din_var(16) ;
		din_var := din_var(15 downto 0) & x"0000" ;
	end if;
	dout <= din_var ;
	cout <= c_var ;
	end process ;
end behav ;
