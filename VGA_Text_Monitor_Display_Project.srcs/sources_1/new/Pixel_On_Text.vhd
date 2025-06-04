----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 06/04/2025
-- Design Name: Pixel Text Rendering Logic
-- Module Name: Pixel_On_Text - Behavioral
-- Project Name: VGA Text Terminal Character Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
-- Determines whether a pixel should be lit ('1') based on the character's bitmap and
-- its location on the screen. Uses Font_ROM for pixel data and accepts a string input
-- with a top-left position for display.
-- 
-- Dependencies: Font_ROM.vhd, CommonPackage.vhd
-- 
-- Revision:
-- Revision 1.00 - File Created
-- Additional Comments:
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work;
-- this line also is must.This includes the particular package into your program.
use work.CommonPackage.all;

entity Pixel_On_Text is
	generic(
	   -- Sets num of chars to render from DisplayText
       textLength: integer := 11
	);
	port (
		clk: in std_logic; -- Clock
		displayText: in string (1 to textLength) := (others => NUL); -- Text wanted to be displayed
		-- top left corner of where to start rendering text
		position: in point_2d := (0, 0);
		-- current pixel postion
		horzCoord: in integer; -- current horizontal pixel coordinate on screen
		vertCoord: in integer; -- current vertical pixel coordinate on screen
		
		pixel: out std_logic := '0' -- output '1' of pixel is part of char, else '0'
	);

end Pixel_On_Text;

architecture Behavioral of Pixel_On_Text is
    -- Vertical row of pixels from the character bitmap
	signal fontAddress: integer;
	-- A row of bit in a charactor, we check if our current (x,y) is 1 in char row
	signal charBitInRow: std_logic_vector(FONT_WIDTH-1 downto 0) := (others => '0');
	-- char in ASCII code
	signal charCode:integer := 0;
	-- the position(column) of a character in the given text
	signal charPosition:integer := 0;
	-- the bit position(column) in a character
	signal bitPosition:integer := 0;
begin
    -- (horzCoord - position.x): x positionin the top left of the whole text
    charPosition <= (horzCoord - position.x)/FONT_WIDTH + 1;
    bitPosition <= (horzCoord - position.x) mod FONT_WIDTH;
    charCode <= character'pos(displayText(charPosition));
    -- charCode*16: first row of the char
    fontAddress <= charCode*16+(vertCoord - position.y);

    -- Instantiates Font_Rom.vhd to retrieve one 8-bit row of pixels
    -- for the current char
	fontRom: entity work.Font_Rom
	port map(
		clk => clk,
		addr => fontAddress,
		fontRow => charBitInRow
	);
	
	-- Pixel Logic Proces
	pixelOn: process(clk)
		variable inXRange: boolean := false; -- Are we within text's width(textLength*FONT_WIDTH)?
		variable inYRange: boolean := false; -- Are we within the text's height(FONT_HEIGHT)?
	begin
        if rising_edge(clk) then
            
            -- reset
            inXRange := false;
            inYRange := false;
            pixel <= '0';
            -- If current pixel is in the horizontal range of text
            if horzCoord >= position.x and horzCoord < position.x + (FONT_WIDTH * textlength) then
                inXRange := true;
            end if;
            
            -- If current pixel is in the vertical range of text
            if vertCoord >= position.y and vertCoord < position.y + FONT_HEIGHT then
                inYRange := true;
            end if;
            
            -- check if pixel is on for text display
            if inXRange and inYRange then
                if charBitInRow(FONT_WIDTH-bitPosition) = '1' then
                    pixel <= '1';
                end if;					
            end if;

		end if;
	end process;

end Behavioral;
