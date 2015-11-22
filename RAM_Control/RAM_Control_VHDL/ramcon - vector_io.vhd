-- Xilinx XPort Language Converter, Version 4.1 (110)
-- 
-- ABEL Design Source: ramcon.abl
-- VHDL Design Output: ramcon.vhd
-- Created 15-Oct-2015 09:05 PM
--
-- Copyright (c) 2015, Xilinx, Inc.  All Rights Reserved.
-- Xilinx Inc makes no warranty, expressed or implied, with respect to
-- the operation and/or functionality of the converted output files.
-- 

Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ramcon is
   Port (
      CLK_RAMC, RESET, C4MHZ,
	    RW_40, INIT, TT40_1, TS40, SCLK, ICACHE,
	    WE_FLASH, OE_FLASH: in std_logic;
      UDQ0, UDQ1, LDQ0, LDQ1, CE_B0, CE_B1, WE, CAS, RAS, CLK_RAM, CLKEN, BA0,
	    BA1, LE_RAM, OERAM_40, OE40_RAM: out std_logic;
      ARAM		: out STD_LOGIC_VECTOR (12 downto 0);      
      SEL16M: out std_logic;
      TA40, TCI40: out std_logic;
      TBI40: in std_logic;
      A40		: in STD_LOGIC_VECTOR (30 downto 0);
   	SIZ40		: in STD_LOGIC_VECTOR (1 downto 0);
      D30		: in STD_LOGIC_VECTOR (31 downto 28)

      
   );
end ramcon;


architecture ramcon_behav of ramcon is
   signal RQ_ACLR_ctrl, NQ_ACLR_ctrl,
	 BA1_D, BA0_D, RAS_D, CAS_D, TA40_D, WE_D, CE_B1_D,
	 CE_B0_D, LDQ1_D, LDQ0_D, UDQ1_D, UDQ0_D, LDQ1_SIG, LDQ0_SIG, UDQ1_SIG, UDQ0_SIG, OE40_RAM_D, OERAM_40_D, TRANSFER_ACLR, TRANSFER_CLK, SELRAM1,
	 SELRAM0, REFRESH, ENACLK, ENANOPC, CLRNOPC, CLRREFC,
	 TRANSFER: std_logic;
   signal TA40_FB, TA40_OE, TRANSFER_FB: std_logic;
	signal NQ :  STD_LOGIC_VECTOR (2 downto 0);
	signal RQ :  STD_LOGIC_VECTOR (7 downto 0);
	signal CQ :  STD_LOGIC_VECTOR (5 downto 0);
	signal CQ_D :  STD_LOGIC_VECTOR (5 downto 0);
   signal ARAM_D: STD_LOGIC_VECTOR (11 downto 0);      
   signal ARAM_LOW: STD_LOGIC_VECTOR (11 downto 0);      
   signal ARAM_HIGH: STD_LOGIC_VECTOR (11 downto 0);      
   signal ARAM_PRECHARGE: STD_LOGIC_VECTOR (11 downto 0);   
   signal ARAM_OPTCODE: STD_LOGIC_VECTOR (11 downto 0);   
   

   Function to_std_logic(X: in Boolean) return Std_Logic is
   variable ret : std_logic;
   begin
   if x then ret := '1';  else ret := '0'; end if;
   return ret;
   end to_std_logic;


   -- sizeIt replicates a value to an array of specific length.
   Function sizeIt(a: std_Logic; len: integer) return std_logic_vector is
      variable rep: std_logic_vector( len-1 downto 0);
   begin for i in rep'range loop rep(i) := a;  end loop; return rep;
   end sizeIt;
begin

