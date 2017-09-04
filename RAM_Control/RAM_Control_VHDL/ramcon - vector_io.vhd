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
      UDQ0, UDQ1, LDQ0, LDQ1, WE, CAS, RAS, CLK_RAM, CLKEN, 
	    LE_RAM, OERAM_40, OE40_RAM: out std_logic;
      CE 		: out STD_LOGIC_VECTOR (1 downto 0);      
      BA			: out STD_LOGIC_VECTOR (1 downto 0);      
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
	TYPE sdram_state_machine_type IS (
				powerup, 					--000000
				init_precharge,			--000001 
				init_precharge_commit,  --000011
				init_refresh,				--000010
				init_wait,					--000110
				init_opcode,				--000111
				end_cycle,					--000101
				start_state,				--000100
				refresh_start,				--001100
				refresh_wait,				--001101
				read_start_ras,			--001111
				read_commit_ras,			--001110
				read_start_cas,			--001010
				read_commit_cas,			--001011
				read_data_wait,			--001001
				read_line_s0,				--001000
				write_start_ras,			--011100
				write_commit_ras,			--010100
				write_tra_ack,				--010101
				write_start_cas,			--010111
				write_commit_cas,			--010110
				write_line_s0,				--010010
				precharge			--110011
				);
   signal RAS_D: std_logic; 
	signal CAS_D: std_logic;
	signal TA40_D: std_logic;
	signal WE_D: std_logic;
	signal OE40_RAM_D: std_logic;
	signal OERAM_40_D: std_logic;
	signal TRANSFER_ACLR: std_logic;
	signal TRANSFER_CLK: std_logic;
	signal REFRESH: std_logic;
	signal CLRREFC: std_logic;
	signal TRANSFER: std_logic;
	signal TA40_FB: std_logic;
	signal NQ :  STD_LOGIC_VECTOR (2 downto 0);
	signal RQ :  STD_LOGIC_VECTOR (7 downto 0);
	signal CQ :  sdram_state_machine_type;
	signal CQ_D :  sdram_state_machine_type;
	signal SELRAM :  STD_LOGIC_VECTOR (1 downto 0);
	signal SELRAM_D :  STD_LOGIC_VECTOR (1 downto 0);
	signal CE_B_D :  STD_LOGIC_VECTOR (1 downto 0);
   signal ARAM_D: STD_LOGIC_VECTOR (11 downto 0);      
   signal ARAM_LOW: STD_LOGIC_VECTOR (11 downto 0);      
   signal ARAM_HIGH: STD_LOGIC_VECTOR (11 downto 0);      
   constant ARAM_PRECHARGE: STD_LOGIC_VECTOR (11 downto 0) := "010000000000";
   constant ARAM_OPTCODE: STD_LOGIC_VECTOR (11 downto 0) := "000000100010"; 
	signal ENACLK_PRE : STD_LOGIC;
	signal RAM_READY : STD_LOGIC;
	signal BURST :  STD_LOGIC_VECTOR (1 downto 0);
	signal BYTE_ENCODE :  STD_LOGIC_VECTOR (3 downto 0);
	signal BYTE_D :  STD_LOGIC_VECTOR (3 downto 0);
   

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
			CE		 <= "11";
			WE <= '1';
			CAS <= '1';
			RAS <= '1';
			BA  <= "00";
			OERAM_40 <= '1';
			OE40_RAM <= '1';
			TA40_FB <= '1';	
			ARAM (11 downto 0) <= "000000000000";
			CQ	<= powerup;
			NQ  <= "000";
			SELRAM_D <= "00";
			REFRESH <='0';
			RAM_READY <='0';
			BYTE_ENCODE <="1111";
      elsif rising_edge(CLK_RAMC) then
			if(CLRREFC ='1')then
				REFRESH <= '0';
			elsif(RQ >= "00111100") then
				REFRESH <= '1';
			end if;
						
			if(
				CQ = init_precharge_commit or
				CQ = init_wait or								
				CQ = refresh_wait)
			then
				NQ <= NQ +1;
			else 
				NQ  <= "000";
			end if;

			if(CQ=start_state)then
				RAM_READY <='1';
			end if;
			
			if(RAM_READY='1')then
				BA <= A40(24 downto 23);
			else
				BA <= "00";
			end if;

			--sizing
			if((A40 (1 downto 0) = "10" and SIZ40 = "01") or
				(A40(1) = '1' and SIZ40 = "10") or
				SIZ40 = "00" or
				SIZ40 = "11" or
				RW_40='1')
			then
				BYTE_ENCODE(0)<='0';
			else
				BYTE_ENCODE(0)<='1';
			end if;
			
			if((A40 (1 downto 0) = "00" and SIZ40 = "01") or
				(A40(1) = '0' and SIZ40 = "10") or
				SIZ40 = "00" or
				SIZ40 = "11" or
				RW_40='1')
			then
				BYTE_ENCODE(1)<='0';
			else
				BYTE_ENCODE(1)<='1';
			end if;

			if((A40 (1 downto 0) = "11" and SIZ40 = "01") or
				(A40(1) = '1' and SIZ40 = "10") or
				SIZ40 = "00" or
				SIZ40 = "11" or
				RW_40='1')
			then
				BYTE_ENCODE(2)<='0';
			else
				BYTE_ENCODE(2)<='1';
			end if;
			
			if((A40 (1 downto 0) = "01" and SIZ40 = "01") or
				(A40(1) = '0' and SIZ40 = "10") or
				SIZ40 = "00" or
				SIZ40 = "11" or
				RW_40='1')
			then
				BYTE_ENCODE(3)<='0';
			else
				BYTE_ENCODE(3)<='1';
			end if;

			if(SIZ40 = "11") then --line acces: we need bursting!
				if(CQ = read_start_ras or CQ = write_start_ras)then
					burst <="11"; --Init: burst of 4
				elsif((CQ = read_data_wait or CQ = write_commit_cas))then
					burst <=burst-1; --decrement
				end if;
			else
				burst <="00"; --no burst
			end if;
			

			SELRAM_D <= SELRAM;		
			UDQ0 <= BYTE_D(0);
			UDQ1 <= BYTE_D(1);
			LDQ0 <= BYTE_D(2);
			LDQ1 <= BYTE_D(3);
			CE <= CE_B_D;
			WE <= WE_D;
			CAS <= CAS_D;
			RAS <= RAS_D;
			OERAM_40 <= OERAM_40_D;
			OE40_RAM <= OE40_RAM_D;
			TA40_FB <= TA40_D;	
			ARAM (11 downto 0) <= ARAM_D;			 
			CQ	<= CQ_D;
      end if;
   end process;

	CLRREFC <= '1' when 	CQ = init_precharge_commit
								or CQ = init_opcode
								or CQ = refresh_start 
								or RESET ='0'
						else '0';

   process (C4MHZ, CLRREFC) begin
      if CLRREFC='1' then
			RQ<=	"00000000";
      elsif rising_edge(C4MHZ) then
			RQ <= RQ +1;
      end if;
   end process;

   TRANSFER_CLK <= '1' when TS40 ='0' and TT40_1 ='0' and (SELRAM/="00") else '0';
	TRANSFER_ACLR <= '1' when 	CQ = read_start_ras or
										CQ = write_start_ras or 
										RESET ='0' else '0';

   process (CLK_RAMC) begin
		if falling_edge(CLK_RAMC) then
			if(TRANSFER_ACLR ='1')then
				TRANSFER <= '0';
			elsif(TRANSFER_CLK = '1') then
				TRANSFER <= '1';
			end if;
		end if;
	end process;


