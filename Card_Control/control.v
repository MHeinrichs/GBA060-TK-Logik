// Xilinx XPort Language Converter, Version 4.1 (110)
// 
// ABEL    Design Source: C:\Users\Matze\Amiga\Hardwarehacks\gb_a1k_tk\Logik\Card_Control\control.abl
// Verilog Design Output: control.v
// Created 04-Oct-2015 10:10 PM
//
// Copyright (c) 2015, Xilinx, Inc.  All Rights Reserved.
// Xilinx Inc makes no warranty, expressed or implied, with respect to
// the operation and/or functionality of the converted output files.
// 

module control(SEL16M, PLL_CLK, RSTO40, HALT30, IPL30_0, IPL30_1, IPL30_2,
      DSACK30_0, DSACK30_1, STERM30, CPU40_60, A40_0, A40_1, SIZ40_0, SIZ40_1,
      RW40, TM40_0, TM40_1, TM40_2, TT40_0, TT40_1, TS40, PLL_S0, PLL_S1,
      CLK30, PCLK, BCLK, SCLK, CLK_BS, CLK_RAMC, AL_0, AL_1, A30_LE, OE_BS,
      LE_BS, DIR_BS, BWL0_BS, BWL1_BS, BWL2_BS, FC30_0, FC30_1, FC30_2, AS30,
      DS30, RW30, SIZ30_0, SIZ30_1, RESET30, RSTI40, IPL40_0, IPL40_1, IPL40_2,
      TBI40, MDIS40, CDIS40, TA40, TEA40, BGR60, ICACHE);
   input SEL16M, PLL_CLK, RSTO40, HALT30, IPL30_0, IPL30_1, IPL30_2, DSACK30_0,
	 DSACK30_1, STERM30, CPU40_60, A40_0, A40_1, SIZ40_0, SIZ40_1, RW40,
	 TM40_0, TM40_1, TM40_2, TT40_0, TT40_1, TS40;
   output PLL_S0, PLL_S1, CLK30, PCLK, BCLK, SCLK, CLK_BS, CLK_RAMC, AL_0,
	 AL_1, A30_LE, OE_BS, LE_BS, DIR_BS, BWL0_BS, BWL1_BS, BWL2_BS, FC30_0,
	 FC30_1, FC30_2, AS30, DS30, RW30, SIZ30_0, SIZ30_1, RESET30, RSTI40,
	 IPL40_0, IPL40_1, IPL40_2, TBI40, MDIS40, CDIS40, TA40, TEA40, BGR60,
	 ICACHE;
   reg AL_0, AL_1, BWL0_BS, BWL1_BS, BWL2_BS, SIZ30_0, SIZ30_1;

   wire RSTINT, AMIQ0, AMIQ1, LDSACK0, LDSACK1, QDSACK0, QDSACK1, CNTDIS, CAQ2,
	 CAQ1, CAQ0, LEND, ATERM, AMISEL, LONGPORT, WORDPORT, BYTEPORT, H11,
	 H10, H9, H8, H7, H6, H5, H4, H3, H2, H1, H0, F10, F9, F8, F7, F6, F5,
	 F4, F3, F2, F1, F0, STOPRES, STOPHALT, PLL_S1_OE, PLL_S0_OE,
	 CLK_RAMC_CLK, CLK_RAMC_T, CLK_BS_CLK, CLK_BS_D, PCLK_CLK, PCLK_D,
	 SCLK_CLK, SCLK_D, BCLK_CLK, BCLK_D, CLK30_CLK, CLK30_T, RSTI40_CLK,
	 RSTI40_D, RESET30_OE, RSTINT_D, RSTINT_CLK, RSTINT_ACLR, QDSACK0_ACLR,
	 QDSACK0_CLK, QDSACK0_D, QDSACK1_ACLR, QDSACK1_CLK, QDSACK1_D,
	 LDSACK0_ACLR, LDSACK0_CLK, LDSACK0_D, LDSACK1_ACLR, LDSACK1_CLK,
	 LDSACK1_D, TA40_OE, LEND_ACLR, LEND_CLK, CNTDIS_ACLR, CNTDIS_CLK,
	 CNTDIS_D, AS30_ASET, AS30_CLK, DS30_ASET, DS30_CLK, ATERM_ACLR,
	 ATERM_CLK, LE_BS_ACLR, LE_BS_CLK, F0_D, F1_D, F2_D, F3_D, F4_D, F5_D,
	 F6_D, F7_D, F8_D, F9_D, F10_D, H0_D, H1_D, H2_D, H3_D, H4_D, H5_D,
	 H6_D, H7_D, H8_D, H9_D, H10_D, H11_D, RESET30_ZD, PLL_S0_ZD,
	 PLL_S1_ZD, AMIQ0_ACLR_ctrl, AMIQ0_CLK_ctrl, CAQ0_ACLR_ctrl,
	 CAQ0_CLK_ctrl, F0_ACLR_ctrl, F0_CLK_ctrl, H0_ACLR_ctrl, H0_CLK_ctrl;
   reg NAMIACC, AS30_FB, CAQ2_D, CAQ1_D, CAQ0_D, AS30_OE, DS30_OE, LEND_D,
	 AMIQ1_D, AMIQ0_D, AS30_D, DS30_D, ATERM_D, LE_BS_D, F0_FB, F1_FB,
	 F2_FB, F3_FB, F4_FB, F5_FB, F6_FB, F7_FB, F8_FB, F9_FB, F10_FB, H0_FB,
	 H1_FB, H2_FB, H3_FB, H4_FB, H5_FB, H6_FB, H7_FB, H8_FB, H9_FB, H10_FB,
	 H11_FB, ATERM_FB, LEND_FB, CAQ0_FB, CAQ1_FB, CAQ2_FB, CNTDIS_FB,
	 QDSACK1_FB, QDSACK0_FB, LDSACK1_FB, LDSACK0_FB, AMIQ1_FB, AMIQ0_FB,
	 RSTINT_FB, RSTI40_FB, DS30_FB, LE_BS_FB, CLK_RAMC_FB, CLK_BS_FB,
	 SCLK_FB, BCLK_FB, PCLK_FB, CLK30_FB, TA40_ZD;

   // initial {AS30_FB, F0_FB, F1_FB, F2_FB, F3_FB, F4_FB, F5_FB, F6_FB,
   //       F7_FB, F8_FB, F9_FB, F10_FB, H0_FB, H1_FB, H2_FB, H3_FB, H4_FB,
   //       H5_FB, H6_FB, H7_FB, H8_FB, H9_FB, H10_FB, H11_FB, ATERM_FB,
   //       LEND_FB, CAQ0_FB, CAQ1_FB, CAQ2_FB, CNTDIS_FB, QDSACK1_FB,
   //       QDSACK0_FB, LDSACK1_FB, LDSACK0_FB, AMIQ1_FB, AMIQ0_FB,
   //       RSTINT_FB, RSTI40_FB, DS30_FB, LE_BS_FB, CLK_RAMC_FB, CLK_BS_FB,
   //       SCLK_FB, BCLK_FB, PCLK_FB, CLK30_FB} = 46'h0;

   assign TA40 = (TA40_OE) ? TA40_ZD : 1'bz;
   assign RESET30 = (RESET30_OE) ? RESET30_ZD : 1'bz;
   assign PLL_S1 = (PLL_S1_OE) ? PLL_S1_ZD : 1'bz;
   assign PLL_S0 = (PLL_S0_OE) ? PLL_S0_ZD : 1'bz;

   assign CLK30 = CLK30_FB;
   always @(posedge CLK30_CLK)
      CLK30_FB <= CLK30_FB ^ CLK30_T;

   assign PCLK = PCLK_FB;
   always @(posedge PCLK_CLK)
      PCLK_FB <= PCLK_D;

   assign BCLK = BCLK_FB;
   always @(posedge BCLK_CLK)
      BCLK_FB <= BCLK_D;

   assign SCLK = SCLK_FB;
   always @(posedge SCLK_CLK)
      SCLK_FB <= SCLK_D;

   assign CLK_BS = CLK_BS_FB;
   always @(posedge CLK_BS_CLK)
      CLK_BS_FB <= CLK_BS_D;

   assign CLK_RAMC = CLK_RAMC_FB;
   always @(posedge CLK_RAMC_CLK)
      CLK_RAMC_FB <= CLK_RAMC_FB ^ CLK_RAMC_T;

   assign LE_BS = LE_BS_FB;
   always @(posedge LE_BS_CLK or posedge LE_BS_ACLR)
      if (LE_BS_ACLR)
	 LE_BS_FB <= 1'h0;
      else
	 LE_BS_FB <= LE_BS_D;

   assign AS30 = (AS30_OE) ? AS30_FB : 1'bz;
   always @(posedge AS30_CLK or posedge AS30_ASET)
      if (AS30_ASET)
	 AS30_FB <= 1'h1;
      else
	 AS30_FB <= AS30_D;

   assign DS30 = (DS30_OE) ? DS30_FB : 1'bz;
   always @(posedge DS30_CLK or posedge DS30_ASET)
      if (DS30_ASET)
	 DS30_FB <= 1'h1;
      else
	 DS30_FB <= DS30_D;

   assign RSTI40 = RSTI40_FB;
   always @(posedge RSTI40_CLK)
      RSTI40_FB <= RSTI40_D;

   assign RSTINT = RSTINT_FB;
   always @(posedge RSTINT_CLK or posedge RSTINT_ACLR)
      if (RSTINT_ACLR)
	 RSTINT_FB <= 1'h0;
      else
	 RSTINT_FB <= RSTINT_D;

   assign {AMIQ0, AMIQ1} = {AMIQ0_FB, AMIQ1_FB};
   always @(posedge AMIQ0_CLK_ctrl or posedge AMIQ0_ACLR_ctrl)
      if (AMIQ0_ACLR_ctrl)
	 {AMIQ0_FB, AMIQ1_FB} <= 2'h0;
      else
	 {AMIQ0_FB, AMIQ1_FB} <= {AMIQ0_D, AMIQ1_D};

   assign LDSACK0 = LDSACK0_FB;
   always @(posedge LDSACK0_CLK or posedge LDSACK0_ACLR)
      if (LDSACK0_ACLR)
	 LDSACK0_FB <= 1'h0;
      else
	 LDSACK0_FB <= LDSACK0_D;

   assign LDSACK1 = LDSACK1_FB;
   always @(posedge LDSACK1_CLK or posedge LDSACK1_ACLR)
      if (LDSACK1_ACLR)
	 LDSACK1_FB <= 1'h0;
      else
	 LDSACK1_FB <= LDSACK1_D;

   assign QDSACK0 = QDSACK0_FB;
   always @(posedge QDSACK0_CLK or posedge QDSACK0_ACLR)
      if (QDSACK0_ACLR)
	 QDSACK0_FB <= 1'h0;
      else
	 QDSACK0_FB <= QDSACK0_D;

   assign QDSACK1 = QDSACK1_FB;
   always @(posedge QDSACK1_CLK or posedge QDSACK1_ACLR)
      if (QDSACK1_ACLR)
	 QDSACK1_FB <= 1'h0;
      else
	 QDSACK1_FB <= QDSACK1_D;

   assign CNTDIS = CNTDIS_FB;
   always @(posedge CNTDIS_CLK or posedge CNTDIS_ACLR)
      if (CNTDIS_ACLR)
	 CNTDIS_FB <= 1'h0;
      else
	 CNTDIS_FB <= CNTDIS_D;

   assign {CAQ2, CAQ1, CAQ0} = {CAQ2_FB, CAQ1_FB, CAQ0_FB};
   always @(posedge CAQ0_CLK_ctrl or posedge CAQ0_ACLR_ctrl)
      if (CAQ0_ACLR_ctrl)
	 {CAQ2_FB, CAQ1_FB, CAQ0_FB} <= 3'h0;
      else
	 {CAQ2_FB, CAQ1_FB, CAQ0_FB} <= {CAQ2_D, CAQ1_D, CAQ0_D};

   assign LEND = LEND_FB;
   always @(posedge LEND_CLK or posedge LEND_ACLR)
      if (LEND_ACLR)
	 LEND_FB <= 1'h0;
      else
	 LEND_FB <= LEND_D;

   assign ATERM = ATERM_FB;
   always @(posedge ATERM_CLK or posedge ATERM_ACLR)
      if (ATERM_ACLR)
	 ATERM_FB <= 1'h0;
      else
	 ATERM_FB <= ATERM_D;

   assign {H11, H10, H9, H8, H7, H6, H5, H4, H3, H2, H1, H0} = {H11_FB, H10_FB,
	 H9_FB, H8_FB, H7_FB, H6_FB, H5_FB, H4_FB, H3_FB, H2_FB, H1_FB, H0_FB};
   always @(posedge H0_CLK_ctrl or posedge H0_ACLR_ctrl)
      if (H0_ACLR_ctrl)
	 {H11_FB, H10_FB, H9_FB, H8_FB, H7_FB, H6_FB, H5_FB, H4_FB, H3_FB,
	       H2_FB, H1_FB, H0_FB} <= 12'h0;
      else
	 {H11_FB, H10_FB, H9_FB, H8_FB, H7_FB, H6_FB, H5_FB, H4_FB, H3_FB,
	       H2_FB, H1_FB, H0_FB} <= {H11_D, H10_D, H9_D, H8_D, H7_D, H6_D,
	       H5_D, H4_D, H3_D, H2_D, H1_D, H0_D};

   assign {F10, F9, F8, F7, F6, F5, F4, F3, F2, F1, F0} = {F10_FB, F9_FB,
	 F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB, F1_FB, F0_FB};
   always @(posedge F0_CLK_ctrl or posedge F0_ACLR_ctrl)
      if (F0_ACLR_ctrl)
	 {F10_FB, F9_FB, F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB,
	       F1_FB, F0_FB} <= 11'h0;
      else
	 {F10_FB, F9_FB, F8_FB, F7_FB, F6_FB, F5_FB, F4_FB, F3_FB, F2_FB,
	       F1_FB, F0_FB} <= {F10_D, F9_D, F8_D, F7_D, F6_D, F5_D, F4_D,
	       F3_D, F2_D, F1_D, F0_D};

