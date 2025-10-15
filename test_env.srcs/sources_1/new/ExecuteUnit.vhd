library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ExecuteUnit is
  Port (
    PCOut       : in std_logic_vector(15 downto 0);
    RD1         : in std_logic_vector(15 downto 0);
    RD2         : in std_logic_vector(15 downto 0);
    ExtImm      : in std_logic_vector(15 downto 0);
    func        : in std_logic_vector(2 downto 0);
    sa          : in std_logic;
    ALUSrc      : in std_logic;
    ALUOp       : in std_logic_vector(2 downto 0);
    
    ALURes      : out std_logic_vector(15 downto 0);
    BranchAddr  : out std_logic_vector(15 downto 0);
    ZeroSignal  : out std_logic
  );
end ExecuteUnit;

architecture Behavioral of ExecuteUnit is

signal ALUCtrl      : std_logic_vector(2 downto 0);
signal ALUInput2    : std_logic_vector(15 downto 0);
signal ALUResAux    : std_logic_vector(15 downto 0);
signal ZeroAux      : std_logic;
--signal jmpFlag      : std_logic := '0';

begin

--ALU control
process(ALUOp, Func)
begin
    case(ALUOp) is
        when "000" => case (Func) is 
                        when "000" => ALUCtrl <= "000"; -- ADD
                        when "001" => ALUCtrl <= "001"; -- SUB
                        when "010" => ALUCtrl <= "010"; -- SLL
                        when "011" => ALUCtrl <= "011"; -- SRL
                        when "100" => ALUCtrl <= "100"; -- AND
                        when "101" => ALUCtrl <= "101"; -- OR
                        when "110" => ALUCtrl <= "110"; -- XOR
                        when "111" => ALUCtrl <= "111"; -- SUB  
                        when others => NULL;           
                      end case;
        when "001" => ALUCtrl <= "000"; -- ADDI
        when "010" => ALUCtrl <= "001"; -- BEQ
        when "101" => ALUCtrl <= "100"; -- ANDI
        when "110" => ALUCtrl <= "101"; -- ORI
        when "111" => ALUCtrl <= "111"; -- JMP
        when others => ALUCtrl <= "000";            
    end case;
end process;

--ALU
process(ALUCtrl, RD1, ALUInput2, sa) 
begin
    case (ALUCtrl) is
        when "000" => ALUResAux <= RD1 + ALUInput2; -- ADD/ADDI
        when "001" => ALUResAux <= RD1 - ALUInput2; -- SUB/BEQ ...
        when "010" => case (sa) is     -- SLL
                           when '1' => ALUResAux <= RD1(14 downto 0) & "0";
                           when others => ALUResAux <= RD1;
                      end case; 
        when "011" => case (sa) is     -- SRL
                           when '1' => ALUResAux <= "0" & RD1(15 downto 1);
                           when others => ALUResAux <= RD1;
                      end case;
        when "100" => ALUResAux <= RD1 and ALUInput2; -- AND
        when "101" => ALUResAux <= RD1 or ALUInput2; -- OR
        when "110" => ALUResAux <= RD1 xor ALUInput2; -- XOR
        when "111" => if RD1 < ALUInput2 then   -- SLT
                        ALUResAux <= x"0001";
                      else ALUResAux <= x"0000";
                      end if;  
                   
        when others => ALUResAux <= x"0000";
        
        case (ALUResAux) is
            when x"0000" => ZeroAux <= '1';
            when others => ZeroAux <= '0';
        end case;              
                 
    end case;
end process;

ZeroSignal <= ZeroAux;
ALURes <= ALUResAux;
--BranchAddr <= PCOut + (ExtImm(14 downto 0) & "0");

end Behavioral;
