library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity InstructionDecode is
  Port ( 
    clk         : in std_logic;
    en          : in std_logic;
    instr       : in std_logic_vector(15 downto 0);
    regWrite    : in std_logic;
    regDst      : in std_logic;
    writeData   : in std_logic_vector(15 downto 0);
    extOp       : in std_logic;
    
    readData1   : out std_logic_vector(15 downto 0);
    readData2   : out std_logic_vector(15 downto 0);
    extImm      : out std_logic_vector(15 downto 0);
    func        : out std_logic_vector(2 downto 0);
    sa          : out std_logic
  );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

--reg file
type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (others => x"0000");

signal writeAddr : std_logic_vector(2 downto 0);

begin

writeAddr <=  instr(9 downto 7) when regDst = '0' else instr(6 downto 4);

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and regWrite = '1' then 
            reg_file(conv_integer(writeAddr)) <= writeData;
        end if;
    end if;
end process;

readData1 <= reg_file(conv_integer(instr(12 downto 10)));
readData2 <= reg_file(conv_integer(instr(9 downto 7)));

extImm(6 downto 0) <= instr(6 downto 0);
extImm(15 downto 7) <= (others => instr(6)) when extOp = '1' else (others => '0');

sa <= instr(3);
func <= instr(2 downto 0);

end Behavioral;