-- Register Section


   process (CLK_RAMC, RESET) begin
      if RESET='0' then
			UDQ0 <= '1';
			UDQ1 <= '1';
			LDQ0 <= '1';
			LDQ1 <= '1';
			CE_B0 <= '1';
			CE_B1 <= '1';
			WE <= '1';
			CAS <= '1';
			RAS <= '1';
			BA0 <= '1';
			BA1 <= '1';
			OERAM_40 <= '1';
			OE40_RAM <= '1';
			TA40_FB <= '1';	
			ARAM (11 downto 0) <= "000000000000";
			CQ	<= "000000";
      elsif rising_edge(CLK_RAMC) then
			UDQ0 <= UDQ0_D;
			UDQ1 <= UDQ1_D;
			LDQ0 <= LDQ0_D;
			LDQ1 <= LDQ1_D;
			CE_B0 <= CE_B0_D;
			CE_B1 <= CE_B1_D;
			WE <= WE_D;
			CAS <= CAS_D;
			RAS <= RAS_D;
			BA0 <= A40(23);
			BA1 <= A40(24);
			OERAM_40 <= OERAM_40_D;
			OE40_RAM <= OE40_RAM_D;
			TA40_FB <= TA40_D;	
			ARAM (11 downto 0) <= ARAM_D;			 
			CQ	<= CQ_D;
      end if;
   end process;
   TA40 <= TA40_FB when TA40_OE='1' else 'Z';

   RQ_ACLR_ctrl <= (not RESET) or CLRREFC;
   process (C4MHZ, RQ_ACLR_ctrl) begin
      if RQ_ACLR_ctrl='1' then
			RQ<=	"00000000";
      elsif rising_edge(C4MHZ) then
			RQ <= RQ +1;
      end if;
   end process;

   NQ_ACLR_ctrl <= (not RESET) or CLRNOPC;
   process (CLK_RAMC, NQ_ACLR_ctrl) begin
      if NQ_ACLR_ctrl='1' then
			NQ  <= "000";
      elsif rising_edge(CLK_RAMC) then
			if(ENANOPC = '0') then
				NQ  <= "000";
			else
				NQ <= NQ +1;
			end if;
      end if;
   end process;

   TRANSFER_CLK <= '1' when TS40 ='0' and TT40_1 ='0' and A40(30 downto 26) = "00010" else '0';
   TRANSFER_ACLR <= '1' when 	CQ = "001111" or
										CQ = "011100" or 
										RESET ='0' else '0';
   process (TRANSFER_CLK, TRANSFER_ACLR) begin
      if TRANSFER_ACLR='1' then
			TRANSFER <= '0';
      elsif TRANSFER_CLK'event and TRANSFER_CLK='1' then
			TRANSFER <= '1';
      end if;
   end process;

