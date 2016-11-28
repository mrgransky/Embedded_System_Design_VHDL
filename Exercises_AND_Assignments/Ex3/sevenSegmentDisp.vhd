----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:37 11/10/2008 
-- Design Name: 
-- Module Name:    sevenSegmentDisp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegmentDisp is
    Port ( clk : in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR (3 downto 0);
           dataOut : out  STD_LOGIC_VECTOR (6 downto 0);
           rst : in  STD_LOGIC);
end sevenSegmentDisp;

architecture Behavioral of sevenSegmentDisp is

signal dataOutTemp : STD_LOGIC_VECTOR (6 downto 0);

begin

dataOut <= dataOutTemp;

		--      0
		--     ---  
		--  5 |   | 1
		--     ---   <- 6
		--  4 |   | 2
		--     ---
		--      3
		
---------------- Embedded system design task----------------------------------
-- Make here selector using with - select structure in order to present 4-bit
-- dataIn signal in 7-segment display.

-- Hint: Note that the leds in the 7-segment display are inverted =>
-- '0' led is on
-- '1' led is off
-- For example. 0 in 7-segment display is "1000000"
-------------------------------------------------------------------------------

			

end Behavioral;

