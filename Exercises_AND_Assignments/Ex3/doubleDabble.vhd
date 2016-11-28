library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity doubleDabble is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           dataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out  STD_LOGIC_VECTOR (15 downto 0));
end doubleDabble;

architecture Behavioral of doubleDabble is

signal regIn : STD_LOGIC_VECTOR (15 downto 0);
signal regOut : STD_LOGIC_VECTOR (15 downto 0);
signal load : STD_LOGIC;

signal shift1 : STD_LOGIC;
signal shift2 : STD_LOGIC;
signal shift3 : STD_LOGIC;

signal shiftCount : STD_LOGIC_VECTOR (4 downto 0);

begin

process(clk)
begin
	if rising_edge(clk) then
		if rst = '0' then
			dataOut 		<= (others => '0');
			regIn 		<= (others => '0');
			regOut 		<= (others => '0');
			load 			<= '1';
			shift1 		<= '0';
			shift2 		<= '0';
			shift3 		<= '0';
			shiftCount 	<= (others => '0');
		else
		
		-- If the number is higher than 9999, then error
			if dataIn > "0010011100001111" then 
				regOut 	<= "1110111011101110";
				dataOut 	<= "1110111011101110";
			else		
				if load = '1' then 
					regIn <= dataIn;
					load <= '0';
					shift1 <= '0';
					shift2 <= '0';
					shift3 <= '0';
					shiftCount <= (others => '0');
				else
					-- Operations shift and sum 3 until regIn is "empty"
					if shiftCount >= "10000" then
						dataOut 	<= regOut;
						regOut 	<= regIn;
						load 		<= '1';
						shift1 	<= '0';
						shift2 	<= '0';
						shift3 	<= '0';
					else
						load <= '0';
						if regOut(11 downto 8) > "0100" and shift3 = '0' then
							regOut <= regOut + 768; -- add 3 to "hundreds"
							shift3 <= '1';
						elsif regOut(7 downto 4) > "0100" and shift2 = '0' then
							regOut <= regOut + 48; -- add 3 to "tens"
							shift2 <= '1';
						elsif regOut(3 downto 0) > "0100" and shift1 = '0' then
							regOut <= regOut + 3; -- add 3 to "ones"
							shift1 <= '1';
						else 
							regOut(15 downto 0) 	<= regOut(14 downto 0) & regIn(15);
							regIn(15 downto 0) 	<= regIn(14 downto 0) & '0';
							shiftCount 				<= shiftCount + 1;
							shift1 <= '0';
							shift2 <= '0';
							shift3 <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;


end Behavioral;