-- Start of original equations
	SEL16M <= '1' when A40(30 downto 25) = "000000" else '0';
   SELRAM0 	<= '1' when A40(30 downto 25) = "000100" else '0'; 
   SELRAM1 	<= '1' when A40(30 downto 25) = "000101" else '0'; 
   TA40_OE 	<= '1' when A40(30 downto 26) = "00010" else '0'; -- was: SELRAM0 or SELRAM1;
   TCI40 	<= '1' when ICACHE ='1' and(	
													A40(30 downto 19) = "000000011111" 	or
													A40(30 downto 23) = "00000000"  or 
													A40(30 downto 21) = "0000000100" ) else
					'1' when A40(30 downto 21) = "0000001001"  or 
								A40(30 downto 22) = "000000101"  or 
								A40(30 downto 21) = "0000001100"  or
								A40(30 downto 26) = "00010" else '0';
   LE_RAM <= '0';
   REFRESH <= '1' when    RQ >= "00111100" else '0';
   CLK_RAM <= (not CLK_RAMC) and ENACLK;
   CLKEN <= '1';

	ARAM_LOW <= std_logic_vector'('0' & '0' & '0' & A40(10) & A40(9) & A40(8) &
	       A40(7) & A40(6) & A40(5) & A40(4) & A40(3) & A40(2));
	ARAM_HIGH <= A40(22 downto 11);
	ARAM_PRECHARGE <= "010000000000";
	ARAM_OPTCODE <= "000000100010";
	UDQ0_SIG <= '0' when (A40 (1 downto 0) = "10" and SIZ40 = "01") or
								(A40(1) = '1' and SIZ40 = "10") or
								SIZ40 = "00" or
								SIZ40 = "11" 
						 else '1';
	UDQ1_SIG <= '0' when (A40 (1 downto 0) = "00" and SIZ40 = "01") or
								(A40(1) = '0' and SIZ40 = "10") or
								SIZ40 = "00" or
								SIZ40 = "11" 
						 else '1';
	LDQ0_SIG <= '0' when (A40 (1 downto 0) = "11" and SIZ40 = "01") or
								(A40(1) = '1' and SIZ40 = "10") or
								SIZ40 = "00" or
								SIZ40 = "11"
						 else '1';
	LDQ1_SIG <= '0' when (A40 (1 downto 0) = "01" and SIZ40 = "01") or
								(A40(1) = '0' and SIZ40 = "10") or
								SIZ40 = "00" or
								SIZ40 = "11"
						 else '1';

	CLRREFC <= '1' when 	CQ = "000011" or
								CQ = "000111" or
								CQ = "001100" 
						else '0';

	ENANOPC	<= '1' when 	CQ = "000011" or
								CQ = "000110" or
								CQ = "000101" or
								CQ = "001101" or
								CQ = "001001" or
								CQ = "011101" or
								CQ = "110010" 
						else '0'; 
	CLRNOPC	<= '0' when 	CQ = "000000" or
								CQ = "000011" or
								CQ = "000110" or
								CQ = "000101" or
								CQ = "000100" or
								CQ = "001101" or
								CQ = "011101" or
								CQ = "110010" 
						else '1'; 

   process (CQ, INIT, RQ, REFRESH, TRANSFER, SCLK, A40, SIZ40, SELRAM0, SELRAM1, NQ, RW_40)
   begin
      
		 ARAM_D <= "000000000000";

      case CQ is
      when "000000" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (INIT)='1' then
		    CQ_D <= "000001";
		 else
		    CQ_D <= "000000";
		 end if;
      when "000001" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '0';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '0';
		 ARAM_D <= ARAM_PRECHARGE;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "000011";
      when "000011" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (NQ >= "001") then
		    CQ_D <= "000010";
		 else
		    CQ_D <= "000011";
		 end if;
      when "000010" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '0';
		 RAS_D <= '0';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "000110";
      when "000110" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (	NQ >= "110" and
		      RQ >= "00000100") then
		    CQ_D <= "000111";
		 elsif ( NQ >= "110" and
					RQ <= "00000100")
		       then
		    CQ_D <= "000010";
		 else
		    CQ_D <= "000110";
		 end if;
      when "000111" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '0';
		 TA40_D <= '1';
		 CAS_D <= '0';
		 RAS_D <= '0';
		 ARAM_D <= ARAM_OPTCODE;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "000101";
      when "000101" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (NQ >= "001") then
		    CQ_D <= "000100";
		 else
		    CQ_D <= "000101";
		 end if;
      when "000100" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (REFRESH='1') then
		    CQ_D <= "001100";
		 elsif ((not REFRESH) and TRANSFER and RW_40 and (not SCLK))='1' then
		    CQ_D <= "001111";
		 elsif ((not REFRESH) and TRANSFER and (not RW_40) and SCLK)='1' then
		    CQ_D <= "011100";
		 else
		    CQ_D <= "000100";
		 end if;
      when "001100" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '0';
		 RAS_D <= '0';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "001101";
      when "001101" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (NQ >= "110") then
		    CQ_D <= "000100";
		 else
		    CQ_D <= "001101";
		 end if;
      when "001111" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '0';
	 	 ARAM_D <= ARAM_HIGH;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "001110";
	  when "001110" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "001010";
      when "001010" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '0';
		 RAS_D <= '1';
	 	 ARAM_D <= ARAM_LOW;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "001011";
      when "001011" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "001001";
      when "001001" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (SIZ40 ="11") then
		    CQ_D <= "001000";
		 else
		    CQ_D <= "011111";
		 end if;
      when "001000" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "011000";
      when "011000" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "011001";
      when "011001" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "011011";
      when "011011" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "011010";
      when "011010" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "011110";
      when "011110" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "011111";
      when "011111" =>
		 OERAM_40_D <= not ((SELRAM0 or SELRAM1) and RW_40);
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '0';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '0';
	 	 ARAM_D <= ARAM_PRECHARGE;
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "011101";
      when "011101" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (NQ >= "001") then
		    CQ_D <= "000100";
		 else
		    CQ_D <= "011101";
		 end if;
      when "011100" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '0';
	 	 ARAM_D <= ARAM_HIGH;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "010100";
      when "010100" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "010101";
      when "010101" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "010111";
      when "010111" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 
	 	 UDQ0_D <= UDQ0_SIG;
	 	 UDQ1_D <= UDQ1_SIG;
	 	 LDQ0_D <= LDQ0_SIG;
	 	 LDQ1_D <= LDQ1_SIG;
	
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '0';
		 TA40_D <= '0';
		 CAS_D <= '0';
		 RAS_D <= '1';
		 ARAM_D <= ARAM_LOW;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "010110";
      when "010110" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 if (SIZ40 ="11") then
		    CQ_D <= "010010";
		 else
		    CQ_D <= "110001";
		 end if;
      when "010010" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 	 UDQ0_D <= UDQ0_SIG;
	 	 UDQ1_D <= UDQ1_SIG;
	 	 LDQ0_D <= LDQ0_SIG;
	 	 LDQ1_D <= LDQ1_SIG;
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "010011";
      when "010011" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "010001";
      when "010001" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 	 UDQ0_D <= UDQ0_SIG;
	 	 UDQ1_D <= UDQ1_SIG;
	 	 LDQ0_D <= LDQ0_SIG;
	 	 LDQ1_D <= LDQ1_SIG;
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "010000";
      when "010000" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "110000";
      when "110000" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	
	 	 UDQ0_D <= UDQ0_SIG;
	 	 UDQ1_D <= UDQ1_SIG;
	 	 LDQ0_D <= LDQ0_SIG;
	 	 LDQ1_D <= LDQ1_SIG;
	
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '0';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '0';
		 --CLRNOPC <= '1';
		 CQ_D <= "110001";
      when "110001" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= not SELRAM0;
		 CE_B1_D <= not SELRAM1;
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "110011";
      when "110011" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '0';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '0';
	 	 ARAM_D <= ARAM_PRECHARGE;
		 ENACLK <= '1';
		 --CLRNOPC <= '1';
		 CQ_D <= "110010";
      when "110010" =>
		 OERAM_40_D <= '1';
		 OE40_RAM_D <= '1';
		 UDQ0_D <= '1';
		 UDQ1_D <= '1';
		 LDQ0_D <= '1';
		 LDQ1_D <= '1';
		 CE_B0_D <= '1';
		 CE_B1_D <= '1';
		 WE_D <= '1';
		 TA40_D <= '1';
		 CAS_D <= '1';
		 RAS_D <= '1';
		 ENACLK <= '1';
		 if (NQ >= "001") then
		    CQ_D <= "000100";
		 else
		    CQ_D <= "110010";
		 end if;
      when others =>
       OERAM_40_D <= '0';
		 OE40_RAM_D <= '0';
		 UDQ0_D <= '0';
		 UDQ1_D <= '0';
		 LDQ0_D <= '0';
		 LDQ1_D <= '0';
		 CE_B0_D <= '0';
		 CE_B1_D <= '0';
		 WE_D <= '0';
		 TA40_D <= '0';
		 CAS_D <= '0';
		 RAS_D <= '0';
	    CQ_D <= "000000";
		 ENACLK <= '0';
      end case;
   end process;
end ramcon_behav;
