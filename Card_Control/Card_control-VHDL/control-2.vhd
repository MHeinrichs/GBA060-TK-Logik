----------------------------------------------------------------------------------
-- Company: A1K
-- Engineer: Georg Braun and Matthias Heinrichs
-- 
-- Create Date:    20:21:31 09/26/2015 
-- Design Name: 	 68060-68030-Statemachine
-- Module Name:    control - Behavioral 
-- Project Name: 
-- Target Devices: XC95144XL-TQFP100-10ns
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 0.1
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Testet frequencies: 100Mhz & 80Mhz
-- other frequencies not tested!
-- Phone me NOW!!!!! ;)
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
           PLL_S : out  STD_LOGIC_VECTOR (1 downto 0);	--Steuerausg?nge fuer PLL-Justage
           CLK30 : inout  STD_LOGIC;								--CLK zum Mainboard
           PCLK : out  STD_LOGIC;								--CLK_40 040
           BCLK : out  STD_LOGIC;								--CLKEN40 040
           SCLK : out  STD_LOGIC;								--BCLK zum Ram-Controller
           CLK_BS : out  STD_LOGIC;								--CLK Bus-Sizing
           CLK_RAMC : out  STD_LOGIC;							--CLK RAM-Controller
           AL	: out STD_LOGIC_VECTOR (1 downto 0);		--Adressleitung-Ausgang A0-1 zum Mainboard
           A30_LE : out  STD_LOGIC;								--Latch-Enable fuer Adresspuffer zum Mainboard

           OE_BS : out  STD_LOGIC;								--Output-Enable fuer Bus-Sizing
           LE_BS : inout  STD_LOGIC;								--Latch-Enable fuer Bus-Sizing
           DIR_BS : out  STD_LOGIC;								--Read/Write f?r Bus-Sizing
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
           ICACHE : out  STD_LOGIC;							--Steuerwort zum Ram-Controller I-Cache

           BR30 :  in  STD_LOGIC;								--Busrequest 030-Seite
			  BGACK30 :  in  STD_LOGIC;							--Bus Grant ack 030-Seite			  
			  BG30 : out  STD_LOGIC;								--Busgrant 030-Seite
			  BR40 :  in  STD_LOGIC;								--Busrequest 040-Seite
			  BG40 :  out  STD_LOGIC;								--Busgrant 040-Seite
			  BB40 :  in  STD_LOGIC;								--Busbusy 040-Seite
			  LOCK40 : in  STD_LOGIC;								--Bus Lock 040			  
			  LOCKE40 : in  STD_LOGIC;							--Bus Lock End 040
			  A_OE :  out  STD_LOGIC);								--030-Adressbus output enable
				
end control;

architecture Behavioral of control is
   TYPE sm_cycle_termination IS (
				idle,				--01
				active,			--11
				start				--00
				);
   TYPE sm_030_positive_flank IS (
				S0,
				S2,
				S4	
				);
   TYPE sm_030_negative_flank IS (
				S1,
				S3,
				S5	
				);
								
	--byteorder: D31-D0: byte3,byte2,byte1,byte0
	--wordorder: D31-D0: high_word,low_word
   TYPE sm_sizing IS (
				idle,				--000
				size_decode,	--001
				get_byte2,		--010
				get_byte1,		--100
				get_low_word,	--011				
				cycle_end		--101
				);
	TYPE sm_dma IS (
				STATE0,
				STATE1,
				STATE2,
				STATE3,
				STATE4,
				STATE5,
				STATE6,
				STATE7,
				STATE8,
				STATE9,
				STATE10				
				);
