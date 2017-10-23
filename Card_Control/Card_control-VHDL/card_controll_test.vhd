--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:11:00 10/04/2015
-- Design Name:   
-- Module Name:   C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/Card_Control/Card_control-VHDL/card_controll_test.vhd
-- Project Name:  Card_control-VHDL
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Card_control
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY card_controll_test IS
END card_controll_test;
 
ARCHITECTURE behavior OF card_controll_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control
    PORT(
         SEL16M : IN  std_logic;
         PLL_CLK : IN  std_logic;
         OSC_CLK : IN  std_logic;
         RSTO40 : IN  std_logic;
         HALT30 : IN  std_logic;
         IPL30 : IN  std_logic_vector(2 downto 0);
         BERR30 : IN  std_logic;
         DSACK30 : IN  std_logic_vector(1 downto 0);
         STERM30 : IN  std_logic;
         CIOUT40 : IN  std_logic;
         CPU40_60 : IN  std_logic;
         A40 : IN  std_logic_vector(1 downto 0);
         SIZ40 : IN  std_logic_vector(1 downto 0);
         RW40 : IN  std_logic;
         TM40 : IN  std_logic_vector(2 downto 0);
         TT40 : IN  std_logic_vector(1 downto 0);
         TS40 : IN  std_logic;
         PLL_S : OUT  std_logic_vector(1 downto 0);
         CLK30 : INOUT  std_logic;
         PCLK : inOUT  std_logic;
         BCLK : OUT  std_logic;
         SCLK : INOUT  std_logic;
         CLK_BS : OUT  std_logic;
         CLK_RAMC : INOUT  std_logic;
         AL : OUT  std_logic_vector(1 downto 0);
         A30_LE : OUT  std_logic;
         OE_BS : OUT  std_logic;
         LE_BS : INOUT  std_logic;
         DIR_BS : OUT  std_logic;
         BWL_BS : OUT  std_logic_vector(2 downto 0);
         FC30 : OUT  std_logic_vector(2 downto 0);
         AS30 : OUT  std_logic;
         DS30 : OUT  std_logic;
         RW30 : OUT  std_logic;
         SIZ30 : OUT  std_logic_vector(1 downto 0);
         RESET30 : INOUT  std_logic;
         RSTI40 : INOUT  std_logic;
         IPL40 : OUT  std_logic_vector(2 downto 0);
         TBI40 : OUT  std_logic;
         TCI40 : OUT  std_logic;
         MDIS40 : OUT  std_logic;
         CDIS40 : OUT  std_logic;
         TA40 : OUT  std_logic;
         TEA40 : OUT  std_logic;
         BGR60 : OUT  std_logic;
         ICACHE : OUT  std_logic;
           BR30 :  in  STD_LOGIC;								--Busrequest 030-Seite
			  BGACK30 :  in  STD_LOGIC;							--Bus Grant ack 030-Seite			  
			  BG30 : out  STD_LOGIC;								--Busgrant 030-Seite
			  BR40 :  in  STD_LOGIC;								--Busrequest 040-Seite
			  BG40 :  out  STD_LOGIC;								--Busgrant 040-Seite
			  BB40 :  in  STD_LOGIC;								--Busbusy 040-Seite
			  LOCK40 : in  STD_LOGIC;								--Bus Lock 040			  
			  LOCKE40 : in  STD_LOGIC;							--Bus Lock End 040
			  A_OE :  out  STD_LOGIC
			  );
    END COMPONENT;
    
	 TYPE BUS_TERM IS (
				BUS_STERM,
				BUS_32,
				BUS_16,
				BUS_8
				);

   --Inputs
   signal SEL16M : std_logic := '0';
   signal PLL_CLK : std_logic := '0';
   signal OSC_CLK : std_logic := '0';
   signal RSTO40 : std_logic := '0';
   signal HALT30 : std_logic := '0';
   signal IPL30 : std_logic_vector(2 downto 0) := (others => '0');
   signal BERR30 : std_logic := '0';
   signal DSACK30 : std_logic_vector(1 downto 0) := (others => '0');
   signal STERM30 : std_logic := '0';
   signal CIOUT40 : std_logic := '0';
   signal CPU40_60 : std_logic := '0';
   signal A40 : std_logic_vector(1 downto 0) := (others => '0');
   signal SIZ40 : std_logic_vector(1 downto 0) := (others => '0');
   signal RW40 : std_logic := '0';
   signal TM40 : std_logic_vector(2 downto 0) := (others => '0');
   signal TT40 : std_logic_vector(1 downto 0) := (others => '0');
   signal TS40 : std_logic := '0';
   signal BR30 : STD_LOGIC := '0';								--Busrequest 030-Seite
	signal BGACK30 :  STD_LOGIC := '0';							--Bus Grant ack 030-Seite			  
	signal BR40 :  STD_LOGIC := '0';								--Busrequest 040-Seite
	signal BB40 :  STD_LOGIC := '0';								--Busbusy 040-Seite
	signal LOCK40 : STD_LOGIC := '0';								--Bus Lock 040			  
	signal LOCKE40 : STD_LOGIC := '0';							--Bus Lock End 040

	--BiDirs
   signal RESET30 : std_logic;
   signal LE_BS : std_logic;

 	--Outputs
   signal PLL_S : std_logic_vector(1 downto 0);
   signal PCLK : std_logic;
   signal BCLK : std_logic;
   signal SCLK : std_logic;
   signal CLK30 : std_logic;
   signal CLK_BS : std_logic;
   signal CLK_RAMC : std_logic;
   signal AL : std_logic_vector(1 downto 0);
   signal A30_LE : std_logic;
   signal OE_BS : std_logic;
   signal DIR_BS : std_logic;
   signal BWL_BS : std_logic_vector(2 downto 0);
   signal FC30 : std_logic_vector(2 downto 0);
   signal AS30 : std_logic;
   signal DS30 : std_logic;
   signal RW30 : std_logic;
   signal SIZ30 : std_logic_vector(1 downto 0);
   signal RSTI40 : std_logic;
   signal IPL40 : std_logic_vector(2 downto 0);
   signal TBI40 : std_logic;
   signal TCI40 : std_logic;
   signal MDIS40 : std_logic;
   signal CDIS40 : std_logic;
   signal TA40 : std_logic;
   signal TEA40 : std_logic;
   signal BGR60 : std_logic;
   signal ICACHE : std_logic;
	signal BG30 : STD_LOGIC;
	signal BG40 : STD_LOGIC;
	signal A_OE : STD_LOGIC;
	signal WATCH_DOG : std_logic_vector(15 downto 0);
	signal TRANSFER_IN_PROGRES : STD_LOGIC;
	signal ACTUAL_BUS_TERM: BUS_TERM;
	signal TIP : STD_LOGIC;
	

   -- Clock period definitions
   constant PLL_CLK_period : time := 5.0000001 ns;
   constant OSC_CLK_period : time := PLL_CLK_period*5;
   constant CLK030_period : time := 19.097896 ns;
   --constant CLK30_period : time := 10 ns;
	--timescale 1ns / 1ns
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control PORT MAP (
          SEL16M => SEL16M,
          PLL_CLK => PLL_CLK,
          OSC_CLK => OSC_CLK,
          RSTO40 => RSTO40,
          HALT30 => HALT30,
          IPL30 => IPL30,
          BERR30 => BERR30,
          DSACK30 => DSACK30,
          STERM30 => STERM30,
          CIOUT40 => CIOUT40,
          CPU40_60 => CPU40_60,
          A40 => A40,
          SIZ40 => SIZ40,
          RW40 => RW40,
          TM40 => TM40,
          TT40 => TT40,
          TS40 => TS40,
          PLL_S => PLL_S,
          CLK30 => CLK30,
          PCLK => PCLK,
          BCLK => BCLK,
          SCLK => SCLK,
          CLK_BS => CLK_BS,
          CLK_RAMC => CLK_RAMC,
          AL => AL,
          A30_LE => A30_LE,
          OE_BS => OE_BS,
          LE_BS => LE_BS,
          DIR_BS => DIR_BS,
          BWL_BS => BWL_BS,
          FC30 => FC30,
          AS30 => AS30,
          DS30 => DS30,
          RW30 => RW30,
          SIZ30 => SIZ30,
          RESET30 => RESET30,
          RSTI40 => RSTI40,
          IPL40 => IPL40,
          TBI40 => TBI40,
          TCI40 => TCI40,
          MDIS40 => MDIS40,
          CDIS40 => CDIS40,
          TA40 => TA40,
          TEA40 => TEA40,
          BGR60 => BGR60,
          ICACHE => ICACHE,
          BR30 => BR30,
		    BGACK30 => BGACK30,
			 BG30 => BG30,
			 BR40 => BR40,
			 BG40 => BG40,
			 BB40 => BB40,
			 LOCK40 => LOCK40,
			 LOCKE40 => LOCKE40,
			 A_OE =>A_OE

        );

   -- Clock process definitions
   PLL_CLK_process :process
   begin
		PLL_CLK <= '0';
		wait for PLL_CLK_period/2;
		PLL_CLK <= '1';
		wait for PLL_CLK_period/2;
   end process;
 
   OSC_CLK_process :process
   begin
		OSC_CLK <= '0';
		wait for OSC_CLK_period/2;
		OSC_CLK <= '1';
		wait for OSC_CLK_period/2;
   end process;
 
   CLK30_process :process
   begin
		CLK30 <= '0';
		wait for CLK030_period/2;
		CLK30 <= '1';
		wait for CLK030_period/2;
   end process;

	DS_PROC :process
	begin
		STERM30 <='1';
		DSACK30 <= "11";
		wait until AS30 = '0';
		case ACTUAL_BUS_TERM is
			when BUS_32 =>
				STERM30 <='1';
				DSACK30 <= "00";
			when BUS_16 =>
				STERM30 <='1';
				DSACK30 <= "01";
			when BUS_8 =>
				STERM30 <='1';
				DSACK30 <= "10";
			when BUS_STERM =>
				STERM30 <='0';
				DSACK30 <= "11";
		end case;
		wait until AS30 = '1';
		STERM30 <='1';
		DSACK30 <= "11";
	end process;
	
	WATCH_DOG_PROCESS :process
	begin
		wait UNTIL rising_edge(BCLK);
		if(TA40='0' or TRANSFER_IN_PROGRES = '0')then
			WATCH_DOG <= x"0000";
		else
			WATCH_DOG <= WATCH_DOG+1;
		end if;
		if(WATCH_DOG >x"20")then
			report "Timeout";
			WATCH_DOG <= x"0000";
		end if;
	end process;

	TRANSFER_PROCESS :process
	begin
		wait UNTIL rising_edge(BCLK);
		if(TA40='0' or RESET30='0')then
			TIP <= '0';
		end if;
		
		if(TRANSFER_IN_PROGRES ='1' and TIP = '0') then
			TIP <='1';
			TS40 <='0';
		else
			TS40 <='1';
		end if;
	end process;

	
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET30 	<='0';
		HALT30	<='0';
		RSTO40	<='1';
		SEL16M 	<='0';
		IPL30 	<="111";
		BERR30	<='1';
		CIOUT40	<='1';
		CPU40_60 <='0';
		A40 		<="ZZ";
		SIZ40 	<="00";
		RW40		<='1';
		TM40		<="111";
		TT40		<="11";
		ACTUAL_BUS_TERM <= BUS_16;
     BR30 <='1';
	  BGACK30 <='1';
	  BR40 <='0';
	  BB40 <='1';
	  LOCK40 <='1';
	  LOCKE40 <='1';
		
		
      wait for 50 ns;	
		RESET30 <='1';
		HALT30<='1';

      wait UNTIL RSTI40 ='1';
		wait for PLL_CLK_period*16;
		TT40 <="00";
		TM40 <= "000";
		A40 <= "00";
		SIZ40 <="00"; --line
		SEL16M <='1';

		
		ACTUAL_BUS_TERM <= BUS_16;
		RW40 <= '1';
		TRANSFER_IN_PROGRES <='1';
		wait for PLL_CLK_period*200;
      TRANSFER_IN_PROGRES <='0';

		wait;
   end process;

END;
