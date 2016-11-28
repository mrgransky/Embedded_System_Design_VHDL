
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TimeManager is
    Port ( mclk 	: in  STD_LOGIC;
           rst 	: in  STD_LOGIC;
           led 	: out  STD_LOGIC;
			  clk_1	: out STD_LOGIC;	--Exercise3
			  clk_500: out STD_LOGIC;	--Exercise3
			  clk_100: out std_logic;									-- For simulation purposes
			  debug 	: out std_logic_vector(15 downto 0));		-- For simulation purposes
end TimeManager;

architecture Behavioral of TimeManager is

signal clk_100k_counter	: std_logic_vector(11 downto 0);
signal blink_counter		: std_logic_vector(15 downto 0);
signal clk_500_counter	: std_logic_vector(15 downto 0); --Exercise 3
signal clk_100k			: std_logic := '0';			
signal blink_led			: std_logic := '0';
signal clk_500Hz			: std_logic := '0';					--Exercise 3

--EMBEDDED SYSTEM DESIGN: 
-- Constant values for counter. These are defined as integers, which must be later on converted into std_logic_vector.

constant end_value			: integer := 250;		
constant end_value_500		: integer := 50000; --Exercise 3: Counting with 50 MHz clock up to 50k, in order to obtain 500 Hz clock
constant end_value_blink	: integer := 50000;

begin

clk100k_process: process(mclk,rst)
begin		
	if (rising_edge(mclk)) then
		if (rst = '0') then
			clk_100k_counter 	<= (others => '0');
			clk_100k 			<= '0';
		else
			if (clk_100k_counter =  conv_std_logic_vector(end_value-1, 12)) then
				clk_100k 			<= not clk_100k;
				clk_100k_counter 	<= (others => '0');
			else
				clk_100k_counter 	<= clk_100k_counter + 1;
			end if;
		end if;
	end if;
end process;

ledblink_process: process(clk_100k,rst)
begin
		if (rst = '0') then
			blink_counter 		<= (others => '0');
			blink_led 			<= '0';
		else
			if (rising_edge(clk_100k)) then
				if (blink_counter = conv_std_logic_vector(end_value_blink-1, 16)) then
						blink_led <= not blink_led;
						blink_counter 	<= (others => '0');
				else
					blink_counter 	<= blink_counter + 1;
				end if;
			end if;
	end if;
end process;

--Exercise 3: Making 500 Hz clock. Similar than in previous excercises

clk500Hz_process: process(mclk)
begin		
	if (rising_edge(mclk)) then
		if (rst = '0') then
			clk_500_counter 	<= (others => '0');
			clk_500Hz 			<= '0';
		else
			if (clk_500_counter =  conv_std_logic_vector(end_value_500-1, 16)) then
				clk_500Hz 			<= not clk_500Hz;
				clk_500_counter 	<= (others => '0');
			else
				clk_500_counter 	<= clk_500_counter + 1;
			end if;
		end if;
	end if;
end process;

debug 	<= blink_counter;
led 		<= blink_led;
clk_1 	<= blink_led; 	-- Exercise 3: The blink_led signal is 1 Hz signal, hence it can be directly used as clk_1s
clk_500 	<= clk_500Hz;	-- Exercise 3: Routing out the 500 Hz clock signal
clk_100 	<= clk_100k;


end Behavioral;

