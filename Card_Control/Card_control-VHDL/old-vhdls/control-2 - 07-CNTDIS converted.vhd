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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity control is
--  Port (
--      SEL16M, PLL_CLK, RSTO40, HALT30, IPL30(0), IPL30(1), IPL30(2), DSACK30(0),
--	    DSACK30(1), STERM30, CPU40_60, A40(0), A40(1), SIZ40(0), SIZ40(1), RW40,
--	    TM40(0), TM40(1), TM40(2), TT40(0), TT40(1), TS40: in std_logic;
--      PLL_S(0), PLL_S(1), CLK30, PCLK, BCLK, SCLK, CLK_BS, CLK_RAMC, AL(0), AL(1),
--	    A30_LE, OE_BS, LE_BS, DIR_BS, BWL_BS(0), BWL_BS(1), BWL_BS(2), FC30(0),
--	    FC30(1), FC30(2), AS30, DS30, RW30, SIZ30(0), SIZ30(1), RESET30,
--	    RSTI40, IPL40(0), IPL40(1), IPL40(2), TBI40, MDIS40, CDIS40, TA40,
--	    TEA40, BGR60, ICACHE: buffer std_logic
 Port ( SEL16M : in  STD_LOGIC;								--Steuerwort vom Ram-Controller	SEL16M		
           PLL_CLK : in  STD_LOGIC;								--Eingangs-CLK / Ausgang PLL
           OSC_CLK : in  STD_LOGIC;								--CLK vom Oszillator (entfallen)
           RSTO40 : in  STD_LOGIC;								--Reset-Ausgang von 040-CPU 
           HALT30 : in  STD_LOGIC;								--HALT-Leitung vom Mainboard
           IPL30 : in  STD_LOGIC_VECTOR (2 downto 0);		--Interrupt Prio-Level 0-2 vom Mainboard
           BERR30 : in  STD_LOGIC;								-- Bus-Error vom Mainboard (entfallen)
           DSACK30 : in  STD_LOGIC_VECTOR (1 downto 0);	--DSACK Bit 0/1 vom Mainboard
           STERM30 : in  STD_LOGIC;								--STERM vom Mainboard
           CIOUT40 : in  STD_LOGIC;								--Cache-Inhibit-Out von 040-CPU (entfallen)
           CPU40_60 : in  STD_LOGIC;							--Erkennung 68040 oder 68060
           A40 : in  STD_LOGIC_VECTOR (1 downto 0);		--Adressleitung 0-1 von 040-CPU
           SIZ40 : in  STD_LOGIC_VECTOR (1 downto 0);		--Transfer-Breite Bit 0-1 von 040-CPU
           RW40 : in  STD_LOGIC;									--Read/Write von 040-CPU
           TM40 : in  STD_LOGIC_VECTOR (2 downto 0);		--Transfer Modifier Bit 0-3 von 040-CPU
           TT40 : in  STD_LOGIC_VECTOR (1 downto 0);		--Transfer-Type Bit 0-1 von 040-CPU
           TS40 : in  STD_LOGIC;									--Transfer-Start von 040-CPU
           PLL_S : out  STD_LOGIC_VECTOR (1 downto 0);	--Steuerausgänge fuer PLL-Justage
           CLK30 : out  STD_LOGIC;								--CLK zum Mainboard
           PCLK : out  STD_LOGIC;								--CLK_40 040
           BCLK : out  STD_LOGIC;								--CLKEN40 040
           SCLK : out  STD_LOGIC;								--BCLK zum Ram-Controller
           CLK_BS : out  STD_LOGIC;								--CLK Bus-Sizing
           CLK_RAMC : out  STD_LOGIC;							--CLK RAM-Controller
           AL	: out STD_LOGIC_VECTOR (1 downto 0);		--Adressleitung-Ausgang A0-1 zum Mainboard
           A30_LE : out  STD_LOGIC;								--Latch-Enable fuer Adresspuffer zum Mainboard

           OE_BS : out  STD_LOGIC;								--Output-Enable fuer Bus-Sizing
           LE_BS : out  STD_LOGIC;								--Latch-Enable fuer Bus-Sizing
           DIR_BS : out  STD_LOGIC;								--Read/Write für Bus-Sizing
           BWL_BS : out  STD_LOGIC_VECTOR (2 downto 0);	--Steuerwort fuer Busbreite Bus-Sizing Bit 0-3
           FC30 : out  STD_LOGIC_VECTOR (2 downto 0);		--Function-Code 0-2 zum Mainboard
           AS30 : out  STD_LOGIC;								--Adress-Strobe zum Mainboard
           DS30 : out  STD_LOGIC;								--Data-Strobe zum Mainboard
           RW30 : out  STD_LOGIC;								--Read/Write zum Mainboard
           SIZ30 : out  STD_LOGIC_VECTOR (1 downto 0);	--Transfer-Breite Bit 0-1 zum Mainboard
           RESET30 : inout  STD_LOGIC;							--Reset vom Mainboard
           RSTI40 : out  STD_LOGIC;								--Reset-Eingang zur 040-CPU
           IPL40 : out  STD_LOGIC_VECTOR (2 downto 0);	--Interrupt Prio-Level 0-2 zur 040-CPU
           TBI40 : out  STD_LOGIC;								--Transfer Burst Inhibit zur 040-CPU
           TCI40 : out  STD_LOGIC;								--Steuerung im RAM-Controller (kann entfallen; CONFIG_1) (entfallen)
           MDIS40 : out  STD_LOGIC;								--MMU-Disable zur 040-CPU (kann entfallen)
           CDIS40 : out  STD_LOGIC;								--Cache-Disable zur 040-CPU (kann entfallen)
           TA40 : out  STD_LOGIC;								--Transfer Acknowledge zur 040-CPU
           TEA40 : out  STD_LOGIC;								--Transfer Error Acknowledge zur 040-CPU
           BGR60 : out  STD_LOGIC;								--BG-Relinquish-Control zur 060-CPU (zu RAM-Controller; CONFIG_0)
           ICACHE : out  STD_LOGIC);							--Steuerwort zum Ram-Controller I-Cache

end control;


architecture control_behav of control is
   signal CAQ0_CLK_ctrl,
	 CAQ0_ACLR_ctrl, AMIQ0_CLK_ctrl, AMIQ0_ACLR_ctrl, 
	 TA40_ZD, LE_BS_D, ATERM_D, DS30_D, AS30_D, AMIQ0_D,
	 AMIQ1_D, LE_BS_CLK, LE_BS_ACLR, ATERM_CLK, ATERM_ACLR, DS30_CLK,
	 DS30_ASET, AS30_CLK, AS30_ASET,
	 LEND_D, DS30_OE, AS30_OE, CAQ0_D, CAQ1_D, CAQ2_D, LEND_CLK, LEND_ACLR,
	 TA40_OE, STOPHALT, STOPRES, BYTEPORT, WORDPORT, LONGPORT, AMISEL, NAMIACC,
	 ATERM, LEND, CAQ0, CAQ1, CAQ2, CNTDIS, AMIQ1, AMIQ0, RSTINT: std_logic;
   signal 
	 LE_BS_FB, DS30_FB, AMIQ0_FB, AMIQ1_FB,
	 CAQ2_FB,
	 CAQ1_FB, CAQ0_FB, LEND_FB, ATERM_FB, AS30_FB: std_logic
	 -- :='0'
	 ;
signal	CLK_RAMC_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	SCLK_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	CLK30_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	BCLK040_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	BCLK060_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	COUNTHALT : STD_LOGIC_VECTOR (11 downto 0):="000000000000";	--Filter-Counter fuer HALT-Leitung
signal	COUNTRES : STD_LOGIC_VECTOR (10 downto 0):="00000000000";	--Counter für Resetsteuerung
signal	RSTI40_SIG : STD_LOGIC:='0';	--internes Signal für die Resetgenerierung
signal	LDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht
signal	QDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht & verzoegert

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

	PLL_S	<=	"Z0";

-- Register Section

	--clocks
	CLK_RAMC	<= CLK_RAMC_SIG;
	SCLK	<=	SCLK_SIG;
	BCLK	<= BCLK060_SIG when CPU40_60 = '1' ELSE BCLK040_SIG;
	CLK30 <= CLK30_SIG;
	--clocks pos edge
	CLOCKS_P: process (PLL_CLK)
	begin
		if (rising_edge(PLL_CLK)) then
			CLK_RAMC_SIG	<= not CLK_RAMC_SIG;
			CLK_BS	<= not CLK_RAMC_SIG;
			PCLK	<= not CLK_RAMC_SIG;
			SCLK_SIG	<= CLK30_SIG xor CLK_RAMC_SIG;
			BCLK060_SIG	<= CLK30_SIG xor CLK_RAMC_SIG;			
			CLK30_SIG	<= CLK30_SIG xor not CLK_RAMC_SIG;			
		end if;
	end process CLOCKS_P;
		--clocks neg edge
	CLOCKS_N: process (PLL_CLK)
	begin
		if (falling_edge(PLL_CLK)) then
			BCLK040_SIG	<= CLK30_SIG xor CLK_RAMC_SIG;
		end if;
	end process CLOCKS_N;

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

	RESET_40I: process (SCLK_SIG)
	begin
		if(rising_edge(SCLK_SIG)) then
			if(RSTO40 = '1' and (RESET30 = '0' or STOPHALT = '0')) then
				RSTI40_SIG	<=	'0';
			else 
				RSTI40_SIG	<=	'1';
			end if;
		end if;
	end process RESET_40I;

	RSTI40 <= RSTI40_SIG;

	RESET_DLY: process (RSTI40_SIG,SCLK_SIG)
	begin
		if(RSTI40_SIG = '0')then
			RSTINT	<='0';
		elsif(rising_edge(SCLK_SIG)) then
			RSTINT	<=	RSTI40_SIG;
		end if;
	end process RESET_DLY;

   (AMIQ0, AMIQ1) <= std_logic_vector'(AMIQ0_FB & AMIQ1_FB);
   process (AMIQ0_CLK_ctrl, AMIQ0_ACLR_ctrl) begin
      if AMIQ0_ACLR_ctrl='1' then
	 (AMIQ0_FB, AMIQ1_FB) <= std_logic_vector'("00");
      elsif AMIQ0_CLK_ctrl'event and AMIQ0_CLK_ctrl='1' then
	 (AMIQ0_FB, AMIQ1_FB) <= std_logic_vector'(AMIQ0_D & AMIQ1_D);
      end if;
   end process;

	--sampling DSACK
	QDSACK_SYNC: process (NAMIACC,SCLK_SIG)
	begin
		if(NAMIACC = '1')then
			QDSACK	<="00";
		elsif(rising_edge(SCLK_SIG)) then
			--sample DSACK
			if(STERM30='0') then
				QDSACK	<= "11";
			else
				QDSACK(0) <= not DSACK30(0);
				QDSACK(1) <= not DSACK30(1);
			end if;
		end if;
	end process QDSACK_SYNC;


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
	--Filterung HALT-Leitung vom Mainboard
	STOPHALT	<=	'1' when COUNTHALT(11 downto 7) = "11111" else '0';
	HALT_P: process (HALT30,SCLK_SIG)
	begin
		if(HALT30 = '0') then
			COUNTHALT	<= "000000000000";
		elsif (rising_edge(SCLK_SIG)) then
			if( STOPHALT ='1') then
				COUNTHALT	<= COUNTHALT;
			else
				COUNTHALT	<= COUNTHALT + 1;
			end if;
		end if;
	end process HALT_P;
   
	--Erzeugung der Resets
	RESET30	<=	'0' when (RSTO40 ='0' AND STOPHALT='1') OR (RESET30 ='0' AND STOPRES = '0') else 'Z'; 
	STOPRES	<= '1' when COUNTRES(10 downto 7) = "1111" else '0';
	RESET_P: process (RSTO40,SCLK_SIG)
	begin
		if(RSTO40 = '0')then
			COUNTRES	<= "00000000000";
		elsif(rising_edge(SCLK_SIG)) then
			if( STOPRES ='1') then
				COUNTRES	<= COUNTRES;
			else
				COUNTRES	<= COUNTRES + 1;
			end if;			
		end if;
	end process RESET_P;

-- Start of original equations
	--CPU Konfiguration
	IPL40		<= "111"	when RSTINT ='0' else IPL30;	
	-- the 111 controls on a 040: small buffer data, adress&Transfer, controll
	-- the 111 controls on a 060: extra Data Write Hold Mode disabled, 68040 Acknowledge Termination Protokoll, Acknowledge Termination ignore State Capability disabled
	CDIS40	<= '1';
	MDIS40	<= '1';
	--originaler ABEL CODE:
	--normbus		= 1;
	--CDIS40			= RSTINT															// Cache-Disable deaktiviert	(ein Pullup tut es)
	--				# !RSTINT & normbus;											// 040: kein BUS-Multiplexer	060: keine Bedeutung
	--DLE_off		= 1;
	--MDIS40			= RSTINT															// MMU-Disable deativiert		(ein Pullup tut es)
	--				# !RSTINT & DLE_off;											// 040: DLE-Mode deaktiviert	060: keine Bedeutung
	BGR60	<= '0'; --no DMA!
	RW30	<= RW40;
	A30_LE	<= '0'; -- Adress-Latch zum Mainboard transparent geschal.
	ICACHE	<= '1' when TT40(1) = '0' AND (TM40 ="010" or TM40 = "110") else '0'; -- !TT1 -> normal/move16 TM2..0 -> user code access   // !TT1 -> normal/move16 TM2..0 -> supervisor code access

	FC30(0)	<= '1' when TT40(1)='0' AND (TM40(1)='0' or TM40(1 downto 0)="11") else	-- user data
					'1' when TT40(1 downto 0 )="10" AND TM40(0)='1' else						-- alt logical func
					'1' when TT40(1 downto 0 )="11" else '0'; 									-- avec / breakpoints
					
	FC30(1)	<=	'1' when TT40(1)='0' AND TM40(1 downto 0)="10" else						-- supv / user code
					'1' when TT40(1 downto 0)="10" AND TM40(1)='1' else 						-- alt logical func
					'1' when TT40(1 downto 0)="11" else '0';										-- avec / breakpoints

	FC30(2)	<= '1' when TT40(1)='0' AND TM40(2 downto 0)="101" else 						-- supv data
					'1' when TT40(1)='0' AND TM40(2 downto 0)="110" else 						-- supv code
					'1' when TT40(1 downto 0 )="10" AND TM40(2)='1' else						-- alt logical func
					'1' when TT40(1 downto 0)="11" else '0';										-- avec / breakpoints

	LDSACK_SYNC: process (NAMIACC,SCLK_SIG)
	begin
		if(NAMIACC = '1')then
			LDSACK	<="00";
		elsif(falling_edge(SCLK_SIG)) then
			--LDSACKx is active in AQ2 & AQ3 !
			if(((QDSACK(0)='1' or QDSACK(1)='1') and (DSACK30(0)='0' or STERM30='0')) or
				(LDSACK(0) ='1' and CNTDIS ='0' and AMIQ1='1' and AMIQ0='1')	--hold to sync with CAQ
				) then
				LDSACK(0)	<= '1';
			else
				LDSACK(0)	<= '0';
			end if;
			
			if(((QDSACK(0)='1' or QDSACK(1)='1') and (DSACK30(1)='0' or STERM30='0')) or
				(LDSACK(1) ='1' and CNTDIS ='0' and AMIQ1='1' and AMIQ0='1')	--hold to sync with CAQ
				) then
				LDSACK(1)	<= '1';
			else
				LDSACK(1)	<= '0';
			end if;
		end if;
	end process LDSACK_SYNC;
	
   
   OE_BS <= AMISEL;
   DIR_BS <= RW40;
   LONGPORT <= (RSTI40_SIG and LDSACK(1) and LDSACK(0)) or (LONGPORT and (not LEND));
   WORDPORT <= (RSTI40_SIG and LDSACK(1) and (not LDSACK(0))) or (WORDPORT and (not
	 ((not CAQ2) and (not CAQ1) and (not CAQ0))));
   BYTEPORT <= (RSTI40_SIG and (not LDSACK(1)) and LDSACK(0)) or (BYTEPORT and (not
	 ((not CAQ2) and (not CAQ1) and (not CAQ0))));

   TA40_OE <= AMISEL;
   AMISEL <= (RSTI40_SIG and (not TT40(1)) and SEL16M) or (RSTI40_SIG and TT40(1));
   TBI40 <= not ((RSTI40_SIG and (not TT40(1)) and SEL16M) or (RSTI40_SIG and TT40(1)));
   TEA40 <= not ((LONGPORT and WORDPORT and AS30_FB) or (LONGPORT and BYTEPORT
	 and AS30_FB) or (WORDPORT and BYTEPORT and AS30_FB));


   LEND_ACLR <= not RSTI40_SIG;
   LEND_CLK <= SCLK_SIG;
   CAQ0_CLK_ctrl <= SCLK_SIG;
   CAQ0_ACLR_ctrl <= not RSTI40_SIG;


   TA40 <= TA40_ZD when TA40_OE='1' else 'Z';
   process (CAQ0_FB, CAQ1_FB, CAQ2_FB, TS40, SEL16M, LONGPORT, A40(0), WORDPORT,
	 AMISEL, RW40, BYTEPORT, RSTI40_SIG, ATERM, LDSACK(1), LDSACK(0), CNTDIS,
	 A40(1), TT40(1), TT40(0), SIZ40(1), SIZ40(0))
      variable stdVec3: std_logic_vector(2 downto 0);
   begin
      (NAMIACC, LEND_D, TA40_ZD, AS30_OE, DS30_OE, SIZ30(0), SIZ30(1), AL(0),
	    AL(1), BWL_BS(0), BWL_BS(1), BWL_BS(2), CAQ2_D, CAQ1_D, CAQ0_D) <=
	    std_logic_vector'("000000000000000");
      stdVec3 := std_logic_vector'(CAQ2_FB & CAQ1_FB & CAQ0_FB);
      case stdVec3 is
      when "000" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= '0';
	 AL(0) <= '0';
	 AL(1) <= '0';
	 NAMIACC <= '1';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= '1';
	 BWL_BS(2) <= '1';
	 if ((not TS40) and (not TT40(1)) and SEL16M)='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("001");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
	 end if;
      when "001" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= SIZ40(1) and (not SIZ40(0));
	 AL(0) <= A40(0) and (not (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1)
	       and SIZ40(0))));
	 AL(1) <= A40(1) and (not (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1)
	       and SIZ40(0))));
	 BWL_BS(0) <= not ((AMISEL and (not RW40) and (((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)) or (SIZ40(1) and (not SIZ40(0))
	       and (not A40(1))) or (SIZ40(1) and (not SIZ40(0)) and A40(1)) or
	       ((not SIZ40(1)) and SIZ40(0) and (not A40(1)) and (not A40(0))) or
	       ((not SIZ40(1)) and SIZ40(0) and A40(1) and (not A40(0))))) or
	       (AMISEL and RW40 and (LONGPORT or WORDPORT or BYTEPORT)));
	 BWL_BS(1) <= not ((AMISEL and (not RW40) and (((not SIZ40(1)) and (not
	       SIZ40(0))) or (SIZ40(1) and SIZ40(0)) or (SIZ40(1) and (not SIZ40(0))
	       and (not A40(1))) or ((not SIZ40(1)) and SIZ40(0) and (not A40(1))
	       and (not A40(0))) or ((not SIZ40(1)) and SIZ40(0) and (not A40(1))
	       and A40(0)))) or (AMISEL and RW40 and (WORDPORT or BYTEPORT)));
	 BWL_BS(2) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0))
	       or (SIZ40(1) and (not SIZ40(0)) and (not A40(1)))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("010");
	 elsif (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and SIZ40(1) and (not SIZ40(0)) and A40(1))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 elsif (RSTI40_SIG and ATERM and LDSACK(1) and (not LDSACK(0)) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and
	       SIZ40(0))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 elsif ((RSTI40_SIG and ATERM and LDSACK(1) and LDSACK(0) and (not CNTDIS)) or
	       (RSTI40_SIG and ATERM and LDSACK(1) and (not LDSACK(0)) and (not CNTDIS)
	       and ((SIZ40(1) and (not SIZ40(0))) or ((not SIZ40(1)) and
	       SIZ40(0)))) or (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0)
	       and (not CNTDIS) and (not SIZ40(1)) and SIZ40(0)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("001");
	 end if;
      when "010" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= ((not SIZ40(1)) and SIZ40(0)) or (SIZ40(1) and (not SIZ40(0)))
	       or ((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0));
	 SIZ30(1) <= '0';
	 AL(0) <= '1';
	 AL(1) <= '0';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 BWL_BS(2) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and SIZ40(1) and (not SIZ40(0)) and (not A40(1)))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 elsif (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and
	       SIZ40(0))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("010");
	 end if;
      when "011" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= ((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0));
	 AL(0) <= '0';
	 AL(1) <= '1';
	 BWL_BS(0) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 BWL_BS(1) <= not (AMISEL and RW40 and WORDPORT);
	 BWL_BS(2) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and
	       SIZ40(0))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 elsif (RSTI40_SIG and ATERM and LDSACK(1) and (not LDSACK(0)) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and
	       SIZ40(0))))='1' then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("011");
	 end if;
      when "100" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= ((not SIZ40(1)) and SIZ40(0)) or (SIZ40(1) and (not SIZ40(0)))
	       or ((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and SIZ40(0));
	 SIZ30(1) <= '0';
	 AL(0) <= '1';
	 AL(1) <= '1';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= '1';
	 BWL_BS(2) <= not ((AMISEL and (not RW40)) or (AMISEL and RW40 and
	       BYTEPORT));
	 if ((RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0) and (not CNTDIS)
	       and (((not SIZ40(1)) and (not SIZ40(0))) or (SIZ40(1) and
	       SIZ40(0)))) or (RSTI40_SIG and ATERM and (not LDSACK(1)) and LDSACK(0)
	       and (not CNTDIS) and SIZ40(1) and (not SIZ40(0)) and A40(1)))='1'
	       then
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("101");
	 else
	    (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("100");
	 end if;
      when "101" =>
	 TA40_ZD <= '0';
	 AS30_OE <= '0';
	 DS30_OE <= '0';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= '0';
	 AL(0) <= '0';
	 AL(1) <= '0';
	 NAMIACC <= '1';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= '1';
	 BWL_BS(2) <= '1';
	 LEND_D <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when "110" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= '0';
	 AL(0) <= '0';
	 AL(1) <= '0';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= '1';
	 BWL_BS(2) <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when "111" =>
	 TA40_ZD <= not (TT40(1) and TT40(0));
	 AS30_OE <= '1';
	 DS30_OE <= '1';
	 SIZ30(0) <= (not SIZ40(1)) and SIZ40(0);
	 SIZ30(1) <= '0';
	 AL(0) <= '0';
	 AL(1) <= '0';
	 BWL_BS(0) <= '1';
	 BWL_BS(1) <= '1';
	 BWL_BS(2) <= '1';
	 (CAQ2_D, CAQ1_D, CAQ0_D) <= std_logic_vector'("000");
      when others =>
      end case;
      stdVec3 := (others=>'0');  -- no storage needed
   end process;
   AS30_ASET <= (not RSTI40_SIG) or NAMIACC;
   AS30_CLK <= SCLK_SIG;
   DS30_ASET <= (not RSTI40_SIG) or NAMIACC;
   DS30_CLK <= SCLK_SIG;
   ATERM_ACLR <= (not RSTI40_SIG) or NAMIACC;
   ATERM_CLK <= SCLK_SIG;
   LE_BS_ACLR <= (not RSTI40_SIG) or NAMIACC;
   LE_BS_CLK <= SCLK_SIG;
   AMIQ0_CLK_ctrl <= SCLK_SIG;
   AMIQ0_ACLR_ctrl <= (not RSTI40_SIG) or NAMIACC;

	CNTDIS_PROC: process (RSTI40_SIG,SCLK_SIG)
	begin
		if(RSTI40_SIG = '0')then
			CNTDIS <= '0';
		elsif(rising_edge(SCLK_SIG)) then
			CNTDIS <= ATERM;
		end if;
	end process CNTDIS_PROC;

   process (AMIQ0_FB, AMIQ1_FB, LDSACK(1), LDSACK(0), RW40, CNTDIS)
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
	 AS30_D <= not ((not LDSACK(0)) and (not LDSACK(1)));
	 DS30_D <= not ((not LDSACK(0)) and (not LDSACK(1)));
	 if (LDSACK(1) or LDSACK(0))='1' then
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
