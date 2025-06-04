----------------------------------------------------------------------------------
-- Company: University of Connecticut
-- Engineer: Isai Torres
-- 
-- Create Date: 06/04/2025
-- Design Name: Common Constants and Types
-- Module Name: CommonPackage - Package
-- Project Name: VGA Text Terminal Character Display
-- Target Devices: ZedBoard Zynq-7000
-- Tool Versions: Vivado 2024.2
-- Description: 
-- Contains global constants (like FONT_WIDTH and FONT_HEIGHT) and data structures 
-- (such as 2D point type) used across VGA display modules.
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
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Package that will be needed to be used across the used VHDL files
package commonPackage is
	
	-------------------------------------------------------
	-- Global Configuration Constants
	-------------------------------------------------------
	-- Address and Data width used for memory-mapped access
	constant ADDR_WIDTH : integer := 11;
	constant DATA_WIDTH : integer := 8;
	-- each Character is 8 pixels wide and 16 pixels tall
	constant FONT_WIDTH : integer := 8;
	constant FONT_HEIGHT : integer := 16;
	
	
	-------------------------------------------------------
	-- 2D Geometry Types
	-------------------------------------------------------
	-- 2D point type - used to represent coordinates
	-- used for pixel or character position
	type point_2d is
	record
		x : integer;
		y : integer;
	end record;

    -- Array to define color mapping
	type type_textColorMap is array(natural range <>) of std_logic_vector(7 downto 0); 
	
	-------------------------------------------------------
	-- Drawable Pixel Information
	-------------------------------------------------------

	-- Describes one drawable pixel
	-- pixelOn tells if it should be lit
	-- rgb stores color information
	type type_drawElement is
	record
		pixelOn: boolean;
		rgb: std_logic_vector(7 downto 0);
	end record;
	
	-- default blank pixel (black)
	constant init_type_drawElement: type_drawElement := (pixelOn => false, rgb => (others => '0'));
	-- Array of drawable elements
	type type_drawElementArray is array(natural range <>) of type_drawElement; 
	

	-------------------------------------------------------
	-- Arbiter Bus Types for Character Memory Access
	-------------------------------------------------------
    -- Bus interface for Arbiter Ports
    
    --Input Port
    -- i/p port struct to a mem-mapped arbiter sys
        -- Request a r/w to an addr
        -- Contains write data if needed
	type type_inArbiterPort is
	record
		dataRequest: boolean;
		addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
		writeRequest: boolean;
		writeData: std_logic_vector(DATA_WIDTH-1 downto 0);
	end record;
	
	-- default state idle/no transaction
	constant init_type_inArbiterPort: type_inArbiterPort := (
	   dataRequest => false,
	   addr => (others => '0'),
	   writeRequest => false,
	   writeData  => (others => '0'));
	-- Array of input ports
	type type_inArbiterPortArray is array(natural range <>) of type_inArbiterPort;
	
	-- Output Port
	-- Ouput Port struct for arbiter
	   -- indicates if data is ready(dataWaiting)
	   -- Carries the read data or write status
	type type_outArbiterPort is
	record
		dataWaiting: boolean;
		data: std_logic_vector(DATA_WIDTH-1 downto 0);
		dataWritten: boolean;
	end record;
	
	-- Default no o/p ready state
	constant init_type_outArbiterPort: type_outArbiterPort := (dataWaiting => false, data => (others => '0'), dataWritten => false);
	-- Array of o/ps for multiple memory clients
	type type_outArbiterPortArray is array(natural range <>) of type_outArbiterPort;


	-------------------------------------------------------
	-- Utility Functions
	-------------------------------------------------------
    --Declares a helper func to compute log base 2 of a num
	function log2_float(val : positive) return natural;

end CommonPackage;
-- Package Body
-- Implements log2_float()
    -- Converts val to real
    -- takes log2(), rounds up, converts to int
package body CommonPackage is
	function log2_float(val : positive) return natural is
	begin
		return integer(ceil(log2(real(val))));
	end function;
end CommonPackage;