-- Signal section
   SELRAM(0)<= '1' when A40(30 downto 25) = "000100" else 
					'1' when A40(30 downto 25) = "000110" else '0'; 
   SELRAM(1)<= '1' when A40(30 downto 25) = "000101" else 
					'1' when A40(30 downto 25) = "000111" else '0'; 
	SEL16M 	<= '0' when (SELRAM/="00")  else '1';--'1' when A40(30 downto 25) = "000000" else '0';

   TA40 		<= TA40_FB when (SELRAM/="00") else 'Z'; --tristate on amiga access

   TCI40 	<= '1' when (ICACHE ='1' and(														
													A40(30 downto 23) = "00000000" or  
													A40(30 downto 21) = "0000000100" or
													A40(30 downto 19) = "000000011111" 	
													))or
								A40(30 downto 21) = "0000001001"  or 
								A40(30 downto 22) = "000000101"  or 
								A40(30 downto 21) = "0000001100"  or
								SELRAM/="00"
								else '0';
   LE_RAM <= '0' when ENACLK_PRE ='1' else '1'; --LE_RAM goes only to the read from RAM direction of the 74ACT16543
  
   CLK_RAM <= (not CLK_RAMC);
   CLKEN <=	ENACLK_PRE;

	ARAM_LOW <= std_logic_vector'('0' & '0' & A40(26) & A40(10) & A40(9) & A40(8) &
	       A40(7) & A40(6) & A40(5) & A40(4) & A40(3) & A40(2));
	ARAM_HIGH <= A40(22 downto 11);


