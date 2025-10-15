library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity ROM is
  generic (
    addr_length : natural := 8;
    data_length : natural := 16
  );  

  Port (
    clk      : in std_logic;
    en       : in std_logic;
    addr     : in std_logic_vector((addr_length - 1) downto 0);
    data_out : out std_logic_vector((data_length - 1) downto 0)
   );
end ROM;

architecture Behavioral of ROM is

type rom_type is array(0 to (2**(addr_length) - 1)) of std_logic_vector((data_length - 1) downto 0);

constant memory : rom_type := 
(
    x"0000",
    x"0001",
    x"0002",
    x"0003"
);

begin

    process(clk)
    begin
        
        if rising_edge(clk) then
            if en = '1' then
                data_out <= memory(conv_integer(addr));
            end if;
        end if;
        
    end process;

end Behavioral;
