-- Xilinx XPort Language Converter, Version 4.1 (110)
-- 
-- ABEL Design Source: ramcon.abl
-- VHDL Design Output: ramcon.vhd
-- Created 15-Oct-2015 08:47 PM
--
-- Copyright (c) 2015, Xilinx, Inc.  All Rights Reserved.
-- Xilinx Inc makes no warranty, expressed or implied, with respect to
-- the operation and/or functionality of the converted output files.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ramcon is
   Port (
      CLK_RAMC	: in STD_LOGIC;
      RESET		: in STD_LOGIC;
      A40		: in STD_LOGIC_VECTOR (30 downto 0);
      C4MHZ		: in STD_LOGIC;
	  RW_40		: in STD_LOGIC;
	  INIT		: in STD_LOGIC;
	  SIZ40		: in STD_LOGIC_VECTOR (1 downto 0);
	  TT40_1	: in STD_LOGIC;
	  TS40		: in STD_LOGIC;
	  SCLK		: in STD_LOGIC;
	  ICACHE	: in STD_LOGIC;
	  WE_FLASH	: in STD_LOGIC;
	  OE_FLASH	: in STD_LOGIC;
      TBI40		: in STD_LOGIC;
      D30		: in STD_LOGIC_VECTOR (31 downto 28);
	  UDQ0		: buffer STD_LOGIC;
	  UDQ1		: buffer STD_LOGIC;
	  LDQ0		: buffer STD_LOGIC;
	  LDQ1		: buffer STD_LOGIC;
	  CE_B0		: buffer STD_LOGIC;
	  CE_B1		: buffer STD_LOGIC;
	  WE		: buffer STD_LOGIC;
	  CAS		: buffer STD_LOGIC;
	  RAS		: buffer STD_LOGIC;
	  CLK_RAM	: buffer STD_LOGIC;
	  CLKEN		: buffer STD_LOGIC;
	  BA0		: buffer STD_LOGIC;
	  BA1		: buffer STD_LOGIC;
	  LE_RAM	: buffer STD_LOGIC;
	  OERAM_40	: buffer STD_LOGIC;
	  OE40_RAM	: buffer STD_LOGIC;
	  ARAM		: buffer STD_LOGIC_VECTOR (12 downto 0);
      SEL16M	: buffer STD_LOGIC;
      TA40		: buffer STD_LOGIC;
      TCI40		: buffer STD_LOGIC
   );
end ramcon;


