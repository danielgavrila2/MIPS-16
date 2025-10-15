library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_new is
    Port ( an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           led : out STD_LOGIC_VECTOR(15 downto 0);
           sw : in  STD_LOGIC_VECTOR(15 downto 0);
           btn : in  STD_LOGIC_VECTOR(4 downto 0);
           clk : in  STD_LOGIC);
end test_new;

architecture Behavioral of test_new is
    
    component mpg is
        Port ( 
            btn : in STD_LOGIC;
            clk : in STD_LOGIC;
            en  : out STD_LOGIC
         );
    end component;
    
    signal cnt : STD_LOGIC_VECTOR(2 downto 0) := "000"; 
    signal o : STD_LOGIC_VECTOR(7 downto 0);
    signal enable : STD_LOGIC;

begin

    button_filter: mpg port map (btn(0), clk, enable);

    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if sw(0) = '1' then
                    cnt <= cnt + 1; 
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    process(cnt)
    begin
        case cnt is
            when "000" => o <= "00000001";
            when "001" => o <= "00000010";
            when "010" => o <= "00000100";
            when "011" => o <= "00001000";
            when "100" => o <= "00010000";
            when "101" => o <= "00100000";
            when "110" => o <= "01000000";
            when "111" => o <= "10000000";
            when others => o <= "00000000";
        end case;
    end process;

    led(7 downto 0) <= o;

end Behavioral;