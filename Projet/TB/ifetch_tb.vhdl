library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mem.all;


--  A testbench has no ports.
entity ifetch_tb is
end ifetch_tb;

architecture behav of ifetch_tb is
	
	component icache
	port(
			if_adr			: in std_logic_vector(31 downto 0) ;
			if_adr_valid	: in Std_Logic;

			ic_inst			: out std_logic_vector(31 downto 0) ;
			ic_stall			: out Std_Logic);
	end component;

	component ifetch
	port(
	-- Icache interface
			if_adr			: out Std_Logic_Vector(31 downto 0) ;
			if_adr_valid	: out Std_Logic;

			ic_inst			: in Std_Logic_Vector(31 downto 0) ;
			ic_stall			: in Std_Logic;

	-- Decode interface
			if_adr_next		: out Std_Logic_Vector(31 downto 0) ;
			if_ir				: out Std_Logic_Vector(31 downto 0) ;
			if_ir_valid		: out Std_Logic;

			dec_fetch_inst	: in Std_Logic;
			dec_bpc			: in Std_Logic_Vector(31 downto 0) ;
			dec_bpc_valid	: in Std_Logic;


	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in Std_Logic;
			vss				: in Std_Logic);
	end component;

	signal	if_adr			: Std_Logic_Vector(31 downto 0) ;
	signal	if_adr_valid	: Std_Logic;
	signal	ic_inst			: Std_Logic_Vector(31 downto 0) ;
	signal	ic_stall			: Std_Logic;
   
	signal	if_adr_next		: Std_Logic_Vector(31 downto 0) ;
	signal	if_ir				: Std_Logic_Vector(31 downto 0) ;
	signal	if_ir_valid		: Std_Logic;
	signal	dec_fetch_inst	: Std_Logic;
	signal	dec_bpc			: Std_Logic_Vector(31 downto 0) ;
	signal	dec_bpc_valid	: Std_Logic;
   
	signal	ck					: Std_Logic;
	signal	reset_n			: Std_Logic;
	signal	vdd				: Std_Logic;
	signal	vss				: Std_Logic;

	signal	GoodAdr			: Std_Logic_Vector(31 downto 0) ;
	signal	BadAdr			: Std_Logic_Vector(31 downto 0) ;

	--for adder_0: adder use entity work.adder;

	begin
	--  Component instantiation.
	ifetch_0 : ifetch
	port map (	if_adr			=> if_adr,
					if_adr_valid	=> if_adr_valid,
					ic_inst			=> ic_inst,
					ic_stall			=> ic_stall,
					if_adr_next		=> if_adr_next,
					if_ir				=> if_ir,
					if_ir_valid		=> if_ir_valid,
					dec_fetch_inst	=> dec_fetch_inst,
					dec_bpc			=> dec_bpc,
					dec_bpc_valid	=> dec_bpc_valid,
					ck					=> ck,
					reset_n			=> reset_n,
					vdd				=> vdd,
					vss				=> vss);

	icache_0 : icache
	port map (	if_adr			=> if_adr,
					if_adr_valid	=> if_adr_valid,
					ic_inst			=> ic_inst,
					ic_stall			=> ic_stall);

   -- Test ADR GOOD or BAD

process(if_adr, if_adr_valid)
begin
	if if_adr_valid = '1' then
		assert if_adr /= GoodAdr report "GOOD!!!" severity failure;
		assert if_adr /= BadAdr report "BAD!!!" severity failure;
	end if;
end process;
	
	--  This process does the real job.
process

begin

	GoodAdr <= std_logic_vector(TO_SIGNED(mem_goodadr, 32));
	BadAdr <= std_logic_vector(TO_SIGNED(mem_badadr, 32));

	vdd <= '1';
	vss <= '0';
	reset_n <= '0';
	ck <= '0';
	wait for 1 ns;
	ck <= '1';
	wait for 1 ns;
	reset_n <= '1';
	dec_fetch_inst	<= '1';
	dec_bpc <= X"0000000C";
	dec_bpc_valid <= '0';
	ck <= '0';
	wait for 1 ns;
	ck <= '1';
	wait for 1 ns;
	dec_fetch_inst	<= '0';
	dec_bpc <= X"0000000C";
	dec_bpc_valid <= '0';
	ck <= '0';
	wait for 1 ns;
	ck <= '1';
	wait for 1 ns;
	dec_fetch_inst	<= '1';
	dec_bpc <= X"0000001C";
	dec_bpc_valid <= '1';
	ck <= '0';
	wait for 1 ns;
	ck <= '1';
	wait for 1 ns;

	assert false report "end of test" severity note;

wait;
end process;
end behav;