-- SM transistion process
   process (CQ, RQ, REFRESH, TRANSFER, SCLK, SELRAM_D, NQ, RW_40, BYTE_ENCODE, ARAM_LOW, ARAM_HIGH, BURST)
   begin
		--default values
		OERAM_40_D <= '1';
		OE40_RAM_D <= '1';
		BYTE_D <= "1111";
		CE_B_D <= "11";
		WE_D <= '1';
		TA40_D <= '1';
		CAS_D <= '1';
		RAS_D <= '1';
		ENACLK_PRE <= '1';
		ARAM_D <= "000000000000";

      case CQ is
      when powerup =>
			CQ_D <= init_precharge;
      when init_precharge =>
			CE_B_D <= "00";
			WE_D <= '0';
			RAS_D <= '0';
			ARAM_D <= ARAM_PRECHARGE;
			CQ_D <= init_precharge_commit;
      when init_precharge_commit =>
			CE_B_D <= "00";
			if (NQ >= "001") then
				CQ_D <= init_refresh;
			else
				CQ_D <= init_precharge_commit;
			end if;
      when init_refresh =>
			CE_B_D <= "00";
			CAS_D <= '0';
			RAS_D <= '0';
			CQ_D <= init_wait;
      when init_wait =>
			CE_B_D <= "00";
			if (	NQ >= "110" and
		      RQ >= "00000100") 
			then
				CQ_D <= init_opcode;
			elsif ( NQ >= "110" and
				RQ <= "00000100")
		   then
				CQ_D <= init_refresh;
			else
				CQ_D <= init_wait;
			end if;
      when init_opcode =>
			CE_B_D <= "00";
			WE_D <= '0';
			CAS_D <= '0';
			RAS_D <= '0';
			ARAM_D <= ARAM_OPTCODE;
			CQ_D <= end_cycle;
      when end_cycle =>
			CQ_D <= start_state;
      when start_state =>
			if (REFRESH='1') then
				CQ_D <= refresh_start;
			elsif (TRANSFER and RW_40 and (not SCLK))='1' then
				CQ_D <= read_start_ras;
			elsif (TRANSFER and (not RW_40) and SCLK)='1' then
				CQ_D <= write_start_ras;
			else
				CQ_D <= start_state;
			end if;
      when refresh_start =>
			CE_B_D <= "00";
			CAS_D <= '0';
			RAS_D <= '0';
			CQ_D <= refresh_wait;
      when refresh_wait =>
			if (NQ >= "110") then
				CQ_D <= start_state;
			else
				CQ_D <= refresh_wait;
			end if;
      when read_start_ras =>
			CE_B_D <= not SELRAM_D;
			RAS_D <= '0';
			ARAM_D <= ARAM_HIGH;
			CQ_D <= read_commit_ras;
	   when read_commit_ras =>
			CE_B_D <= not SELRAM_D;
			CQ_D <= read_start_cas;
      when read_start_cas =>
			OERAM_40_D <= '0';
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			CAS_D <= '0';
			ARAM_D <= ARAM_LOW;
			CQ_D <= read_commit_cas;
      when read_commit_cas =>
			OERAM_40_D <= '0';
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			CQ_D <= read_data_wait;
      when read_data_wait =>
			OERAM_40_D <= '0';
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			ENACLK_PRE <= '0';
			if (burst /="00") then
				CQ_D <= read_line_s0;
			else
				CQ_D <= precharge;
			end if;
      when read_line_s0 =>
			OERAM_40_D <= '0';
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			CQ_D <= read_data_wait;
      when write_start_ras =>
			CE_B_D <= not SELRAM_D;
			RAS_D <= '0';
			ARAM_D <= ARAM_HIGH;
			CQ_D <= write_commit_ras;
      when write_commit_ras =>
			OE40_RAM_D <= '0';
			CE_B_D <= not SELRAM_D;
			CQ_D <= write_tra_ack;
      when write_tra_ack =>
			OE40_RAM_D <= '0';
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			CQ_D <= write_start_cas;
      when write_start_cas =>
			OE40_RAM_D <= '0';		 
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			WE_D <= '0';
			TA40_D <= '0';
			CAS_D <= '0';
			ARAM_D <= ARAM_LOW;
			CQ_D <= write_commit_cas;
      when write_commit_cas =>
			OE40_RAM_D <= '0';
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			ENACLK_PRE <= '0';
			if (burst/="00") then
				CQ_D <= write_line_s0;
			else
				CQ_D <= precharge;
			end if;
      when write_line_s0 =>
			OE40_RAM_D <= '0';
			BYTE_D <= BYTE_ENCODE;
			CE_B_D <= not SELRAM_D;
			TA40_D <= '0';
			if (burst/="00") then
				CQ_D <= write_commit_cas;
			else
				CQ_D <= precharge;
			end if;
      when precharge =>
			CE_B_D <= "00";
			WE_D <= '0';
			RAS_D <= '0';
			ARAM_D <= ARAM_PRECHARGE;
			CQ_D <= end_cycle;
		end case;
   end process;
end ramcon_behav;
