
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

entity TimeManager is
    Port ( mclk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           led : out  STD_LOGIC;
			  clk_100 : out std_logic;									-- For simulation purposes
			  debug : out std_logic_vector(15 downto 0));		-- For simulation purposes
end TimeManager;

architecture Behavioral of TimeManager is

--EMBEDDED SYSTEM DESIGN: 
-- In the architechture part, the component (VHDL module) parts and dependencies are introduced. In here, all the 
-- signals, constants, and components, which are related to the module are presented. 
-- 
-- signal is a vector, which has the defined amount of bits, hence the signal can be a bus, or it may have only one bit.
-- constants are constant values, which cannot be changed by any user operation, but they are "hard coded" 
-- during the synthesis. 


signal clk_100k_counter	: std_logic_vector(11 downto 0);
signal blink_counter		: std_logic_vector(15 downto 0);
signal clk_100k			: std_logic := '0';	
signal blink_led			: std_logic;

--EMBEDDED SYSTEM DESIGN: 
-- Constant values for counter. These are defined as integers, which must be later on converted into std_logic_vector.

constant end_value			: integer := 250;		
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

-- EMBEDDED SYSTEM DESIGN: 
-- In the ledblink process, the reset is implemented asynchronously. This is done by adding the rst signal into process
-- sensitivity list: process(signalx,signaly). This means that the change in rst signal also triggers the process.
-- Note that the asynchronous logic is not following the rising edge of the clock.

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

debug <= blink_counter;
led <= blink_led;
clk_100 <= clk_100k;

end Behavioral;

