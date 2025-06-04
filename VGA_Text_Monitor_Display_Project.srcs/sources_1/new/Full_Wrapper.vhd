----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 06/04/2025
-- Design Name: Text Rendering Wrapper
-- Module Name: wrapper - Behavioral
-- Project Name: VGA Text Terminal Character Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
-- Top-level wrapper module that instantiates multiple Pixel_On_Text modules to display 
-- hardcoded test strings at specific screen coordinates. Intended for VGA text demonstration.
-- 
-- Dependencies: Pixel_On_Text.vhd, CommonPackage.vhd
-- 
-- Revision:
-- Revision 1.00 - File Created
-- Additional Comments:
-- 
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
library work;
-- this line also is must.This includes the particular package into your program.
use work.CommonPackage.all;

entity wrapper is
  Port (
    clk: in std_logic; -- Clock
    xCoord: in std_logic_vector(11 downto 0);-- 12-buit horiz pixel coord (from VGA sync)
    yCoord: in std_logic_vector(11 downto 0); -- 12-bit vert pixel coord (from VGA sync)
    pixOn: out std_logic -- o/p signal set to '1' when any text pixel is on
   );
end wrapper;

architecture Behavioral of wrapper is
	
	signal h : integer := to_integer(signed(xCoord)); -- converts xCoord to int
	signal v : integer := to_integer(signed(yCoord)); -- Converts yCoord to int
    
    -- results
    signal d1 : std_logic := '0';
    signal d2 : std_logic := '0';
    signal d3 : std_logic := '0';
    
begin

-------------------------------------------
-- Multiple Text Instances
-------------------------------------------
    -- Each one of these check if current pixels position fall inside visible regio
    -- if they are in range and font data bit is 1 its output will be '1'
	textElement1: entity work.Pixel_On_Text
	generic map (
		textLength => 40
	)
	port map(
		clk => clk,
		displayText => "Hello Isai, you managed to display text!",
		position => (50, 50),
		horzCoord => h,
		vertCoord => v,
		pixel => d1
	);
	
	textElement2: entity work.Pixel_On_Text
	generic map (
		textLength => 29
	)
	port map(
		clk => clk,
		displayText => "This is a pretty cool project",
		position => (50, 82),
		horzCoord => h,
		vertCoord => v,
		pixel => d2
	);
	
	textElement3: entity work.Pixel_On_Text
	generic map (
		textLength => 56
	)
	port map(
		clk => clk,
		displayText =>"This project was not easy to do but I finally finihed it",
		position => (50, 114),
		horzCoord => h,
		vertCoord => v,
		pixel => d3
	);
	-- OR Combination Process
	pixelInTextGroup: process(clk)
        begin
            
            if rising_edge(clk) then
                -- the pixel is on when one of the text matched
                -- effectively layers multiple text rendering onto the screen
                pixOn <= d1 or d2 or d3;

            end if;
        end process;

end Behavioral;