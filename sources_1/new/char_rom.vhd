----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/21/2025
-- Design Name: Character ROM
-- Module Name: char_rom - Behavioral
-- Project Name: VGA Text Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
--      ROM storing fixed ASCII message:
--      "HELLO FPGA" centered on row 0
--
-- Dependencies: None
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- ROM size = 4800 entries (80 cols × 60 rows)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity char_rom is
    Port (
        clk      : in  std_logic;
        addr     : in  std_logic_vector(12 downto 0);  -- 13 bits for 0-4799
        data_out : out std_logic_vector(7 downto 0)    -- ASCII output
    );
end char_rom;

architecture Behavioral of char_rom is
    -- Defined ROM type : 4800 entries of 8-bit ASCII
    type rom_type is array(0 to 4799) of std_logic_vector(7 downto 0);
    signal rom : rom_type := (
        -- Row 0: insert "HELLO FPGA" from col 35 to 44
        0 to 34    => x"20", -- spaces
        35         => x"48", -- H
        36         => x"45", -- E
        37         => x"4C", -- L
        38         => x"4C", -- L
        39         => x"4F", -- O
        40         => x"20", -- space
        41         => x"46", -- F
        42         => x"50", -- P
        43         => x"47", -- G
        44         => x"41", -- A
        45 to 79   => x"20", -- rest of row 0 spaces
        80 to 4799 => x"20"  -- rows 1-59: all spaces
    );

begin
    -- ROM read process (synchronous)
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= rom(to_integer(unsigned(addr)));
        end if;
    end process;

end Behavioral;