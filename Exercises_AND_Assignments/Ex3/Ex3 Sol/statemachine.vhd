library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateMachine is
Port(
	mclk: in std_logic;
	rst: in std_logic;
	clk_1s: in std_logic;
	push_button: in std_logic;
	leds: out std_logic_vector(2 downto 0));
end StateMachine;

-----------------------------------------
---------- ARCHITECHTURE ----------------
-----------------------------------------

architecture Behavioral of StateMachine is

-----------------------------------------------------
---------- SIGNALS, CONSTANTS, TYPE DEFINITIONS -----
-----------------------------------------------------
signal delay_count	: std_logic_vector(25 downto 0);
signal button_pressed : std_logic;

constant time_delay : integer := 25000000;


------------Embedded system design task -------------------
-- 		Insert here type definition for FLASH_STATE 		--
-- state machine with states: RESET,FLASH1,FLASH2,FLASH3	--
-----------------------------------------------------------

type flash_leds_states is (RESET,FLASH1,FLASH2,FLASH3);
signal FLASH_STATE : flash_leds_states;


------------Embedded system design task -------------------
-- 		Insert here type definition for BUTTON_STATE		--
-- state machine with states: RESET,IDLE,DELAY				--
-----------------------------------------------------------

type button_states is (RESET,IDLE,DELAY);
signal BUTTON_STATE : button_states;

begin

------------Embedded system design task --------------------
-- Create here state machine that increases the amount of --
-- flashing leds. Initially one led should blink.			 --
-- when push button is pressed, the amount of leds 		 --
-- increases by 1. Totally 3 leds should be blinking		 --
-- simultaneously. After this, when the button is pressed,--
-- the amount of flashing leds is reduced back to 1.		 --	
-----------------------------------------------------------

-----------------------------------------------------
----------------- LED FLASH PROCESS -----------------
-----------------------------------------------------


LedFlashStateMachine : process(mclk)
begin

if (rising_edge(mclk)) then
	if (rst = '0') then
		FLASH_STATE <= RESET;
		leds <= (others => '0');
	else
		case FLASH_STATE is
		
		when RESET =>
						FLASH_STATE <= FLASH1;
		when FLASH1 =>
						if button_pressed = '1' then
							leds <= (others => '0');
							FLASH_STATE <= FLASH2;
						else
							leds(0) <= clk_1s; 
						end if;
		when FLASH2 =>
						if button_pressed = '1' then
							leds <= (others => '0');
							FLASH_STATE <= FLASH3;
						else	
							leds(1 downto 0) <= clk_1s & clk_1s;
						end if;
		when FLASH3 =>
						if button_pressed = '1' then
							leds <= (others => '0');
							FLASH_STATE <= FLASH1;
						else				
							leds(2 downto 0) <= clk_1s & clk_1s & clk_1s;
						end if;
			end case;
	end if;
end if;
end process;

-----------------------------------------------------
----------------- BUTTON TIME DELAY -----------------
-----------------------------------------------------

------------Embedded system design task -------------------
-- 		Create here process that creates debouncer		--
-- function for push button. Use state machine structure	--
-- of BUTTON_STATE state machine								--
-----------------------------------------------------------
		

button : process(mclk)
begin
	if rising_edge(mclk) then	
		if (rst = '0') then
			BUTTON_STATE <= RESET;
			button_pressed  <= '0';
		else
			case BUTTON_STATE is
								when RESET => 
												BUTTON_STATE <= IDLE;
				  
								when IDLE =>
												if push_button = '1' then
													button_pressed <= '1';
													BUTTON_STATE <= DELAY;
												else
													button_pressed  <= '0';
												end if;
								when DELAY =>
												if (delay_count = conv_std_logic_vector(time_delay - 1 , 26)) then
													button_pressed  <= '0';
													BUTTON_STATE <= IDLE;
													delay_count <= "00000000000000000000000000";
												else
													delay_count 	<= delay_count + 1;
												end if;
			end case;			
		end if;
	end if;
end process;

end Behavioral;