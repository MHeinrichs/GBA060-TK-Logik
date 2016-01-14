----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:21:31 09/26/2015 
-- Design Name: 
-- Module Name:    control - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
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
	 CAQ0_ACLR_ctrl, 
	 TA40_ZD, 
	 LEND_D,  CAQ0_D, CAQ1_D, CAQ2_D, LEND_CLK, LEND_ACLR,
	 TA40_OE,
	 CAQ0, CAQ1, CAQ2: std_logic;
   signal 
	 
	 CAQ2_FB,
	 CAQ1_FB, CAQ0_FB, LEND_FB: std_logic
	 -- :='0'
	 ;
signal	RSTINT : STD_LOGIC:='0';	--Reset um 1 BCLK verzoegert
signal	AMIQ : STD_LOGIC_VECTOR (1 downto 0):="00";	--State-Machine Terminierung
signal	LDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht
signal	QDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht & verzoegert
signal	CNTDIS : STD_LOGIC:='0';	--
signal	SIZING : STD_LOGIC_VECTOR (2 downto 0):="000";	--State-Machine Sizing
signal	LEND : STD_LOGIC:='0';	--
signal	ATERM : STD_LOGIC:='0';	--
signal	NAMIACC : STD_LOGIC:='0';	--
signal	AMISEL : STD_LOGIC:='0';	--
signal	LONGPORT : STD_LOGIC:='0';	--
signal	WORDPORT : STD_LOGIC:='0';	--
signal	BYTEPORT : STD_LOGIC:='0';	--
signal	COUNTHALT : STD_LOGIC_VECTOR (11 downto 0):="000000000000";	--Filter-Counter fuer HALT-Leitung
signal	COUNTRES : STD_LOGIC_VECTOR (10 downto 0):="00000000000";	--Counter für Resetsteuerung
signal	STOPRES : STD_LOGIC:='0';	--
signal	STOPHALT : STD_LOGIC:='0';	--Ausgangsverkettung Filter-Counter
signal	CLK_RAMC_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	SCLK_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	CLK30_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	BCLK040_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	BCLK060_SIG : STD_LOGIC:='0';	--internes Signal für die Taktaufbereitung
signal	TA40_SIG : STD_LOGIC:='0';	--internes Signal für die Tristatesteuerung
signal	AS30_SIG : STD_LOGIC:='0';	--internes Signal für die Tristatesteuerung
signal	DS30_SIG : STD_LOGIC:='0';	--internes Signal für die Tristatesteuerung
signal	AS30_OE : STD_LOGIC:='0';	--internes Signal für die Tristatesteuerung
signal	DS30_OE : STD_LOGIC:='0';	--internes Signal für die Tristatesteuerung
signal	RSTI40_SIG : STD_LOGIC:='0';	--internes Signal für die Resetgenerierung
signal	RST_TERM : STD_LOGIC:='0';	--internes Signal für die Resetgenerierung des Terminierungsprozesses
signal	BYTE : STD_LOGIC:='0'; --hilfssignal für die Identifikation von BYTE-Zugriffen
signal	WORD : STD_LOGIC:='0'; --hilfssignal für die Identifikation von WORD-Zugriffen
signal	LONG : STD_LOGIC:='0'; --hilfssignal für die Identifikation von LONG-Zugriffen
signal	TERM : STD_LOGIC:='0'; --hilfssignal für die Identifikation vom Zyklusende

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
-- Einstellung PLL     M = high (3,3V out) 1 = 3-State (5V pullup) 0 = low 
-- Basisfrequenz: 40MHz
-- S1 S0	Multi		S1	OE	S0	OE	CODE	
-- 0	0	x2			0	1	0	1	00		
-- 0	1	x5			0	1	1	0	0Z
--	M	0	x3			1	1	0	1	10
--	M	1	x3,33		1	1	1	0	1Z	
--	1	0	x4			1	0	0	1	Z0
--	1	1	x2,5		1	0	1	0	ZZ
	PLL_S	<=	"Z0";
	
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

--	1  0	/DSACK						SIZ1 SIZ0  Size030	FC2 FC1 FC0  Space
--	---------------------------	------------------	------------------
--	H  L	 8 Bit-Port (D31-D24)	0    1	   Byte		1   1   1    CPU
--	L  H	16 Bit-Port (D31-D16)	1    0	   Word		0   0   1    USR Data
--	L  L	32 Bit-Port (D31-D00)	1    1	   3 Bytes	0   1   0    USR Prog
--											0    0	   Long		1   0   1    SUP Data
--																		1   1   0    SUP Prog

