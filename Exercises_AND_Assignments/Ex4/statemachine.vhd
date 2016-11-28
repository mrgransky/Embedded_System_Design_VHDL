library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateMachine is
Port(
	mclk			: in std_logic;
	rst			: in std_logic;
	clk_1s		: in std_logic;
	push_button	: in std_logic;
	leds			: out std_logic_vector(2 downto 0)
	);
end StateMachine;


architecture Behavioral of StateMachine is

-----------------------------------------------------
---------- SIGNALS, CONSTANTS, TYPE DEFINITIONS -----
-----------------------------------------------------
signal button_pressed : std_logic;
signal delay_counter : std_logic_vector(25 downto 0);

constant time_delay : integer := 25000000;

-- Exercise 4:
--	Insert here type definition for FLASH_STATE 		
-- state machine with states: RESET,FLASH1,FLASH2,FLASH3	--

type flash_leds_states is (RESET, FLASH1, FLASH2, FLASH3); 	-- State machine for led flashing
signal FLASH_STATE : flash_leds_states;

-- Exercise 4:
-- Insert here type definition for BUTTON_STATE		
-- state machine with states: RESET,IDLE,DELAY				

type press_button_states is (RESET, IDLE, DELAY);				-- State machine for button debouncer
signal BUTTON_STATE : press_button_states;

begin

-- Exercise 4:
-- Create here state machine that increases the amount of --
-- flashing leds. Initially one led should blink.			 --
-- when push button is pressed, the amount of leds 		 --
-- increases by 1. Totally 3 leds should be blinking		 --
-- simultaneously. After this, when the button is pressed,--
-- the amount of flashing leds is reduced back to 1.		 --	

-----------------------------------------------------
----------------- LED FLASH PROCESS -----------------
-----------------------------------------------------


LedFlashStateMachine : process(mclk)
begin

if (rising_edge(mclk)) then
   if rst = '0' then
		FLASH_STATE <= RESET;		-- On reset, the State machine is started
		leds <= (others => '0');
	else
	
		case FLASH_STATE is							-- Case - When structure is convenient for state machine
		
		when RESET => FLASH_STATE <= FLASH1; 
		
		when FLASH1 =>									
			if button_pressed = '1' then		-- Follow button pressed flag to change state. button_pressed is controlled in _button_ process
				leds <= (others => '0');
				FLASH_STATE <= FLASH2;			
			else
				leds(0) <= clk_1s;				-- set clk_1s to flash led.
				
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
				leds(2 downto 0) <= (clk_1s & clk_1s & clk_1s);
			end if;
			
		end case;
	end if;

end if;
end process;

-----------------------------------------------------
----------------- BUTTON TIME DELAY -----------------
-----------------------------------------------------

--Exercise 4:
--Create here process that creates debouncer		
--function for push button. Use state machine structure	
--of BUTTON_STATE state machine								
		

button : process(mclk)
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
				if push_button = '1' then								
					button_pressed <= '1';															-- When button is pressed, set button_pressed flag.
					BUTTON_STATE 	<= DELAY;
				end if;
				
			when DELAY =>
				button_pressed <= '0';																-- button_pressed signal is high only one mclk cycle.
					if delay_counter = conv_std_logic_vector(time_delay-1, 26) then	-- wait 0.5s
						delay_counter 	<= (others => '0');	
						BUTTON_STATE 	<= IDLE;														-- and then go back to IDLE
					else
						delay_counter 	<= delay_counter + 1;
					end if;
			end case;

		end if;
	end if;

end process;

end Behavioral;