architecture ramcon_behav of ramcon is
   signal RQ0_CLK_ctrl: STD_LOGIC;
   signal RQ0_ACLR_ctrl: STD_LOGIC;
   signal NQ0_CLK_ctrl: STD_LOGIC;
   signal NQ0_ACLR_ctrl: STD_LOGIC;
   signal ARAM_0_CLK_ctrl: STD_LOGIC;
   signal ARAM_0_ACLR_ctrl: STD_LOGIC;
   signal CQ0_CLK_ctrl: STD_LOGIC;
   signal CQ0_ACLR_ctrl: STD_LOGIC;
   signal BA1_FB, BA1_ASET, BA1_CLK, BA1_D: STD_LOGIC;
   signal BA0_FB, BA0_ASET, BA0_CLK, BA0_D: STD_LOGIC;
   signal RAS_FB, RAS_ASET, RAS_CLK, RAS_D: STD_LOGIC;
   signal CAS_FB, CAS_ASET, CAS_CLK, CAS_D: STD_LOGIC;
   signal TA40_FB, TA40_OE, TA40_ASET, TA40_CLK, TA40_D: STD_LOGIC;
   signal WE_FB, WE_ASET, WE_CLK, WE_D: STD_LOGIC;
   signal CE_B1_FB, CE_B1_ASET, CE_B1_CLK, CE_B1_D: STD_LOGIC;
   signal CE_B0_FB, CE_B0_ASET, CE_B0_CLK, CE_B0_D: STD_LOGIC;
   signal LDQ1_FB, LDQ1_ASET, LDQ1_CLK, LDQ1_D: STD_LOGIC;
   signal LDQ0_FB, LDQ0_ASET, LDQ0_CLK, LDQ0_D: STD_LOGIC;
   signal UDQ1_FB, UDQ1_ASET, UDQ1_CLK, UDQ1_D: STD_LOGIC;
   signal UDQ0_FB, UDQ0_ASET, UDQ0_CLK, UDQ0_D: STD_LOGIC;
   signal OERAM_40_FB, OERAM_40_ASET, OERAM_40_CLK, OERAM_40_D: STD_LOGIC;
   signal OE40_RAM_FB, OE40_RAM_ASET, OE40_RAM_CLK, OE40_RAM_D: STD_LOGIC;
   signal SELRAM1: STD_LOGIC;
   signal SELRAM0: STD_LOGIC;
   signal REFRESH: STD_LOGIC;
   signal ENACLK: STD_LOGIC;
   signal ENANOPC: STD_LOGIC;
   signal CLRNOPC: STD_LOGIC;
   signal CLRREFC: STD_LOGIC;
   signal CLRTRAN: STD_LOGIC;
   signal TRANSFER_FB, TRANSFER_ACLR, TRANSFER_CLK, TRANSFER_D, TRANSFER: STD_LOGIC;
   signal NQ: STD_LOGIC_VECTOR(2 downto 0);
   signal CQ: STD_LOGIC_VECTOR(5 downto 0);
   signal RQ: STD_LOGIC_VECTOR(7 downto 0);
   signal NQ_FB: STD_LOGIC_VECTOR(2 downto 0);
   signal CQ_FB: STD_LOGIC_VECTOR(5 downto 0);
   signal RQ_FB: STD_LOGIC_VECTOR(7 downto 0);
   signal NQ_D: STD_LOGIC_VECTOR(2 downto 0);
   signal CQ_D: STD_LOGIC_VECTOR(5 downto 0);
   signal RQ_D: STD_LOGIC_VECTOR(7 downto 0);
   signal ARAM_FB: STD_LOGIC_VECTOR(12 downto 0);
   signal ARAM_D: STD_LOGIC_VECTOR(12 downto 0);

   Function to_std_logic(X: in Boolean) return Std_Logic is
   variable ret : STD_LOGIC;
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

   UDQ0 <= UDQ0_FB;
   process (UDQ0_CLK, UDQ0_ASET) begin
      if UDQ0_ASET='1' then
	 UDQ0_FB <= '1';
      elsif UDQ0_CLK'event and UDQ0_CLK='1' then
	 UDQ0_FB <= UDQ0_D;
      end if;
   end process;

   UDQ1 <= UDQ1_FB;
   process (UDQ1_CLK, UDQ1_ASET) begin
      if UDQ1_ASET='1' then
	 UDQ1_FB <= '1';
      elsif UDQ1_CLK'event and UDQ1_CLK='1' then
	 UDQ1_FB <= UDQ1_D;
      end if;
   end process;

   LDQ0 <= LDQ0_FB;
   process (LDQ0_CLK, LDQ0_ASET) begin
      if LDQ0_ASET='1' then
	 LDQ0_FB <= '1';
      elsif LDQ0_CLK'event and LDQ0_CLK='1' then
	 LDQ0_FB <= LDQ0_D;
      end if;
   end process;

   LDQ1 <= LDQ1_FB;
   process (LDQ1_CLK, LDQ1_ASET) begin
      if LDQ1_ASET='1' then
	 LDQ1_FB <= '1';
      elsif LDQ1_CLK'event and LDQ1_CLK='1' then
	 LDQ1_FB <= LDQ1_D;
      end if;
   end process;

   CE_B0 <= CE_B0_FB;
   process (CE_B0_CLK, CE_B0_ASET) begin
      if CE_B0_ASET='1' then
	 CE_B0_FB <= '1';
      elsif CE_B0_CLK'event and CE_B0_CLK='1' then
	 CE_B0_FB <= CE_B0_D;
      end if;
   end process;

   CE_B1 <= CE_B1_FB;
   process (CE_B1_CLK, CE_B1_ASET) begin
      if CE_B1_ASET='1' then
	 CE_B1_FB <= '1';
      elsif CE_B1_CLK'event and CE_B1_CLK='1' then
	 CE_B1_FB <= CE_B1_D;
      end if;
   end process;

   WE <= WE_FB;
   process (WE_CLK, WE_ASET) begin
      if WE_ASET='1' then
	 WE_FB <= '1';
      elsif WE_CLK'event and WE_CLK='1' then
	 WE_FB <= WE_D;
      end if;
   end process;

   CAS <= CAS_FB;
   process (CAS_CLK, CAS_ASET) begin
      if CAS_ASET='1' then
	 CAS_FB <= '1';
      elsif CAS_CLK'event and CAS_CLK='1' then
	 CAS_FB <= CAS_D;
      end if;
   end process;

   RAS <= RAS_FB;
   process (RAS_CLK, RAS_ASET) begin
      if RAS_ASET='1' then
	 RAS_FB <= '1';
      elsif RAS_CLK'event and RAS_CLK='1' then
	 RAS_FB <= RAS_D;
      end if;
   end process;

   BA0 <= BA0_FB;
   process (BA0_CLK, BA0_ASET) begin
      if BA0_ASET='1' then
	 BA0_FB <= '1';
      elsif BA0_CLK'event and BA0_CLK='1' then
	 BA0_FB <= BA0_D;
      end if;
   end process;

   BA1 <= BA1_FB;
   process (BA1_CLK, BA1_ASET) begin
      if BA1_ASET='1' then
	 BA1_FB <= '1';
      elsif BA1_CLK'event and BA1_CLK='1' then
	 BA1_FB <= BA1_D;
      end if;
   end process;

   OERAM_40 <= OERAM_40_FB;
   process (OERAM_40_CLK, OERAM_40_ASET) begin
      if OERAM_40_ASET='1' then
	 OERAM_40_FB <= '1';
      elsif OERAM_40_CLK'event and OERAM_40_CLK='1' then
	 OERAM_40_FB <= OERAM_40_D;
      end if;
   end process;

   OE40_RAM <= OE40_RAM_FB;
   process (OE40_RAM_CLK, OE40_RAM_ASET) begin
      if OE40_RAM_ASET='1' then
	 OE40_RAM_FB <= '1';
      elsif OE40_RAM_CLK'event and OE40_RAM_CLK='1' then
	 OE40_RAM_FB <= OE40_RAM_D;
      end if;
   end process;

   ARAM <= ARAM_FB;
   process (ARAM_0_CLK_ctrl, ARAM_0_ACLR_ctrl) begin
      if ARAM_0_ACLR_ctrl='1' then
	 	ARAM_FB	<= "0000000000000";
      elsif ARAM_0_CLK_ctrl'event and ARAM_0_CLK_ctrl='1' then
	 	ARAM_FB <= ARAM_D;
      end if;
   end process;

   TA40 <= TA40_FB when TA40_OE='1' else 'Z';
   process (TA40_CLK, TA40_ASET) begin
      if TA40_ASET='1' then
	 TA40_FB <= '1';
      elsif TA40_CLK'event and TA40_CLK='1' then
	 TA40_FB <= TA40_D;
      end if;
   end process;

   RQ <= RQ_FB;
   process (RQ0_CLK_ctrl, RQ0_ACLR_ctrl) begin
      if RQ0_ACLR_ctrl='1' then
	 	RQ_FB<="00000000";
      elsif RQ0_CLK_ctrl'event and RQ0_CLK_ctrl='1' then
	 	RQ_FB <= RQ_D;
      end if;
   end process;

   CQ <= CQ_FB;
   process (CQ0_CLK_ctrl, CQ0_ACLR_ctrl) begin
      if CQ0_ACLR_ctrl='1' then
	 	CQ_FB <= "000000";
      elsif CQ0_CLK_ctrl'event and CQ0_CLK_ctrl='1' then
	 	CQ_FB <= CQ_D;
      end if;
   end process;

   NQ <= NQ_FB;
   process (NQ0_CLK_ctrl, NQ0_ACLR_ctrl) begin
      if NQ0_ACLR_ctrl='1' then
	 	NQ_FB<= "000";
      elsif NQ0_CLK_ctrl'event and NQ0_CLK_ctrl='1' then
	 	NQ_FB <= NQ_D;
      end if;
   end process;

   TRANSFER <= TRANSFER_FB;
   process (TRANSFER_CLK, TRANSFER_ACLR) begin
      if TRANSFER_ACLR='1' then
	 TRANSFER_FB <= '0';
      elsif TRANSFER_CLK'event and TRANSFER_CLK='1' then
	 TRANSFER_FB <= TRANSFER_D;
      end if;
   end process;