signal	DMA_SM: sm_dma;
signal	RSTINT : STD_LOGIC:='0';	--Reset um 1 BCLK verzoegert
signal	SM_030_P : sm_030_positive_flank :=S0; 
signal	SM_030_N : sm_030_negative_flank :=S5; 
signal	DSACK_VALID : STD_LOGIC_VECTOR (1 downto 0):="00";	--Valid DSACK sample
signal	SIZ30_D : STD_LOGIC_VECTOR (1 downto 0):="11";	--SIZ30-Signal
signal	SIZ30_SIG : STD_LOGIC_VECTOR (1 downto 0):="11";	--SIZ30-Signal
signal	AL_D : STD_LOGIC_VECTOR (1 downto 0):="11";		--Lower Address-Signal
signal	AL_SIG : STD_LOGIC_VECTOR (1 downto 0):="11";		--Lower Address-Signal
signal	RW30_SIG : STD_LOGIC:='0';	--
signal	SIZING : sm_sizing;	--State-Machine Sizing
signal	SIZING_D : sm_sizing;	--State-Machine Sizing
signal	NAMIACC : STD_LOGIC:='0';	--
signal	AMISEL : STD_LOGIC:='0';	--
signal	COUNTHALT : STD_LOGIC_VECTOR (11 downto 0):="000000000000";	--Filter-Counter fuer HALT-Leitung
signal	COUNTRES : STD_LOGIC_VECTOR (10 downto 0):="00000000000";	--Counter f?r Resetsteuerung
signal	COUNTTIMEOUT : STD_LOGIC_VECTOR (10 downto 0):="00000000000";	--Counter für Timeout
signal	STOPRES : STD_LOGIC:='0';	--
signal	STOPHALT : STD_LOGIC:='0';	--Ausgangsverkettung Filter-Counter
signal	CLK_RAMC_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	SCLK_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	CLK30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK040_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK060_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	TA40_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	AS30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	DS30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	AS30_OE : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	DS30_OE : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	RSTI40_SIG : STD_LOGIC:='0';	--internes Signal f?r die Resetgenerierung
signal	BYTE : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von BYTE-Zugriffen
signal	WORD : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von WORD-Zugriffen
signal	LONG : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von LONG-Zugriffen
signal	TERM : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation vom Zyklusende
signal	BR30_Q : STD_LOGIC:='0';  --BR30 auf BCLK synchonisiert
signal	BGACK30_Q : STD_LOGIC:='0';  --BGACK30 auf BCLK synchonisiert
signal	CONTROL40_OE : STD_LOGIC:='0';  --Signal f?r die Tristate-Bedingung der 040-Control
signal	LE_BS_SIG : STD_LOGIC:='0';  --Signal f?r den latch vom Bus
signal	LE_BS_D : STD_LOGIC:='0';  --Signal f?r den latch vom Bus verz?gert
signal	TERM_P : STD_LOGIC:='0'; 	  --Auf der P-Clock gesampeltes Termionierungssignal
signal	TIP : STD_LOGIC:='0'; --Signal "transfer in progress"
signal	TACK : STD_LOGIC:='0'; --Signal "transfer acknowledge"
signal	TACK_D0 : STD_LOGIC:='0'; --Signal "transfer acknowledge"
signal	BCLK060_SIG_D: STD_LOGIC:='0'; --Signal BUS-CLOCK-D0
signal	CLK30_D0 : STD_LOGIC:='0'; --
signal	CLK30_D1 : STD_LOGIC:='0'; --
signal	TS40_D0 : STD_LOGIC:='0'; --
signal	TERM_P_D0 : STD_LOGIC:='0'; --
signal	TERM_P_D1 : STD_LOGIC:='0'; --

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
-- Einstellung PLL     1 = high (3,3V out) Z = 3-State (5V pullup) 0 = low 
-- Basisfrequenz: 40MHz
-- S1 S0	Multi		S1	OE	S0	OE	CODE	
-- 0	0	x2			0	1	0	1	00		
-- 0	Z	x5			0	1	1	0	0Z
--	1	0	x3			1	1	0	1	10
--	1	Z	x3,33		1	1	1	0	1Z	
--	Z	0	x4			1	0	0	1	Z0
--	Z	Z	x2,5		1	0	1	0	ZZ
	--PLL_S	<=	"0Z"; --100MHz
	PLL_S	<=	"Z0"; --80MHz
	--PLL_S	<=	"1Z"; --66MHz
	--PLL_S	<=	"10"; --60MHz
	--PLL_S	<=	"ZZ"; --50MHz
	--PLL_S	<=	"00"; --40MHz
	
	--clocks
	CLK_RAMC	<= CLK_RAMC_SIG;
	SCLK	<=	SCLK_SIG;
	BCLK	<= BCLK060_SIG when CPU40_60 = '1' ELSE BCLK040_SIG;
	BCLK_SIG <= BCLK060_SIG when CPU40_60 = '1' ELSE BCLK040_SIG;
	--CLK30 <= CLK30_SIG;
	CLK30 <= 'Z';
	--clocks pos edge
	CLOCKS_P: process (PLL_CLK)
	begin
		if (rising_edge(PLL_CLK)) then
			CLK_RAMC_SIG	<= not CLK_RAMC_SIG;
			CLK_BS	<= not CLK_RAMC_SIG;
			PCLK	<= not CLK_RAMC_SIG;
			--CLK30_SIG	<= CLK30;			
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
	--RESET30	<=	'0' when (RSTO40 ='0' AND STOPHALT='1') OR (RESET30 ='0' AND STOPRES = '0') else 'Z'; 
	RESET30	<=	'Z'; 
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
	RW30	<= RW30_SIG when CONTROL40_OE ='1' else 'Z';
	SIZ30	<= SIZ30_SIG when CONTROL40_OE ='1' else "ZZ";
	AL 	<= AL_SIG when CONTROL40_OE ='1' else "ZZ";
	A30_LE	<= '0'; -- Adress-Latch zum Mainboard transparent geschal.
	--	A30_LE	<= '1' when COUNTTIMEOUT="00111111111" and TIP = '0' else '0'; --for debugging!; -- Adress-Latch zum Mainboard transparent geschal.

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

	BYTE <= '1' when SIZ40 = "01" else '0';
	WORD <= '1' when SIZ40 = "10" else '0';
	LONG <= '1' when SIZ40 = "11" or SIZ40 ="00" else '0';
	

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

	
	OE_BS		<= AMISEL when CONTROL40_OE ='1' else '0';
	DIR_BS	<=	RW40;


	AMISEL	<= '1' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
														or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '0';
	TBI40		<= '0' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
														or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '1';
	
	TRANSFER_SAMPLE: process (RSTI40_SIG,PLL_CLK)
	begin 
		if(RSTI40_SIG = '0')then
			TS40_D0	<= '1';
			TIP 		<= '0';
			TERM_P_D0<= '1'; 
			TERM_P_D1<= '1';
