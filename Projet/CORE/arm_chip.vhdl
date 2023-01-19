library ieee;
use ieee.std_logic_1164.all;

entity arm_chip is
	port(
	-- Icache interface
			if_adr			: out Std_Logic_Vector(31 downto 0);
			if_adr_valid	: out Std_Logic;

			ic_inst			: in Std_Logic_Vector(31 downto 0);
			ic_stall			: in Std_Logic;

	-- Dcache interface
			mem_adr			: out Std_Logic_Vector(31 downto 0);
			mem_stw			: out Std_Logic;
			mem_stb			: out Std_Logic;
			mem_load			: out Std_Logic;

			mem_data			: out Std_Logic_Vector(31 downto 0);
			dc_data			: in Std_Logic_Vector(31 downto 0);
			dc_stall			: in Std_Logic;


	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vddi				: in bit;
			vssi				: in bit;
			vdde				: in bit;
			vsse				: in bit);
end arm_chip;


architecture struct OF arm_chip is

Component arm_core
	port(
	-- Icache interface
			if_adr			: out Std_Logic_Vector(31 downto 0);
			if_adr_valid	: out Std_Logic;

			ic_inst			: in Std_Logic_Vector(31 downto 0);
			ic_stall			: in Std_Logic;

	-- Dcache interface
			mem_adr			: out Std_Logic_Vector(31 downto 0);
			mem_stw			: out Std_Logic;
			mem_stb			: out Std_Logic;
			mem_load			: out Std_Logic;

			mem_data			: out Std_Logic_Vector(31 downto 0);
			dc_data			: in Std_Logic_Vector(31 downto 0);
			dc_stall			: in Std_Logic;


	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
end Component;

Component pi_px
port (
  pad : in Std_Logic;	-- pad
  t : out Std_Logic;	-- t
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component po_px
port (
  i : in Std_Logic;	-- i
  pad : out Std_Logic;	-- pad
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component pck_px
port (
  pad : in Std_Logic;	-- pad
  ck : out Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component pvddeck_px
port (
  cko : out Std_Logic ;	-- cko
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component pvsseck_px
port (
  cko : out Std_Logic ;	-- cko
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component pvddick_px
port (
  cko : out Std_Logic ;	-- cko
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

Component pvssick_px
port (
  cko : out Std_Logic ;	-- cko
  ck : in Std_Logic;	-- ck
  vdde : in BIT;	-- vdde
  vddi : in BIT;	-- vddi
  vsse : in BIT;	-- vsse
  vssi : in BIT	-- vssi
  );
end Component;

--signal if2dec_full	: std_logic;

	signal core_if_adr			: Std_Logic_Vector(31 downto 0);
	signal core_if_adr_valid	: Std_Logic;
	signal pad_ic_inst			: Std_Logic_Vector(31 downto 0);
	signal pad_ic_stall			: Std_Logic;
	signal core_mem_adr			: Std_Logic_Vector(31 downto 0);
	signal core_mem_stw			: Std_Logic;
	signal core_mem_stb			: Std_Logic;
	signal core_mem_load			: Std_Logic;
	signal core_mem_data			: Std_Logic_Vector(31 downto 0);
	signal pad_dc_data			: Std_Logic_Vector(31 downto 0);
	signal pad_dc_stall			: Std_Logic;
	signal pad_ck					: Std_Logic;
	signal pad_reset_n			: Std_Logic;

	signal ck_ring					: Std_Logic;

begin
	arm_core_i : arm_core
	port map (
			if_adr			=> core_if_adr,
			if_adr_valid	=> core_if_adr_valid,
			ic_inst			=> pad_ic_inst,
			ic_stall			=> pad_ic_stall,
			mem_adr			=> core_mem_adr,
			mem_stw			=> core_mem_stw,
			mem_stb			=> core_mem_stb,
			mem_load			=> core_mem_load,
			mem_data			=> core_mem_data,
			dc_data			=> pad_dc_data,
			dc_stall			=> pad_dc_stall,
			ck					=> pad_ck,
			reset_n			=> pad_reset_n,
			vdd				=> vddi,
			vss				=> vssi);

	if_adr_0  : po_px port map (i => core_if_adr(0 ), pad => if_adr(0 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_1  : po_px port map (i => core_if_adr(1 ), pad => if_adr(1 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_2  : po_px port map (i => core_if_adr(2 ), pad => if_adr(2 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_3  : po_px port map (i => core_if_adr(3 ), pad => if_adr(3 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_4  : po_px port map (i => core_if_adr(4 ), pad => if_adr(4 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_5  : po_px port map (i => core_if_adr(5 ), pad => if_adr(5 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_6  : po_px port map (i => core_if_adr(6 ), pad => if_adr(6 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_7  : po_px port map (i => core_if_adr(7 ), pad => if_adr(7 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_8  : po_px port map (i => core_if_adr(8 ), pad => if_adr(8 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_9  : po_px port map (i => core_if_adr(9 ), pad => if_adr(9 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_10 : po_px port map (i => core_if_adr(10), pad => if_adr(10), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_11 : po_px port map (i => core_if_adr(11), pad => if_adr(11), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_12 : po_px port map (i => core_if_adr(12), pad => if_adr(12), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_13 : po_px port map (i => core_if_adr(13), pad => if_adr(13), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_14 : po_px port map (i => core_if_adr(14), pad => if_adr(14), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_15 : po_px port map (i => core_if_adr(15), pad => if_adr(15), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_16 : po_px port map (i => core_if_adr(16), pad => if_adr(16), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_17 : po_px port map (i => core_if_adr(17), pad => if_adr(17), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_18 : po_px port map (i => core_if_adr(18), pad => if_adr(18), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_19 : po_px port map (i => core_if_adr(19), pad => if_adr(19), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_20 : po_px port map (i => core_if_adr(20), pad => if_adr(20), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_21 : po_px port map (i => core_if_adr(21), pad => if_adr(21), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_22 : po_px port map (i => core_if_adr(22), pad => if_adr(22), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_23 : po_px port map (i => core_if_adr(23), pad => if_adr(23), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_24 : po_px port map (i => core_if_adr(24), pad => if_adr(24), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_25 : po_px port map (i => core_if_adr(25), pad => if_adr(25), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_26 : po_px port map (i => core_if_adr(26), pad => if_adr(26), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_27 : po_px port map (i => core_if_adr(27), pad => if_adr(27), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_28 : po_px port map (i => core_if_adr(28), pad => if_adr(28), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_29 : po_px port map (i => core_if_adr(29), pad => if_adr(29), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_30 : po_px port map (i => core_if_adr(30), pad => if_adr(30), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	if_adr_31 : po_px port map (i => core_if_adr(31), pad => if_adr(31), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 

	if_adr_valid_pad : po_px port map (i =>  core_if_adr_valid, pad => if_adr_valid, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 


			--ic_inst			=> pad_ic_inst,
	ic_inst_0  : pi_px port map (t => pad_ic_inst(0 ), pad => ic_inst(0 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_1  : pi_px port map (t => pad_ic_inst(1 ), pad => ic_inst(1 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_2  : pi_px port map (t => pad_ic_inst(2 ), pad => ic_inst(2 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_3  : pi_px port map (t => pad_ic_inst(3 ), pad => ic_inst(3 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_4  : pi_px port map (t => pad_ic_inst(4 ), pad => ic_inst(4 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_5  : pi_px port map (t => pad_ic_inst(5 ), pad => ic_inst(5 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_6  : pi_px port map (t => pad_ic_inst(6 ), pad => ic_inst(6 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_7  : pi_px port map (t => pad_ic_inst(7 ), pad => ic_inst(7 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_8  : pi_px port map (t => pad_ic_inst(8 ), pad => ic_inst(8 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_9  : pi_px port map (t => pad_ic_inst(9 ), pad => ic_inst(9 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_10 : pi_px port map (t => pad_ic_inst(10), pad => ic_inst(10), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_11 : pi_px port map (t => pad_ic_inst(11), pad => ic_inst(11), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_12 : pi_px port map (t => pad_ic_inst(12), pad => ic_inst(12), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_13 : pi_px port map (t => pad_ic_inst(13), pad => ic_inst(13), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_14 : pi_px port map (t => pad_ic_inst(14), pad => ic_inst(14), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_15 : pi_px port map (t => pad_ic_inst(15), pad => ic_inst(15), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_16 : pi_px port map (t => pad_ic_inst(16), pad => ic_inst(16), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_17 : pi_px port map (t => pad_ic_inst(17), pad => ic_inst(17), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_18 : pi_px port map (t => pad_ic_inst(18), pad => ic_inst(18), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_19 : pi_px port map (t => pad_ic_inst(19), pad => ic_inst(19), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_20 : pi_px port map (t => pad_ic_inst(20), pad => ic_inst(20), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_21 : pi_px port map (t => pad_ic_inst(21), pad => ic_inst(21), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_22 : pi_px port map (t => pad_ic_inst(22), pad => ic_inst(22), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_23 : pi_px port map (t => pad_ic_inst(23), pad => ic_inst(23), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_24 : pi_px port map (t => pad_ic_inst(24), pad => ic_inst(24), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_25 : pi_px port map (t => pad_ic_inst(25), pad => ic_inst(25), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_26 : pi_px port map (t => pad_ic_inst(26), pad => ic_inst(26), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_27 : pi_px port map (t => pad_ic_inst(27), pad => ic_inst(27), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_28 : pi_px port map (t => pad_ic_inst(28), pad => ic_inst(28), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_29 : pi_px port map (t => pad_ic_inst(29), pad => ic_inst(29), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_30 : pi_px port map (t => pad_ic_inst(30), pad => ic_inst(30), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	ic_inst_31 : pi_px port map (t => pad_ic_inst(31), pad => ic_inst(31), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--ic_stall			=> pad_ic_stall,
	ic_stall_pad : pi_px port map (t => pad_ic_stall, pad => ic_stall, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--mem_adr			=> core_mem_adr,
	mem_adr_0  : po_px port map (i => core_mem_adr(0 ), pad => mem_adr(0 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_1  : po_px port map (i => core_mem_adr(1 ), pad => mem_adr(1 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_2  : po_px port map (i => core_mem_adr(2 ), pad => mem_adr(2 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_3  : po_px port map (i => core_mem_adr(3 ), pad => mem_adr(3 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_4  : po_px port map (i => core_mem_adr(4 ), pad => mem_adr(4 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_5  : po_px port map (i => core_mem_adr(5 ), pad => mem_adr(5 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_6  : po_px port map (i => core_mem_adr(6 ), pad => mem_adr(6 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_7  : po_px port map (i => core_mem_adr(7 ), pad => mem_adr(7 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_8  : po_px port map (i => core_mem_adr(8 ), pad => mem_adr(8 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_9  : po_px port map (i => core_mem_adr(9 ), pad => mem_adr(9 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_10 : po_px port map (i => core_mem_adr(10), pad => mem_adr(10), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_11 : po_px port map (i => core_mem_adr(11), pad => mem_adr(11), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_12 : po_px port map (i => core_mem_adr(12), pad => mem_adr(12), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_13 : po_px port map (i => core_mem_adr(13), pad => mem_adr(13), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_14 : po_px port map (i => core_mem_adr(14), pad => mem_adr(14), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_15 : po_px port map (i => core_mem_adr(15), pad => mem_adr(15), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_16 : po_px port map (i => core_mem_adr(16), pad => mem_adr(16), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_17 : po_px port map (i => core_mem_adr(17), pad => mem_adr(17), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_18 : po_px port map (i => core_mem_adr(18), pad => mem_adr(18), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_19 : po_px port map (i => core_mem_adr(19), pad => mem_adr(19), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_20 : po_px port map (i => core_mem_adr(20), pad => mem_adr(20), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_21 : po_px port map (i => core_mem_adr(21), pad => mem_adr(21), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_22 : po_px port map (i => core_mem_adr(22), pad => mem_adr(22), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_23 : po_px port map (i => core_mem_adr(23), pad => mem_adr(23), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_24 : po_px port map (i => core_mem_adr(24), pad => mem_adr(24), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_25 : po_px port map (i => core_mem_adr(25), pad => mem_adr(25), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_26 : po_px port map (i => core_mem_adr(26), pad => mem_adr(26), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_27 : po_px port map (i => core_mem_adr(27), pad => mem_adr(27), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_28 : po_px port map (i => core_mem_adr(28), pad => mem_adr(28), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_29 : po_px port map (i => core_mem_adr(29), pad => mem_adr(29), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_30 : po_px port map (i => core_mem_adr(30), pad => mem_adr(30), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_adr_31 : po_px port map (i => core_mem_adr(31), pad => mem_adr(31), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--mem_stw			=> core_mem_stw,
	mem_stw_pad : po_px port map (i =>  core_mem_stw, pad => mem_stw, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--mem_stb			=> core_mem_stb,
	mem_stb_pad : po_px port map (i =>  core_mem_stb, pad => mem_stb, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--mem_load			=> core_mem_load,
	mem_load_pad : po_px port map (i =>  core_mem_load, pad => mem_load, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--mem_data			=> core_mem_data,
	mem_data_0  : po_px port map (i => core_mem_data(0 ), pad => mem_data(0 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_1  : po_px port map (i => core_mem_data(1 ), pad => mem_data(1 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_2  : po_px port map (i => core_mem_data(2 ), pad => mem_data(2 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_3  : po_px port map (i => core_mem_data(3 ), pad => mem_data(3 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_4  : po_px port map (i => core_mem_data(4 ), pad => mem_data(4 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_5  : po_px port map (i => core_mem_data(5 ), pad => mem_data(5 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_6  : po_px port map (i => core_mem_data(6 ), pad => mem_data(6 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_7  : po_px port map (i => core_mem_data(7 ), pad => mem_data(7 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_8  : po_px port map (i => core_mem_data(8 ), pad => mem_data(8 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_9  : po_px port map (i => core_mem_data(9 ), pad => mem_data(9 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_10 : po_px port map (i => core_mem_data(10), pad => mem_data(10), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_11 : po_px port map (i => core_mem_data(11), pad => mem_data(11), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_12 : po_px port map (i => core_mem_data(12), pad => mem_data(12), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_13 : po_px port map (i => core_mem_data(13), pad => mem_data(13), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_14 : po_px port map (i => core_mem_data(14), pad => mem_data(14), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_15 : po_px port map (i => core_mem_data(15), pad => mem_data(15), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_16 : po_px port map (i => core_mem_data(16), pad => mem_data(16), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_17 : po_px port map (i => core_mem_data(17), pad => mem_data(17), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_18 : po_px port map (i => core_mem_data(18), pad => mem_data(18), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_19 : po_px port map (i => core_mem_data(19), pad => mem_data(19), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_20 : po_px port map (i => core_mem_data(20), pad => mem_data(20), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_21 : po_px port map (i => core_mem_data(21), pad => mem_data(21), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_22 : po_px port map (i => core_mem_data(22), pad => mem_data(22), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_23 : po_px port map (i => core_mem_data(23), pad => mem_data(23), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_24 : po_px port map (i => core_mem_data(24), pad => mem_data(24), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_25 : po_px port map (i => core_mem_data(25), pad => mem_data(25), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_26 : po_px port map (i => core_mem_data(26), pad => mem_data(26), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_27 : po_px port map (i => core_mem_data(27), pad => mem_data(27), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_28 : po_px port map (i => core_mem_data(28), pad => mem_data(28), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_29 : po_px port map (i => core_mem_data(29), pad => mem_data(29), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_30 : po_px port map (i => core_mem_data(30), pad => mem_data(30), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	mem_data_31 : po_px port map (i => core_mem_data(31), pad => mem_data(31), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	--		dc_data			=> pad_dc_data,
	dc_data_0  : pi_px port map (t => pad_dc_data(0 ), pad => dc_data(0 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_1  : pi_px port map (t => pad_dc_data(1 ), pad => dc_data(1 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_2  : pi_px port map (t => pad_dc_data(2 ), pad => dc_data(2 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_3  : pi_px port map (t => pad_dc_data(3 ), pad => dc_data(3 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_4  : pi_px port map (t => pad_dc_data(4 ), pad => dc_data(4 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_5  : pi_px port map (t => pad_dc_data(5 ), pad => dc_data(5 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_6  : pi_px port map (t => pad_dc_data(6 ), pad => dc_data(6 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_7  : pi_px port map (t => pad_dc_data(7 ), pad => dc_data(7 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_8  : pi_px port map (t => pad_dc_data(8 ), pad => dc_data(8 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_9  : pi_px port map (t => pad_dc_data(9 ), pad => dc_data(9 ), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_10 : pi_px port map (t => pad_dc_data(10), pad => dc_data(10), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_11 : pi_px port map (t => pad_dc_data(11), pad => dc_data(11), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_12 : pi_px port map (t => pad_dc_data(12), pad => dc_data(12), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_13 : pi_px port map (t => pad_dc_data(13), pad => dc_data(13), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_14 : pi_px port map (t => pad_dc_data(14), pad => dc_data(14), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_15 : pi_px port map (t => pad_dc_data(15), pad => dc_data(15), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_16 : pi_px port map (t => pad_dc_data(16), pad => dc_data(16), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_17 : pi_px port map (t => pad_dc_data(17), pad => dc_data(17), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_18 : pi_px port map (t => pad_dc_data(18), pad => dc_data(18), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_19 : pi_px port map (t => pad_dc_data(19), pad => dc_data(19), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_20 : pi_px port map (t => pad_dc_data(20), pad => dc_data(20), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_21 : pi_px port map (t => pad_dc_data(21), pad => dc_data(21), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_22 : pi_px port map (t => pad_dc_data(22), pad => dc_data(22), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_23 : pi_px port map (t => pad_dc_data(23), pad => dc_data(23), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_24 : pi_px port map (t => pad_dc_data(24), pad => dc_data(24), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_25 : pi_px port map (t => pad_dc_data(25), pad => dc_data(25), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_26 : pi_px port map (t => pad_dc_data(26), pad => dc_data(26), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_27 : pi_px port map (t => pad_dc_data(27), pad => dc_data(27), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_28 : pi_px port map (t => pad_dc_data(28), pad => dc_data(28), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_29 : pi_px port map (t => pad_dc_data(29), pad => dc_data(29), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_30 : pi_px port map (t => pad_dc_data(30), pad => dc_data(30), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	dc_data_31 : pi_px port map (t => pad_dc_data(31), pad => dc_data(31), ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	--		dc_stall			=> pad_dc_stall,
	dc_stall_pad : pi_px port map (t => pad_dc_stall, pad => dc_stall, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--ck					=> pad_ck,
	pck : pck_px port map (pad => ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
			--reset_n			=> pad_reset_n,
	preset : pi_px port map (t => pad_reset_n, pad => reset_n, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 

	pvdde_0 : pvddeck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvdde_1 : pvddeck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvdde_2 : pvddeck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvdde_3 : pvddeck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvddi_0 : pvddick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvddi_1 : pvddick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvddi_2 : pvddick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvddi_3 : pvddick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 

	pvsse_0 : pvsseck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvsse_1 : pvsseck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvsse_2 : pvsseck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvsse_3 : pvsseck_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvssi_0 : pvssick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvssi_1 : pvssick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvssi_2 : pvssick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 
	pvssi_3 : pvssick_px port map (cko => pad_ck, ck => ck_ring, vdde => vdde, vddi => vddi, vsse => vsse, vssi => vssi); 

end;

