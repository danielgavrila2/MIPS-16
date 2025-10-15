library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en  : out STD_LOGIC);
end mpg;
 
architecture Behavioral of MPG is

signal cnt_int : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
signal Q1, Q2, Q3 : STD_LOGIC;

begin

    en <= Q2 and (not Q3);

    process(clk)
    begin
        if rising_edge(clk) then
            cnt_int <= cnt_int + 1;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if cnt_int(17 downto 0) = "111111111111111111" then
                Q1 <= btn;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;

end Behavioral;