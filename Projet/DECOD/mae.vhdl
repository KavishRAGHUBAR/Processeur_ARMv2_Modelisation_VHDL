--MAE de decod -> not used

library ieee;
use ieee.std_logic_1164.ALL;

entity MAE is
port (reset,clk : in STD_LOGIC;
      ETAT : in STD_LOGIC_VECTOR(2 downto 0);
      T1,T2,T3,T4,T5,T6 : in std_logic;
      something : out STD_LOGIC_vector(2 downto 0));
end MAE;

architecture behav of MAE is

   Signal REG_ETAT : STD_LOGIC_VECTOR(2 downto 0); --max 8 états possibles
   
  -- FETCH : 000
  -- BRANCH : 001
  -- LINK : 010
  -- MTRANS : 011
  -- RUN : 100
begin
process(clk,reset)
begin
  if reset ='0' then REG_ETAT <= "000"; --début, reset actif à l'état bas
  elsif (rising_edge(clk)) then
    case REG_ETAT is
        when "000" => REG_ETAT <= "000"; --fetch
            if T2 = '1' then REG_ETAT <= "100";--go to run
            end if;
        when "100" => REG_ETAT <= "100"; --run
            if T4 = '1' then REG_ETAT <= "010";--go to link
            elsif T5 = '1' then REG_ETAT <= "001";--go to branch
            elsif T6 = '1' then REG_ETAT <= "011";--go to mtrans
            end if;
        when "010" => REG_ETAT <= "010"; --link
            if T1 = '1' then REG_ETAT <= "001";--go to branch
            end if;
        when "001" => REG_ETAT <= "001"; --branch
            if T2 = '1' then REG_ETAT <= "100"; --go to run
            elsif T3 = '1' then REG_ETAT <= "000"; --go to fetch  
            end if;
        when "011" => REG_ETAT <= "011"; --mtrans
            if T2 = '1' then REG_ETAT <= "100"; --go to run
            elsif T3 = '1' then REG_ETAT <= "001";--go to branch
            end if;
        When others => REG_ETAT <= "000"; --fetch (début)
    end case;
   end if;
  
end process;
     --update output
     something <= REG_ETAT;
end behav;

