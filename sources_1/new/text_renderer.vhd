----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/21/2025
-- Design Name: Text Renderer
-- Module Name: text_renderer - Behavioral
-- Project Name: VGA Text Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: Renders characters from char_rom using font_rom onto VGA output.
--
-- Dependencies: char_rom.vhd, font_rom.vhd, vga_sync.vhd
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Outputs RGB (white text on black background)
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

entity text_renderer is
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           hcount : in STD_LOGIC_VECTOR (9 downto 0); -- from vga_sync
           vcount : in STD_LOGIC_VECTOR (9 downto 0); -- from vga_sync
           video_on : in STD_LOGIC;     -- active screen area
           rgb : out std_logic_vector(2 downto 0); -- VGA RGB output (white or black)
           
           -- char_rom interface
           char_data : in STD_LOGIC_VECTOR (7 downto 0);
           char_code : out std_logic_vector(7 downto 0);
           char_addr : out STD_LOGIC_VECTOR (12 downto 0); -- from char_rom
           
            -- font_rom interface
            glyph_row  : out std_logic_vector(2 downto 0);
            pixel_bits : in  std_logic_vector(7 downto 0)   -- from font_rom
        );
end text_renderer;

architecture Behavioral of text_renderer is
    signal char_col,char_row : unsigned(6 downto 0); -- 0 to 79, 0 to 59
    signal x_offset : unsigned(2 downto 0);
    signal y_offset : unsigned(2 downto 0);
    signal pixel_bit : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rgb <= "000";  -- black screen
            else
                -- Step 1: compute char position and pixel offsets
                char_col <= unsigned(hcount(9 downto 3)); -- hcount / 8
                char_row  <= unsigned(vcount(9 downto 3)); -- vcount / 8
                x_offset <= unsigned(hcount(2 downto 0)); -- hcount % 8
                y_offset <= unsigned(vcount(2 downto 0)); -- vcount % 8

                -- compute character address
                char_addr <= std_logic_vector(resize(char_row * 80 + char_col,13));

                -- connect char output to font ROM
                char_code  <= char_data;
                glyph_row  <= std_logic_vector(y_offset);


                -- select 1 bit in glyph row for this pixel
                if x_offset <= 7 then
                    pixel_bit <= pixel_bits(7 - to_integer(x_offset));
                else
                    pixel_bit <= '0';
                end if;

                -- final color output
                if video_on = '1' and pixel_bit = '1' then
                    rgb <= "111";  -- white text
                else
                    rgb <= "000";  -- black background
                end if;
            end if;
        end if;
    end process;
end Behavioral;
