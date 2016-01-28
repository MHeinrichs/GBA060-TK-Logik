--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:00:20 11/05/2015
-- Design Name:   
-- Module Name:   C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/RAM_Control/RAM_Control_VHDL/RamCon-Test.vhd
-- Project Name:  RAM_Control_VHDL
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ramcon
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RamConTest IS
END RamConTest;
 
ARCHITECTURE behavior OF RamConTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ramcon
    PORT(
         CLK_RAMC : IN  std_logic;
         RESET : IN  std_logic;
         C4MHZ : IN  std_logic;
         RW_40 : IN  std_logic;
         INIT : IN  std_logic;
         TT40_1 : IN  std_logic;
         TS40 : IN  std_logic;
         SCLK : IN  std_logic;
         ICACHE : IN  std_logic;
         WE_FLASH : IN  std_logic;
         OE_FLASH : IN  std_logic;
         UDQ0 : OUT  std_logic;
         UDQ1 : OUT  std_logic;
         LDQ0 : OUT  std_logic;
         LDQ1 : OUT  std_logic;
         CE_B0 : OUT  std_logic;
         CE_B1 : OUT  std_logic;
         WE : OUT  std_logic;
         CAS : OUT  std_logic;
         RAS : OUT  std_logic;
         CLK_RAM : OUT  std_logic;
         CLKEN : OUT  std_logic;
         BA0 : OUT  std_logic;
         BA1 : OUT  std_logic;
         LE_RAM : OUT  std_logic;
         OERAM_40 : OUT  std_logic;
         OE40_RAM : OUT  std_logic;
         ARAM : OUT  std_logic_vector(12 downto 0);
         SEL16M : OUT  std_logic;
         TA40 : OUT  std_logic;
         TCI40 : OUT  std_logic;
         TBI40 : IN  std_logic;
         A40 : IN  std_logic_vector(30 downto 0);
         SIZ40 : IN  std_logic_vector(1 downto 0);
         D30 : IN  std_logic_vector(31 downto 28)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_RAMC : std_logic := '0';
   signal RESET : std_logic := '0';
   signal C4MHZ : std_logic := '0';
   signal RW_40 : std_logic := '0';
   signal INIT : std_logic := '0';
   signal TT40_1 : std_logic := '0';
   signal TS40 : std_logic := '0';
   signal SCLK : std_logic := '0';
   signal ICACHE : std_logic := '0';
   signal WE_FLASH : std_logic := '0';
   signal OE_FLASH : std_logic := '0';
   signal TBI40 : std_logic := '0';
   signal A40 : std_logic_vector(30 downto 0) := (others => '0');
   signal SIZ40 : std_logic_vector(1 downto 0) := (others => '0');
   signal D30 : std_logic_vector(31 downto 28) := (others => '0');

 	--Outputs
   signal UDQ0 : std_logic;
   signal UDQ1 : std_logic;
   signal LDQ0 : std_logic;
   signal LDQ1 : std_logic;
   signal CE_B0 : std_logic;
   signal CE_B1 : std_logic;
   signal WE : std_logic;
   signal CAS : std_logic;
   signal RAS : std_logic;
   signal CLK_RAM : std_logic;
   signal CLKEN : std_logic;
   signal BA0 : std_logic;
   signal BA1 : std_logic;
   signal LE_RAM : std_logic;
   signal OERAM_40 : std_logic;
   signal OE40_RAM : std_logic;
   signal ARAM : std_logic_vector(12 downto 0);
   signal SEL16M : std_logic;
   signal TA40 : std_logic;
   signal TCI40 : std_logic;

   -- Clock period definitions
   constant CLK_RAMC_period : time := 10 ns;
   constant SCLK_period : time := 20 ns;
   constant CLK_RAM_period : time := 10 ns;
   constant CLKEN_period : time := 10 ns;
	constant C4MHZ_period : time := 250 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ramcon PORT MAP (
          CLK_RAMC => CLK_RAMC,
          RESET => RESET,
          C4MHZ => C4MHZ,
          RW_40 => RW_40,
          INIT => INIT,
          TT40_1 => TT40_1,
          TS40 => TS40,
          SCLK => SCLK,
          ICACHE => ICACHE,
          WE_FLASH => WE_FLASH,
          OE_FLASH => OE_FLASH,
          UDQ0 => UDQ0,
          UDQ1 => UDQ1,
          LDQ0 => LDQ0,
          LDQ1 => LDQ1,
          CE_B0 => CE_B0,
          CE_B1 => CE_B1,
          WE => WE,
          CAS => CAS,
          RAS => RAS,
          CLK_RAM => CLK_RAM,
          CLKEN => CLKEN,
          BA0 => BA0,
          BA1 => BA1,
          LE_RAM => LE_RAM,
          OERAM_40 => OERAM_40,
          OE40_RAM => OE40_RAM,
          ARAM => ARAM,
          SEL16M => SEL16M,
          TA40 => TA40,
          TCI40 => TCI40,
          TBI40 => TBI40,
          A40 => A40,
          SIZ40 => SIZ40,
          D30 => D30
        );

   -- Clock process definitions
   CLK_RAMC_process :process
   begin
		CLK_RAMC <= '0';
		wait for CLK_RAMC_period/2;
		CLK_RAMC <= '1';
		wait for CLK_RAMC_period/2;
   end process;
 
   SCLK_process :process
   begin
		SCLK <= '0';
		wait for SCLK_period/2;
		SCLK <= '1';
		wait for SCLK_period/2;
   end process;
 
   C4MHZ_process :process
   begin
		C4MHZ <= '0';
		wait for C4MHZ_period/2;
		C4MHZ <= '1';
		wait for C4MHZ_period/2;
   end process;



   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET<='0';
		TS40 <='1';
		TT40_1 <='1';
		A40(30 downto 0) <= "0000000000000000000000000000000";
      wait for 30 ns;	
		RESET<='1';
      wait for CLK_RAMC_period*5;
      -- insert stimulus here 
		INIT <='1';
      wait for CLK_RAMC_period*100;
		-- start a cycle
		
		A40(30 downto 25) <= "000100";
		TT40_1 <='0';
		SIZ40 <="11";
		RW_40 <= '1';
		wait for 1 ns;	
		TS40 <='0';

		wait until TA40 = '0';		
		wait until TA40 = '1';
		TS40 <='1';
      wait for CLK_RAMC_period*4;

		TT40_1 <='0';
		SIZ40 <="11";
		RW_40 <= '0';
		wait for 1 ns;	
		TS40 <='0';

		wait until TA40 = '0';		
		wait until TA40 = '1';

		
      wait;
   end process;

END;