-- Start of original equations
   SEL16M <= (not A40(30)) and (not A40(29)) and (not A40(28)) and (not A40(27))
	 and (not A40(26)) and (not A40(25));
   SELRAM0 <= (not A40(30)) and (not A40(29)) and (not A40(28)) and A40(27) and
	 (not A40(26)) and (not A40(25));
   SELRAM1 <= (not A40(30)) and (not A40(29)) and (not A40(28)) and A40(27) and
	 (not A40(26)) and A40(25);
   TCI40 <= (ICACHE and SEL16M and (not A40(24)) and A40(23) and A40(22) and
	 A40(21) and A40(20) and A40(19)) or (ICACHE and SEL16M and (not A40(24))
	 and (not A40(23)) and (not A40(22)) and (not A40(21))) or (ICACHE and
	 SEL16M and (((not A40(24)) and (not A40(23)) and (not A40(22)) and
	 A40(21)) or ((not A40(24)) and (not A40(23)) and A40(22)) or ((not A40(24))
	 and A40(23) and (not A40(22)) and (not A40(21))))) or (SEL16M and
	 ((A40(24) and (not A40(23)) and (not A40(22)) and A40(21)) or (A40(24) and
	 (not A40(23)) and A40(22)) or (A40(24) and A40(23) and (not A40(22)) and
	 (not A40(21))))) or SELRAM0 or SELRAM1;
   TRANSFER_D <= '1';
   TRANSFER_CLK <= (not TS40) and (not TT40_1) and (SELRAM0 or SELRAM1);
   TRANSFER_ACLR <= CLRTRAN or (not RESET);
   TA40_OE <= SELRAM0 or SELRAM1;
   LE_RAM <= '0';
   RQ0_CLK_ctrl <= C4MHZ;
   RQ0_ACLR_ctrl <= (not RESET) or CLRREFC;
   RQ_D <=	RQ + 1;
   REFRESH <= '1' when RQ >= "00111100" else '0';
   NQ0_CLK_ctrl <= CLK_RAMC;
   NQ0_ACLR_ctrl <= (not RESET) or CLRNOPC;
   NQ_D	<= "000" when ENANOPC ='1' else NQ + "001";
   CLK_RAM <= (not CLK_RAMC) and ENACLK;
   CLKEN <= '1';
   TA40_CLK <= CLK_RAMC;
   TA40_ASET <= not RESET;
   OERAM_40_CLK <= CLK_RAMC;
   OERAM_40_ASET <= not RESET;
   OE40_RAM_CLK <= CLK_RAMC;
   OE40_RAM_ASET <= not RESET;
   UDQ0_CLK <= CLK_RAMC;
   UDQ0_ASET <= not RESET;
   UDQ1_CLK <= CLK_RAMC;
   UDQ1_ASET <= not RESET;
   LDQ0_CLK <= CLK_RAMC;
   LDQ0_ASET <= not RESET;
   LDQ1_CLK <= CLK_RAMC;
   LDQ1_ASET <= not RESET;
   CE_B0_CLK <= CLK_RAMC;
   CE_B0_ASET <= not RESET;
   CE_B1_CLK <= CLK_RAMC;
   CE_B1_ASET <= not RESET;
   WE_CLK <= CLK_RAMC;
   WE_ASET <= not RESET;
   CAS_CLK <= CLK_RAMC;
   CAS_ASET <= not RESET;
   RAS_CLK <= CLK_RAMC;
   RAS_ASET <= not RESET;
   BA0_CLK <= CLK_RAMC;
   BA0_ASET <= not RESET;
   BA1_CLK <= CLK_RAMC;
   BA1_ASET <= not RESET;
   ARAM_0_CLK_ctrl <= CLK_RAMC;
   ARAM_0_ACLR_ctrl <= not RESET;
   CQ0_CLK_ctrl <= CLK_RAMC;
   CQ0_ACLR_ctrl <= not RESET;


   process (CQ_FB, INIT, RQ, REFRESH, TRANSFER, SCLK, A40, RW_40, 
   	 SIZ40, SELRAM0, SELRAM1, NQ)
   begin
      (CLRREFC, CLRTRAN, CLRNOPC, OERAM_40_D, OE40_RAM_D, UDQ0_D, UDQ1_D, LDQ0_D,
	    LDQ1_D, CE_B0_D, CE_B1_D, WE_D, TA40_D, CAS_D, RAS_D, BA0_D, BA1_D,
	    ENACLK, ENANOPC) <=
	    std_logic_vector'("0000000000000000000");
	    ARAM_D <= "0000000000000";
	    CQ_D <= "000000";
      case CQ_FB is
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 if (INIT)='1' then
	    CQ_D <=  std_logic_vector'("000001");
	 else
	    CQ_D <=  std_logic_vector'("000000");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <=
	       std_logic_vector'(A40(22) & '1' & A40(20) & A40(19) & A40(18) &
	       A40(17) & A40(16) & A40(15) & A40(14) & A40(13) & A40(12) & A40(11));
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("000011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 CLRREFC <= '1';
	 if (NQ >= "001") then 
		CQ_D <= std_logic_vector'("000010");
	 else
		CQ_D <= std_logic_vector'("000011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("000110");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (NQ >= "110" and RQ >= "00000100") then
	    CQ_D <= std_logic_vector'("000111");
	 elsif (NQ >= "110" and RQ <= "00000100") then
	    CQ_D <= std_logic_vector'("000010");
	 else
	    CQ_D <= std_logic_vector'("000110");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <= std_logic_vector'("000000100010");
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CLRREFC <= '1';
	 CQ_D <= std_logic_vector'("000101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (NQ >= "001") then
	    CQ_D <= std_logic_vector'("000100");
	 else
	    CQ_D <= std_logic_vector'("000101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 if (REFRESH)='1' then
	    CQ_D <= std_logic_vector'("001100");
	 elsif ((not REFRESH) and TRANSFER and RW_40 and (not SCLK))='1' then
	    CQ_D <= std_logic_vector'("001111");
	 elsif ((not REFRESH) and TRANSFER and (not RW_40) and SCLK)='1' then
	    CQ_D <= std_logic_vector'("011100");
	 else
	    CQ_D <= std_logic_vector'("000100");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CLRREFC <= '1';
	 CQ_D <= std_logic_vector'("001101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (NQ >= "110") then
	    CQ_D <= std_logic_vector'("000100");
	 else
	    CQ_D <= std_logic_vector'("001101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <= A40(22 downto 11);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CLRTRAN <= '1';
	 CQ_D <= std_logic_vector'("001110");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("001010");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <=
	       std_logic_vector'('0' & '0' & '0' & A40(10) & A40(9) & A40(8) &
	       A40(7) & A40(6) & A40(5) & A40(4) & A40(3) & A40(2));
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("001011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("001001");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (SIZ40(0) and SIZ40(1))='1' then
	    CQ_D <= std_logic_vector'("001000");
	 else
	    CQ_D <= std_logic_vector'("011111");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011000");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011001");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011010");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011110");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011111");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <=
	       std_logic_vector'(A40(22) & '1' & A40(20) & A40(19) & A40(18) &
	       A40(17) & A40(16) & A40(15) & A40(14) & A40(13) & A40(12) & A40(11));
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("011101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (NQ >= "001") then
	    CQ_D <= std_logic_vector'("000100");
	 else
	    CQ_D <= std_logic_vector'("011101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <= A40(22 downto 11);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CLRTRAN <= '1';
	 CQ_D <= std_logic_vector'("010100");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010101");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010111");
      when "010111" =>
	 OERAM_40_D <= '1';
	 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 UDQ0_D <= not ((A40(1) and (not A40(0)) and (not SIZ40(1)) and SIZ40(0))
	       or (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and
	       (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 UDQ1_D <= not (((not A40(1)) and (not A40(0)) and (not SIZ40(1)) and
	       SIZ40(0)) or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not
	       SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ0_D <= not ((A40(1) and A40(0) and (not SIZ40(1)) and SIZ40(0)) or
	       (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ1_D <= not (((not A40(1)) and A40(0) and (not SIZ40(1)) and SIZ40(0))
	       or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1))
	       and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 CE_B0_D <= not SELRAM0;
	 CE_B1_D <= not SELRAM1;
	 WE_D <= '0';
	 TA40_D <= '0';
	 CAS_D <= '0';
	 RAS_D <= '1';
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <=
	       std_logic_vector'('0' & '0' & '0' & A40(10) & A40(9) & A40(8) &
	       A40(7) & A40(6) & A40(5) & A40(4) & A40(3) & A40(2));
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010110");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 if (SIZ40(0) and SIZ40(1))='1' then
	    CQ_D <= std_logic_vector'("010010");
	 else
	    CQ_D <= std_logic_vector'("110001");
	 end if;
      when "010010" =>
	 OERAM_40_D <= '1';
	 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 UDQ0_D <= not ((A40(1) and (not A40(0)) and (not SIZ40(1)) and SIZ40(0))
	       or (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and
	       (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 UDQ1_D <= not (((not A40(1)) and (not A40(0)) and (not SIZ40(1)) and
	       SIZ40(0)) or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not
	       SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ0_D <= not ((A40(1) and A40(0) and (not SIZ40(1)) and SIZ40(0)) or
	       (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ1_D <= not (((not A40(1)) and A40(0) and (not SIZ40(1)) and SIZ40(0))
	       or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1))
	       and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 CE_B0_D <= not SELRAM0;
	 CE_B1_D <= not SELRAM1;
	 WE_D <= '1';
	 TA40_D <= '0';
	 CAS_D <= '1';
	 RAS_D <= '1';
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010001");
      when "010001" =>
	 OERAM_40_D <= '1';
	 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 UDQ0_D <= not ((A40(1) and (not A40(0)) and (not SIZ40(1)) and SIZ40(0))
	       or (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and
	       (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 UDQ1_D <= not (((not A40(1)) and (not A40(0)) and (not SIZ40(1)) and
	       SIZ40(0)) or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not
	       SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ0_D <= not ((A40(1) and A40(0) and (not SIZ40(1)) and SIZ40(0)) or
	       (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ1_D <= not (((not A40(1)) and A40(0) and (not SIZ40(1)) and SIZ40(0))
	       or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1))
	       and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 CE_B0_D <= not SELRAM0;
	 CE_B1_D <= not SELRAM1;
	 WE_D <= '1';
	 TA40_D <= '0';
	 CAS_D <= '1';
	 RAS_D <= '1';
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("010000");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("110000");
      when "110000" =>
	 OERAM_40_D <= '1';
	 OE40_RAM_D <= not ((SELRAM0 or SELRAM1) and (not RW_40));
	 UDQ0_D <= not ((A40(1) and (not A40(0)) and (not SIZ40(1)) and SIZ40(0))
	       or (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and
	       (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 UDQ1_D <= not (((not A40(1)) and (not A40(0)) and (not SIZ40(1)) and
	       SIZ40(0)) or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not
	       SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ0_D <= not ((A40(1) and A40(0) and (not SIZ40(1)) and SIZ40(0)) or
	       (A40(1) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 LDQ1_D <= not (((not A40(1)) and A40(0) and (not SIZ40(1)) and SIZ40(0))
	       or ((not A40(1)) and SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1))
	       and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0)));
	 CE_B0_D <= not SELRAM0;
	 CE_B1_D <= not SELRAM1;
	 WE_D <= '1';
	 TA40_D <= '0';
	 CAS_D <= '1';
	 RAS_D <= '1';
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '0';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("110001");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("110011");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ARAM_D(11 downto 0) <=
	       std_logic_vector'(A40(22) & '1' & A40(20) & A40(19) & A40(18) &
	       A40(17) & A40(16) & A40(15) & A40(14) & A40(13) & A40(12) & A40(11));
	 ENACLK <= '1';
	 CLRNOPC <= '1';
	 CQ_D <= std_logic_vector'("110010");
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
	 BA0_D <= A40(23);
	 BA1_D <= A40(24);
	 ENACLK <= '1';
	 ENANOPC <= '1';
	 if (NQ >= "001") then
	    CQ_D <= std_logic_vector'("000100");
	 else
	    CQ_D <= std_logic_vector'("110010");
	 end if;
      when others =>
      end case;
   end process;
end ramcon_behav;
