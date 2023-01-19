library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
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
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv		: out Std_Logic;
		reg_ovr		: out Std_Logic;
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
		reg_pcv		: out Std_Logic; --bit de validité du registre PC
		inc_pc		: in Std_Logic; --si c'est valid inc_pc vaut 1 et on fait +4
	
	-- global interface
		ck				: in Std_Logic;
		reset_n		: in Std_Logic;
		vdd			: in bit;
		vss			: in bit);
end Reg;

architecture Behavior OF Reg is

-- les registres
signal r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, pc : std_logic_vector(31 downto 0); 	-- les 16 registres 
signal vr0, vr1, vr2, vr3, vr4, vr5, vr6, vr7, vr8, vr9, vr10, vr11, vr12, vr13, vr14, vpc : std_logic ;	-- les bits de validite de chaque registre

--signal u_pc : unsigned (31 downto 0);
-- les flags
signal f_cry, f_zero, f_neg, f_cznv, f_ovr, f_vv : std_logic ;	-- les flags 

begin

-- Gestion Read CSPR Port


process (ck, reset_n)


 begin

 if rising_edge (ck) then

   if reset_n = '0' then

	-- au reset : on valide les registres
   	vr0<='1';
 	vr1<='1';
 	vr2<='1';
	vr3<='1';
 	vr4<='1';
	vr5<='1';
	vr6<='1';
	vr7<='1';
 	vr8<='1';
 	vr9<='1';
	vr10<='1';
 	vr11<='1';
 	vr12<='1';
 	vr13<='1';
	vr14<='1';
 	vpc<='1';

	-- au reset : pc vaut 0 ==> retour au debut du programme	
	pc<=x"00000000";
	--u_pc<= unsigned(pc) ;	
	--à commenter après, c'est juste pour tester les additions
	r0 <=x"00000000";
	r1 <=x"0000001D";
	r2 <=x"00000043";
	r3 <=x"00000901";
	r4 <=x"0000A030";
	r5 <=x"000080A1";
	r6 <=x"0020FE04";
	r7 <=x"7050780E";
	r8 <=x"00010F05";
	r9 <=x"000030FE";
	r10 <=x"009A052F";
	r11 <=x"028010EE";
	r12 <=x"00A50440";
	r13 <=x"A0640B17";
	r14 <=x"B0B70E09";

   else
		
			------------------------------------------------- mofification---------------------------
			-- pour mettre a jour : bit de validite des flags c,z,n
			if ( f_cznv = '1' ) then
				if ( inval_czn = '1' ) then
					f_cznv <= '0' ; -- on invalide le flag
					f_cry <= '0' ;
					f_zero<= '0' ;
					f_neg<= '0' ;
				else
					f_cznv <= '1' ;
					f_cry<= '1' ;
					f_zero<= '1' ;
					f_neg<= '1' ;
				end if;
			else 					  -- f_cznv est invalidé : donc maj du flag si ecriture
				if (inval_czn = '0') then
					if ( cspr_wb = '1' ) then -- si y'a ecriture dans le banc de registres
						f_cznv <= '1' ;  -- on valide le flag
						f_cry<= wcry ;
						f_zero<= wzero ;
						f_neg<= wneg ;
					else
						f_cznv <= '0' ;
						f_cry<= '0' ;
						f_zero<= '0' ;
						f_neg<= '0' ;
					end if;
				else 
					f_cznv <= '0';
					f_cry<= '0' ;
					f_zero<= '0' ;
					f_neg<= '0' ;
				end if;
			end if;

			-- pour mettre a jour : bit de validite de l'overflow
			if ( f_ovr = '1' ) then
				if ( inval_ovr = '1' ) then
					f_ovr <= '0' ;
					f_vv<= '0' ;
				else
					f_ovr <= '1' ;
					f_vv<= '1' ;
				end if;
			else
				if( inval_ovr = '0' ) then
					if( cspr_wb = '1' ) then
						f_ovr <= wovr ;
						f_vv<= '1' ;
					else
						f_ovr <= '0' ;
						f_vv<= '0' ;
					end if;
				else
					f_ovr <= '0';
					f_vv<= '0' ;
				end if;
			end if;
		
			
			-- pour la validation de r0
			if ( vr0 = '1' ) then
				if ( ( inval_adr1=x"0" and inval1='1' ) or (inval_adr2=x"0" and inval2='1') ) then
					vr0 <= '0' ;
				else
					vr0 <= '1' ;
				end if;
			else
				if ( not ( inval_adr1=x"0" and inval1='1' ) or (inval_adr2=x"0" and inval2='1')) then
					if ( (wen1='1' and wadr1=x"0") or (wen2='1' and wadr2=x"0") ) then
						vr0 <= '1' ;
					else
						vr0 <= '0' ;
					end if;
				else
					vr0 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r0
			if ( (wen1='1' and wadr1=x"0") and vr0='0' ) then --gestion de la priorite de wen1 sur wen2
				r0<=wdata1;
			elsif ( (wen2='1' and wadr2=x"0") and vr0='0' )  then
				r0<=wdata2;
			else 
				r0 <= r0;
			end if;
			
			
			-- pour la validation de r1
			if ( vr1 = '1' ) then
				if ( ( inval_adr1=x"1" and inval1='1' ) or (inval_adr2=x"1" and inval2='1') ) then
					vr1 <= '0' ;
				else
					vr1 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"1" and inval1='1' ) or (inval_adr2=x"1" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"1") or (wen2='1' and wadr2=x"1") ) then
						vr1 <= '1' ;
					else
						vr1 <= '0' ;
					end if;
				else
					vr1 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r1
			if ( (wen1='1' and wadr1=x"1") and vr1='0' ) then --gestion de la priorite de wen1 sur wen2
				r1<=wdata1;
			elsif ( (wen2='1' and wadr2=x"1") and vr1='0'  ) then
				r1<=wdata2;
			end if;
			
			-- pour la validation de r2
			if ( vr2 = '1' ) then
				if ( ( inval_adr1=x"2" and inval1='1' ) or (inval_adr2=x"2" and inval2='1') ) then
					vr2 <= '0' ;
				else
					vr2 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"2" and inval1='1' ) or (inval_adr2=x"2" and inval2='1')  ) then
					if ( (wen1='1' and wadr1=x"2") or (wen2='1' and wadr2=x"2") ) then
						vr2 <= '1' ;
					else
						vr2 <= '0' ;
					end if;
				else
					vr2 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r2
			if ( (wen1='1' and wadr1=x"2") and vr2='0' ) then --gestion de la priorite de wen1 sur wen2
				r2<=wdata1;
			elsif ( (wen2='1' and wadr2=x"2") and vr2='0' )  then
				r2<=wdata2;
			end if;

			-- pour la validation de r3
			if ( vr3 = '1' ) then
				if ( ( inval_adr1=x"3" and inval1='1' ) or (inval_adr2=x"3" and inval2='1') ) then
					vr3 <= '0' ;
				else
					vr3 <= '1' ;
				end if;
			else
				if ( not ( ( inval_adr1=x"3" and inval1='1' ) or (inval_adr2=x"3" and inval2='1') ) ) then
					if ( (wen1='1' and wadr1=x"3") or (wen2='1' and wadr2=x"3") ) then
						vr3 <= '1' ;
					else
						vr3 <= '0' ;
					end if;
				else
					vr3 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r3
			if ( (wen1='1' and wadr1=x"3") and vr3='0' ) then --gestion de la priorite de wen1 sur wen2
				r3<=wdata1;
			elsif ( (wen2='1' and wadr2=x"") and vr3='0' ) then
				r3<=wdata2;
			end if;

			-- pour la validation de r4
			if ( vr4 = '1' ) then
				if ( ( inval_adr1=x"4" and inval1='1' ) or (inval_adr2=x"4" and inval2='1') ) then
					vr4 <= '0' ;
				else
					vr4 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"4" and inval1='1' ) or (inval_adr2=x"4" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"4") or (wen2='1' and wadr2=x"4") ) then
						vr4 <= '1' ;
					else
						vr4 <= '0' ;
					end if;
				else
					vr4 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r4
			if ( (wen1='1' and wadr1=x"4") and vr4='0' ) then --gestion de la priorite de wen1 sur wen2
				r4<=wdata1;
			elsif ( (wen2='1' and wadr2=x"4") and vr4='0' ) then
				r4<=wdata2;
			end if;

			-- pour la validation de r5
			if ( vr5 = '1' ) then
				if ( ( inval_adr1=x"5" and inval1='1' ) or (inval_adr2=x"5" and inval2='1') ) then
					vr5 <= '0' ;
				else
					vr5 <= '1' ;
				end if;
			else
				if (not( inval_adr1=x"5" and inval1='1' ) or (inval_adr2=x"5" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"5") or (wen2='1' and wadr2=x"5") ) then
						vr5 <= '1' ;
					else
						vr5 <= '0' ;
					end if;
				else
					vr5 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r5
			if ( (wen1='1' and wadr1=x"5") and vr5='0' ) then --gestion de la priorite de wen1 sur wen2
				r5<=wdata1;
			elsif ( (wen2='1' and wadr2=x"5") and vr5='0' ) then
				r5<=wdata2;
			end if;

			-- pour la validation de r6
			if ( vr6 = '1' ) then
				if ( ( inval_adr1=x"6" and inval1='1' ) or (inval_adr2=x"6" and inval2='1') ) then
					vr6 <= '0' ;
				else
					vr6 <= '1' ;
				end if;
			else
				if (not ( inval_adr1=x"6" and inval1='1' ) or (inval_adr2=x"6" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"6") or (wen2='1' and wadr2=x"6") ) then
						vr6 <= '1' ;
					else
						vr6 <= '0' ;
					end if;
				else
					vr6 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r6
			if ( (wen1='1' and wadr1=x"6") and vr6='0' ) then --gestion de la priorite de wen1 sur wen2
				r6<=wdata1;
			elsif ( (wen2='1' and wadr2=x"6") and vr6='0' ) then
				r6<=wdata2;
			end if;

			-- pour la validation de r7
			if ( vr7 = '1' ) then
				if ( ( inval_adr1=x"7" and inval1='1' ) or (inval_adr2=x"7" and inval2='1') ) then
					vr7 <= '0' ;
				else
					vr7 <= '1' ;
				end if;
			else
				if (not( inval_adr1=x"7" and inval1='1' ) or (inval_adr2=x"7" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"7") or (wen2='1' and wadr2=x"7") ) then
						vr7 <= '1' ;
					else
						vr7 <= '0' ;
					end if;
				else
					vr7 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r7
			if ( (wen1='1' and wadr1=x"7") and vr7='0' ) then --gestion de la priorite de wen1 sur wen2
				r7<=wdata1;
			elsif ( (wen2='1' and wadr2=x"7") and vr7='0' ) then
				r7<=wdata2;
			end if;

			-- pour la validation de r8
			if ( vr8 = '1' ) then
				if ( ( inval_adr1=x"8" and inval1='1' ) or (inval_adr2=x"8" and inval2='1') ) then
					vr8 <= '0' ;
				else
					vr8 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"8" and inval1='1' ) or (inval_adr2=x"8" and inval2='1')  ) then
					if ( (wen1='1' and wadr1=x"8") or (wen2='1' and wadr2=x"8") ) then
						vr8 <= '1' ;
					else
						vr8 <= '0' ;
					end if;
				else
					vr8 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r8
			if ( (wen1='1' and wadr1=x"8") and vr8='0' ) then --gestion de la priorite de wen1 sur wen2
				r8<=wdata1;
			elsif ( (wen2='1' and wadr2=x"8") and vr8='0' ) then
				r8<=wdata2;
			end if;

			-- pour la validation de r9
			if ( vr9 = '1' ) then
				if ( ( inval_adr1=x"9" and inval1='1' ) or (inval_adr2=x"9" and inval2='1') ) then
					vr9 <= '0' ;
				else
					vr9 <= '1' ;
				end if;
			else
				if ( not ( inval_adr1=x"9" and inval1='1' ) or (inval_adr2=x"9" and inval2='1')  ) then
					if ( (wen1='1' and wadr1=x"9") or (wen2='1' and wadr2=x"9") ) then
						vr9 <= '1' ;
					else
						vr9 <= '0' ;
					end if;
				else
					vr9 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r9
			if ( (wen1='1' and wadr1=x"9") and vr9='0' ) then --gestion de la priorite de wen1 sur wen2
				r9<=wdata1;
			elsif ( (wen2='1' and wadr2=x"9") and vr9='0' ) then
				r9<=wdata2;
			end if;

			-- pour la validation de r10
			if ( vr10 = '1' ) then
				if ( ( inval_adr1=x"A" and inval1='1' ) or (inval_adr2=x"A" and inval2='1') ) then
					vr10 <= '0' ;
				else
					vr10 <= '1' ;
				end if;
			else
				if ( not ( inval_adr1=x"A" and inval1='1' ) or (inval_adr2=x"A" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"A") or (wen2='1' and wadr2=x"A") ) then
						vr10 <= '1' ;
					else
						vr10 <= '0' ;
					end if;
				else
					vr10 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r10
			if ( (wen1='1' and wadr1=x"A") and vr10='0' ) then --gestion de la priorite de wen1 sur wen2
				r10<=wdata1;
			elsif ( (wen2='1' and wadr2=x"A") and vr10='0' )  then
				r10<=wdata2;
			end if;

			-- pour la validation de r11
			if ( vr11 = '1' ) then
				if ( ( inval_adr1=x"B" and inval1='1' ) or (inval_adr2=x"B" and inval2='1') ) then
					vr11 <= '0' ;
				else
					vr11 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"B" and inval1='1' ) or (inval_adr2=x"B" and inval2='1')  ) then
					if ( (wen1='1' and wadr1=x"B") or (wen2='1' and wadr2=x"B") ) then
						vr11 <= '1' ;
					else
						vr11 <= '0' ;
					end if;
				else
					vr11 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r11
			if ( (wen1='1' and wadr1=x"B") and vr11='0' ) then --gestion de la priorite de wen1 sur wen2
				r11<=wdata1;
			elsif ( (wen2='1' and wadr2=x"B") and vr11='0' )  then
				r11<=wdata2;
			end if;

			-- pour la validation de r12
			if ( vr12 = '1' ) then
				if ( ( inval_adr1=x"C" and inval1='1' ) or (inval_adr2=x"C" and inval2='1') ) then
					vr12 <= '0' ;
				else
					vr12 <= '1' ;
				end if;
			else
				if ( not ( inval_adr1=x"C" and inval1='1' ) or (inval_adr2=x"C" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"C") or (wen2='1' and wadr2=x"C") ) then
						vr12 <= '1' ;
					else
						vr12 <= '0' ;
					end if;
				else
					vr12 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r12
			if ( (wen1='1' and wadr1=x"C") and vr12='0' ) then --gestion de la priorite de wen1 sur wen2
				r12<=wdata1;
			elsif ( (wen2='1' and wadr2=x"C") and vr12='0' )  then
				r12<=wdata2;
			end if;

			-- pour la validation de r13
			if ( vr13 = '1' ) then
				if ( ( inval_adr1=x"D" and inval1='1' ) or (inval_adr2=x"D" and inval2='1') ) then
					vr13 <= '0' ;
				else
					vr13 <= '1' ;
				end if;
			else
				if ( not ( inval_adr1=x"D" and inval1='1' ) or (inval_adr2=x"D" and inval2='1')  ) then
					if ( (wen1='1' and wadr1=x"D") or (wen2='1' and wadr2=x"D") ) then
						vr13 <= '1' ;
					else
						vr13 <= '0' ;
					end if;
				else
					vr13 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r13
			if ( (wen1='1' and wadr1=x"D") and vr13='0' ) then --gestion de la priorite de wen1 sur wen2
				r13<=wdata1;
			elsif ( (wen2='1' and wadr2=x"D") and vr13='0' )  then
				r13<=wdata2;
			end if;


			-- pour la validation de r14
			if ( vr14 = '1' ) then
				if ( ( inval_adr1=x"E" and inval1='1' ) or (inval_adr2=x"E" and inval2='1') ) then
					vr14 <= '0' ;
				else
					vr14 <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"E" and inval1='1' ) or (inval_adr2=x"E" and inval2='1') ) then
					if ( (wen1='1' and wadr1=x"E") or (wen2='1' and wadr2=x"E") ) then
						vr14 <= '1' ;
					else
						vr14 <= '0' ;
					end if;
				else
					vr14 <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : r14
			if ( (wen1='1' and wadr1=x"E") and vr14='0' ) then --gestion de la priorite de wen1 sur wen2
				r14<=wdata1;
			elsif ( (wen2='1' and wadr2=x"E") and vr14='0' )  then
				r14<=wdata2;
			end if;

			-- pour la validation de PC
			if ( vpc = '1' ) then
				if ( ( inval_adr1=x"F" and inval1='1' ) or (inval_adr2=x"F" and inval2='1') ) then
					vpc <= '0' ;
				else
					vpc <= '1' ;
				end if;
			else
				if ( not( inval_adr1=x"F" and inval1='1' ) or (inval_adr2=x"F" and inval2='1')) then
					if ( (wen1='1' and wadr1=x"F") or (wen2='1' and wadr2=x"F") ) then
						vpc <= '1' ;
					else
						vpc <= '0' ;
					end if;
				else
					vpc <= '0' ;
				end if;
			end if;
		
			-- pour l'ecriture : pc
			if ( vpc = '1' and inc_pc ='1') then

					--u_pc<= unsigned(pc) ;			-- necessaire pour faire l'addition
					--u_pc<=u_pc+4 ;				-- ici on fait : pc = pc+4
					pc <= std_logic_vector(unsigned(pc)+4);
					--pc<=std_logic_vector(u_pc);
			elsif ( (wen1='1' and wadr1=x"F") and vpc='0' ) then --gestion de la priorite de wen1 sur wen2

					pc<=wdata1 ;
			else
				pc <= pc;

			end if;

					
			-----------------------------------------------------fin modifiction --------------------
			
		
	end if;

