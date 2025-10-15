library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
    Port ( 
        clk  : in STD_LOGIC;
        btn  : in STD_LOGIC_VECTOR (4 downto 0);
        sw   : in STD_LOGIC_VECTOR (15 downto 0);
        led  : out STD_LOGIC_VECTOR (15 downto 0);
        an   : out STD_LOGIC_VECTOR (7 downto 0);
        cat  : out STD_LOGIC_VECTOR (6 downto 0)
    );
end test_env;

    architecture Behavioral of test_env is

    component mpg 
        Port(
            btn  : in std_logic;
            clk  : in std_logic;
            en   : out std_logic
        );
    end component;

    component SSD
        port( clk: in STD_LOGIC;
            digits: in STD_LOGIC_VECTOR(15 DOWNTO 0);
            an: out STD_LOGIC_VECTOR(7 DOWNTO 0);
            cat: out STD_LOGIC_VECTOR(6 DOWNTO 0);
            vec: in std_logic_vector(15 downto 0));
    end component;
    
    component InstructionFetch 
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
    end component;
    
    component InstructionDecode 
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
    end component;
    
    component MainControl 
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
    end component;
    
    component ExecuteUnit 
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
    end component;
    
    component MEM 
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
    end component;
    
   
signal Instr, PCOut, RD1, RD2, WD, ExtImm               : std_logic_vector(15 downto 0);
signal JumpAddr, BranchAddr, ALURes, ALURes1, MemData   : std_logic_vector(15 downto 0);
signal func                                             : std_logic_vector(2 downto 0);
signal sa, zero                                         : std_logic;
signal digits, sortat                                   : std_logic_vector(15 downto 0);
signal en, rst, PCSrc                                   : std_logic;

--controllers
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemToReg, RegWrite : std_logic; 
signal ALUOp : std_logic_vector(2 downto 0);  
   
    
begin

    button_filter : mpg port map (
        btn => btn(0),
        clk => clk,
        en  => en
    );
    
    
    display: SSD port map(
        clk     => clk,
        digits  => digits,
        an      => an,
        cat     => cat,
        vec     => sortat
    ); 
    
    --main units
    IF_UNIT: InstructionFetch port map (
        clk         => clk,
        rst         => rst,
        we          => en,
        branchAddr  => BranchAddr,
        jmpAddr     => JumpAddr,
        PCSrc       => PCSrc,
        jump        => Jump,
        
        instruction => Instr,
        PCOut       => PCOut
    );
    
    ID_UNIT: InstructionDecode port map (
        clk         => clk,
        en          => en,
        instr       => Instr,
        regWrite    => RegWrite,
        regDst      => RegDst,
        writeData   => WD,
        extOp       => ExtOp,
        
        readData1   => RD1,
        readData2   => RD2,
        extImm      => ExtImm,
        func        => func,
        sa          => sa
    );

    MC_UNIT: MainControl port map (
        instr       => Instr(15 downto 13),
        
        regWrite    => RegWrite,
        regDst      => RegDst,
        extOp       => ExtOp,
        jump        => Jump,
        branch      => Branch,
        ALUsrc      => ALUSrc,
        ALUop       => ALUOp,
        memWrite    => MemWrite,
        memToReg    => MemToReg
    );
    
    EX_UNIT: ExecuteUnit port map (
        PCOut       => PCOut,
        RD1         => RD1,
        RD2         => RD2,
        ExtImm      => ExtImm,
        func        => func,
        sa          => sa,
        ALUSrc      => ALUSrc,
        ALUOp       => ALUOp,
        
        ALURes      => ALURes,
        BranchAddr  => BranchAddr,
        ZeroSignal  => zero
    );
    
    MEM_UNIT: MEM port map (
        clk         => clk,
        en          => en,
        ALUResIn    => ALURes,
        RD2         => RD2,
        MemWrite    => MemWrite,
        
        MemData     => MemData,
        ALUResOut   => ALURes1,
        Number      => sortat
    );
    
    WD <= MemData when MemToReg = '1' else ALURes1;
    
    PCSrc <= zero and Branch;
    
    JumpAddr <= PCOut(15 downto 14) & Instr(13 downto 0);
    
    with sw(7 downto 5) select
        digits <=  Instr when "000", 
                   PCOut when "001",
                   RD1 when "010",
                   RD2 when "011",
                   ExtImm when "100",
                   ALURes when "101",
                   MemData when "110",
                   WD when "111",
                   (others => 'X') when others; 
                   
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;
