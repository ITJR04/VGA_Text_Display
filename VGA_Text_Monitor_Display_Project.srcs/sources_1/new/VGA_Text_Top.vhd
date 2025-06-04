----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 06/04/2025
-- Design Name: Top-Level VGA Text System
-- Module Name: VGA_Text_Top - Behavioral
-- Project Name: VGA Text Terminal Character Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
-- Top-level system for text-based VGA output. Instantiates clock generator (25MHz),
-- VGA sync generator, and text display wrapper module to draw hardcoded strings.
-- 
-- Dependencies: wrapper.vhd, vga_sync.vhd, clocking_wizard.xci
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

entity VGA_Text_Top is
  Port (
        clk_100MHz : in std_logic;
        reset : in std_logic;
        
        hsync : out std_logic;
        vsync : out std_logic;
        red : out std_logic_vector(2 downto 0);
        green : out std_logic_vector(2 downto 0);
        blue: out std_logic_vector(2 downto 0) );
end VGA_Text_Top;

architecture Behavioral of VGA_Text_Top is
        -- Clock signal after Clock Wizard (25.175 MHz)
        signal clk_25MHz : std_logic;
        signal locked : std_logic;
        -- VGA timing signals
        signal xCoord, yCoord : std_logic_vector(11 downto 0);
        signal video_on : std_logic;
        
        -- Output from text renderer
        signal pixel_on_text : std_logic;
        
begin
----------------------------------------------------------------
    -- Clocking Wizard instance (assumes you created one in Vivado)
    ----------------------------------------------------------------
    clocking_wizard_inst: entity work.clocking_wizard
        port map(
            clk_in1 => clk_100MHz,
            clk_out1 => clk_25MHz,
            resetn => '1',
            locked => locked
            );
    ----------------------------------------------------------------
    -- VGA Timing Generator
    ----------------------------------------------------------------
    vga_sync_inst : entity work.vga_sync
        port map (
            clk       => clk_25MHz,
            reset     => reset,
            hsync     => hsync,
            vsync     => vsync,
            video_on  => video_on,
            xCoord    => xCoord,
            yCoord    => yCoord
        );

    ----------------------------------------------------------------
    -- VGA Text Rendering (Wrapper)
    ----------------------------------------------------------------
    text_display : entity work.wrapper
        port map (
            clk    => clk_25MHz,
            xCoord => xCoord,
            yCoord => yCoord,
            pixOn  => pixel_on_text
        );

    ----------------------------------------------------------------
    -- VGA RGB Output Logic
    ----------------------------------------------------------------
    process(clk_25MHz)
    begin
        if rising_edge(clk_25MHz) then
            if video_on = '1' and pixel_on_text = '1' then
                red   <= "111";
                green <= "111";
                blue  <= "111";
            else
                red   <= "000";
                green <= "000";
                blue  <= "000";
            end if;
        end if;
    end process;

end Behavioral;