end if;




-- pour les lectures : rd1
			CASE radr1 IS
				WHEN x"0" => reg_rd1 <= r0;
				WHEN x"1" => reg_rd1 <= r1;
				WHEN x"2" => reg_rd1 <= r2;
				WHEN x"3" => reg_rd1 <= r3;
				WHEN x"4" => reg_rd1 <= r4;
				WHEN x"5" => reg_rd1 <= r5;
				WHEN x"6" => reg_rd1 <= r6;
				WHEN x"7" => reg_rd1 <= r7;
				WHEN x"8" => reg_rd1 <= r8;
				WHEN x"9" => reg_rd1 <= r9;
				WHEN x"A" => reg_rd1 <= r10;
				WHEN x"B" => reg_rd1 <= r11;
				WHEN x"C" => reg_rd1 <= r12;
				WHEN x"D" => reg_rd1 <= r13;
				WHEN x"E" => reg_rd1 <= r14;
				WHEN x"F" => reg_rd1 <= pc;
				WHEN OTHERS => reg_rd1 <= x"00000000";
			END CASE;

			CASE radr1 IS
				WHEN x"0" => reg_v1 <= vr0;
				WHEN x"1" => reg_v1 <= vr1;
				WHEN x"2" => reg_v1 <= vr2;
				WHEN x"3" => reg_v1 <= vr3;
				WHEN x"4" => reg_v1 <= vr4;
				WHEN x"5" => reg_v1 <= vr5;
				WHEN x"6" => reg_v1 <= vr6;
				WHEN x"7" => reg_v1 <= vr7;
				WHEN x"8" => reg_v1 <= vr8;
				WHEN x"9" => reg_v1 <= vr9;
				WHEN x"A" => reg_v1 <= vr10;
				WHEN x"B" => reg_v1 <= vr11;
				WHEN x"C" => reg_v1 <= vr12;
				WHEN x"D" => reg_v1 <= vr13;
				WHEN x"E" => reg_v1 <= vr14;
				WHEN x"F" => reg_v1 <= vpc;
				WHEN OTHERS => reg_v1 <= '0';
			END CASE;

			-- pour les lectures : rd2	
			
			CASE radr2 IS
				WHEN x"0" => reg_rd2 <= r0;
				WHEN x"1" => reg_rd2 <= r1;
				WHEN x"2" => reg_rd2 <= r2;
				WHEN x"3" => reg_rd2 <= r3;
				WHEN x"4" => reg_rd2 <= r4;
				WHEN x"5" => reg_rd2 <= r5;
				WHEN x"6" => reg_rd2 <= r6;
				WHEN x"7" => reg_rd2 <= r7;
				WHEN x"8" => reg_rd2 <= r8;
				WHEN x"9" => reg_rd2 <= r9;
				WHEN x"A" => reg_rd2 <= r10;
				WHEN x"B" => reg_rd2 <= r11;
				WHEN x"C" => reg_rd2 <= r12;
				WHEN x"D" => reg_rd2 <= r13;
				WHEN x"E" => reg_rd2 <= r14;
				WHEN x"F" => reg_rd2 <= pc;
				WHEN OTHERS => reg_rd2 <= x"00000000";
			END CASE;

			CASE radr2 IS
				WHEN x"0" => reg_v2 <= vr0;
				WHEN x"1" => reg_v2 <= vr1;
				WHEN x"2" => reg_v2 <= vr2;
				WHEN x"3" => reg_v2 <= vr3;
				WHEN x"4" => reg_v2 <= vr4;
				WHEN x"5" => reg_v2 <= vr5;
				WHEN x"6" => reg_v2 <= vr6;
				WHEN x"7" => reg_v2 <= vr7;
				WHEN x"8" => reg_v2 <= vr8;
				WHEN x"9" => reg_v2 <= vr9;
				WHEN x"A" => reg_v2 <= vr10;
				WHEN x"B" => reg_v2 <= vr11;
				WHEN x"C" => reg_v2 <= vr12;
				WHEN x"D" => reg_v2 <= vr13;
				WHEN x"E" => reg_v2 <= vr14;
				WHEN x"F" => reg_v2 <= vpc;
				WHEN OTHERS => reg_v2 <= '0';
			END CASE;

			-- pour les lectures : rd3	
			
			CASE radr3 IS
				WHEN x"0" => reg_rd3 <= r0;
				WHEN x"1" => reg_rd3 <= r1;
				WHEN x"2" => reg_rd3 <= r2;
				WHEN x"3" => reg_rd3 <= r3;
				WHEN x"4" => reg_rd3 <= r4;
				WHEN x"5" => reg_rd3 <= r5;
				WHEN x"6" => reg_rd3 <= r6;
				WHEN x"7" => reg_rd3 <= r7;
				WHEN x"8" => reg_rd3 <= r8;
				WHEN x"9" => reg_rd3 <= r9;
				WHEN x"A" => reg_rd3 <= r10;
				WHEN x"B" => reg_rd3 <= r11;
				WHEN x"C" => reg_rd3 <= r12;
				WHEN x"D" => reg_rd3 <= r13;
				WHEN x"E" => reg_rd3 <= r14;
				WHEN x"F" => reg_rd3 <= pc;
				WHEN OTHERS => reg_rd3 <= x"00000000";
			END CASE;

			CASE radr3 IS
				WHEN x"0" => reg_v3 <= vr0;
				WHEN x"1" => reg_v3 <= vr1;
				WHEN x"2" => reg_v3 <= vr2;
				WHEN x"3" => reg_v3 <= vr3;
				WHEN x"4" => reg_v3 <= vr4;
				WHEN x"5" => reg_v3 <= vr5;
				WHEN x"6" => reg_v3 <= vr6;
				WHEN x"7" => reg_v3 <= vr7;
				WHEN x"8" => reg_v3 <= vr8;
				WHEN x"9" => reg_v3 <= vr9;
				WHEN x"A" => reg_v3 <= vr10;
				WHEN x"B" => reg_v3 <= vr11;
				WHEN x"C" => reg_v3 <= vr12;
				WHEN x"D" => reg_v3 <= vr13;
				WHEN x"E" => reg_v3 <= vr14;
				WHEN x"F" => reg_v3 <= vpc;
				WHEN OTHERS => reg_v3 <= '0';
			END CASE;
end process;


-- Gestion de PC et de son bit de validite
reg_pc<=pc;
reg_pcv<=vpc;


-- Gestion des 4 flags et les 2 bits de validite

--4 flags		
reg_cry<=f_cry;
reg_zero<=f_zero;	
reg_neg<=f_neg;			
reg_ovr<=f_ovr;

--2 bits validite
reg_cznv<=f_cznv;			
reg_vv<=f_vv;


end Behavior;
