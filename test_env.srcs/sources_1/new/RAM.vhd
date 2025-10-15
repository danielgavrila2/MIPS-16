----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2025 12:21:21 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity RAM is
  Port (
    clk     : in std_logic;
    we      : in std_logic;
    en      : in std_logic;
    addr    : in std_logic_vector(7 downto 0);
    di      : in std_logic_vector(15 downto 0);
    do      : out std_logic_vector(15 downto 0)
   );
end RAM;

architecture Behavioral of RAM is

type ram_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal ram_memory : ram_type;

begin

    process(clk)
    begin
    
        if rising_edge(clk) then
            if en = '1' then
                if we = '1' then
                    ram_memory(conv_integer(addr)) <= di;
                else
                    do <= ram_memory(conv_integer(addr));
                end if;
            end if;
        end if;
    
    end process;

end Behavioral;
