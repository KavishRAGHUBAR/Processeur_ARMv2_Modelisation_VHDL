------------------------------------------
--- tp 5
--- shift

--améliorations : conversion en int en 1 endroit qu'on affecte à une variable
--		: eviter d'utiliser des fonctions et generer nos composants pour shift left et right

library IEEE;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;


entity shifter IS
port (	
	shift_lsl : in Std_Logic;
	shift_lsr : in Std_Logic;
	shift_asr : in Std_Logic; 
	shift_ror : in Std_Logic; --le bit n-2 d'un decalage (a droite) par n va dans carryout. les bits (n-2 à 0) du LSB de din part dans les bits du 						MSB (31 à 31 -n) de dout
	shift_rrx : in Std_Logic; --cin,cout,decalage par 1 bit
	shift_val : in Std_Logic_Vector(4 downto 0);
	din : in Std_Logic_Vector(31 downto 0);
	cin : in Std_Logic;
	dout : out Std_Logic_Vector(31 downto 0);
	cout : out Std_Logic;
	-- global interface
	vdd : in bit;
	vss : in bit);
end shifter;

architecture archi of shifter IS

component lsl 
	port(din : in std_logic_vector(31 downto 0) ;
	shift_val : in std_logic_vector(4 downto 0);
	dout : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	vdd		: in bit;
    	vss		: in bit 
    	);
end component;

component lsr 
	port(din : in std_logic_vector(31 downto 0) ;
	shift_val : in std_logic_vector(4 downto 0);
	dout : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	vdd		: in bit;
    vss		: in bit 
    	);
end component;

component asr 
	port(din : in std_logic_vector(31 downto 0) ;
	shift_val : in std_logic_vector(4 downto 0);
	dout : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	vdd		: in bit;
    	vss		: in bit 
    	);
end component;

signal out_lsl, out_lsr, out_asr: std_logic_vector(31 downto 0);
signal coutlsl, coutlsr, coutasr : std_logic ;



	begin
	
	lsl_inst : lsl
		port map(din=>din, dout=>out_lsl, cout=>coutlsl, vss=>vss, vdd=>vdd, shift_val=>shift_val);

	lsr_inst :lsr
		port map(din=>din, dout=>out_lsr, cout=>coutlsr, vss=>vss, vdd=>vdd, shift_val=>shift_val);

	asr_inst :asr
		port map(din=>din, dout=>out_asr, cout=>coutasr, vss=>vss, vdd=>vdd, shift_val=>shift_val);
	
	process (din,shift_val,shift_lsl,shift_lsr,shift_asr,shift_ror,shift_rrx)
		variable dout_var : std_logic_vector(31 downto 0);
		variable c_var : std_logic ;

		begin
		dout_var := din;
		c_var := '0';

		if (shift_lsl = '1') then
			dout_var := out_lsl;
			c_var := coutlsl;
		

		elsif (shift_lsr = '1') then
			dout_var := out_lsr;
			c_var := coutlsr;		
		

		elsif (shift_asr = '1') then
			dout_var := out_asr;
			c_var := coutasr;		
		

		elsif (shift_rrx= '1') then
			c_var := din(0);
			dout_var(31) := cin ;
			dout_var(30 downto 0) := din(31 downto 1);
		

		elsif (shift_ror = '1') then
			c_var := din(to_integer(unsigned(shift_val))-1);
			dout_var := din(to_integer(unsigned(shift_val))-1 downto 0)& din(31 downto to_integer(unsigned(shift_val)));

		end if;
		cout <= c_var;
		dout <= dout_var;
	end process;

end archi;

