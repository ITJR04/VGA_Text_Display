-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 06/04/2025
-- Design Name: VGA Sync Generator
-- Module Name: vga_sync - Behavioral
-- Project Name: VGA Text Terminal Character Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
-- Generates horizontal and vertical sync signals, video enable signal, and pixel coordinates
-- for a 640x480 resolution VGA display running at 60Hz with 25 MHz pixel clock.
-- 
-- Dependencies: None
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

entity vga_sync is
    Port (
        clk       : in  std_logic; -- 25.175 MHz clock
        reset     : in  std_logic;  -- synchronous reset
        hsync     : out std_logic;
        vsync     : out std_logic;
        video_on  : out std_logic;  -- high when pixel is visible
        xCoord    : out std_logic_vector(11 downto 0); -- horizontal position
        yCoord    : out std_logic_vector(11 downto 0)  -- vertical position
    );
end vga_sync;

architecture Behavioral of vga_sync is

    -- VGA timing constants
    constant H_DISPLAY : integer := 640;
    constant H_FRONT   : integer := 16;
    constant H_SYNC    : integer := 96;
    constant H_BACK    : integer := 48;
    constant H_TOTAL   : integer := 800;

    constant V_DISPLAY : integer := 480;
    constant V_FRONT   : integer := 10;
    constant V_SYNC    : integer := 2;
    constant V_BACK    : integer := 33;
    constant V_TOTAL   : integer := 525;

    -- counters
    signal h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count : integer range 0 to V_TOTAL - 1 := 0;

begin

    -- Horizontal and vertical counters
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                h_count <= 0;
                v_count <= 0;
            else
                if h_count = H_TOTAL - 1 then
                    h_count <= 0;
                    if v_count = V_TOTAL - 1 then
                        v_count <= 0;
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Generate sync signals (active low)
    hsync <= '0' when (h_count >= H_DISPLAY + H_FRONT and h_count < H_DISPLAY + H_FRONT + H_SYNC) else '1';
    vsync <= '0' when (v_count >= V_DISPLAY + V_FRONT and v_count < V_DISPLAY + V_FRONT + V_SYNC) else '1';

    -- Visible region
    video_on <= '1' when (h_count < H_DISPLAY and v_count < V_DISPLAY) else '0';

    -- Output pixel coordinates
    xCoord <= std_logic_vector(to_unsigned(h_count, 12));
    yCoord <= std_logic_vector(to_unsigned(v_count, 12));

end Behavioral;