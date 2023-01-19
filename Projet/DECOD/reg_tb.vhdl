library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

--  A testbench has no ports.
entity reg_tb is
end reg_tb;

architecture behav of reg_tb is
--signaux à écrire ici
	-- Write Port 1 prioritaire
		Signal wdata1		:  Std_Logic_Vector(31 downto 0);
		Signal wadr1		:  Std_Logic_Vector(3 downto 0);
		Signal wen1		:  Std_Logic;

	-- Write Port 2 non prioritaire
		Signal wdata2		:  Std_Logic_Vector(31 downto 0);
		Signal wadr2		:  Std_Logic_Vector(3 downto 0);
		Signal wen2		:  Std_Logic;

	-- Write CSPR Port
		Signal wcry		:  Std_Logic;
		Signal wzero		:  Std_Logic;
		Signal wneg		:  Std_Logic;
		Signal wovr		:  Std_Logic;
		Signal cspr_wb		:  Std_Logic;
		
	-- Read Port 1 32 bits
		Signal reg_rd1		:  Std_Logic_Vector(31 downto 0);
		Signal radr1		:  Std_Logic_Vector(3 downto 0);
		Signal reg_v1		:  Std_Logic;

	-- Read Port 2 32 bits
		Signal reg_rd2		:  Std_Logic_Vector(31 downto 0);
		Signal radr2		:  Std_Logic_Vector(3 downto 0);
		Signal reg_v2		:  Std_Logic;

	-- Read Port 3 32 bits
		Signal reg_rd3		:  Std_Logic_Vector(31 downto 0);
		Signal radr3		:  Std_Logic_Vector(3 downto 0);
		Signal reg_v3		:  Std_Logic;

	-- read CSPR Port
		Signal reg_cry		:  Std_Logic;
		Signal reg_zero		:  Std_Logic;
		Signal reg_neg		:  Std_Logic;
		Signal reg_cznv		:  Std_Logic;
		Signal reg_ovr		:  Std_Logic;
		Signal reg_vv		:  Std_Logic;
		
	-- Invalidate Port 
		Signal inval_adr1	:  Std_Logic_Vector(3 downto 0);
		Signal inval1		:  Std_Logic;

		Signal inval_adr2	:  Std_Logic_Vector(3 downto 0);
		Signal inval2		:  Std_Logic;

		Signal inval_czn	:  Std_Logic;
		Signal inval_ovr	:  Std_Logic;

	-- PC
		Signal reg_pc		:  Std_Logic_Vector(31 downto 0);
		Signal reg_pcv		:  Std_Logic; --bit de validité du registre PC
		Signal inc_pc		:  Std_Logic; --si c'est valid inc_pc vaut 1 et on fait +4


	-- global interface
		Signal ck		 :Std_logic;
		Signal reset_n		 :Std_logic;
		Signal vdd		 :bit:='1';
		Signal vss		 :bit:='0';


begin

REG: entity work.reg
port map(
	-- Write Port 1 prioritaire
		 wdata1 => wdata1,
		 wadr1 => wadr1,
		 wen1 => wen1,

	-- Write Port 2 non prioritaire
		 wdata2 => wdata2,
		 wadr2 => wadr2,
		 wen2 => wen2,

	-- Write CSPR Port
		 wcry => wcry,
		 wzero => wzero,
		 wneg => wneg,
		 wovr => wovr,
		 cspr_wb => cspr_wb,
		
	-- Read Port 1 32 bits
		 reg_rd1 => reg_rd1,
		 radr1 => radr1,
		 reg_v1 => reg_v1,

	-- Read Port 2 32 bits
		 reg_rd2 => reg_rd2,
		 radr2 => radr2,
		 reg_v2 => reg_v2,

	-- Read Port 3 32 bits
		 reg_rd3 => reg_rd3,
		 radr3 => radr3,
		 reg_v3 => reg_v3,

	-- read CSPR Port
		 reg_cry => reg_cry,
		 reg_zero => reg_zero,
		 reg_neg => reg_neg,
		 reg_cznv => reg_cznv,
		 reg_ovr => reg_ovr,
		 reg_vv => reg_vv,
		
	-- Invalidate Port 
		 inval_adr1 => inval_adr1,
		 inval1 => inval1,

		 inval_adr2 => inval_adr2,
		 inval2 => inval2,

		 inval_czn => inval_czn,
		 inval_ovr => inval_ovr,

	-- PC
		 reg_pc => reg_pc,
		 reg_pcv => reg_pcv, --bit de validité du registre PC
		 inc_pc => inc_pc, --si c'est valid inc_pc vaut 1 et on fait +4


	-- global interface
		 ck => ck,
		 reset_n => reset_n,
		 vdd => vdd,
		 vss => vss);


reset_n <= '1' after 10 ns , '0' after 20 ns, '1' after 30 ns ;

--testbench 1: incrementation de pc
--inval1 <= '0' after 12 ns;
--inval_adr1 <= x"F" after 12 ns;
--inc_pc <= '1' after 36 ns, '0' after 93 ns;

--testbench 2: incrementationn de pc puis branchement puis incrementation de pc 
inval1 <= '0' after 20 ns, '1' after 50 ns, '0' after 60 ns;
inval_adr1 <= x"F" after 12 ns;
inc_pc <= '1' after 36 ns, '0' after 45 ns, '1' after 53 ns;

wdata1<=x"0000001C" after 12 ns; --x"00000012" after 42 ns ;
wen1<='1' after 20 ns;-- '0' after 38 ns, '1' after 60 ns;
wadr1<=x"F" after 12 ns;
cspr_wb <='1' after 12 ns;

--testbench 3: lecture de R5 avec radr1 (sur le port de lecture 1)
--radr1 <= x"5" after 12 ns;

--testbench 4: tester la priorite de wdata1 sur wdata2
--inval1 <= '0' after 20 ns, '1' after 50 ns;
--inval_adr1 <= x"7" after 12 ns;

--wdata1<=x"0000000B" after 12 ns; --x"00000012" after 42 ns ;
--wen1<='1' after 20 ns;-- '0' after 38 ns, '1' after 60 ns;
--wadr1<=x"7" after 12 ns;

--cspr_wb <='1' after 12 ns;

--wdata2<=x"0000000C" after 12 ns; --x"00000012" after 42 ns ;
--wen2<='1' after 20 ns;-- '0' after 38 ns, '1' after 60 ns;
--wadr2<=x"7" after 12 ns;

--radr1 <= x"7" after 12 ns;

proc : process
begin
boucle : for cpt IN 1 TO 100 loop
	ck <= '0';
	wait for 2 ns;
	ck <= '1';
	wait for 2 ns;
END loop;


wait; --on met le wait juste avant end process proc
end process proc;

end behav;
