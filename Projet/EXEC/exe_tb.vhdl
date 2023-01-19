library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

--  A testbench has no ports.
entity exe_tb is
end exe_tb;

architecture behav of exe_tb is
--signaux à écrire ici

-- Decode interface synchro
			Signal dec2exe_empty	 :Std_logic;
			Signal exe_pop		 :Std_logic;

	-- Decode interface operands
			Signal dec_op1		 :Std_Logic_Vector(31 downto 0); -- first alu input
			Signal dec_op2		 :Std_Logic_Vector(31 downto 0); -- shifter input
			Signal dec_exe_dest	 :Std_Logic_Vector(3 downto 0); -- Rd destination
			Signal dec_exe_wb	 :Std_Logic; -- Rd destination write back
			Signal dec_flag_wb	 :Std_Logic; -- CSPR modifiy

	-- Decode to mem interface 
			Signal dec_mem_data	 :Std_Logic_Vector(31 downto 0); -- data to MEM W
			Signal dec_mem_dest	 :Std_Logic_Vector(3 downto 0); -- Destination MEM R
			Signal dec_pre_index 	 :Std_logic;

			Signal dec_mem_lw	 :Std_Logic;
			Signal dec_mem_lb	 :Std_Logic;
			Signal dec_mem_sw	 :Std_Logic;
			Signal dec_mem_sb	 :Std_Logic;

	-- Shifter command
			Signal dec_shift_lsl	 :Std_Logic;
			Signal dec_shift_lsr	 :Std_Logic;
			Signal dec_shift_asr	 :Std_Logic;
			Signal dec_shift_ror	 :Std_Logic;
			Signal dec_shift_rrx	 :Std_Logic;
			Signal dec_shift_val	 :Std_Logic_Vector(4 downto 0);
			Signal dec_cy		 :Std_Logic;

	-- Alu operand selection
			Signal dec_comp_op1	 :Std_Logic;
			Signal dec_comp_op2	 :Std_Logic;
			Signal dec_alu_cy 	 :Std_Logic;

	-- Alu command
			Signal dec_alu_cmd	 :Std_Logic_Vector(1 downto 0);

	-- Exe bypass to decod
			Signal exe_res		 :Std_Logic_Vector(31 downto 0);

			Signal exe_c		 :Std_Logic;
			Signal exe_v		 :Std_Logic;
			Signal exe_n		 :Std_Logic;
			Signal exe_z		 :Std_Logic;

			Signal exe_dest		 :Std_Logic_Vector(3 downto 0); -- Rd destination
			Signal exe_wb		 :Std_Logic; -- Rd destination write back
			Signal exe_flag_wb	 :Std_Logic; -- CSPR modifiy

	-- Mem interface
			Signal exe_mem_adr	 :Std_Logic_Vector(31 downto 0); -- Alu res register
			Signal exe_mem_data	 :Std_Logic_Vector(31 downto 0);
			Signal exe_mem_dest	 :Std_Logic_Vector(3 downto 0);

			Signal exe_mem_lw	 :Std_Logic;
			Signal exe_mem_lb	 :Std_Logic;
			Signal exe_mem_sw	 :Std_Logic;
			Signal exe_mem_sb	 :Std_Logic;

			Signal exe2mem_empty	 :Std_logic;
			Signal mem_pop		 :Std_logic;

	-- global interface
			Signal ck		 :Std_logic;
			Signal reset_n		 :Std_logic:='0';
			Signal vdd		 :bit:='1';
			Signal vss		 :bit:='0';



begin

EXEC: entity work.exe
port map(
-- Decode interface synchro
	dec2exe_empty => dec2exe_empty,
	exe_pop => exe_pop,

-- Decode interface operands
	dec_op1 => dec_op1,
	dec_op2 => dec_op2,
	dec_exe_dest => dec_exe_dest,
	dec_exe_wb => dec_exe_wb,
	dec_flag_wb => dec_flag_wb,

-- Decode to mem interface 
	dec_mem_data => dec_mem_data,
	dec_mem_dest => dec_mem_dest,
	dec_pre_index => dec_pre_index,

	dec_mem_lw => dec_mem_lw,
	dec_mem_lb => dec_mem_lb,
	dec_mem_sw => dec_mem_sw,
	dec_mem_sb => dec_mem_sb,

-- Shifter command
	dec_shift_lsl => dec_shift_lsl,
	dec_shift_lsr => dec_shift_lsr,
	dec_shift_asr => dec_shift_asr,
	dec_shift_ror => dec_shift_ror,
	dec_shift_rrx => dec_shift_rrx,
	dec_shift_val => dec_shift_val,
	dec_cy => dec_cy,

-- Alu operand selection
	dec_comp_op1 => dec_comp_op1,
	dec_comp_op2 => dec_comp_op2,
	dec_alu_cy => dec_alu_cy,

-- Alu command
	dec_alu_cmd => dec_alu_cmd,

-- Exe bypass to decod
	exe_res => exe_res,
	exe_c => exe_c,
	exe_v => exe_v,
	exe_n => exe_n,
	exe_z => exe_z,

	exe_dest => exe_dest,
	exe_wb => exe_wb,
	exe_flag_wb => exe_flag_wb,

-- Mem interface
	exe_mem_adr => exe_mem_adr,
	exe_mem_data => exe_mem_data,
	exe_mem_dest => exe_mem_dest,

	exe_mem_lw => exe_mem_lw,
	exe_mem_lb => exe_mem_lb,	
	exe_mem_sw => exe_mem_sw,	
	exe_mem_sb => exe_mem_sb,

	exe2mem_empty => exe2mem_empty,	 
	mem_pop => mem_pop,		 

-- global interface
	ck => ck,
	reset_n => reset_n,
	vdd => vdd,
	vss => vss);


reset_n <= '1' after 2 us;

dec_alu_cmd<="00" after 10 ns;
dec_op1<= x"10007001" after 40 ns;
dec_op2<=x"00001210" after 40 ns;


dec_comp_op1<='0' after 30 ns;
dec_comp_op2<='0'after 30 ns;
dec_alu_cy<='0' after 10 ns;

dec_shift_lsl<= '1' after 10 ns, '0' after 50 ns;
dec_shift_lsr<= '0' after 10 ns;
dec_shift_asr<= '0' after 10 ns;
dec_shift_ror<= '0' after 10 ns;
dec_shift_rrx<= '0' after 10 ns;
dec_shift_val<= "00000" after 10 ns;
dec_cy<='0' after 10 ns;

dec_mem_data<=x"00000000" after 10 ns;
dec_mem_dest<="0000" after 10 ns;
dec_pre_index<= '0' after 10 ns;

dec2exe_empty<='1';

dec_exe_dest<=x"0" after 10 ns;
dec_exe_wb<='1' after 10 ns;
dec_flag_wb<='1' after 10 ns;

dec_mem_lw<='0'after 10 ns;
dec_mem_lb<='0'after 10 ns;
dec_mem_sw<='0'after 10 ns;
dec_mem_sb<='0' after 10 ns;

mem_pop<='0' after 10 ns;


proc : process
begin
boucle : for cpt IN 1 TO 100 loop
	ck <= '0';
	wait for 10 ns;
	ck <= '1';
	wait for 10 ns;
END loop;


wait; --on met le wait juste avant end process proc
end process proc;

end behav;
