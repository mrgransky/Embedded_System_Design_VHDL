----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:44 09/16/2014 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port 
	 ( 
			mclk : in  STD_LOGIC;
			rst : in  STD_LOGIC;
         btn : in  STD_LOGIC_VECTOR (3 downto 0);
         sw : in  STD_LOGIC_VECTOR (7 downto 0);
         led : out  STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
	
	component TimeManager is
		Port 
		( 
			mclk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           led : out  STD_LOGIC;
			  clk_100 : out std_logic;
			  debug : out std_logic_vector(15 downto 0)
		);
	end component;

signal clk_100k :  std_logic;
signal debug : std_logic_vector(15 downto 0);

begin

	tmanag: TimeManager 
	
	port map (
		mclk => mclk,
		rst => rst,
		led => led(1),
		clk_100 => clk_100k,
		debug => debug);

--Mapping the switches to unused leds. 
led(7 downto 2) <= sw(7 downto 2);
led(0) <= sw(0);

end Behavioral;

