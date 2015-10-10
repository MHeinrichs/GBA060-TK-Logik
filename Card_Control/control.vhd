-- Xilinx XPort Language Converter, Version 4.1 (110)
-- 
-- ABEL Design Source: C:\Users\Matze\Amiga\Hardwarehacks\gb_a1k_tk\Logik\Card_Control\control.abl
-- VHDL Design Output: control.vhd
-- Created 04-Oct-2015 10:10 PM
--
-- Copyright (c) 2015, Xilinx, Inc.  All Rights Reserved.
-- Xilinx Inc makes no warranty, expressed or implied, with respect to
-- the operation and/or functionality of the converted output files.
-- 

Library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_arith.all;
entity control is
   Port (
      SEL16M, PLL_CLK, RSTO40, HALT30, IPL30_0, IPL30_1, IPL30_2, DSACK30_0,
	    DSACK30_1, STERM30, CPU40_60, A40_0, A40_1, SIZ40_0, SIZ40_1, RW40,
	    TM40_0, TM40_1, TM40_2, TT40_0, TT40_1, TS40: in std_logic;
      PLL_S0, PLL_S1, CLK30, PCLK, BCLK, SCLK, CLK_BS, CLK_RAMC, AL_0, AL_1,
	    A30_LE, OE_BS, LE_BS, DIR_BS, BWL0_BS, BWL1_BS, BWL2_BS, FC30_0,
	    FC30_1, FC30_2, AS30, DS30, RW30, SIZ30_0, SIZ30_1, RESET30,
	    RSTI40, IPL40_0, IPL40_1, IPL40_2, TBI40, MDIS40, CDIS40, TA40,
	    TEA40, BGR60, ICACHE: buffer std_logic
   );
end control;


architecture control_behav of control is
   signal H0_CLK_ctrl, H0_ACLR_ctrl, F0_CLK_ctrl, F0_ACLR_ctrl, CAQ0_CLK_ctrl,
	 CAQ0_ACLR_ctrl, AMIQ0_CLK_ctrl, AMIQ0_ACLR_ctrl, PLL_S1_ZD, PLL_S0_ZD,
	 RESET30_ZD, TA40_ZD, H11_D, H10_D, H9_D, H8_D, H7_D, H6_D, H5_D, H4_D,
	 H3_D, H2_D, H1_D, H0_D, F10_D, F9_D, F8_D, F7_D, F6_D, F5_D, F4_D,
	 F3_D, F2_D, F1_D, F0_D, LE_BS_D, ATERM_D, DS30_D, AS30_D, AMIQ0_D,
	 AMIQ1_D, LE_BS_CLK, LE_BS_ACLR, ATERM_CLK, ATERM_ACLR, DS30_CLK,
	 DS30_ASET, AS30_CLK, AS30_ASET, CNTDIS_D, CNTDIS_CLK, CNTDIS_ACLR,
	 LEND_D, DS30_OE, AS30_OE, CAQ0_D, CAQ1_D, CAQ2_D, LEND_CLK, LEND_ACLR,
	 TA40_OE, LDSACK1_D, LDSACK1_CLK, LDSACK1_ACLR, LDSACK0_D, LDSACK0_CLK,
	 LDSACK0_ACLR, QDSACK1_D, QDSACK1_CLK, QDSACK1_ACLR, QDSACK0_D,
	 QDSACK0_CLK, QDSACK0_ACLR, RSTINT_ACLR, RSTINT_CLK, RSTINT_D,
	 RESET30_OE, RSTI40_D, RSTI40_CLK, CLK30_T, CLK30_CLK, BCLK_D,
	 BCLK_CLK, SCLK_D, SCLK_CLK, PCLK_D, PCLK_CLK, CLK_BS_D, CLK_BS_CLK,
	 CLK_RAMC_T, CLK_RAMC_CLK, PLL_S0_OE, PLL_S1_OE, STOPHALT, STOPRES, F0,
	 F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, H0, H1, H2, H3, H4, H5, H6,
	 H7, H8, H9, H10, H11, BYTEPORT, WORDPORT, LONGPORT, AMISEL, NAMIACC,
	 ATERM, LEND, CAQ0, CAQ1, CAQ2, CNTDIS, QDSACK1, QDSACK0, LDSACK1,
	 LDSACK0, AMIQ1, AMIQ0, RSTINT: std_logic;
   signal CLK30_FB, PCLK_FB, BCLK_FB, SCLK_FB, CLK_BS_FB, CLK_RAMC_FB,
	 LE_BS_FB, DS30_FB, RSTI40_FB, RSTINT_FB, AMIQ0_FB, AMIQ1_FB,
	 LDSACK0_FB, LDSACK1_FB, QDSACK0_FB, QDSACK1_FB, CNTDIS_FB, CAQ2_FB,
	 CAQ1_FB, CAQ0_FB, LEND_FB, ATERM_FB, H11_FB, H10_FB, H9_FB, H8_FB,
	 H7_FB, H6_FB, H5_FB, H4_FB, H3_FB, H2_FB, H1_FB, H0_FB, F10_FB, F9_FB,
	 F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB, F1_FB, F0_FB,
	 AS30_FB: std_logic
	 -- :='0'
	 ;

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

