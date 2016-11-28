----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:20:49 10/05/2015 
-- Design Name: 
-- Module Name:    BtnDelay - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BtnDelay is
    Port ( mclk 	: in  STD_LOGIC;
           rst 	: in  STD_LOGIC;
           button : in  STD_LOGIC;
           button_pressed : out  STD_LOGIC);
end BtnDelay;

architecture Behavioral of BtnDelay is
signal delay_counter : std_logic_vector(25 downto 0);

constant time_delay : integer := 50000000;

type press_button_states is (RESET, IDLE, DELAY);				-- State machine for button debouncer
signal BUTTON_STATE : press_button_states;


begin


button_delay : process(mclk)
begin
	if rising_edge(mclk) then	
	
		if rst = '0' then
			BUTTON_STATE 	<= RESET;								-- Start the state machine at reset
			button_pressed <= '0';
		else

			case BUTTON_STATE is
			
			when RESET => 												
					BUTTON_STATE <= IDLE;			
			
			when IDLE =>												-- In idle observe the push button state
				if button = '1' then								
					button_pressed <= '1';															-- When button is pressed, set button_pressed flag.
					BUTTON_STATE 	<= DELAY;
				end if;
				
			when DELAY =>
					if delay_counter = conv_std_logic_vector(time_delay-1, 26) then	-- wait 1s
						delay_counter 	<= (others => '0');	
						BUTTON_STATE 	<= IDLE;														-- and then go back to IDLE
						button_pressed <= '0';														
					else
						delay_counter 	<= delay_counter + 1;
					end if;
			end case;

		end if;
	end if;

end process;

end Behavioral;

