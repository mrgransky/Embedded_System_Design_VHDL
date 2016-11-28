library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port 
	 ( 
			mclk 	: in  STD_LOGIC;
			rst 	: in  STD_LOGIC; 				
         btn 	: in  STD_LOGIC_VECTOR (3 downto 0);
         sw 	: in  STD_LOGIC_VECTOR (7 downto 0);
         led 	: out STD_LOGIC_VECTOR(7 downto 0);
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
			  clk_1		: out STD_LOGIC; --  Add 1 Hz clock as output from TimeManager
			  clk_500	: out STD_LOGIC; --  Add 500 Hz clock as output from TimeManager
			  clk_100 	: out STD_LOGIC;									
			  debug 		: out STD_LOGIC_VECTOR(15 downto 0)			
			 );		
	end component;
	
	
	-- Declare Display component 
	component Display is     
	Port (  
			mclk			: in STD_LOGIC;
         rst			: in STD_LOGIC;
         dataIn		: in STD_LOGIC_VECTOR (15 downto 0);
         clk_1s		: in STD_LOGIC;
         clk_display	: in STD_LOGIC;         
         an				: out STD_LOGIC_VECTOR (3 downto 0);
         SevenSegment: out STD_LOGIC_VECTOR (6 downto 0)
			);
	end component;
	
	--Excercise4: Declare StateMachine component
	component StateMachine is
	Port 
	(
			mclk			: in std_logic;
			rst			: in std_logic;
			clk_1s		: in std_logic;
			push_button	: in std_logic;
			leds			: out std_logic_vector(2 downto 0)
	);
	end component;
	
	--Excercise5: Add Shiftreg component
	component Shiftreg is
	Port 
	(
			mclk 		: in  STD_LOGIC;
         clk_1s 	: in  STD_LOGIC;
         rst 		: in  STD_LOGIC;
         data_in 	: in  STD_LOGIC_VECTOR (7 downto 0);
         load_button 		: in STD_LOGIC;
			unload_button		: in STD_LOGIC;
			data_out 			: out STD_LOGIC
	);
	end component;
	
	component Dimmer is
	port
	(
		mclk 			: in  STD_LOGIC;
      rst 			: in  STD_LOGIC;
      switches 	: in  STD_LOGIC_VECTOR (7 downto 0);
      led 			: out  STD_LOGIC
	);
	end component;
	
signal reset 		: std_logic;			
signal clk_100k 	: std_logic;
signal clk_1hz 	: std_logic;		-- Signal for 1 Hz clock
signal clk_500hz 	: std_logic;		-- Signal for 500 Hz clock

signal debug : std_logic_vector(15 downto 0);

begin

	tmanag : TimeManager 
	port map 
	(
		mclk 		=> mclk,
		rst 		=> reset, 					
		led 		=> led(1),
		clk_1 	=> clk_1hz,
		clk_500 	=> clk_500hz,
		clk_100	=> clk_100k,
		debug 	=> debug
	);

	-- Display component port map
	Disp : Display
	port map
	(
		mclk 			=> mclk,
      rst 			=> reset, 						 
		dataIn 		=> "0000000000000000",  -- Exercise 3: This is reserved for later use. 
		clk_1s 		=> clk_1hz,
      clk_display => clk_500hz,
      an 			=> an,
      SevenSegment => seg
   );
	
	--Excercise4: Add StateMachine component port map
	StateMach : StateMachine
	port map
	(
			mclk			=> mclk,
			rst			=> reset,
			clk_1s		=> clk_1hz,
			push_button	=> btn(0),
			leds			=>	led(4 downto 2) 
	);
	
	--Excercise5: Add Shiftregister component port map
	Shiftregister : Shiftreg
	port map
	(
			mclk 		=> mclk,
         clk_1s 	=> clk_1hz,
         rst 		=> not btn(3),
         data_in 	=> sw(7 downto 0),
         load_button  	=> btn(2),
			unload_button 	=> btn(1),
			data_out 		=> led(5)
	);
	
	-- Ex6
	dim : Dimmer
	port map
	(
		mclk 		=> mclk,
      rst 		=> reset,
      switches =>	sw(7 downto 0),
      led 		=> led(6)
	
	);
		
led(7) 	<= '0';  --Exercise 5: Change this to 7 downto 6, since leds 0-5 are defined elsewhere.
led(0) 				<= sw(0);
reset					<= '1'; --If you are experiencing problems with system startup, define reset signal and use it as reset input for components.
dp 					<= '1'; --Activate ('1') or Deactivate ('0') dots in 7-segment display
end Behavioral;