-- Tristate Section
   TA40 <= TA40_ZD when TA40_OE='1' else 'Z';
   RESET30 <= RESET30_ZD when RESET30_OE='1' else 'Z';
   PLL_S1 <= PLL_S1_ZD when PLL_S1_OE='1' else 'Z';
   PLL_S0 <= PLL_S0_ZD when PLL_S0_OE='1' else 'Z';

-- Register Section

   CLK30 <= CLK30_FB;
   process (CLK30_CLK) begin
      if CLK30_CLK'event and CLK30_CLK='1' then
	 CLK30_FB <= CLK30_FB xor CLK30_T;
      end if;
   end process;

   PCLK <= PCLK_FB;
   process (PCLK_CLK) begin
      if PCLK_CLK'event and PCLK_CLK='1' then
	 PCLK_FB <= PCLK_D;
      end if;
   end process;

   BCLK <= BCLK_FB;
   process (BCLK_CLK) begin
      if BCLK_CLK'event and BCLK_CLK='1' then
	 BCLK_FB <= BCLK_D;
      end if;
   end process;

   SCLK <= SCLK_FB;
   process (SCLK_CLK) begin
      if SCLK_CLK'event and SCLK_CLK='1' then
	 SCLK_FB <= SCLK_D;
      end if;
   end process;

   CLK_BS <= CLK_BS_FB;
   process (CLK_BS_CLK) begin
      if CLK_BS_CLK'event and CLK_BS_CLK='1' then
	 CLK_BS_FB <= CLK_BS_D;
      end if;
   end process;

   CLK_RAMC <= CLK_RAMC_FB;
   process (CLK_RAMC_CLK) begin
      if CLK_RAMC_CLK'event and CLK_RAMC_CLK='1' then
	 CLK_RAMC_FB <= CLK_RAMC_FB xor CLK_RAMC_T;
      end if;
   end process;

   LE_BS <= LE_BS_FB;
   process (LE_BS_CLK, LE_BS_ACLR) begin
      if LE_BS_ACLR='1' then
	 LE_BS_FB <= '0';
      elsif LE_BS_CLK'event and LE_BS_CLK='1' then
	 LE_BS_FB <= LE_BS_D;
      end if;
   end process;

   AS30 <= AS30_FB when AS30_OE='1' else 'Z';
   process (AS30_CLK, AS30_ASET) begin
      if AS30_ASET='1' then
	 AS30_FB <= '1';
      elsif AS30_CLK'event and AS30_CLK='1' then
	 AS30_FB <= AS30_D;
      end if;
   end process;

   DS30 <= DS30_FB when DS30_OE='1' else 'Z';
   process (DS30_CLK, DS30_ASET) begin
      if DS30_ASET='1' then
	 DS30_FB <= '1';
      elsif DS30_CLK'event and DS30_CLK='1' then
	 DS30_FB <= DS30_D;
      end if;
   end process;

   RSTI40 <= RSTI40_FB;
   process (RSTI40_CLK) begin
      if RSTI40_CLK'event and RSTI40_CLK='1' then
	 RSTI40_FB <= RSTI40_D;
      end if;
   end process;

   RSTINT <= RSTINT_FB;
   process (RSTINT_CLK, RSTINT_ACLR) begin
      if RSTINT_ACLR='1' then
	 RSTINT_FB <= '0';
      elsif RSTINT_CLK'event and RSTINT_CLK='1' then
	 RSTINT_FB <= RSTINT_D;
      end if;
   end process;

   (AMIQ0, AMIQ1) <= std_logic_vector'(AMIQ0_FB & AMIQ1_FB);
   process (AMIQ0_CLK_ctrl, AMIQ0_ACLR_ctrl) begin
      if AMIQ0_ACLR_ctrl='1' then
	 (AMIQ0_FB, AMIQ1_FB) <= std_logic_vector'("00");
      elsif AMIQ0_CLK_ctrl'event and AMIQ0_CLK_ctrl='1' then
	 (AMIQ0_FB, AMIQ1_FB) <= std_logic_vector'(AMIQ0_D & AMIQ1_D);
      end if;
   end process;

   LDSACK0 <= LDSACK0_FB;
   process (LDSACK0_CLK, LDSACK0_ACLR) begin
      if LDSACK0_ACLR='1' then
	 LDSACK0_FB <= '0';
      elsif LDSACK0_CLK'event and LDSACK0_CLK='1' then
	 LDSACK0_FB <= LDSACK0_D;
      end if;
   end process;

   LDSACK1 <= LDSACK1_FB;
   process (LDSACK1_CLK, LDSACK1_ACLR) begin
      if LDSACK1_ACLR='1' then
	 LDSACK1_FB <= '0';
      elsif LDSACK1_CLK'event and LDSACK1_CLK='1' then
	 LDSACK1_FB <= LDSACK1_D;
      end if;
   end process;

   QDSACK0 <= QDSACK0_FB;
   process (QDSACK0_CLK, QDSACK0_ACLR) begin
      if QDSACK0_ACLR='1' then
	 QDSACK0_FB <= '0';
      elsif QDSACK0_CLK'event and QDSACK0_CLK='1' then
	 QDSACK0_FB <= QDSACK0_D;
      end if;
   end process;

   QDSACK1 <= QDSACK1_FB;
   process (QDSACK1_CLK, QDSACK1_ACLR) begin
      if QDSACK1_ACLR='1' then
	 QDSACK1_FB <= '0';
      elsif QDSACK1_CLK'event and QDSACK1_CLK='1' then
	 QDSACK1_FB <= QDSACK1_D;
      end if;
   end process;

   CNTDIS <= CNTDIS_FB;
   process (CNTDIS_CLK, CNTDIS_ACLR) begin
      if CNTDIS_ACLR='1' then
	 CNTDIS_FB <= '0';
      elsif CNTDIS_CLK'event and CNTDIS_CLK='1' then
	 CNTDIS_FB <= CNTDIS_D;
      end if;
   end process;

   (CAQ2, CAQ1, CAQ0) <= std_logic_vector'(CAQ2_FB & CAQ1_FB & CAQ0_FB);
   process (CAQ0_CLK_ctrl, CAQ0_ACLR_ctrl) begin
      if CAQ0_ACLR_ctrl='1' then
	 (CAQ2_FB, CAQ1_FB, CAQ0_FB) <= std_logic_vector'("000");
      elsif CAQ0_CLK_ctrl'event and CAQ0_CLK_ctrl='1' then
	 (CAQ2_FB, CAQ1_FB, CAQ0_FB) <= std_logic_vector'(CAQ2_D & CAQ1_D &
	       CAQ0_D);
      end if;
   end process;

   LEND <= LEND_FB;
   process (LEND_CLK, LEND_ACLR) begin
      if LEND_ACLR='1' then
	 LEND_FB <= '0';
      elsif LEND_CLK'event and LEND_CLK='1' then
	 LEND_FB <= LEND_D;
      end if;
   end process;

   ATERM <= ATERM_FB;
   process (ATERM_CLK, ATERM_ACLR) begin
      if ATERM_ACLR='1' then
	 ATERM_FB <= '0';
      elsif ATERM_CLK'event and ATERM_CLK='1' then
	 ATERM_FB <= ATERM_D;
      end if;
   end process;

   (H11, H10, H9, H8, H7, H6, H5, H4, H3, H2, H1, H0) <=
	 std_logic_vector'(H11_FB & H10_FB & H9_FB & H8_FB & H7_FB & H6_FB &
	 H5_FB & H4_FB & H3_FB & H2_FB & H1_FB & H0_FB);
   process (H0_CLK_ctrl, H0_ACLR_ctrl) begin
      if H0_ACLR_ctrl='1' then
	 (H11_FB, H10_FB, H9_FB, H8_FB, H7_FB, H6_FB, H5_FB, H4_FB, H3_FB,
	       H2_FB, H1_FB, H0_FB) <= std_logic_vector'("000000000000");
      elsif H0_CLK_ctrl'event and H0_CLK_ctrl='1' then
	 (H11_FB, H10_FB, H9_FB, H8_FB, H7_FB, H6_FB, H5_FB, H4_FB, H3_FB,
	       H2_FB, H1_FB, H0_FB) <= std_logic_vector'(H11_D & H10_D & H9_D &
	       H8_D & H7_D & H6_D & H5_D & H4_D & H3_D & H2_D & H1_D & H0_D);
      end if;
   end process;

   (F10, F9, F8, F7, F6, F5, F4, F3, F2, F1, F0) <= std_logic_vector'(F10_FB &
	 F9_FB & F8_FB & F7_FB & F6_FB & F5_FB & F4_FB & F3_FB & F2_FB & F1_FB
	 & F0_FB);
   process (F0_CLK_ctrl, F0_ACLR_ctrl) begin
      if F0_ACLR_ctrl='1' then
	 (F10_FB, F9_FB, F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB,
	       F1_FB, F0_FB) <= std_logic_vector'("00000000000");
      elsif F0_CLK_ctrl'event and F0_CLK_ctrl='1' then
	 (F10_FB, F9_FB, F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB,
	       F1_FB, F0_FB) <= std_logic_vector'(F10_D & F9_D & F8_D & F7_D &
	       F6_D & F5_D & F4_D & F3_D & F2_D & F1_D & F0_D);
      end if;
   end process;

