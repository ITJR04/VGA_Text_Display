----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/21/2025
-- Design Name: ASCII Font ROM
-- Module Name: font_rom - Behavioral
-- Project Name: VGA Text Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: Returns an 8-bit row of a glyph for a given ASCII char and row index
--
-- Dependencies: None
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Supports basic 8x8 font for chars used in "HELLO FPGA"
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

entity font_rom is
  Port (
      clk : in std_logic;
      char_code : in std_logic_vector(7 downto 0); --ASCII code
      row_index : in std_logic_vector(2 downto 0); -- row within 8x8 glyph
      pixel_row : out std_logic_vector(7 downto 0)); -- 1-bit per pixel row
end font_rom;

architecture Behavioral of font_rom is
    type rom_array is array(0 to 1023) of std_logic_vector(7 downto 0); -- 128 chars × 8 rows
    signal rom : rom_array := (
        -- SPACE ASCII 32
        32*8 + 0 => "00000000", 32*8 + 1 => "00000000",
        32*8 + 2 => "00000000", 32*8 + 3 => "00000000",
        32*8 + 4 => "00000000", 32*8 + 5 => "00000000",
        32*8 + 6 => "00000000", 32*8 + 7 => "00000000",

        -- 'A' ASCII 65
        65*8 + 0 => "00011000", 65*8 + 1 => "00100100",
        65*8 + 2 => "01000010", 65*8 + 3 => "01000010",
        65*8 + 4 => "01111110", 65*8 + 5 => "01000010",
        65*8 + 6 => "01000010", 65*8 + 7 => "00000000",

        -- 'E' ASCII 69
        69*8 + 0 => "01111110", 69*8 + 1 => "01000000",
        69*8 + 2 => "01000000", 69*8 + 3 => "01111100",
        69*8 + 4 => "01000000", 69*8 + 5 => "01000000",
        69*8 + 6 => "01111110", 69*8 + 7 => "00000000",

        -- 'F' ASCII 70
        70*8 + 0 => "01111110", 70*8 + 1 => "01000000",
        70*8 + 2 => "01000000", 70*8 + 3 => "01111100",
        70*8 + 4 => "01000000", 70*8 + 5 => "01000000",
        70*8 + 6 => "01000000", 70*8 + 7 => "00000000",

        -- 'G' ASCII 71
        71*8 + 0 => "00111100", 71*8 + 1 => "01000000",
        71*8 + 2 => "01000000", 71*8 + 3 => "01001110",
        71*8 + 4 => "01000010", 71*8 + 5 => "01000010",
        71*8 + 6 => "00111100", 71*8 + 7 => "00000000",

        -- 'H' ASCII 72
        72*8 + 0 => "01000010", 72*8 + 1 => "01000010",
        72*8 + 2 => "01000010", 72*8 + 3 => "01111110",
        72*8 + 4 => "01000010", 72*8 + 5 => "01000010",
        72*8 + 6 => "01000010", 72*8 + 7 => "00000000",

        -- 'L'
        76*8 + 0 => "01000000", 76*8 + 1 => "01000000",
        76*8 + 2 => "01000000", 76*8 + 3 => "01000000",
        76*8 + 4 => "01000000", 76*8 + 5 => "01000000",
        76*8 + 6 => "01111110", 76*8 + 7 => "00000000",

        -- 'O' ASCII 79
        79*8 + 0 => "00111100", 79*8 + 1 => "01000010",
        79*8 + 2 => "01000010", 79*8 + 3 => "01000010",
        79*8 + 4 => "01000010", 79*8 + 5 => "01000010",
        79*8 + 6 => "00111100", 79*8 + 7 => "00000000",

        -- 'P' ASCII 80
        80*8 + 0 => "01111100", 80*8 + 1 => "01000010",
        80*8 + 2 => "01000010", 80*8 + 3 => "01111100",
        80*8 + 4 => "01000000", 80*8 + 5 => "01000000",
        80*8 + 6 => "01000000", 80*8 + 7 => "00000000",

        others => "00000000"  -- default: blank
    );


begin
    process(clk)
        variable index : integer;
    begin
        if rising_edge(clk) then
            index := to_integer(unsigned(char_code) * 8 + unsigned(row_index));
            pixel_row <= rom(index);
        end if;
    end process;
end Behavioral;
