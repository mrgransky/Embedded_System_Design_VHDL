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

up_counter: process(clk_1s)
begin
    if rising_edge(clk_1s) then
    
---------------- Embedded system design task-----------------
-- Make here a system that counts up to 9999 by using clk_1s
-------------------------------------------------------------
    end if;
end process;


Display_refresh : process(clk_display)
begin
    if(rising_edge(clk_display)) then
        if rst = '0' then
            an <= "0000";
            an_count <= (others => '0');
        else
			
---------------- Embedded system design task----------------------------------
-- Make here a system that selects and inserts data segment decoded sequence
-- (seq1,seq2,seq3,seq4) into SevenSegmentDisp driver. The process must also
-- reset the corresponding ~an bit. Note that all other an bits must remain set.

-- Hint: At this point you can make a system that polls through all four
-- 7-segment displays and. 
-------------------------------------------------------------------------------
        end if;
    end if;
end process;

seg1 <= decoded_value(3 downto 0);
seg2 <= decoded_value(7 downto 4);
seg3 <= decoded_value(11 downto 8);
seg4 <= decoded_value(15 downto 12);


end Behavioral;