-- Start of original equations
   PLL_S1_ZD <= '0';
   PLL_S1_OE <= '1';
   PLL_S0_ZD <= '1';
   PLL_S0_OE <= '0';
   CLK_RAMC_CLK <= PLL_CLK;
   CLK_RAMC_T <= '1';
   CLK_BS_CLK <= PLL_CLK;
   CLK_BS_D <= not CLK_RAMC;
   PCLK_CLK <= PLL_CLK;
   PCLK_D <= not CLK_RAMC;
   SCLK_CLK <= PLL_CLK;
   SCLK_D <= CLK30 xor CLK_RAMC;
   BCLK_CLK <= (PLL_CLK and CPU40_60) or ((not PLL_CLK) and (not CPU40_60));
   BCLK_D <= CLK30 xor CLK_RAMC;
   CLK30_CLK <= PLL_CLK;
   CLK30_T <= not CLK_RAMC;
   H0_CLK_ctrl <= SCLK;
   H0_ACLR_ctrl <= not HALT30;
   (H11_D, H10_D, H9_D, H8_D, H7_D, H6_D, H5_D, H4_D, H3_D, H2_D, H1_D, H0_D)
	 <= ((std_logic_vector'(unsigned(std_logic_vector'(H11 & H10 & H9 & H8
	 & H7 & H6 & H5 & H4 & H3 & H2 & H1 & H0)) +
	 unsigned'("000000000001"))) and (not (sizeIt(STOPHALT,12)))) or
	 (std_logic_vector'(H11 & H10 & H9 & H8 & H7 & H6 & H5 & H4 & H3 & H2 &
	 H1 & H0) and sizeIt(STOPHALT,12));
   STOPHALT <= H11 and H10 and H9 and H8 and H7;
   RSTI40_CLK <= SCLK;
   RSTI40_D <= not (((not (RESET30)) and RSTO40) or ((not STOPHALT) and
	 RSTO40));
   F0_CLK_ctrl <= SCLK;
   F0_ACLR_ctrl <= not RSTO40;
   (F10_D, F9_D, F8_D, F7_D, F6_D, F5_D, F4_D, F3_D, F2_D, F1_D, F0_D) <=
	 ((std_logic_vector'(unsigned(std_logic_vector'(F10 & F9 & F8 & F7 & F6
	 & F5 & F4 & F3 & F2 & F1 & F0)) + unsigned'("00000000001"))) and (not
	 (sizeIt(STOPRES,11)))) or (std_logic_vector'(F10 & F9 & F8 & F7 & F6 &
	 F5 & F4 & F3 & F2 & F1 & F0) and sizeIt(STOPRES,11));
   STOPRES <= F10 and F9 and F8 and F7;
   RESET30_OE <= ((not RSTO40) and STOPHALT) or ((not (RESET30)) and (not
	 STOPRES));
   RESET30_ZD <= not (((not RSTO40) and STOPHALT) or ((not (RESET30)) and (not
	 STOPRES)));
   RSTINT_D <= RSTI40;
   RSTINT_CLK <= SCLK;
   RSTINT_ACLR <= not RSTI40;
   IPL40_0 <= (RSTINT and IPL30_0) or ((not RSTINT) and '1');
   IPL40_1 <= (RSTINT and IPL30_1) or ((not RSTINT) and '1');
   IPL40_2 <= (RSTINT and IPL30_2) or ((not RSTINT) and '1');
   CDIS40 <= RSTINT or ((not RSTINT) and '1');
   MDIS40 <= RSTINT or ((not RSTINT) and '1');
   BGR60 <= '0';
   RW30 <= RW40;
   A30_LE <= '0';
   ICACHE <= ((not TT40_1) and (not TM40_2) and TM40_1 and (not TM40_0)) or
	 ((not TT40_1) and TM40_2 and TM40_1 and (not TM40_0));
   FC30_0 <= ((not TT40_1) and (not TM40_1)) or ((not TT40_1) and TM40_1 and
	 TM40_0) or (TT40_1 and (not TT40_0) and TM40_0) or (TT40_1 and
	 TT40_0);
   FC30_1 <= ((not TT40_1) and TM40_1 and (not TM40_0)) or (TT40_1 and (not
	 TT40_0) and TM40_1) or (TT40_1 and TT40_0);
   FC30_2 <= ((not TT40_1) and TM40_2 and (not TM40_1) and TM40_0) or ((not
	 TT40_1) and TM40_2 and TM40_1 and (not TM40_0)) or (TT40_1 and (not
	 TT40_0) and TM40_2) or (TT40_1 and TT40_0);
   QDSACK0_ACLR <= NAMIACC;
   QDSACK0_CLK <= SCLK;
   QDSACK0_D <= (not DSACK30_0) or (not STERM30);
   QDSACK1_ACLR <= NAMIACC;
   QDSACK1_CLK <= SCLK;
   QDSACK1_D <= (not DSACK30_1) or (not STERM30);
   LDSACK0_ACLR <= NAMIACC;
   LDSACK0_CLK <= not SCLK;
   LDSACK0_D <= ((not DSACK30_0) and (QDSACK0 or QDSACK1)) or ((not STERM30)
	 and (QDSACK0 or QDSACK1)) or (LDSACK0 and AMIQ1 and AMIQ0 and (not
	 CNTDIS));
   LDSACK1_ACLR <= NAMIACC;
   LDSACK1_CLK <= not SCLK;
   LDSACK1_D <= ((not DSACK30_1) and (QDSACK0 or QDSACK1)) or ((not STERM30)
	 and (QDSACK0 or QDSACK1)) or (LDSACK1 and AMIQ1 and AMIQ0 and (not
	 CNTDIS));
   OE_BS <= AMISEL;
   DIR_BS <= RW40;
   LONGPORT <= (RSTI40 and LDSACK1 and LDSACK0) or (LONGPORT and (not LEND));
   WORDPORT <= (RSTI40 and LDSACK1 and (not LDSACK0)) or (WORDPORT and (not
	 ((not CAQ2) and (not CAQ1) and (not CAQ0))));
   BYTEPORT <= (RSTI40 and (not LDSACK1) and LDSACK0) or (BYTEPORT and (not
	 ((not CAQ2) and (not CAQ1) and (not CAQ0))));
   TA40_OE <= AMISEL;
   AMISEL <= (RSTI40 and (not TT40_1) and SEL16M) or (RSTI40 and TT40_1);
   TBI40 <= not ((RSTI40 and (not TT40_1) and SEL16M) or (RSTI40 and TT40_1));
   TEA40 <= not ((LONGPORT and WORDPORT and AS30_FB) or (LONGPORT and BYTEPORT
	 and AS30_FB) or (WORDPORT and BYTEPORT and AS30_FB));
   LEND_ACLR <= not RSTI40;
   LEND_CLK <= SCLK;
   CAQ0_CLK_ctrl <= SCLK;
   CAQ0_ACLR_ctrl <= not RSTI40;


   process (CAQ0_FB, CAQ1_FB, CAQ2_FB, TS40, SEL16M, LONGPORT, A40_0, WORDPORT,
	 AMISEL, RW40, BYTEPORT, RSTI40, ATERM, LDSACK1, LDSACK0, CNTDIS,
	 A40_1, TT40_1, TT40_0, SIZ40_1, SIZ40_0)
      variable stdVec3: std_logic_vector(2 downto 0);
   begin
      (NAMIACC, LEND_D, TA40_ZD, AS30_OE, DS30_OE, SIZ30_0, SIZ30_1, AL_0,
	    AL_1, BWL0_BS, BWL1_BS, BWL2_BS, CAQ2_D, CAQ1_D, CAQ0_D) <=
	    std_logic_vector'("000000000000000");
      stdVec3 := std_logic_vector'(CAQ2_FB & CAQ1_FB & CAQ0_FB);
      case stdVec3 is
      when "000" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= '0';
	 AL_0 <= '0';
	 AL_1 <= '0';
	 NAMIACC <= '1';
	 BWL0_BS <= '1';
	 BWL1_BS <= '1';
	 BWL2_BS <= '1';
	 if ((not TS40) and (not TT40_1) and SEL16M)='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("001");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
	 end if;
      when "001" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= SIZ40_1 and (not SIZ40_0);
	 AL_0 <= A40_0 and (not (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1
	       and SIZ40_0)));
	 AL_1 <= A40_1 and (not (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1
	       and SIZ40_0)));
	 BWL0_BS <= not ((AMISEL and (not RW40) and (((not SIZ40_1) and (not
	       SIZ40_0)) or (SIZ40_1 and SIZ40_0) or (SIZ40_1 and (not SIZ40_0)
	       and (not A40_1)) or (SIZ40_1 and (not SIZ40_0) and A40_1) or
	       ((not SIZ40_1) and SIZ40_0 and (not A40_1) and (not A40_0)) or
	       ((not SIZ40_1) and SIZ40_0 and A40_1 and (not A40_0)))) or
	       (AMISEL and RW40 and (LONGPORT or WORDPORT or BYTEPORT)));
	 BWL1_BS <= not ((AMISEL and (not RW40) and (((not SIZ40_1) and (not
	       SIZ40_0)) or (SIZ40_1 and SIZ40_0) or (SIZ40_1 and (not SIZ40_0)
	       and (not A40_1)) or ((not SIZ40_1) and SIZ40_0 and (not A40_1)
	       and (not A40_0)) or ((not SIZ40_1) and SIZ40_0 and (not A40_1)
	       and A40_0))) or (AMISEL and RW40 and (WORDPORT or BYTEPORT)));
	 BWL2_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and SIZ40_0)
	       or (SIZ40_1 and (not SIZ40_0) and (not A40_1))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("010");
	 elsif (RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and SIZ40_1 and (not SIZ40_0) and A40_1)='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 elsif (RSTI40 and ATERM and LDSACK1 and (not LDSACK0) and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and
	       SIZ40_0)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 elsif ((RSTI40 and ATERM and LDSACK1 and LDSACK0 and (not CNTDIS)) or
	       (RSTI40 and ATERM and LDSACK1 and (not LDSACK0) and (not CNTDIS)
	       and ((SIZ40_1 and (not SIZ40_0)) or ((not SIZ40_1) and
	       SIZ40_0))) or (RSTI40 and ATERM and (not LDSACK1) and LDSACK0
	       and (not CNTDIS) and (not SIZ40_1) and SIZ40_0))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("001");
	 end if;
      when "010" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= ((not SIZ40_1) and SIZ40_0) or (SIZ40_1 and (not SIZ40_0))
	       or ((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and SIZ40_0);
	 SIZ30_1 <= '0';
	 AL_0 <= '1';
	 AL_1 <= '0';
	 BWL0_BS <= '1';
	 BWL1_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 BWL2_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and SIZ40_1 and (not SIZ40_0) and (not A40_1))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 elsif (RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and
	       SIZ40_0)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("010");
	 end if;
      when "011" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= ((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and SIZ40_0);
	 AL_0 <= '0';
	 AL_1 <= '1';
	 BWL0_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 BWL1_BS <= not (AMISEL and RW40 and WORDPORT);
	 BWL2_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and
	       SIZ40_0)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 elsif (RSTI40 and ATERM and LDSACK1 and (not LDSACK0) and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and
	       SIZ40_0)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 end if;
      when "100" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= ((not SIZ40_1) and SIZ40_0) or (SIZ40_1 and (not SIZ40_0))
	       or ((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and SIZ40_0);
	 SIZ30_1 <= '0';
	 AL_0 <= '1';
	 AL_1 <= '1';
	 BWL0_BS <= '1';
	 BWL1_BS <= '1';
	 BWL2_BS <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if ((RSTI40 and ATERM and (not LDSACK1) and LDSACK0 and (not CNTDIS)
	       and (((not SIZ40_1) and (not SIZ40_0)) or (SIZ40_1 and
	       SIZ40_0))) or (RSTI40 and ATERM and (not LDSACK1) and LDSACK0
	       and (not CNTDIS) and SIZ40_1 and (not SIZ40_0) and A40_1))='1'
	       then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 end if;
      when "101" =>
	 TA40_ZD <= '0';
	 AS30_OE <= '0';
	 DS30_OE <= '0';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= '0';
	 AL_0 <= '0';
	 AL_1 <= '0';
	 NAMIACC <= '1';
	 BWL0_BS <= '1';
	 BWL1_BS <= '1';
	 BWL2_BS <= '1';
	 LEND_D <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when "110" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= '0';
	 AL_0 <= '0';
	 AL_1 <= '0';
	 BWL0_BS <= '1';
	 BWL1_BS <= '1';
	 BWL2_BS <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when "111" =>
	 TA40_ZD <= not (TT40_1 and TT40_0);
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30_0 <= (not SIZ40_1) and SIZ40_0;
	 SIZ30_1 <= '0';
	 AL_0 <= '0';
	 AL_1 <= '0';
	 BWL0_BS <= '1';
	 BWL1_BS <= '1';
	 BWL2_BS <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when others =>
      end case;
      stdVec3 := (others=>'0');  -- no storage needed
   end process;
   CNTDIS_ACLR <= not RSTI40;
   CNTDIS_CLK <= SCLK;
   CNTDIS_D <= ATERM;
   AS30_ASET <= (not RSTI40) or NAMIACC;
   AS30_CLK <= SCLK;
   DS30_ASET <= (not RSTI40) or NAMIACC;
   DS30_CLK <= SCLK;
   ATERM_ACLR <= (not RSTI40) or NAMIACC;
   ATERM_CLK <= SCLK;
   LE_BS_ACLR <= (not RSTI40) or NAMIACC;
   LE_BS_CLK <= SCLK;
   AMIQ0_CLK_ctrl <= SCLK;
   AMIQ0_ACLR_ctrl <= (not RSTI40) or NAMIACC;


   process (AMIQ0_FB, AMIQ1_FB, LDSACK1, LDSACK0, RW40, CNTDIS)
      variable stdVec2: std_logic_vector(1 downto 0);
   begin
      (AS30_D, DS30_D, ATERM_D, LE_BS_D, AMIQ1_D, AMIQ0_D) <=
	    std_logic_vector'("000000");
      stdVec2 := std_logic_vector'(AMIQ1_FB & AMIQ0_FB);
      case stdVec2 is
      when "00" =>
	 AS30_D <= '0';
	 DS30_D <= not RW40;
	 (AMIQ1_D, AMIQ0_D) <= std_logic_vector'("01");
      when "01" =>
	 AS30_D <= not ((not LDSACK0) and (not LDSACK1));
	 DS30_D <= not ((not LDSACK0) and (not LDSACK1));
	 if (LDSACK1 or LDSACK0)='1' then
	    (AMIQ1_D, AMIQ0_D) <= std_logic_vector'("11");
	 else
	    (AMIQ1_D, AMIQ0_D) <= std_logic_vector'("01");
	 end if;
      when "11" =>
	 AS30_D <= not CNTDIS;
	 DS30_D <= not (CNTDIS and RW40);
	 ATERM_D <= '1';
	 LE_BS_D <= '1';
	 if (CNTDIS)='1' then
	    (AMIQ1_D, AMIQ0_D) <= std_logic_vector'("01");
	 else
	    (AMIQ1_D, AMIQ0_D) <= std_logic_vector'("11");
	 end if;
      when others =>
      end case;
      stdVec2 := (others=>'0');  -- no storage needed
   end process;
end control_behav;
