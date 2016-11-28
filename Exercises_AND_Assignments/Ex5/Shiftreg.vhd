----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:29 10/05/2015 
-- Design Name: 
-- Module Name:    Shiftreg - Behavioral 
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

entity Shiftreg is
    Port ( mclk 		: in  STD_LOGIC;
           clk_1s 	: in  STD_LOGIC;
           rst 		: in  STD_LOGIC;
           data_in 	: in  STD_LOGIC_VECTOR (7 downto 0);
           load_button 		: in STD_LOGIC;
			  unload_button	: in STD_LOGIC;
			  data_out 			: out STD_LOGIC
			  );

end Shiftreg;

architecture Behavioral of Shiftreg is

component BtnDelay is
Port(
		mclk 	: in  STD_LOGIC;
      rst 	: in  STD_LOGIC;
      button : in  STD_LOGIC;
      button_pressed : out  STD_LOGIC
	  );
end component;

type SregStates is (RESET, LOAD, UNLOAD); 	-- State machine for loading / unloading
signal LOAD_UNLOAD : SregStates;

signal register_pointer 		: integer range 0 to 8;				-- register_pointer shows the bit from reg signal which is set to output
signal reg 							: std_logic_vector(7 downto 0);
signal load_button_pressed 	: std_logic;							
signal unload_button_pressed 	: std_logic;

begin

	ButtonDelayLoad : BtnDelay
	port map
	(
		mclk 			=> mclk,
      rst 			=> rst, 						 
		button 		=> load_button,
      button_pressed => load_button_pressed
   );

	ButtonDelayUnload : BtnDelay
	port map
	(
		mclk 			=> mclk,
      rst 			=> rst, 						 
		button 		=> unload_button,
      button_pressed => unload_button_pressed
   );

shift_register : process(clk_1s,rst)
begin

	if rst = '0' then
		LOAD_UNLOAD 		<= RESET;
		register_pointer 	<= 0;
		reg 					<= (others => '0');
		data_out 			<= '0';
	else

		if rising_edge(clk_1s) then	
			case LOAD_UNLOAD is	
			
				when RESET => LOAD_UNLOAD <= LOAD;
				
				when LOAD =>													
					if load_button_pressed = '1' then
						reg <= data_in;										-- update the state of switches to reg when load button is pressed
					end if;
					
					if unload_button_pressed = '1' then
						LOAD_UNLOAD <= UNLOAD;								-- start to unload register after unload button is pressed
					end if;
				
				when UNLOAD =>
					if (register_pointer < 8) then						-- go through the register bit by bit
						data_out <= reg(register_pointer);				-- and set each individual bit to output
						register_pointer <= register_pointer + 1;
					else
						register_pointer <= 0;								 
						LOAD_UNLOAD <= LOAD;
						reg <= (others => '0');
					end if;

			end case;
		end if;
	end if;

end process;

end Behavioral;

