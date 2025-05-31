----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 05/30/2025 04:26:42 PM
-- Design Name: VGA Sync Generator
-- Module Name: VGA_sync_gen - Behavioral
-- Project Name: VGA Text Display
-- Target Devices: Zedboard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
--      Generates sync signals and (x,y) pixel coordinates for 
--      640x480 @ 60Hz VGA. Includes horizontal and vertical counters,
--      active video region signal (video_on), and reset logic.
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--      Designed to drive 640x480 displays with precise timing. 
--      Sync pulse widths and porch durations match VGA standard.
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

entity VGA_sync_gen is
  Port (
        clk : in std_logic;
        reset : in std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        video_on : out std_logic;
        hcount : out std_logic_vector(9 downto 0); -- 0 to 799
        vcount : out std_logic_vector(9 downto 0)); -- 0 to 524
end VGA_sync_gen;

architecture Behavioral of VGA_sync_gen is
    
    -- VGA timing constants for 604x480 @ 60 Hz
    constant H_DISPLAY : integer := 640; -- visible pixels
    constant H_FRONT_PORCH : integer := 16;
    constant H_SYNC_PULSE : integer := 96;
    constant H_BACK_PORCH : integer := 48;
    constant H_TOTAL : integer := 800; 
    
    constant V_DISPLAY     : integer := 480; -- visible lines
    constant V_FRONT_PORCH : integer := 10;
    constant V_SYNC_PULSE  : integer := 2;
    constant V_BACK_PORCH  : integer := 33;
    constant V_TOTAL       : integer := 525;
    
    signal h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count : integer range 0 to V_TOTAL -1 := 0;
begin
    -- counter process: updates h_count and v_count on each clock cycle
    process(clk,reset)
    begin
        if reset = '1' then
            h_count <= 0;
            v_count <= 0;
        elsif rising_edge(clk) then
            if h_count = H_TOTAL - 1 then
                h_count <= 0;
                if v_count = V_TOTAL -1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
       end if;
    end process;
    -- Generate HSYNC and VSYNC (active high during sync pulse region)
    hsync <= '1' when (h_count >= H_DISPLAY + H_FRONT_PORCH and h_count < H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE) else '0';
    vsync <= '1' when (v_count >= V_DISPLAY + V_FRONT_PORCH and v_count < V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE) else '0';
    
    -- video on only during visible pixel area 640x480
    video_on <= '1' when (h_count < H_DISPLAY and v_count < V_DISPLAY) else '0';
    
    -- Output horizontal and vertical pixel positions
    hcount <= std_logic_vector(to_unsigned(h_count,10)); -- given pixel x
    vcount <= std_logic_vector(to_unsigned(v_count,10));  -- given pixel y
end Behavioral;