// Start of original equations
   assign PLL_S1_ZD = 1'b0;
   assign PLL_S1_OE = 1'b1;
   assign PLL_S0_ZD = 1'b1;
   assign PLL_S0_OE = 1'b0;
   assign CLK_RAMC_CLK = PLL_CLK;
   assign CLK_RAMC_T = 1'b1;
   assign CLK_BS_CLK = PLL_CLK;
   assign CLK_BS_D = !CLK_RAMC;
   assign PCLK_CLK = PLL_CLK;
   assign PCLK_D = !CLK_RAMC;
   assign SCLK_CLK = PLL_CLK;
   assign SCLK_D = CLK30 ^ CLK_RAMC;
   assign BCLK_CLK = (PLL_CLK & CPU40_60) | ((!PLL_CLK) & (!CPU40_60));
   assign BCLK_D = CLK30 ^ CLK_RAMC;
   assign CLK30_CLK = PLL_CLK;
   assign CLK30_T = !CLK_RAMC;
   assign H0_CLK_ctrl = SCLK;
   assign H0_ACLR_ctrl = !HALT30;
   assign {H11_D, H10_D, H9_D, H8_D, H7_D, H6_D, H5_D, H4_D, H3_D, H2_D, H1_D,
	 H0_D} = (({H11, H10, H9, H8, H7, H6, H5, H4, H3, H2, H1, H0} +
	 12'b0000_0000_0001) & (~{12{STOPHALT}})) | ({H11, H10, H9, H8, H7, H6,
	 H5, H4, H3, H2, H1, H0} & {12{STOPHALT}});
   assign STOPHALT = H11 & H10 & H9 & H8 & H7;
   assign RSTI40_CLK = SCLK;
   assign RSTI40_D = !(((!RESET30) & RSTO40) | ((!STOPHALT) & RSTO40));
   assign F0_CLK_ctrl = SCLK;
   assign F0_ACLR_ctrl = !RSTO40;
   assign {F10_D, F9_D, F8_D, F7_D, F6_D, F5_D, F4_D, F3_D, F2_D, F1_D, F0_D} =
	 (({F10, F9, F8, F7, F6, F5, F4, F3, F2, F1, F0} + 11'b000_0000_0001) &
	 (~{11{STOPRES}})) | ({F10, F9, F8, F7, F6, F5, F4, F3, F2, F1, F0} &
	 {11{STOPRES}});
   assign STOPRES = F10 & F9 & F8 & F7;
   assign RESET30_OE = ((!RSTO40) & STOPHALT) | ((!RESET30) & (!STOPRES));
   assign RESET30_ZD = !(((!RSTO40) & STOPHALT) | ((!RESET30) & (!STOPRES)));
   assign RSTINT_D = RSTI40;
   assign RSTINT_CLK = SCLK;
   assign RSTINT_ACLR = !RSTI40;
   assign IPL40_0 = (RSTINT & IPL30_0) | ((!RSTINT) & 1'b1);
   assign IPL40_1 = (RSTINT & IPL30_1) | ((!RSTINT) & 1'b1);
   assign IPL40_2 = (RSTINT & IPL30_2) | ((!RSTINT) & 1'b1);
   assign CDIS40 = RSTINT | ((!RSTINT) & 1'b1);
   assign MDIS40 = RSTINT | ((!RSTINT) & 1'b1);
   assign BGR60 = 1'b0;
   assign RW30 = RW40;
   assign A30_LE = 1'b0;
   assign ICACHE = ((!TT40_1) & (!TM40_2) & TM40_1 & (!TM40_0)) | ((!TT40_1) &
	 TM40_2 & TM40_1 & (!TM40_0));
   assign FC30_0 = ((!TT40_1) & (!TM40_1)) | ((!TT40_1) & TM40_1 & TM40_0) |
	 (TT40_1 & (!TT40_0) & TM40_0) | (TT40_1 & TT40_0);
   assign FC30_1 = ((!TT40_1) & TM40_1 & (!TM40_0)) | (TT40_1 & (!TT40_0) &
	 TM40_1) | (TT40_1 & TT40_0);
   assign FC30_2 = ((!TT40_1) & TM40_2 & (!TM40_1) & TM40_0) | ((!TT40_1) &
	 TM40_2 & TM40_1 & (!TM40_0)) | (TT40_1 & (!TT40_0) & TM40_2) | (TT40_1
	 & TT40_0);
   assign QDSACK0_ACLR = NAMIACC;
   assign QDSACK0_CLK = SCLK;
   assign QDSACK0_D = (!DSACK30_0) | (!STERM30);
   assign QDSACK1_ACLR = NAMIACC;
   assign QDSACK1_CLK = SCLK;
   assign QDSACK1_D = (!DSACK30_1) | (!STERM30);
   assign LDSACK0_ACLR = NAMIACC;
   assign LDSACK0_CLK = !SCLK;
   assign LDSACK0_D = ((!DSACK30_0) & (QDSACK0 | QDSACK1)) | ((!STERM30) &
	 (QDSACK0 | QDSACK1)) | (LDSACK0 & AMIQ1 & AMIQ0 & (!CNTDIS));
   assign LDSACK1_ACLR = NAMIACC;
   assign LDSACK1_CLK = !SCLK;
   assign LDSACK1_D = ((!DSACK30_1) & (QDSACK0 | QDSACK1)) | ((!STERM30) &
	 (QDSACK0 | QDSACK1)) | (LDSACK1 & AMIQ1 & AMIQ0 & (!CNTDIS));
   assign OE_BS = AMISEL;
   assign DIR_BS = RW40;
   assign LONGPORT = (RSTI40 & LDSACK1 & LDSACK0) | (LONGPORT & (!LEND));
   assign WORDPORT = (RSTI40 & LDSACK1 & (!LDSACK0)) | (WORDPORT & (!((!CAQ2) &
	 (!CAQ1) & (!CAQ0))));
   assign BYTEPORT = (RSTI40 & (!LDSACK1) & LDSACK0) | (BYTEPORT & (!((!CAQ2) &
	 (!CAQ1) & (!CAQ0))));
   assign TA40_OE = AMISEL;
   assign AMISEL = (RSTI40 & (!TT40_1) & SEL16M) | (RSTI40 & TT40_1);
   assign TBI40 = !((RSTI40 & (!TT40_1) & SEL16M) | (RSTI40 & TT40_1));
   assign TEA40 = !((LONGPORT & WORDPORT & AS30_FB) | (LONGPORT & BYTEPORT &
	 AS30_FB) | (WORDPORT & BYTEPORT & AS30_FB));
   assign LEND_ACLR = !RSTI40;
   assign LEND_CLK = SCLK;
   assign CAQ0_CLK_ctrl = SCLK;
   assign CAQ0_ACLR_ctrl = !RSTI40;


   always @(CAQ0_FB or CAQ1_FB or CAQ2_FB or TS40 or SEL16M or LONGPORT or
	 A40_0 or WORDPORT or AMISEL or RW40 or BYTEPORT or RSTI40 or ATERM or
	 LDSACK1 or LDSACK0 or CNTDIS or A40_1 or TT40_1 or TT40_0 or SIZ40_1
	 or SIZ40_0) begin
      {NAMIACC, LEND_D, TA40_ZD, AS30_OE, DS30_OE, SIZ30_0, SIZ30_1, AL_0,
	    AL_1, BWL0_BS, BWL1_BS, BWL2_BS, CAQ2_D, CAQ1_D, CAQ0_D} =
	    15'b000_0000_0000_0000;
      case ({CAQ2_FB, CAQ1_FB, CAQ0_FB})
      3'b000: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b0;
	    AL_1 = 1'b0;
	    NAMIACC = 1'b1;
	    BWL0_BS = 1'b1;
	    BWL1_BS = 1'b1;
	    BWL2_BS = 1'b1;
	    if ((!TS40) & (!TT40_1) & SEL16M) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b001;
	    end else begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b000;
	    end
	 end
      3'b001: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = SIZ40_1 & (!SIZ40_0);
	    AL_0 = A40_0 & (!(((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 &
		  SIZ40_0)));
	    AL_1 = A40_1 & (!(((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 &
		  SIZ40_0)));
	    BWL0_BS = !((AMISEL & (!RW40) & (((!SIZ40_1) & (!SIZ40_0)) |
		  (SIZ40_1 & SIZ40_0) | (SIZ40_1 & (!SIZ40_0) & (!A40_1)) |
		  (SIZ40_1 & (!SIZ40_0) & A40_1) | ((!SIZ40_1) & SIZ40_0 &
		  (!A40_1) & (!A40_0)) | ((!SIZ40_1) & SIZ40_0 & A40_1 &
		  (!A40_0)))) | (AMISEL & RW40 & (LONGPORT | WORDPORT |
		  BYTEPORT)));
	    BWL1_BS = !((AMISEL & (!RW40) & (((!SIZ40_1) & (!SIZ40_0)) |
		  (SIZ40_1 & SIZ40_0) | (SIZ40_1 & (!SIZ40_0) & (!A40_1)) |
		  ((!SIZ40_1) & SIZ40_0 & (!A40_1) & (!A40_0)) | ((!SIZ40_1) &
		  SIZ40_0 & (!A40_1) & A40_0))) | (AMISEL & RW40 & (WORDPORT |
		  BYTEPORT)));
	    BWL2_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    if (RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0) | (SIZ40_1 &
		  (!SIZ40_0) & (!A40_1)))) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b010;
	    end else if (RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) &
		  SIZ40_1 & (!SIZ40_0) & A40_1) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b100;
	    end else if (RSTI40 & ATERM & LDSACK1 & (!LDSACK0) & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0))) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b011;
	    end else if ((RSTI40 & ATERM & LDSACK1 & LDSACK0 & (!CNTDIS)) |
		  (RSTI40 & ATERM & LDSACK1 & (!LDSACK0) & (!CNTDIS) &
		  ((SIZ40_1 & (!SIZ40_0)) | ((!SIZ40_1) & SIZ40_0))) | (RSTI40
		  & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) & (!SIZ40_1) &
		  SIZ40_0)) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b101;
	    end else begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b001;
	    end
	 end
      3'b010: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = ((!SIZ40_1) & SIZ40_0) | (SIZ40_1 & (!SIZ40_0)) |
		  ((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0);
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b1;
	    AL_1 = 1'b0;
	    BWL0_BS = 1'b1;
	    BWL1_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    BWL2_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    if (RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) & SIZ40_1 &
		  (!SIZ40_0) & (!A40_1)) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b101;
	    end else if (RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0))) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b011;
	    end else begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b010;
	    end
	 end
      3'b011: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = ((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0);
	    AL_0 = 1'b0;
	    AL_1 = 1'b1;
	    BWL0_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    BWL1_BS = !(AMISEL & RW40 & WORDPORT);
	    BWL2_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    if (RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0))) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b100;
	    end else if (RSTI40 & ATERM & LDSACK1 & (!LDSACK0) & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0))) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b101;
	    end else begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b011;
	    end
	 end
      3'b100: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = ((!SIZ40_1) & SIZ40_0) | (SIZ40_1 & (!SIZ40_0)) |
		  ((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0);
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b1;
	    AL_1 = 1'b1;
	    BWL0_BS = 1'b1;
	    BWL1_BS = 1'b1;
	    BWL2_BS = !((AMISEL & (!RW40)) | (AMISEL & RW40 & BYTEPORT));
	    if ((RSTI40 & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) &
		  (((!SIZ40_1) & (!SIZ40_0)) | (SIZ40_1 & SIZ40_0))) | (RSTI40
		  & ATERM & (!LDSACK1) & LDSACK0 & (!CNTDIS) & SIZ40_1 &
		  (!SIZ40_0) & A40_1)) begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b101;
	    end else begin
	       {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b100;
	    end
	 end
      3'b101: begin
	    TA40_ZD = 1'b0;
	    AS30_OE = 1'b0;
	    DS30_OE = 1'b0;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b0;
	    AL_1 = 1'b0;
	    NAMIACC = 1'b1;
	    BWL0_BS = 1'b1;
	    BWL1_BS = 1'b1;
	    BWL2_BS = 1'b1;
	    LEND_D = 1'b1;
	    {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b000;
	 end
      3'b110: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b0;
	    AL_1 = 1'b0;
	    BWL0_BS = 1'b1;
	    BWL1_BS = 1'b1;
	    BWL2_BS = 1'b1;
	    {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b000;
	 end
      3'b111: begin
	    TA40_ZD = !(TT40_1 & TT40_0);
	    AS30_OE = 1'b1;
	    DS30_OE = 1'b1;
	    SIZ30_0 = (!SIZ40_1) & SIZ40_0;
	    SIZ30_1 = 1'b0;
	    AL_0 = 1'b0;
	    AL_1 = 1'b0;
	    BWL0_BS = 1'b1;
	    BWL1_BS = 1'b1;
	    BWL2_BS = 1'b1;
	    {CAQ2_D, CAQ1_D, CAQ0_D} = 3'b000;
	 end
      endcase
   end
   assign CNTDIS_ACLR = !RSTI40;
   assign CNTDIS_CLK = SCLK;
   assign CNTDIS_D = ATERM;
   assign AS30_ASET = (!RSTI40) | NAMIACC;
   assign AS30_CLK = SCLK;
   assign DS30_ASET = (!RSTI40) | NAMIACC;
   assign DS30_CLK = SCLK;
   assign ATERM_ACLR = (!RSTI40) | NAMIACC;
   assign ATERM_CLK = SCLK;
   assign LE_BS_ACLR = (!RSTI40) | NAMIACC;
   assign LE_BS_CLK = SCLK;
   assign AMIQ0_CLK_ctrl = SCLK;
   assign AMIQ0_ACLR_ctrl = (!RSTI40) | NAMIACC;


   always @(AMIQ0_FB or AMIQ1_FB or LDSACK1 or LDSACK0 or RW40 or CNTDIS) begin
      {AS30_D, DS30_D, ATERM_D, LE_BS_D, AMIQ1_D, AMIQ0_D} = 6'b00_0000;
      case ({AMIQ1_FB, AMIQ0_FB})
      2'b00: begin
	    AS30_D = 1'b0;
	    DS30_D = !RW40;
	    {AMIQ1_D, AMIQ0_D} = 2'b01;
	 end
      2'b01: begin
	    AS30_D = !((!LDSACK0) & (!LDSACK1));
	    DS30_D = !((!LDSACK0) & (!LDSACK1));
	    if (LDSACK1 | LDSACK0) begin
	       {AMIQ1_D, AMIQ0_D} = 2'b11;
	    end else begin
	       {AMIQ1_D, AMIQ0_D} = 2'b01;
	    end
	 end
      2'b11: begin
	    AS30_D = !CNTDIS;
	    DS30_D = !(CNTDIS & RW40);
	    ATERM_D = 1'b1;
	    LE_BS_D = 1'b1;
	    if (CNTDIS) begin
	       {AMIQ1_D, AMIQ0_D} = 2'b01;
	    end else begin
	       {AMIQ1_D, AMIQ0_D} = 2'b11;
	    end
	 end
      endcase
   end
endmodule
