----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/30/2025 05:16:16 PM
-- Design Name: Top-Level VGA Text Display
-- Module Name: vga_text_top - Behavioral
-- Project Name: VGA Text Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
--      Top-level module that integrates all components required to display
--      ASCII text on a 640x480 VGA monitor. It connects the clock wizard,
--      VGA sync generator, and text renderer. Outputs hsync, vsync, and 3-bit RGB.
--
-- Dependencies: VGA_sync_gen.vhd, text_renderer.vhd, font_rom.vhd, char_rom.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--      Accepts 100 MHz input clock and reset. Uses Clock Wizard to generate
--      the 25 MHz VGA pixel clock.
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

entity vga_text_top is
  Port (
        clk : in std_logic; -- 100MHz clock from zedboard
        reset : in std_logic; -- reset signal from button
        hsync : out std_logic; -- VGA horizontal sync
        vsync : out std_logic; -- VGA vertical sync
        led : out std_logic; -- led indicator for locked 
        rgb : out std_logic_vector(2 downto 0) -- VGA color output     
        );
end vga_text_top;

architecture Behavioral of vga_text_top is
    -- Signals between components
    -- VGA timing signals
    signal hcount, vcount : std_logic_vector(9 downto 0);
    signal video_on : std_logic;
    
    -- Text renderer connections
    signal char_code : std_logic_vector(7 downto 0);
    signal char_addr : std_logic_vector(12 downto 0);
    signal char_data : std_logic_vector(7 downto 0);
    signal glyph_row : std_logic_vector(2 downto 0);
    signal pixel_row : std_logic_vector(7 downto 0);
    
    -- Clock wizard signals
    signal clk25MHz : std_logic;
    signal locked : std_logic;
    
    component clock_wizard
        port (
            clk_in1 : in std_logic;
            clk_out1 : out std_logic;
            resetn : in std_logic;
            locked : out std_logic);
    end component;   
begin
    clk_gen : clock_wizard
        port map (
            clk_in1 => clk, -- 100MHz clock fed into clock_wizard
            clk_out1 => clk25MHz, -- from clock wizard a 25.175MHz clock is outputed via MCMM to all other modules
            resetn => '1', -- active low reset
            locked => locked -- locked signal to make sure MCMM is producing stable and reliable clock
            );
    -- 1. VGA sync generator
    vga_sync_inst : entity work.vga_sync_gen -- uses 25.175MHz clock to generate pixel positions and sync signals
        port map (
                clk => clk25MHz, -- 25.175MHz clock fed from clock_wizard
                reset => reset, -- 
                hsync => hsync,
                vsync => vsync,
                video_on => video_on,
                hcount => hcount,
                vcount => vcount
                );
     -- 2. Character ROM provide preloaded "HELLO FPGA"
     char_rom_inst : entity work.char_rom 
        port map (
                clk => clk25MHz,
                addr => char_addr,
                data_out => char_data
                );
      -- Text Renderer: maps VGA (x,y) to character glyphs and sets pixel color
      text_renderer_inst : entity work.text_renderer
        port map (
                clk => clk25MHz,
                reset  => reset,
                hcount => hcount,
                vcount => vcount,
                video_on => video_on,
                rgb => rgb,
    
                char_code => char_code,
                char_addr => char_addr,
                char_data => char_data,
    
                glyph_row => glyph_row,
                pixel_bits => pixel_row
                );
               
      -- Font ROM (maps ASCII char + row to 8 pixels
      font_rom_inst: entity work.font_rom
        port map (
            clk => clk25MHz,
            char_code => char_code,
            row_index => glyph_row,
            pixel_row => pixel_row
            );
      led <= locked;
end Behavioral;
