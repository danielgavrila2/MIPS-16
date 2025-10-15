library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity TX is
  Port (
    tx_data     : in std_logic_vector(7 downto 0);
    clk         : in std_logic;
    rst         : in std_logic;
    tx_en       : in std_logic;
    baud_en     : in std_logic;
    
    tx_out      : out std_logic;
    tx_rdy      : out std_logic
   );
end TX;

architecture Behavioral of TX is

type state_type is (idle, start, bit_state, stop);
signal state : state_type := idle;

signal bit_count : natural := 0;

begin

process(clk, rst) 
begin
    if rst = '1' then
        state <= idle;
    elsif rising_edge(clk) then
        if baud_en = '1' then
            case state is 
                when idle => 
                    if tx_en = '1' then
                        state <= start;
                    else 
                        state <= idle;
                    end if;
                    
                when start =>
                    state <= bit_state;
                    bit_count <= 0;
                
                when bit_state => 
                    if bit_count = 7 then
                        state <= stop;
                    else 
                        state <= bit_state;
                        bit_count <= bit_count + 1;
                    end if;  
                    
                when stop => 
                    state <= idle;           
            end case;
        end if;
    end if;
end process;   

end Behavioral;
