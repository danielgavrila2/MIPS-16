library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity InstructionFetch is
  Port (
    clk         : in std_logic;
    rst         : in std_logic;
    we          : in std_logic;
    branchAddr  : in std_logic_vector(15 downto 0);
    jmpAddr     : in std_logic_vector(15 downto 0);
    PCSrc       : in std_logic;
    jump        : in std_logic;
    
    instruction : out std_logic_vector(15 downto 0);
    PCOut       : out std_logic_vector(15 downto 0)
   );
end InstructionFetch;

architecture Behavioral of InstructionFetch is
    signal PC : std_logic_vector(15 downto 0) := x"0000";
    signal PC1 : std_logic_vector(15 downto 0) := x"0000";
    
    signal reset : std_logic;
    signal NextAddress : std_logic_vector(15 downto 0) := x"0000";
    signal MuxOut : std_logic_vector(15 downto 0);
    
    type rom_type is array(0 to 255) of std_logic_vector(15 downto 0);
    signal ROM : rom_type := (
        B"000_100_001_0000000",       -- ADDI R8, R0, 0               - x"1080"
        B"011_010_000_010_1_010",     -- SLT R10, R8, R17             - x"682A"
        B"101_010_100_0001101",       -- BEQ R10, R0, done (addr 13)  - x"AA0D"
        B"000_100_001_0010000",       -- ADDI R9, R0, 0               - x"1090"
        B"001_000_101_000_1_011",     -- SUB R11, R17, R8             - x"228B"
        B"000_110_111_0111111",       -- ADDI R11, R11, -1            - x"1BBF"  
        B"011_010_011_011_1_100",     -- SLT R12, R9, R11             - x"69BC"    
        B"101_011_000_0001100",       -- BEQ R12, R0, next_i (addr 12)- x"AC0C"  
        B"010_110_010_000_1_101",     -- SLL R13, R9, 1               - x"590D"
        B"000_011_011_101_0_001",     -- ADD R13, R13, R16            - x"0DD1"  
        B"100_011_011_1100000",       -- LW R14, 0(R13)               - x"8DE0"  
        B"100_011_011_1110010",       -- LW R15, 2(R13)                - x"8DF2"  
        B"011_011_101_111_1_010",     -- SLT R10, R14, R15            - x"6EFA"
        B"101_110_100_0001010",       -- BNE R10, R0, skip (addr 10)  - x"BA0A"  
        B"101_011_101_1111010",       -- BEQ R14, R15, skip (addr 10) - x"AEFA"
        B"100_111_011_1110000",       -- SW R15, 0(R13)               - x"9DF0"
        B"100_111_011_1100010",       -- SW R14, 2(R13)               - x"9DE2" 
        B"000_110_011_0010001",       -- ADDI R9, R9, 1               - x"1991"
        B"111_0000000000110",         -- J inner (addr 6)             - x"E006"  
        B"000_110_001_0000001",       -- ADDI R8, R8, 1               - x"1881"
        B"111_0000000000001",         -- J outer (addr 1)             - x"E001"  
        others => X"0000"
    );
    
begin
    -- pc
    process(clk, reset) 
    begin
        
        if reset = '1' then
            PC <= x"0000";
        elsif rising_edge(clk) then 
            if we = '1' then
                PC <= NextAddress;
            end if;
        end if;
        
    end process;
    
    PC1 <= PC + 1;
    PCOut <= PC1;
    
    Instruction <= ROM(conv_integer(PC));
    
    -- MUX branch
    process(PCSrc, PC1, branchAddr) 
    begin
        case(PCSrc) is
            when '0' => MuxOut <= PC1;
            when '1' => MuxOut <= branchAddr;
            when others => MuxOut <= x"0000";
        end case;
    end process;
    
    -- MUX jump
    process(jump, MuxOut, jmpAddr) 
    begin
        case (jump) is
            when '0' => NextAddress <= MuxOut;
            when '1' => NextAddress <= jmpAddr;
            when others => NextAddress <= x"0000";
        end case;
    end process;
    
end Behavioral;