--	SIZ1 SIZ0  Size040	TT1 TT0   Type	  TM2 TM1 TM0
--	------------------	--------------	  --------------
--	0    1     Byte		0   0   normal	  0   0   0   Data Cache Push
--	1    0     Word		0   1   MOVE16	  0/1 0   1   Usr/SupV data
--	1    1     Line		1   0   AltAcc	  0/1 1   0   Usr/supV code
--	0    0     Long		1   1   Acknow	  0,1 1,0 1,0 MMU data,code
--													  1   1   1   reserved

	BYTE <= '1' when SIZ40 = "10" else '0';
	WORD <= '1' when SIZ40 = "01" else '0';
	LONG <= '1' when SIZ40 = "11" or SIZ40 ="00" else '0';
	TERM <= '1' when ATERM = '1' and CNTDIS= '0' else '0';

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

	LDSACK_SYNC: process (NAMIACC,SCLK_SIG)
	begin
		if(NAMIACC = '1')then
			LDSACK	<="00";
		elsif(falling_edge(SCLK_SIG)) then
			--LDSACKx is active in AQ2 & AQ3 !
			if(((QDSACK(0)='1' or QDSACK(1)='1') and (DSACK30(0)='0' or STERM30='0')) or
				(LDSACK(0) ='1' and CNTDIS ='0' and AMIQ(1)='1' and AMIQ(0)='1')	--hold to sync with CAQ
				) then
				LDSACK(0)	<= '1';
			else
				LDSACK(0)	<= '0';
			end if;
			
			if(((QDSACK(0)='1' or QDSACK(1)='1') and (DSACK30(1)='0' or STERM30='0')) or
				(LDSACK(1) ='1' and CNTDIS ='0' and AMIQ(1)='1' and AMIQ(0)='1')	--hold to sync with CAQ
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
   TEA40 <= not ((LONGPORT and WORDPORT and AS30_SIG) or (LONGPORT and BYTEPORT
	 and AS30_SIG) or (WORDPORT and BYTEPORT and AS30_SIG));


   LEND_ACLR <= not RSTI40_SIG;
   LEND_CLK <= SCLK_SIG;
   CAQ0_CLK_ctrl <= SCLK_SIG;
   CAQ0_ACLR_ctrl <= not RSTI40_SIG;

	AS30		<= AS30_SIG when AS30_OE ='1' else 'Z';
	DS30		<= DS30_SIG when DS30_OE ='1' else 'Z';

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


	CNTDIS_PROC: process (RSTI40_SIG,SCLK_SIG)
	begin
		if(RSTI40_SIG = '0')then
			CNTDIS <= '0';
		elsif(rising_edge(SCLK_SIG)) then
			CNTDIS <= ATERM;
		end if;
	end process CNTDIS_PROC;
	
	RST_TERM	<= '1' when RSTI40_SIG='0' or NAMIACC='1' else '0';
	--terminierung statemachine
	TERMINATION_SM: process (RST_TERM,SCLK_SIG)
	begin
		if(RST_TERM ='1') then
			AS30_SIG <= '1';
			DS30_SIG <= '1';
			ATERM <= '0';
			LE_BS <= '0';
			AMIQ <= "00";
		elsif(rising_edge(SCLK_SIG)) then
			if(AMIQ = "00") then
				AS30_SIG <= '0';
				DS30_SIG <= not RW40;
				ATERM <= '0';
				LE_BS <= '0';
				AMIQ <= "01";
			elsif(AMIQ = "01") then
				if(LDSACK="00")then					
					AS30_SIG <= '0';
					DS30_SIG <= '0';
				else
					AS30_SIG <= '1';
					DS30_SIG <= '1';
				end if;

				ATERM <= '0';
				LE_BS <= '0';
				if(LDSACK /="00")then
					AMIQ <="11";
				else
					AMIQ <="01";
				end if;				
			elsif(AMIQ = "11") then
				AS30_SIG <= not CNTDIS;
				if( CNTDIS = '1' and RW40 = '1')then					
					DS30_SIG <= '0';
				else
					DS30_SIG <= '1';
				end if;
				ATERM <= '1';
				LE_BS <= '1';
				if(CNTDIS ='1')then
					AMIQ <="01";
				else
					AMIQ <="11";
				end if;								
			end if;
		end if;
		
	end process TERMINATION_SM;

end control_behav;
