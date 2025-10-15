library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity MainControl is
  Port (
    instr       : in std_logic_vector(2 downto 0);
    
    regWrite    : out std_logic;
    regDst      : out std_logic;
    extOp       : out std_logic;
    jump        : out std_logic;
    branch      : out std_logic;
    ALUsrc      : out std_logic;
    ALUop       : out std_logic_vector(2 downto 0);
    memWrite    : out std_logic;
    memToReg    : out std_logic
  );
end MainControl;

architecture Behavioral of MainControl is

signal opCode : std_logic_vector(2 downto 0) := instr;

begin
    
    process(opCode)
    begin
        regDst <= '0';
        regWrite <= '0';
        extOp <= '0';
        ALUsrc <= '0';
        ALUop <= "000";
        jump <= '0';
        branch <= '0';
        memWrite <= '0';
        memToReg <= '0';
        
        case (opCode) is
            when "000" => regDst <= '1'; regWrite <= '1'; ALUop <= "000";
            when "001" => regWrite <= '1'; extOp <= '1'; ALUsrc <= '1'; ALUop <= "001"; -- ADDI
            when "010" => extOp <= '1'; ALUsrc <= '1'; ALUop <= "001"; memToReg <= '1'; regWrite <= '1'; -- LW
            when "011" => regDst <= 'X'; extOp <= '1'; ALUsrc <= '1'; ALUop <= "001"; memToReg <= 'X'; memWrite <= '1'; -- SW
            when "100" => regDst <= 'X'; extOp <= '1'; branch <= '1'; ALUop <= "010"; memToReg <= 'X'; -- BEQ
            when "101" => extOp <= '1'; ALUsrc <= '1'; ALUop <= "101"; regWrite <= '1'; -- ANDI
            when "110" => extOp <= '1'; ALUsrc <= '1'; ALUop <= "110"; regWrite <= '1'; -- ORI
            when "111" => regDst <= 'X'; extOp <= '1'; ALUsrc <= 'X'; jump <= '1'; ALUop <= "111"; memToReg <= 'X'; -- JUMP
            
            when others => regDst <= 'X'; extOp <= 'X'; ALUsrc <= 'X'; -- OTHERS
        end case; 
    end process;

end Behavioral;