--			TACK		<= '1';
--			TERM_P	<= '0';
--			TACK_D0	<= '1';
		elsif(rising_edge(PLL_CLK))then
--			CLK30_D0	<= CLK30;
--			CLK30_D1	<= CLK30_D0;			
--			BCLK060_SIG_D <= SCLK_SIG;
--			if(TA40_SIG='0' and TACK ='1')then --hold TA40_SIG until TIP is released
--				TERM_P <='1';
--			elsif(TACK = '0')then
--				TERM_P<= '0';
--			end if;
			TS40_D0	<= TS40;
			TERM_P_D0 <= TERM_P;
			TERM_P_D1 <= TERM_P_D0;
			if(--SCLK_SIG='1' and BCLK060_SIG_D = '0' and --rising bus clock: sample TS
				TS40 ='0' and TS40_D0 ='0' and TT40(1)='0' and SEL16M ='1')then --amiga access
				TIP<='1';
			elsif(--(CLK30_D0='1' and CLK30_D1='0' and SIZING /=idle) or
					TACK = '0')then --transfer acknowlwedge
				TIP<='0';					
			end if;
			
			if(TIP='0' or TACK = '0') then
				TACK_D0 <= '1';
			elsif( TERM_P_D1 = '1' and TERM_P_D0 = '0' ) then
				TACK_D0<='0';
			end if;
			
			--if(SCLK_SIG='0' and BCLK060_SIG_D = '1')then --falling busclock: set TA40
			--	if((TERM_P ='1' or TA40_SIG='0') and TACK = '1' and TIP ='1')then
			--		TACK<='0';
			--	else
			--		TACK<='1';
			--	end if;
			--end if;
		end if;		
	end process TRANSFER_SAMPLE;

	TERM_P		<= '0' WHEN SIZING = cycle_end --end of amiga cycle
									or TT40(1 downto 0)="11" --end of interuptvector cycle
									--or COUNTTIMEOUT="00111111111"
								else '1';
	
	--TRANSFER_END_SAMPLE: process (TACK,TIP,TERM_P)
	--begin 
	--	if(TIP ='0' or TACK ='0')then
	--		TACK_D0	<= '1';
	--	elsif(falling_edge(TERM_P))then
	--		TACK_D0 <= '0';
	--	end if;		
	--end process TRANSFER_END_SAMPLE;


	TRANSFER_ACKNOWLEDGE: process (RSTI40_SIG,SCLK_SIG)
	begin 
		if(RSTI40_SIG = '0')then
			TACK		<= '1';
			COUNTTIMEOUT <= "00000000000";
		elsif(rising_edge(SCLK_SIG))then
			if(TIP='0')	then
				COUNTTIMEOUT <= "00000000000";
			else
				COUNTTIMEOUT <= COUNTTIMEOUT+1;
			end if;

			if(TIP ='1' or TT40(1 downto 0)="11")then
				TACK <= TACK_D0;
			else
				TACK		<= '1';
			end if;
		end if;		
	end process TRANSFER_ACKNOWLEDGE;


	TEA40		<= BERR30; -- not needed anymore
	AS30		<= AS30_SIG when AS30_OE ='1' and CONTROL40_OE ='1' else 'Z';
	DS30		<= DS30_SIG when DS30_OE ='1' and CONTROL40_OE ='1' else 'Z';
	TA40 		<= TACK when AMISEL = '1' else 'Z';
	LE_BS		<= LE_BS_SIG;--'0' when NAMIACC = '1' else LE_BS_D;
	
	
	STATE_030_P: process(RSTI40_SIG,CLK30)
	begin
		if(RSTI40_SIG = '0')then
			SM_030_P <= S0;
			LE_BS_D	<= '0';
		elsif(rising_edge(CLK30)) then			
			LE_BS_D	<= LE_BS_SIG;
			case SM_030_P is
				when S0 =>
					if(SIZING /= idle and SIZING /=cycle_end) then												
						SM_030_P <= S2;
					else		
						SM_030_P <= S0;
					end if;
				when S2 =>
					if(STERM30 = '0') then
						--cool:short termination!
						SM_030_P <= S0;
					else  --wait in S4 for dsack end
						SM_030_P <= S4;
					end if;
				when S4 => --wait here until DSACK is valid!
					if(DSACK_VALID /="00") then
						SM_030_P <= S0;
					end if;
			end case;
		end if;		
	end process STATE_030_P;
	
	STATE_030_N: process(RSTI40_SIG,CLK30)
	begin
		if(RSTI40_SIG = '0')then
			SM_030_N <= S1;
			DSACK_VALID <="00";
			AS30_SIG <= '1';
			DS30_SIG <= '1';
			LE_BS_SIG 	<= '0';
			TERM <= '0';
		elsif(falling_edge(CLK30)) then
			case SM_030_N is
				when S1 =>
					DSACK_VALID <= "00";
					TERM <= '0';
					LE_BS_SIG<= '0';
					if(SM_030_P = S2) then
						AS30_SIG <= '0';
						DS30_SIG <= not RW40;
						SM_030_N <= S3; --start												
					else
						AS30_SIG <= '1';
						DS30_SIG <= '1';
						SM_030_N <= S1;
					end if;
				when S3 =>
					if(SM_030_P = S0) then
						DSACK_VALID <= "11";
						AS30_SIG <= '1';
						DS30_SIG <= '1';
						LE_BS_SIG<= '1';
						SM_030_N <= S1; --short termination		
						TERM <= '1';						
					elsif(	DSACK30 /= "11" or 
								BERR30  = '0' or 
								STERM30  ='0'
							)then --wait here until bus cycle is finished
						AS30_SIG <= '0';
						DS30_SIG <= '0';
						if(STERM30 = '0') then
							DSACK_VALID <= "11";
						else
							DSACK_VALID(0) <= not DSACK30(0);
							DSACK_VALID(1) <= not DSACK30(1);				
						end if;
						LE_BS_SIG<= '0';
						SM_030_N <= S5;
						TERM <= '0';
					end if;
				when S5 =>
					AS30_SIG <= '1';
					DS30_SIG <= '1';
					LE_BS_SIG<= '1';
					TERM <= '1';
					SM_030_N <= S1;					
			end case;
		end if;		
	end process STATE_030_N;

	
	
	--sizing statemachine
	--this is the clocked statemachine transition process
   process (CLK30, RSTI40_SIG) begin
      if RSTI40_SIG='0' then
      	SIZING <= idle;
			LE_BS_D <= '0';
			SIZ30_SIG <="11";
      elsif (rising_edge(CLK30)) then
			SIZ30_SIG<= SIZ30_D;
			AL_SIG	<= AL_D;
			RW30_SIG	<= RW40;
			SIZING	<= SIZING_D;
			LE_BS_D	<= LE_BS_SIG;			
      end if;
   end process;
	--somehow a lot of signals need to be "latched" in a unclocked process
	--this idea comes from the abel-conversion
   SIZING_SM: process (SIZING, TS40, SEL16M, A40,
	 AMISEL, RW40, RSTI40_SIG, DSACK_VALID,
	 TT40, BYTE, WORD, LONG, SIZ40, TIP,TACK,TERM, TACK_D0)
   begin
      if(SIZING =cycle_end) then
			TA40_SIG	<= '0';
			AS30_OE		<= '0';
			DS30_OE		<= '0';
		else
			if(TT40(1 downto 0)="11") then
				TA40_SIG	<= '0';
			else
				TA40_SIG	<= '1';
			end if;
			AS30_OE		<= '1';
			DS30_OE		<= '1';
		end if;
	
		if(SIZING = idle or SIZING = cycle_end)then
			NAMIACC <= '1';
		else
			NAMIACC <= '0';
		end if;
      C1: case SIZING is
			when idle =>
				SIZ30_D <= "00";
					
				AL_D <= "00";
						
				BWL_BS	<= "111";
					
				if( TIP ='1' and TACK ='1' and TACK_D0= '1') then
					SIZING_D <=size_decode;
				else
					SIZING_D <=idle;
				end if;					
			when size_decode =>
				SIZ30_D(0)	<= BYTE;
				SIZ30_D(1)	<= WORD;
				
				if(LONG = '0') then
					AL_D <=	A40;
				else
					AL_D <= "00";
				end if;

				--bus code for data latch
				if(	(RW40 ='0' and not(BYTE = '1' and A40(0)='1')) or -- WRITE: everything except byte acces on odd address
						(RW40 ='1' AND (DSACK_VALID/="00"))) then --READ: any port
					BWL_BS(0)	<=	'0';
				else 
					BWL_BS(0)	<=	'1';
				end if;
					
				if(	(RW40 ='0' and ( LONG = '1' OR			-- WRITE: LONG
																	(WORD = '1' and A40(1)='0')	or		-- WRITE: WORD A1=0
																	(BYTE = '1' and A40(1)='0')))or 	-- WRITE: BYTE A1=0
						(RW40 ='1' AND (DSACK_VALID="10" or DSACK_VALID="01"))) then --READ: word/byte port
					BWL_BS(1)	<=	'0';
				else 
					BWL_BS(1)	<=	'1';
				end if;

				if(	(RW40 ='0') or 	-- WRITE: any access
						(RW40 ='1' AND DSACK_VALID="01")) then --READ: byte port
					BWL_BS(2)	<=	'0';
				else 
					BWL_BS(2)	<=	'1';
				end if;

				if( TERM ='1'  and DSACK_VALID="01" and 					-- byteterm
					(LONG = '1' or (WORD = '1' and A40(1)='0'))	-- LONG or WORD0
					) then
					SIZING_D <= get_byte2;
				elsif( TERM ='1' and DSACK_VALID="01" and  				-- BYTETERM
					WORD = '1' and A40(1)='1'							-- WORD2
					) then
					SIZING_D <= get_byte1;
				elsif(TERM ='1' and DSACK_VALID="10" and 				-- WORDTERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= get_low_word;
				elsif(TERM ='1' and DSACK_VALID="11"						-- LONGTERM
					) then
					SIZING_D <= cycle_end;
				elsif(TERM ='1'  and DSACK_VALID="10" 	and				-- WORDTERM
						(WORD = '1' or BYTE = '1')						-- WORD or BYTE
					) then
					SIZING_D <= cycle_end;
				elsif( TERM ='1'  and DSACK_VALID="01" and				-- BYTETERM
						BYTE = '1'											-- BYTE
					) then
					SIZING_D <= cycle_end;
				else
					SIZING_D <= size_decode;
				end if;
			when get_byte2 =>
				SIZ30_D	<= "01";		--SIZ(0) was BYTE or WORD or LONG  which is allways true...
				AL_D		<=	"01";
				BWL_BS(0)	<= '1';
				if((RW40='0' or (RW40='1' and DSACK_VALID="01"))) then
					BWL_BS(1) <= '0';
					BWL_BS(2) <= '0';
				else
					BWL_BS(1) <= '1';
					BWL_BS(2) <= '1';
				end if;
				
				if(TERM ='1' and DSACK_VALID="01" and  						-- BYTETERM
					WORD = '1' and A40(1)='0'								-- WORD0
					) then
					SIZING_D <= cycle_end;
				elsif(TERM ='1'  and DSACK_VALID="01" and  					-- BYTETERM
					LONG = '1'													-- LONG
					) then
					SIZING_D <= get_low_word;
				else
					SIZING_D <= get_byte2;
				end if;
			when get_low_word =>
				SIZ30_D(0)	<= BYTE;
				SIZ30_D(1)	<= LONG;
					
				AL_D	<= "10";
					
				if(RW40='0' or (RW40='1' and DSACK_VALID="01")) then
					BWL_BS(0) <= '0';
					BWL_BS(2) <= '0';
				else
					BWL_BS(0) <= '1';
					BWL_BS(2) <= '1';
				end if;
				if( RW40='1' and DSACK_VALID="10" )then
					BWL_BS(1) <= '0';
				else
					BWL_BS(1) <= '1';
				end if;
					
				if(TERM ='1'  and DSACK_VALID="01" and  					-- BYTETERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= get_byte1;
				elsif(TERM ='1'  and DSACK_VALID="10" and  				-- WORDTERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= cycle_end;
				else
					SIZING_D <= get_low_word;
				end if;
			when get_byte1 =>
				SIZ30_D	<= "01";		--SIZ(0) was BYTE or WORD or LONG  which is allways true...
				AL_D		<=	"11";
				BWL_BS(1 downto 0) <= "11";
				if(RW40='0' or (RW40='1' and DSACK_VALID="01"))then
					BWL_BS(2) <= '0';
				else
					BWL_BS(2) <= '1';
				end if;
				
				if(TERM ='1'  and DSACK_VALID="01" and  					-- BYTETERM
					(LONG = '1' or											-- LONG
					 (WORD = '1' and A40(1)='1'))						-- WORD2						
					) then
					SIZING_D <= cycle_end;
				else
					SIZING_D <= get_byte1;
				end if;
			when cycle_end=>
				SIZ30_D	<= "00";				
				AL_D <="00";				
				BWL_BS <= "111";
				SIZING_D <=idle;
      end case C1;
   end process SIZING_SM;

	
	DMA_ARBIT: process (BCLK_SIG,RSTI40_SIG)
	begin
		if(RSTI40_SIG = '0')then
			BR30_Q <= '1';
			BGACK30_Q <= '1';
			DMA_SM <=STATE0;
		elsif(rising_edge(BCLK_SIG)) then
			BR30_Q <= BR30;
			BGACK30_Q <= BGACK30;
			case DMA_SM is
				when STATE0 => 
					-- This is the idle state.  If neither master wants the
					-- bus, we stick aroun here.  As soon as one does, we
					-- jump to either's particular mastership branch. 
					if(BGACK30_Q = '0') then --030-BUS (again) in process
						DMA_SM <= STATE4; 
					elsif(BR30_Q = '0') then --030-Bus request
						DMA_SM <= STATE1;
					elsif(BR40 = '0')then --040-Bus request
						DMA_SM <= STATE7;
					else
						DMA_SM <= STATE0;
					end if;
				when STATE1 =>
					-- This starts the 68030 bus as master branch.  Here we
					-- simply assert a bus grant to the '030 bus. 
					DMA_SM <= STATE2;
				when STATE2 =>
					-- At this stage, we wait for a bus grant acknowledge back
					-- from the '030 bus.  Upon receipt of that, or negation of
					-- the '030 request, we go on to the next state. 
					if(BGACK30_Q = '0') then --030-BUS Ack in process
						DMA_SM <= STATE3; 
					elsif(BR30_Q = '1') then --030-Bus request released: advance to the next state
						DMA_SM <= STATE3;
					else
						DMA_SM <= STATE2; -- wait
					end if;
				when STATE3 =>
					-- This state simply drops the 68030 bus grant. 
					DMA_SM <= STATE4;
				when STATE4 =>
					-- This is the main '030-as-master running state.  As long as
					-- the '030 bus is master and no new grants some in, we hang 
					-- out here.  If BGACK goes away, the arbiter goes back to 
					-- to the idle state.  If a new bus request is asserted, a
					-- grant must be presented to that master.
					if(BR30_Q = '0') then -- Another 030-BUS request 
						DMA_SM <= STATE5; 
					elsif(BGACK30_Q = '1') then --end of 030 cycle
						DMA_SM <= STATE0;
					else
						DMA_SM <= STATE4; --030-Bus cycle pending:wait
					end if;
				when STATE5 =>
					-- Here a 68030 bus grant is supplied to a potential new master
					-- while the '030 bus is mastered by the original '030 master.
					DMA_SM<=STATE6;
				when STATE6 =>
					-- This state holds bus grant to the '030 bus active, waiting
					-- for either the current '030 master to negate BGACK, or the
					-- new '030 master to negate bus request. 
					if(BR30_Q = '1') then -- No BR anymore: drop BG 
						DMA_SM <= STATE3; 
					elsif(BGACK30_Q = '1') then -- end of 030 cycle
						DMA_SM <= STATE2;
					else
						DMA_SM <= STATE6; --030-Bus cycle running
					end if;
				when STATE7 =>
					-- The remaining states manage the 68040 as master.  Here, a
					-- grant is simply driven to the '040 bus.
					DMA_SM <= STATE8;
				when STATE8 =>
					-- This is the main 68040 as master running state. As long
					-- as the '040 wants the bus and the '030 doesn't, stay
					-- here. 
					if( BR30_Q='0' and
						((LOCK40='0' and LOCKE40='0') or LOCK40='1')) then -- BR030 and no lock or lockend: go to busbusy test
						DMA_SM <= STATE9; 
					else
						DMA_SM <= STATE8; -- stay here
					end if;
				when STATE9 =>
					-- At this point we drop grant to the '040, and would like
					-- to let the '030 on the bus.  If the '040 has dropped bus
					-- bus, it's ok to proceed.  If not, either hang out here
					-- as long as bus busy is asserted and we're not starting
					-- a new locked cycle.  If we are, go back to the running
					-- state.
					if(BB40='1') then --040- bus not busy: go to state10
						DMA_SM <= STATE10;
					elsif(LOCK40='0' and LOCKE40='1')then  --040-Bus busy locked and no end: goto state 8 to wait for finished bus actvity						
						DMA_SM <= STATE8;
					else -- wait
						DMA_SM <= STATE9;
					end if;
				when STATE10 =>
					-- Just for safety's sake, make sure we really did see the
					--	'040 give the bus back.
					if(BB40='1') then --040- bus not busy: go to arbiter
						DMA_SM <= STATE0;					
					elsif(BR40='1')then -- no 040 request: wait another round
						DMA_SM <= STATE9;					
					else
						DMA_SM <= STATE8; -- somehow a new 040 bus cycle started
					end if;
			end case;
				
			
			
		end if;
	end process DMA_ARBIT;
	
	BG30 <= '0' when 
						COUNTTIMEOUT="00111111111" or --for debugging!
						DMA_SM = STATE1 or
						DMA_SM = STATE2 or
						DMA_SM = STATE5 or
						DMA_SM = STATE6 
					else '1';
	BG40 <= '0' when 
						DMA_SM = STATE7 or
						DMA_SM = STATE8 
					else '1';
	A_OE <= '0' when 
						DMA_SM = STATE0 or
						DMA_SM = STATE7 or
						DMA_SM = STATE8 or
						DMA_SM = STATE9 or
						DMA_SM = STATE10  
					else '1';
	CONTROL40_OE <= '1' when
						DMA_SM = STATE0 or
						DMA_SM = STATE7 or
						DMA_SM = STATE8 or
						DMA_SM = STATE9 or
						DMA_SM = STATE10 
					else '0';
end Behavioral;

