library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display is
    Port ( mclk: in  STD_LOGIC;
           rst: in  STD_LOGIC;
           dataIn: in  STD_LOGIC_VECTOR (15 downto 0);
           clk_1s: in  STD_LOGIC;
           clk_display: in std_logic;         
           an: out STD_LOGIC_VECTOR (3 downto 0);
           SevenSegment: out STD_LOGIC_VECTOR (6 downto 0));
end Display;

architecture Behavioral of Display is

component sevenSegmentDisp is
    Port ( clk: in  STD_LOGIC;
           dataIn: in  STD_LOGIC_VECTOR (3 downto 0);
           dataOut: out STD_LOGIC_VECTOR (6 downto 0);
           rst: in  STD_LOGIC);
end component;

component doubleDabble is
    Port ( clk: in  STD_LOGIC;
           rst: in  STD_LOGIC;
           dataIn: in  STD_LOGIC_VECTOR (15 downto 0);
           dataOut: out STD_LOGIC_VECTOR (15 downto 0));
end component;


signal clkCounter: std_logic_vector(17 downto 0);

signal clk: STD_LOGIC;
signal seg_temp: STD_LOGIC_VECTOR (3 downto 0);

signal an_count: STD_LOGIC_VECTOR (1 downto 0);
signal decoded_value: STD_LOGIC_VECTOR (15 downto 0);

signal counter: STD_LOGIC_VECTOR (15 downto 0);
signal DataToSegment: STD_LOGIC_VECTOR (3 downto 0);

signal seg1: STD_LOGIC_VECTOR (3 downto 0);
signal seg2: STD_LOGIC_VECTOR (3 downto 0);
signal seg3: STD_LOGIC_VECTOR (3 downto 0);
signal seg4: STD_LOGIC_VECTOR (3 downto 0);

begin


SegmentDisplay: sevenSegmentDisp 
port map (clk => mclk,
	  dataIn => DataToSegment,
	  dataOut => SevenSegment,
	  rst => rst);


SevenSegmentDecoder: doubleDabble 
port map (clk => mclk,
	  rst => rst,
	  dataIn => counter,
	  dataOut => decoded_value);

--Excercise3: up_counter process
--Make a counter process, which counts up to 9999 using 1 Hz clock

up_counter: process(clk_1s) -- sensitive to 1s_clk
begin
	if rising_edge(clk_1s) then	
		if rst = '0' then
			counter <= (others => '0');
		else
			if counter = CONV_STD_LOGIC_VECTOR(9999, 14) then -- increment counter value with 1 if the counter value is other than 9999
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
		end if;
	end if;
end process;

--Excercise 3: Display_refresh process

-- Make here a system that selects and inserts data segment decoded sequence
-- (seq1,seq2,seq3,seq4) into SevenSegmentDisp driver. The process must also
-- reset the corresponding ~an bit (active low). Note that all other an bits must remain set.

-- Hint: At this point you can make a system that polls through all four
-- 7-segment displays.

Display_refresh : process(clk_display)
begin
 	if(rising_edge(clk_display)) then
	
		if rst = '0' then
			an 		<= (others => '0');	-- when the system is in reset state, set all an bits to 0
			an_count <= (others => '0');	-- also reset the counter
		else										-- When the reset is not active, start polling the segment counter 	
			if an_count = "00" then			
				an <= "1110";					-- Note the order, LSB is the first digit of the display
				DataToSegment <= seg1;		-- Setting the decoded value to corresponding 
				an_count <= an_count + 1;	-- On the next clock cycle, the 2nd 7-segment display is updated
			elsif an_count = "01" then
				an <= "1101";
				DataToSegment <= seg2;
				an_count <= an_count + 1;
			elsif an_count = "10" then
				an <= "1011";
				DataToSegment <= seg3;
				an_count <= an_count + 1;
			else
				an <= "0111";
				DataToSegment<= seg4;
				an_count <= (others => '0');
			end if;
		end if;
	end if;
						
end process;

-- The plottable numbers from double dabble component are coming as 16-bit wide vector.
-- Each number representation in 7-segment display numbers are 4-bit wide. 
-- The decoded value is "sliced" into segment data asynchronously.

seg1 <= decoded_value(3 downto 0);
seg2 <= decoded_value(7 downto 4);
seg3 <= decoded_value(11 downto 8);
seg4 <= decoded_value(15 downto 12);


end Behavioral;

