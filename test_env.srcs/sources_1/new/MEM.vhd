library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity MEM is
  Port ( 
    clk         : in std_logic;
    en          : in std_logic;
    ALUResIn    : in std_logic_vector(15 downto 0);
    RD2         : in std_logic_vector(15 downto 0);
    MemWrite    : in std_logic;
    
    MemData     : out std_logic_vector(15 downto 0);
    ALUResOut   : out std_logic_vector(15 downto 0);       
    Number      : out std_logic_vector(15 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
signal MEM : mem_type := (
    0 => X"0008",  -- A = 8
    1 => X"0000",
    2 => X"0000",
    3 => X"0000",
    4 => X"0004",  -- N = 4
    5 => X"0000",
    6 => X"0000",
    7 => X"0000",
    8 => X"0007",  -- Element 1
    9 => X"0002",  -- Element 2
    10 => X"0004", -- Element 3
    11 => X"0001", -- Element 4
    12 => X"0000", 
    13 => X"0000",
    14 => X"0000",
    15 => X"0000"
);

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and MemWrite = '1' then
            MEM(conv_integer(ALUResIn(3 downto 0))) <= RD2;
        end if;
    end if; 
end process;

MemData <= MEM(conv_integer(ALUResIn(3 downto 0)));
ALUResOut <= ALUResIn;
Number <= MEM(conv_integer(ALUResIn(15 downto 12)))(3 downto 0) & 
          MEM(conv_integer(ALUResIn(11 downto 8)))(3 downto 0) & 
          MEM(conv_integer(ALUResIn(7 downto 4)))(3 downto 0) & 
          MEM(conv_integer(ALUResIn(3 downto 0)))(3 downto 0);

end Behavioral;
