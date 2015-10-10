----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:38:27 09/24/2015 
-- Design Name: 
-- Module Name:    bus_sizing - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bus_sizing is
    Port ( CLK_BS : in  STD_LOGIC;
           DIR_BS : in  STD_LOGIC;
           BWL_BS : in  STD_LOGIC_VECTOR (2 downto 0);
           LE_BS : in  STD_LOGIC;
           OE_BS : in  STD_LOGIC;
           RESET30 : in  STD_LOGIC;
           D30 : inout  STD_LOGIC_VECTOR (31 downto 0);
           D40 : inout  STD_LOGIC_VECTOR (31 downto 0));
end bus_sizing;

architecture Behavioral of bus_sizing is

signal BYTE: STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal WORD: STD_LOGIC_VECTOR(1 downto 0):= "00";
signal LONG: STD_LOGIC:='0';
signal D30BYTE0: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D30BYTE1: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D30BYTE2: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D30BYTE3: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D40BYTE0: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D40BYTE1: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D40BYTE2: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal D40BYTE3: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
signal LATCH_40_SIG: STD_LOGIC:='0';

begin
	--state decoding
	BYTE(0)	<=	'1' when BWL_BS ="000" else '0';
	BYTE(1)	<=	'1' when BWL_BS ="001" else '0';
	BYTE(2)	<=	'1' when BWL_BS ="010" else '0';
	BYTE(3)	<=	'1' when BWL_BS ="011" else '0';
	WORD(0)	<=	'1' when BWL_BS ="100" else '0';
	WORD(1)	<=	'1' when BWL_BS ="101" else '0';
	LONG		<=	'1' when BWL_BS ="110" else '0';
	--oe ansteuerung für 040-bus (READ)
	D40(31 downto 24)	<=	D40BYTE0 when DIR_BS='1' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D40(23 downto 16)	<=	D40BYTE1 when DIR_BS='1' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D40(15 downto 8)	<=	D40BYTE2 when DIR_BS='1' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D40( 7 downto 0)	<=	D40BYTE3 when DIR_BS='1' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	--oe ansteuerung für 030-bus (WRITE)
	D30(31 downto 24)	<=	D30BYTE0 when DIR_BS='0' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D30(23 downto 16)	<=	D30BYTE1 when DIR_BS='0' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D30(15 downto  8)	<=	D30BYTE2 when DIR_BS='0' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	D30( 7 downto  0)	<=	D30BYTE3 when DIR_BS='0' and OE_BS='1' and RESET30 ='1' else "ZZZZZZZZ";
	
	--Zuordnung Datenleitungen von 040-BUS zu 030-BUS (WRITE)
	D30BYTE0	<=	D40(31 downto 24) when DIR_BS='0' AND BYTE(0)='1' else
					D40(23 downto 16) when DIR_BS='0' AND BYTE(1)='1' else
					D40(15 downto  8) when DIR_BS='0' AND BYTE(2)='1' else
					D40( 7 downto  0) when DIR_BS='0' AND BYTE(3)='1' else
					"00000000";

	D30BYTE1	<=	D40(23 downto 16) when DIR_BS='0' AND (BYTE(0)='1' OR BYTE(1)='1') else
					D40( 7 downto  0) when DIR_BS='0' AND (BYTE(2)='1' OR BYTE(3)='1') else
					"00000000";

	D30BYTE2	<=	D40(15 downto  8) when DIR_BS='0' AND (BYTE(0)='1' OR BYTE(1)='1' OR BYTE(2)='1' OR BYTE(3)='1') else
					"00000000";

	D30BYTE3	<=	D40( 7 downto  0) when DIR_BS='0' AND (BYTE(0)='1' OR BYTE(1)='1' OR BYTE(2)='1' OR BYTE(3)='1') else
					"00000000";
	LATCH_40_SIG	<=	'1' when LE_BS='1' and DIR_BS ='1' else '0';

	--Zuordnung und Latch Datenleitungen von 030-BUS zu 040-BUS (READ)
	LATCH_40: process (LATCH_40_SIG, RESET30)
	begin
		if (RESET30='0') then
			D40BYTE0	<=	"00000000";
			D40BYTE1	<=	"00000000";
			D40BYTE2	<=	"00000000";
			D40BYTE3	<=	"00000000";
		elsif (rising_edge(LATCH_40_SIG)) then
			--BYTE 0
			if(BYTE(0)='1' OR WORD(0)='1' OR LONG ='1') then
				D40BYTE0 <= D30(31 downto 24);
			end if;
			--BYTE 1	
			if(WORD(0)='1' OR LONG ='1') then
				D40BYTE1 <= D30(23 downto 16);
			elsif(BYTE(0)='1' OR BYTE(1)='1') then
				D40BYTE1 <= D30(31 downto 24);
			end if;
			--BYTE 2
			if(LONG ='1') then
				D40BYTE2 <= D30(15 downto  8);
			elsif(BYTE(0)='1' OR BYTE(1)='1' OR BYTE(2)='1' OR WORD(0)='1' OR WORD(1) ='1') then
				D40BYTE2 <= D30(31 downto 24);
			end if;
			--BYTE 3
			if(LONG ='1') then
				D40BYTE3 <= D30( 7 downto  0);
			elsif(BYTE(0)='1' OR BYTE(1)='1' OR BYTE(2)='1' OR BYTE(3)='1') then
				D40BYTE3 <= D30(31 downto 24);
			elsif(WORD(0)='1' OR WORD(1) ='1') then
				D40BYTE3 <= D30(23 downto 16);
			end if;						
		end if;
	end process LATCH_40;
end Behavioral;

