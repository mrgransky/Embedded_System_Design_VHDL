library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port 
	 ( 
			mclk 	: in  STD_LOGIC;
			rst 	: in  STD_LOGIC; 				-- Exercise 3: see comment on line 104
         btn 	: in  STD_LOGIC_VECTOR (3 downto 0);
         sw 	: in  STD_LOGIC_VECTOR (7 downto 0);
         led 	: out  STD_LOGIC_VECTOR(7 downto 0);
			seg 	: out STD_LOGIC_VECTOR (6 downto 0);
			dp 	: out STD_LOGIC;
			an 	: out STD_LOGIC_VECTOR (3 downto 0)
			);
end top;

architecture Behavioral of top is
	
	component TimeManager is
    Port ( 
			  mclk 		: in  STD_LOGIC;
           rst 		: in  STD_LOGIC;
           led 		: out STD_LOGIC;
			  clk_1		: out STD_LOGIC; -- Excercise 3: Add 1 Hz clock as output from TimeManager
			  clk_500	: out STD_LOGIC; -- Excercise 3: Add 500 Hz clock as output from TimeManager
			  clk_100 	: out STD_LOGIC;									
			  debug 		: out STD_LOGIC_VECTOR(15 downto 0)			
			 );		
	end component;
	

-- Exercise3: Declare Display component 
	component Display is     
	Port (  mclk			: in STD_LOGIC;
           rst				: in STD_LOGIC;
           dataIn			: in STD_LOGIC_VECTOR (15 downto 0);
           clk_1s			: in STD_LOGIC;
           clk_display	: in STD_LOGIC;         
           an				: out STD_LOGIC_VECTOR (3 downto 0);
           SevenSegment	: out STD_LOGIC_VECTOR (6 downto 0)
			  );
	end component;
	
signal reset : std_logic;			-- Exercise 3: See comment on line 104
signal clk_100k :  std_logic;
signal clk_1hz : std_logic;		-- Exercise3: Signal for 1 Hz clock
signal clk_500hz : std_logic;		-- Exercise3: Signal for 500 Hz clock
signal debug : std_logic_vector(15 downto 0);

begin

	tmanag : TimeManager 
	port map 
	(
		mclk => mclk,
		rst => reset, 					--Exercise 3: See comment on line 104
		led => led(1),
		clk_1 => clk_1hz,
		clk_500 => clk_500hz,
		clk_100 => clk_100k,
		debug => debug
	);

	-- Exercise3: Add Display component port map
	Disp : Display
	port map
	(
		mclk => mclk,
      rst => reset, 						 --Exercise 3: See comment on line 104
		dataIn => "0000000000000000",  -- Exercise 3: This is reserved for later use. 
		clk_1s => clk_1hz,
      clk_display => clk_500hz,
      an => an,
      SevenSegment => seg
   );

led(7 downto 2) 	<= sw(7 downto 2);
led(0) 				<= sw(0);
reset					<= '1'; --Exercise 3: If you are experiencing problems with system startup, define reset signal and use it as reset input for components.
dp 					<= '1'; --Exercise 3: Activate ('1') or Deactivate ('0') dots in 7-segment display



end Behavioral;