library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decod is
	port(
	-- Exec  operands
			dec_op1			: out Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: out Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest		: out Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: out Std_Logic; -- Rd destination write back
			dec_flag_wb		: out Std_Logic; -- CSPR modifiy

	-- Decod to mem via exec
			dec_mem_data	: out Std_Logic_Vector(31 downto 0); -- data to MEM
			dec_mem_dest	: out Std_Logic_Vector(3 downto 0);
			dec_pre_index 	: out Std_logic; --commanded de pre-index

			dec_mem_lw		: out Std_Logic; --load word
			dec_mem_lb		: out Std_Logic; --load byte
			dec_mem_sw		: out Std_Logic; --store word
			dec_mem_sb		: out Std_Logic; --store byte

	-- Shifter command
			dec_shift_lsl	: out Std_Logic;
			dec_shift_lsr	: out Std_Logic;
			dec_shift_asr	: out Std_Logic;
			dec_shift_ror	: out Std_Logic;
			dec_shift_rrx	: out Std_Logic;
			dec_shift_val	: out Std_Logic_Vector(4 downto 0);
			dec_cy			: out Std_Logic;

	-- Alu operand selection
			dec_comp_op1	: out Std_Logic;
			dec_comp_op2	: out Std_Logic;
			dec_alu_cy 		: out Std_Logic;

	-- Exec Synchro
			dec2exe_empty	: out Std_Logic;
			exe_pop			: in Std_logic; --pop dec2exe
	-- Alu command
			dec_alu_cmd		: out Std_Logic_Vector(1 downto 0);

	-- Alu command
		--	dec_alu_add		: out Std_Logic;
		--	dec_alu_and		: out Std_Logic;
		--	dec_alu_or		: out Std_Logic;
		--	dec_alu_xor		: out Std_Logic;

	-- Exe Write Back to reg
			exe_res			: in Std_Logic_Vector(31 downto 0);

			exe_c				: in Std_Logic;
			exe_v				: in Std_Logic;
			exe_n				: in Std_Logic;
			exe_z				: in Std_Logic;

			exe_dest			: in Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: in Std_Logic; -- Rd destination write back
			exe_flag_wb		: in Std_Logic; -- CSPR modifiy

	-- Ifetch interface
			dec_pc			: out Std_Logic_Vector(31 downto 0) ;
			if_ir				: in Std_Logic_Vector(31 downto 0) ;

	-- Ifetch synchro
			dec2if_empty	: out Std_Logic;
			if_pop			: in Std_Logic;

			if2dec_empty	: in Std_Logic;
			dec_pop			: out Std_Logic;

	-- Mem Write back to reg
			mem_res			: in Std_Logic_Vector(31 downto 0);
			mem_dest			: in Std_Logic_Vector(3 downto 0);
			mem_wb			: in Std_Logic;
			
	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
end Decod;

----------------------------------------------------------------------

architecture Behavior OF Decod is

component Reg
	port(
	-- Write Port 1 prioritaire
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1			: in Std_Logic_Vector(3 downto 0);
		wen1			: in Std_Logic;

	-- Write Port 2 non prioritaire
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2			: in Std_Logic_Vector(3 downto 0);
		wen2			: in Std_Logic;

	-- Write CSPR Port
		wcry			: in Std_Logic;
		wzero			: in Std_Logic;
		wneg			: in Std_Logic;
		wovr			: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits
		reg_rd1		: out Std_Logic_Vector(31 downto 0); --input plustot
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 5 bits (for shift)
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry			: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg			: out Std_Logic;
		reg_ovr			: out Std_Logic;
		
		reg_cznv		: out Std_Logic;
		reg_vv		: out Std_Logic;

	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck					: in Std_Logic;
		reset_n			: in Std_Logic;
		vdd				: in bit;
		vss				: in bit);
end component;

component fifo_32b
	--generic(WIDTH: positive); pas possible de synthétiser
	port(
		din		: in std_logic_vector(31 downto 0);
		dout		: out std_logic_vector(31 downto 0);

		-- commands
		push		: in std_logic;
		pop		: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic;
		vdd		: in bit;
		vss		: in bit
	);

end component;

component fifo_127b
	--generic(WIDTH: positive); pas possible de synthétiser
	port(
		din		: in std_logic_vector(126 downto 0);
		dout		: out std_logic_vector(126 downto 0);

		-- commands
		push		: in std_logic;
		pop		: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic;
		vdd		: in bit;
		vss		: in bit
	);

end component;

signal condv :std_logic; --condition valid
signal cond	: Std_Logic; --predicat
--signal cond_en	: Std_Logic;


signal regop_t  : Std_Logic; --traitement de données
signal mult_t   : Std_Logic; --multiplication (on le fera pas)
signal swap_t   : Std_Logic; --a<=b et b<=a en même temps
signal trans_t  : Std_Logic; --transfert
signal mtrans_t : Std_Logic; --transfert multiples
signal branch_t : Std_Logic; --branchement

-- regop instructions
signal and_i  : Std_Logic;
signal eor_i  : Std_Logic;
signal sub_i  : Std_Logic;
signal rsb_i  : Std_Logic;
signal add_i  : Std_Logic;
signal adc_i  : Std_Logic;
signal sbc_i  : Std_Logic;
signal rsc_i  : Std_Logic;
signal tst_i  : Std_Logic;
signal teq_i  : Std_Logic;
signal cmp_i  : Std_Logic;
signal cmn_i  : Std_Logic;
signal orr_i  : Std_Logic;
signal mov_i  : Std_Logic;
signal bic_i  : Std_Logic;
signal mvn_i  : Std_Logic;

-- mult instruction
--signal mul_i  : Std_Logic;
--signal mla_i  : Std_Logic;

-- trans instruction
--signal transfert_avec_immediat : std_logic;
signal ldrw_i  : Std_Logic; --load word
signal ldrb_i : Std_Logic; --load byte
signal strw_i  : Std_Logic; --store word
signal strb_i : Std_Logic; --store byte

-- mtrans instruction
signal ldm_i  : Std_Logic;
signal stm_i  : Std_Logic;

-- branch instruction
signal b_i    : Std_Logic;
signal bl_i   : Std_Logic;

-- Multiple transferts
--à inclure (on le fait pas pour le moment)

--Transitions pour notre machine à états
signal T1_FETCH : std_logic;
signal T2_FETCH : std_logic;

signal T1_RUN : std_logic;
signal T2_RUN : std_logic;
signal T3_RUN : std_logic;
signal T4_RUN : std_logic;
signal T5_RUN : std_logic;
signal T6_RUN : std_logic;

signal T1_LINK : std_logic;

signal T1_BRANCH : std_logic;
signal T2_BRANCH : std_logic;
signal T3_BRANCH : std_logic;

signal T1_MTRANS : std_logic;
signal T2_MTRANS : std_logic;
signal T3_MTRANS : std_logic;


--Signal PC
signal reg_pc_sig : std_logic_vector(31 downto 0);
signal reg_pcv_sig : std_logic; --flag de validité
signal dec2if_push : std_logic;
signal inc_pc_sig : std_logic;

-- RF read ports
signal radr1_sig : std_logic_vector(3 downto 0);--adrese
signal radr2_sig : std_logic_vector(3 downto 0);
signal radr3_sig : std_logic_vector(3 downto 0);


signal reg_rd1_sig : std_logic_vector(31 downto 0);--data
signal reg_rd2_sig : std_logic_vector(31 downto 0);
signal reg_rd3_sig : std_logic_vector(31 downto 0);


signal rv1_sig : std_logic; --valid
signal rv2_sig : std_logic;
signal rv3_sig : std_logic;


signal reg_cznv_sig : std_logic;
signal reg_vv_sig : std_logic;

--Write ports
--signal wdata1_sig : std_logic_vector(31 downto 0); --write data
--signal wdata2_sig : std_logic_vector(31 downto 0);
--signal wen1_sig : std_logic;--write enable
--signal wen2_sig : std_logic;

--Invalid adr
signal inval_adr1_sig : std_logic_vector(3 downto 0);
signal inval1_sig : std_logic;
signal inval_adr2_sig : std_logic_vector(3 downto 0);
signal inval2_sig : std_logic;
signal inval_czn_sig : std_logic;
signal inval_ovr_sig : std_logic;

-- Exec  operands Signal
signal dec_op1_sig: std_logic_vector(31 downto 0);
signal dec_op2_sig: std_logic_vector(31 downto 0);
signal dec_exe_dest_sig: std_logic_vector(3 downto 0); --Rd
signal dec_exe_wb_sig: Std_Logic; -- Rd destination write back
signal dec_flag_wb_sig: Std_Logic; -- CSPR modifiy

-- Decod to mem via exec Signal
signal dec_mem_data_sig: std_logic_vector(31 downto 0); -- data to MEM
signal dec_mem_dest_sig: std_logic_vector(3 downto 0);
signal dec_pre_index_sig: Std_Logic; --commanded de pre-index



-- Alu operand selection Signal
signal dec_comp_op1_sig: Std_Logic;
signal dec_comp_op2_sig: Std_Logic;
signal dec_alu_cy_sig: Std_Logic;

-- Alu command Signal
signal dec_alu_cmd_sig: std_logic_vector(1 downto 0);

-- Flags
signal cry	: Std_Logic;
signal zero	: Std_Logic;
signal neg	: Std_Logic;
signal ovr	: Std_Logic;

--dec2exe ssig
signal dec2exe_empty_sig : std_logic; 
signal dec2exe_full_sig : std_logic;
signal dec2exe_push_sig : std_logic;
--dec2if sig
signal dec2if_empty_sig : std_logic; --interaction (fifo) avec IFC
signal dec2if_full_sig : std_logic;

--signaux pour les shifts
signal dec_shift_lsl_sig: std_logic;
signal dec_shift_lsr_sig: std_logic;
signal dec_shift_asr_sig: std_logic;
signal dec_shift_ror_sig: std_logic;
signal dec_shift_rrx_sig: std_logic;
signal dec_shift_val_sig: std_logic_vector(4 downto 0);
signal dec_cy_sig: std_logic;

--signaux des loads
signal	dec_mem_lw_sig	:  Std_Logic; --load word
signal	dec_mem_lb_sig	:  Std_Logic; --load byte
signal	dec_mem_sw_sig	:  Std_Logic; --store word
signal	dec_mem_sb_sig	:  Std_Logic; --store byte

-- DECOD FSM - Machine à etats

type state_type is (FETCH, BRANCH, LINK, MTRANS, RUN);
signal etat_present, etat_futur : state_type;

begin

--ici on va connecter nos ports avec le composant Reg
banc_de_registre : Reg port map(
-- Write Port 1 prioritaire
		wdata1 => exe_res,
		wadr1 => exe_dest,
		wen1 => exe_wb,

	-- Write Port 2 non prioritaire
		wdata2 => mem_res,
		wadr2 => mem_dest,
		wen2 => mem_wb,

	-- Write CSPR Port
		wcry => exe_c,
		wzero => exe_z,
		wneg => exe_n,
		wovr => exe_v,
		cspr_wb => exe_flag_wb,
		
	-- Read Port 1 32 bits
		reg_rd1 => reg_rd1_sig,
		radr1 => radr1_sig,
		reg_v1 => rv1_sig,

	-- Read Port 2 32 bits
		reg_rd2 => reg_rd2_sig,
		radr2 => radr2_sig,
		reg_v2 => rv2_sig,

	-- Read Port 3 5 bits (for shift)
		reg_rd3 => reg_rd3_sig,
		radr3 => radr3_sig,
		reg_v3	=> rv3_sig,

	-- read CSPR Port
		reg_cry => cry,
		reg_zero => zero,
		reg_neg => neg, 
		reg_ovr => ovr,
		
		reg_cznv => reg_cznv_sig,
		reg_vv => reg_vv_sig,

	-- Invalidate Port 
		inval_adr1 => inval_adr1_sig,
		inval1 => inval1_sig,

		inval_adr2 => inval_adr2_sig,
		inval2 => inval2_sig,

		inval_czn => inval_czn_sig,
		inval_ovr => inval_ovr_sig,

	-- PC
		reg_pc => reg_pc_sig,
		reg_pcv => reg_pcv_sig,
		inc_pc => inc_pc_sig,
	
	-- global interface
		ck => ck,
		reset_n => reset_n,
		vdd => vdd,
		vss => vss);
		
--port map de fifo_32b
dec2if_fifo : fifo_32b port map(
		din => reg_pc_sig,
		dout => dec_pc,
		-- commands
		push => dec2if_push,
		pop => if_pop,
		-- flags
		full => dec2if_full_sig,
		empty => dec2if_empty_sig,
		
		reset_n => reset_n,
		ck => ck,
		vdd => vdd,
		vss => vss );

--port map de fifo_127b
dec2exe : fifo_127b port map(
	-- Exec  operands Signal
		din(126 downto 95)			=> dec_op1_sig,
		din(94 downto 63)			=> dec_op2_sig,
		din(62 downto 59)		=> dec_exe_dest_sig, --Rd
		din(58)		=> dec_exe_wb_sig , -- Rd destination write back
		din(57)		=> dec_flag_wb_sig , -- CSPR modifiy

	-- Decod to mem via exec Signal
		din(56 downto 25)	=> dec_mem_data_sig, -- data to MEM
		din(24 downto 21)	=> dec_mem_dest_sig,
		din(20) 	=> dec_pre_index_sig, --commanded de pre-index

		din(19)		=> dec_mem_lw_sig, --load word
		din(18)		=> dec_mem_lb_sig, --load byte
		din(17)		=> dec_mem_sw_sig, --store word
		din(16)		=> dec_mem_sb_sig, --store byte

	-- Shifter command Signal
		din(15)	=> dec_shift_lsl_sig,
		din(14)	=> dec_shift_lsr_sig,
		din(13)	=> dec_shift_asr_sig,
		din(12)	=> dec_shift_ror_sig,
		din(11)	=> dec_shift_rrx_sig,
		din(10 downto 6)	=> dec_shift_val_sig,
		din(5)			=> dec_cy_sig,

	-- Alu operand selection Signal
		din(4)	=> dec_comp_op1_sig,
		din(3)	=> dec_comp_op2_sig,
		din(2) 		=> dec_alu_cy_sig,

	-- Alu command Signal
		din(1 downto 0)		=> dec_alu_cmd_sig,		
	
	-- Exec  operands
		dout(126 downto 95)			=> dec_op1,
		dout(94 downto 63)			=> dec_op2,
		dout(62 downto 59)		=> dec_exe_dest, --Rd
		dout(58)		=> dec_exe_wb , -- Rd destination write back
		dout(57)		=> dec_flag_wb , -- CSPR modifiy

	-- Decod to mem via exec
		dout(56 downto 25)	=> dec_mem_data, -- data to MEM
		dout(24 downto 21)	=> dec_mem_dest,
		dout(20) 	=> dec_pre_index, --commanded de pre-index

		dout(19)		=> dec_mem_lw, --load word
		dout(18)		=> dec_mem_lb, --load byte
		dout(17)		=> dec_mem_sw, --store word
		dout(16)		=> dec_mem_sb, --store byte

	-- Shifter command
		dout(15)	=> dec_shift_lsl,
		dout(14)	=> dec_shift_lsr,
		dout(13)	=> dec_shift_asr,
		dout(12)	=> dec_shift_ror,
		dout(11)	=> dec_shift_rrx,
		dout(10 downto 6)	=> dec_shift_val,
		dout(5)			=> dec_cy,

	-- Alu operand selection
		dout(4)	=> dec_comp_op1,
		dout(3)	=> dec_comp_op2,
		dout(2) 		=> dec_alu_cy,

	-- Alu command
		dout(1 downto 0)		=> dec_alu_cmd,	
	
		-- commands
		push 	=>	dec2exe_push_sig ,
		pop		=> exe_pop ,	

		-- flags
		full 	=> dec2exe_full_sig ,
		empty 	=> dec2exe_empty_sig ,

		reset_n	=> reset_n ,
		ck		=> ck ,
		vdd		=> vdd ,
		vss		=> vss	
	);


-- Execution condition


cond <= '1' when (if_ir(31 downto 28) = X"0" and zero = '1') or --Suffix : EQ (equal)
				 (if_ir(31 downto 28) = X"1" and zero = '0') or --NE (not equal)
				 (if_ir(31 downto 28) = X"2" and cry = '1') or --CS (unsigned higher or same)
				 (if_ir(31 downto 28) = X"3" and cry = '0') or --CC (unsigned lower)
				 (if_ir(31 downto 28) = X"4" and neg = '1') or --MI negative
				 (if_ir(31 downto 28) = X"5" and neg = '0') or --PL (positive or zero)
				 (if_ir(31 downto 28) = X"6" and ovr = '1') or --VS (overflow)
				 (if_ir(31 downto 28) = X"7" and ovr = '0') or --VC (no overflow)
				 (if_ir(31 downto 28) = X"8" and cry = '1' and zero = '0') or --HI (unsigned higher)
				 (if_ir(31 downto 28) = X"9" and cry = '0' and zero = '1') or --LS (unsigned lower or same)
				 (if_ir(31 downto 28) = X"A" and (neg xor ovr)='0') or --GE (greater or equal)
				 (if_ir(31 downto 28) = X"B" or (neg xor ovr)='1') or--LT (less than)
				 (if_ir(31 downto 28) = X"C" and zero = '0') or --GT (greater than)
				 (if_ir(31 downto 28) = X"D" and zero = '1') or --LE (less than or equal)
				 (if_ir(31 downto 28) = X"E") else '0'; --AL (ignored)(always)
			 
condv <= '1' when if_ir(31 downto 28) = X"E" else (reg_cznv_sig and reg_vv_sig) ;		


-- decod instruction type

	regop_t <= '1' when if_ir(27 downto 26) = "00" else '0';
	trans_t <= '1' when if_ir(27 downto 26) = "01" else '0';
	mtrans_t <= '1' when if_ir(27 downto 25) = "100" else '0';
	branch_t <= '1' when if_ir(27 downto 25) = "101" else '0';
	--mult_t <= '1' when if_ir(27 downto 22) = "000000" else '0'; on ne fera pas multiplications

	-- decod regop opcode (on fera que les 8 premiers)

	and_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"0" else '0';
	eor_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"1" else '0';
	sub_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"2" else '0';
	rsb_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"3" else '0';
	add_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"4" else '0';
	adc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"5" else '0';
	sbc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"6" else '0';
	rsc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"7" else '0';
	tst_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"8" else '0';
	teq_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"9" else '0';
	cmp_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"A" else '0';
	cmn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"B" else '0';
	orr_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"C" else '0';
	mov_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"D" else '0';
	bic_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"E" else '0';
	mvn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"F" else '0';
	--pour un branchement, on a regop_t = 0 et branch_t = '1'
	--nous allons donc devoir faire une somme : PC+4*OFFSET dans ALU
	--add_i <= add_i or branch_t; --activer add_i si branch_t = 1

--decoder les loads et store ici
ldrw_i <= '1' when (trans_t = '1' and if_ir(20) = '1' and if_ir(22) = '0') else '0'; --load word
ldrb_i 	<= '1' when (trans_t ='1' and if_ir(20) = '1' and if_ir(22) = '1') else '0'; --load byte

strw_i <= '1' when (trans_t = '1' and if_ir(20) = '0' and if_ir(22) = '0') else '0'; --store word
strb_i <= '1' when (trans_t = '1' and if_ir(20) = '0' and if_ir(22) = '1') else '0'; --store byte

dec_mem_lw_sig 	<= ldrw_i; --load word instruction
dec_mem_lb_sig	<= ldrb_i; --load byte instruction
dec_mem_sw_sig	<=	strw_i; --store word instruction
dec_mem_sb_sig	<=	strb_i; --store byte instruction

--branchement avec et sans link à écrire ici
--decoder instr branchement ici
bl_i <= '1' when (branch_t = '1' and if_ir(24) = '1') else '0'; --Br avec link
bl_i <= '1' when (branch_t = '1' and if_ir(24) = '0') else '0'; --Br normal(sans link)




--Gestion des transitions de la MAE

T1_FETCH <= not(dec2if_empty_sig) and if2dec_empty ; --chargement d'instructions, quand la fifo_dec2if n'est pas videe et que if2dec est vide (l'étage est dispo)
T2_FETCH <= dec2if_empty_sig ; 
T1_RUN <=( if2dec_empty or dec2exe_full_sig or (not(condv)) );
T2_RUN <= (not(T1_RUN)) and (not(cond)); -- predicat FAUX
T3_RUN <= not(T2_RUN); --predicat VRAI

	
 --gestion MAE  
          
--MAE : process(ck)
--begin
--	if (rising_edge(ck)) or then
--			case etat_futur is
--				
--			when FETCH => etat_futur <= FETCH;
--				if T1_FETCH = '1' then etat_futur <= FETCH;
--			    elsif T2_FETCH = '1' then etat_futur <= RUN;
--				end if;
				
--			when RUN => etat_futur <= RUN; 
--				if ((T1_RUN or T2_RUN or T3_RUN) = '1') then etat_futur <= RUN;
--			    elsif T4_RUN = '1' then etat_futur <= LINK;
--			    elsif T5_RUN = '1' then etat_futur <= BRANCH;
--			    elsif T6_RUN = '1' then etat_futur <= MTRANS;
--				end if;
				
--			when LINK => etat_futur <= LINK;
--			    if T1_LINK = '1' then etat_futur <= BRANCH;
--				end if;
				
--			when BRANCH => etat_futur <= BRANCH;
--				if T1_BRANCH = '1' then etat_futur <= BRANCH;
--			    elsif T2_BRANCH = '1' then etat_futur <= RUN;
--			    elsif T3_BRANCH = '1' then etat_futur <= FETCH;
--				end if;
				
--			when MTRANS => etat_futur <= MTRANS;
--				if T1_MTRANS = '1'then etat_futur <= MTRANS;
--			    elsif T2_MTRANS = '1' then etat_futur <= RUN;
--			    elsif T3_MTRANS = '1' then etat_futur <= BRANCH;
--				end if;
				
--			When others => etat_futur <= FETCH; --(début)
--		end case;
--	end if;
--end process;

--tester en comportemental parceque avec process on perd 1 cycle d'horloge
	etat_futur <=   FETCH   when (etat_present = FETCH and T1_FETCH = '1') 
							or 	 (etat_present = BRANCH and T3_BRANCH = '1')
				else
					RUN     when (etat_present = FETCH and T2_FETCH = '1')
							or   (etat_present = RUN and (T1_RUN or T2_RUN or T3_RUN) = '1') 
							or 	 (etat_present = MTRANS and T2_MTRANS = '1') 
							or   (etat_present = BRANCH and T2_BRANCH = '1')
				else
					LINK    when (etat_present = RUN and T4_RUN = '1') 
				
				else
					BRANCH  when (etat_present = RUN and T5_RUN = '1')
							or   (etat_present = BRANCH and T1_BRANCH = '1')   
							or   (etat_present = LINK and T1_LINK = '1')

				else
					MTRANS  when (etat_present = RUN and T6_RUN = '1') 
							or (etat_present = MTRANS and T1_MTRANS = '1') 
				else
							FETCH; --si on n'est pas dans aucun cas


--mis à jour de l'état présent. c'est sur état present qu'on va tester pour faire les taches
State_Machine : process(ck)
begin
	if (rising_edge(ck)) then
		if(reset_n = '0') then 
			etat_present <= FETCH ;
		else
			etat_present <= etat_futur;
		end if;
	end if;
end process;


-----------------------------------separation-------------------------------------------------------------------

--initialisation des signaux en fonction du reset


			dec_shift_lsl_sig <= '0' when (reset_n = '0') else dec_shift_lsl_sig;
			dec_shift_lsr_sig <= '0' when (reset_n = '0') else dec_shift_lsr_sig;
			dec_shift_asr_sig <= '0' when (reset_n = '0') else dec_shift_asr_sig;
			dec_shift_ror_sig <= '0' when (reset_n = '0') else dec_shift_ror_sig;
			dec_shift_rrx_sig <= '0' when (reset_n = '0') else dec_shift_rrx_sig;
			dec_shift_val_sig <= "00000" when (reset_n = '0') else dec_shift_val_sig;

			--dec_shift_lsl <= dec_shift_lsl_sig;
			--dec_shift_lsr <= dec_shift_lsr_sig;
			--dec_shift_asr <= dec_shift_asr_sig;
			--dec_shift_ror <= dec_shift_ror_sig;
			--dec_shift_rrx <= dec_shift_rrx_sig;
			--dec_shift_val <= dec_shift_val_sig;





--gestion de dec_alu_cmd : 00->addition(Sum), 01->AND, 10->OR  et 11->XOR

--commande_alu : process(ck)
--begin
--					if ((sub_i or rsb_i or add_i or adc_i or sbc_i or rsc_i or cmp_i or cmn_i or mov_i or mvn_i) = '1') --then
--						dec_alu_cmd_sig <= "00";
--					elsif ((and_i or tst_i or bic_i) = '1') then
--						dec_alu_cmd_sig <= "01";
--					elsif ((orr_i = '1')) then
--						dec_alu_cmd_sig <= "10";
--					elsif ((eor_i or teq_i) = '1') then
--						dec_alu_cmd_sig <= "11";
--					end if;

--end process;



dec_alu_cmd_sig <= "00" when (sub_i or rsb_i or add_i or adc_i or sbc_i or rsc_i or cmp_i or cmn_i or mov_i or mvn_i or trans_t) = '1'
			else "01" when (and_i or tst_i or bic_i) = '1'
			else "10" when (orr_i = '1')
			else "11" when (eor_i or teq_i) = '1';

--dec_alu_cmd_sig <= "01" when (and_i or tst_i or bic_i) = '1';

--dec_alu_cmd_sig <= "10" when (orr_i = '1');

--dec_alu_cmd_sig <= "11" when (eor_i or teq_i) = '1';

--gestion des compléments et de carry

dec_comp_op1_sig <= '1' when (rsb_i or rsc_i) = '1' else '0';

dec_comp_op2_sig <= '1' when (sub_i or sbc_i or cmp_i or bic_i or mvn_i) = '1' else '0' ; 

dec_cy_sig <= '1' when (rsb_i or rsc_i or sub_i or sbc_i or cmp_i or bic_i ) = '1' else '0'; --gestion carry instr et shift

dec_alu_cy_sig <= '1' when (sub_i or rsb_i or sbc_i or rsc_i or cmp_i) = '1' else '0' ;

--gestion de l'incrémentation de pc 
inc_pc_sig <=  '0' when etat_present = BRANCH else dec2if_push; --dans le cas d'un branchement

-----------------------------------------------
--gestion de la fifo
--dec2if_push <= '0' when dec2if_full_sig = '1' else reg_pcv_sig;
--dec2exe_empty <= '1' when etat_present = RUN else '0';

dec_pop <= '0' when ((etat_present = RUN) and T1_RUN='1' and if2dec_empty='1') 
			 else '1' when ((etat_present = RUN) and ((T3_RUN or T2_RUN)='1') and T1_RUN='0' );
dec2exe_empty <= dec2exe_empty_sig;
dec2if_empty <= dec2if_empty_sig;

dec2if_push	<= '1'	when (etat_present = FETCH and T2_FETCH = '1') or 
						(etat_present = RUN and (T1_RUN or T2_RUN or T3_RUN)='1' and dec2if_empty_sig='1')
					else '0' when (etat_present = FETCH and T1_FETCH = '1') or 
						(etat_present = RUN and (T1_RUN or T2_RUN or T3_RUN)='1' and (dec2if_empty_sig)='0');

dec2exe_push_sig <= '0' when (etat_present = FETCH and T1_FETCH = '1' ) or
						(etat_present = RUN and (T1_RUN or T2_RUN)='1' )
				else '1' when (etat_present = RUN and T3_RUN='1' );
--gestion de rn,rd(read ports), nous allons prendre l'exemple sans immédiat et juste pour un add dans un premier temps
radr1_sig <= if_ir(19 downto 16) ; --Rn
radr2_sig <= if_ir(3 downto 0);
radr3_sig <= if_ir(15 downto 12); --Rd

--gestion de ports d'écriture
dec_op1_sig <= reg_rd1_sig;

dec_op2_sig <= reg_rd2_sig when ((regop_t='1' and if_ir(25)='0')  or ( trans_t='1' and if_ir(25)='1')) --op2 est le contenu du Registre Rm
			else x"00000"&if_ir(11 downto 0) when ((regop_t='1' and if_ir(25)='1')  or ( trans_t='1' and if_ir(25)='0')); --op2 est l'immediat

dec_exe_dest_sig <= if_ir(15 downto 12);

--gestion des inval adr
inval_adr1_sig <= exe_dest; --n°Reg invalidation du 1er port d'ecriture
inval1_sig <= exe_wb; 
inval_adr2_sig <= mem_dest;
inval2_sig <= mem_wb;

--dec_flag_wb <= if_ir(20);

--------------------------separation-----------------------------------------------------------------------------
--signaux des pré-index dans le cas des loads et store
dec_pre_index_sig <= '0' when (regop_t = '1')
			else '1' when ( trans_t='1' and (if_ir(24)='1') );

----------------------------------------------
---- STORE : on a besoin de dec_mem_data => contenu de Rd, dec_op1 prend Rn et dec_op2 prend Rm (registre shift), deja fait pour regop_t
dec_mem_data_sig <= reg_rd3_sig when (strw_i='1' or strb_i='1') else dec_mem_data_sig ;

-- LOAD : on a besoin du n° de dec_mem_dest => n° de Rd, dec_op1 prend Rn et dec_op2 prend Rm (registre shift), deja fait pour regop_t
dec_mem_dest_sig <= if_ir(15 downto 12) when (ldrw_i='1' or ldrb_i = '1') else dec_mem_dest_sig;


inval_czn_sig <= if_ir(20);
inval_ovr_sig <= if_ir(20);

--gestion de dec_exe_wb et dec_flag_wb
dec_exe_wb_sig <= and_i or eor_i or sub_i or rsb_i or 
          		add_i or adc_i or sbc_i or rsc_i or 
				orr_i or mov_i or bic_i or mvn_i ;  
				
dec_flag_wb_sig <= regop_t and if_ir(20) ; -- maj des flags si c'est une operation sur registre ET S = 1 (bit n°20)

-- operations ou Rd est modifie

--gestion memoire à faire si on aura le temps

--gestion des transferts multiples : trop compliqué

--juste pour vérifier le fonctionnement :
--T2 = '1' not(if2dec_empty);


end Behavior;
