--nous allons écrire notre arithmetic shift right (sans utiliser de librarie shift)
--on utilisera le même composant pour arithmetic shift left.

library ieee;
use ieee.std_logic_1164.all;


entity asr is  --arithmetic shift right
	port(din : in std_logic_vector(31 downto 0) ;
	shift_val : in std_logic_vector(4 downto 0);
	dout : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	vdd		: in bit;
    vss		: in bit 
    	);
end asr;


architecture behav of asr is
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
		c_var := din_var(0) ;
		din_var := din(31) & din_var(31 downto 1) ;
	end if;
	if(shift_val(1) = '1') then
		c_var := din_var(1) ;
		din_var :=  din(31) & din(31) & din_var(31 downto 2) ; 
	end if;
	if(shift_val(2) = '1') then
		c_var := din_var(3) ;
		din_var := din(31) & din(31) & din(31) & din(31) & din_var(31 downto 4)  ; --x"0" veut dire qu'on décale par 4 ->0b0000
	end if;
	if(shift_val(3) = '1') then
		c_var := din_var(7) ;
		din_var := din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din_var(31 downto 8)   ;
	end if;
	if(shift_val(4) = '1') then
		c_var := din_var(15) ;
		din_var := din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din(31) & din_var(31 downto 16);
	end if;
	dout <= din_var ;
	cout <= c_var ;
	end process ;
end behav ;
