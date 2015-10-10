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
           PLL_S : out  STD_LOGIC_VECTOR (1 downto 0);	--Steuerausgänge fuer PLL-Justage
           CLK30 : inout  STD_LOGIC;								--CLK zum Mainboard
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

architecture Behavioral of control is
signal	RSTINT : STD_LOGIC:='0';	--Reset um 1 BCLK verzoegert
signal	AMIQ : STD_LOGIC_VECTOR (1 downto 0):="00";	--State-Machine Terminierung
signal	LDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht
signal	QDSACK : STD_LOGIC_VECTOR (1 downto 0):="00";	--DSACKx gelatcht & verzoegert
signal	CNTDIS : STD_LOGIC:='0';	--
signal	SIZING : STD_LOGIC_VECTOR (2 downto 0):="000";	--State-Machine Sizing
signal	SIZING_D : STD_LOGIC_VECTOR (2 downto 0):="000";	--State-Machine Sizing
signal	LEND : STD_LOGIC:='0';	--
signal	LEND_D : STD_LOGIC:='0';	--
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
-- Einstellung PLL     1 = high (3,3V out) Z = 3-State (5V pullup) 0 = low 
-- Basisfrequenz: 40MHz
-- S1 S0	Multi		S1	OE	S0	OE	CODE	
-- 0	0	x2			0	1	0	1	00		
-- 0	Z	x5			0	1	1	0	0Z
--	1	0	x3			1	1	0	1	10
--	1	Z	x3,33		1	1	1	0	1Z	
--	Z	0	x4			1	0	0	1	Z0
--	Z	Z	x2,5		1	0	1	0	ZZ
	PLL_S	<=	"0Z"; --100MHz
	--PLL_S	<=	"Z0"; --80MHz
	--PLL_S	<=	"1Z"; --66MHz
	--PLL_S	<=	"10"; --60MHz
	--PLL_S	<=	"ZZ"; --50MHz
	--PLL_S	<=	"00"; --40MHz
	
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

	BYTE <= '1' when SIZ40 = "01" else '0';
	WORD <= '1' when SIZ40 = "10" else '0';
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
	
	OE_BS		<= AMISEL;
	DIR_BS	<=	RW40;
	LONGPORT	<=	'1' when RSTI40_SIG = '1' and LDSACK="11" else		--long access
					'1' when LONGPORT ='1' and LEND ='0' else '0';	-- hold
	WORDPORT	<=	'1' when RSTI40_SIG = '1' and LDSACK="10" else		--word access
					'1' when WORDPORT ='1' and SIZING/="000" else '0';	-- hold
	BYTEPORT	<=	'1' when RSTI40_SIG = '1' and LDSACK="01" else		--byte access
					'1' when BYTEPORT ='1' and SIZING/="000" else '0';	-- hold


	AMISEL	<= '1' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
														or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '0';
	TBI40		<= '0' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
														or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '1';
	TEA40		<= '0' when LONGPORT = '1' and WORDPORT = '1' and AS30_SIG = '1' else
					'0' when LONGPORT = '1' and BYTEPORT = '1' and AS30_SIG = '1' else
					'0' when WORDPORT = '1' and BYTEPORT = '1' and AS30_SIG = '1' else '1'; --error: two ports open!
					
	AS30		<= AS30_SIG when AS30_OE ='1' else 'Z';
	DS30		<= DS30_SIG when DS30_OE ='1' else 'Z';
	TA40 		<= TA40_SIG when AMISEL = '1' else 'Z';

	--sizing statemachine
	--this is the clocked statemachine transition process
   process (SCLK_SIG, RSTI40_SIG) begin
      if RSTI40_SIG='0' then
      	SIZING <= "000";
			LEND <= '0';
      elsif (rising_edge(SCLK_SIG)) then
			SIZING <= SIZING_D;
			LEND <= LEND_D;
      end if;
   end process;
	
	--somehow a lot of signals need to be "latched" in a unclocked process
	--this idea comes from the abel-conversion
   SIZING_SM: process (SIZING, TS40, SEL16M, LONGPORT, A40, WORDPORT,
	 AMISEL, RW40, BYTEPORT, RSTI40_SIG, ATERM, LDSACK, CNTDIS,
	 TT40, BYTE, WORD,LONG, SIZ40)
   begin
      if(SIZING ="101") then
			TA40_SIG	<= '0';
			AS30_OE		<= '0';
			DS30_OE		<= '0';
			LEND_D <= '1';
		else
			LEND_D <= '0';
			if(TT40(1 downto 0)="11") then
				TA40_SIG	<= '0';
			else
				TA40_SIG	<= '1';
			end if;
			AS30_OE		<= '1';
			DS30_OE		<= '1';
		end if;
	
		if(SIZING = "000" or SIZING = "101")then
			NAMIACC <= '1';
		else
			NAMIACC <= '0';
		end if;
      C1: case SIZING is
			when "000" =>
				SIZ30(0)	<= BYTE;
				SIZ30(1) <= '0';
					
				AL <= "00";
						
				BWL_BS	<= "111";
					
				if( TS40 ='0' and TT40(1)='0' and SEL16M ='1') then
					SIZING_D <="001";
				else
					SIZING_D <="000";
				end if;					
			when "001" =>
				SIZ30(0)	<= BYTE;
				SIZ30(1)	<= WORD;
				
				if(LONG = '0') then
					AL <=	A40;
				else
					AL <= "00";
				end if;

				--bus code for data latch
				if(	(AMISEL = '1' and RW40 ='0' and not(BYTE = '1' and A40(0)='1')) or -- WRITE: everything except byte acces on odd address
						(AMISEL = '1' and RW40 ='1' AND (LONGPORT ='1' or WORDPORT  = '1' or BYTEPORT ='1'))) then --READ: any port
					BWL_BS(0)	<=	'0';
				else 
					BWL_BS(0)	<=	'1';
				end if;
					
				if(	(AMISEL = '1' and RW40 ='0' and ( LONG = '1' OR			-- WRITE: LONG
																	(WORD = '1' and A40(1)='0')	or		-- WRITE: WORD A1=0
																	(BYTE = '1' and A40(1)='0')))or 	-- WRITE: BYTE A1=0
						(AMISEL = '1' and RW40 ='1' AND (WORDPORT  = '1' or BYTEPORT ='1'))) then --READ: word/byte port
					BWL_BS(1)	<=	'0';
				else 
					BWL_BS(1)	<=	'1';
				end if;

				if(	(AMISEL = '1' and RW40 ='0') or 	-- WRITE: any access
						(AMISEL = '1' and RW40 ='1' AND BYTEPORT ='1')) then --READ: byte port
					BWL_BS(2)	<=	'0';
				else 
					BWL_BS(2)	<=	'1';
				end if;

				if( TERM ='1' and LDSACK="01" and 					-- byteterm
					(LONG = '1' or (WORD = '1' and A40(1)='0'))	-- LONG or WORD0
					) then
					SIZING_D <= "010";
				elsif( TERM ='1' and LDSACK="01" and  				-- BYTETERM
					WORD = '1' and A40(1)='1'							-- WORD2
					) then
					SIZING_D <= "100";
				elsif(TERM ='1' and LDSACK="10" and 				-- WORDTERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= "011";
				elsif(TERM ='1' and LDSACK="11"						-- LONGTERM
					) then
					SIZING_D <= "101";
				elsif(TERM ='1' and LDSACK="10" 	and				-- WORDTERM
						(WORD = '1' or BYTE = '1')						-- WORD or BYTE
					) then
					SIZING_D <= "101";
				elsif( TERM ='1' and LDSACK="01" and				-- BYTETERM
						BYTE = '1'											-- BYTE
					) then
					SIZING_D <= "101";
				else
					SIZING_D <= "001";
				end if;
			when "010" =>
				SIZ30	<= "01";		--SIZ(0) was BYTE or WORD or LONG  which is allways true...
				AL		<=	"01";
				BWL_BS(0)	<= '1';
				if(( AMISEL ='1' and (RW40='0' or (RW40='1' and BYTEPORT = '1')))) then
					BWL_BS(1) <= '0';
					BWL_BS(2) <= '0';
				else
					BWL_BS(1) <= '1';
					BWL_BS(2) <= '1';
				end if;
				
				if(TERM ='1' and LDSACK="01" and  						-- BYTETERM
					WORD = '1' and A40(1)='0'								-- WORD0
					) then
					SIZING_D <= "101";
				elsif(TERM ='1' and LDSACK="01" and  					-- BYTETERM
					LONG = '1'													-- LONG
					) then
					SIZING_D <= "011";
				else
					SIZING_D <= "010";
				end if;
			when "011" =>
				SIZ30(0)	<= BYTE;
				SIZ30(1)	<= LONG;
					
				AL	<= "10";
					
				if(( AMISEL ='1' and (RW40='0' or (RW40='1' and BYTEPORT = '1')))) then
					BWL_BS(0) <= '0';
					BWL_BS(2) <= '0';
				else
					BWL_BS(0) <= '1';
					BWL_BS(2) <= '1';
				end if;
				if( AMISEL ='1' and               RW40='1' and WORDPORT = '1')then
					BWL_BS(1) <= '0';
				else
					BWL_BS(1) <= '1';
				end if;
					
				if(TERM ='1' and LDSACK="01" and  					-- BYTETERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= "100";
				elsif(TERM ='1' and LDSACK="10" and  				-- WORDTERM
					LONG = '1'												-- LONG
					) then
					SIZING_D <= "101";
				else
					SIZING_D <= "011";
				end if;
			when "100" =>
				SIZ30	<= "01";		--SIZ(0) was BYTE or WORD or LONG  which is allways true...
				AL		<=	"11";
				BWL_BS(1 downto 0) <= "11";
				if( AMISEL ='1' and (RW40='0' or (RW40='1' and BYTEPORT = '1')))then
					BWL_BS(2) <= '0';
				else
					BWL_BS(2) <= '1';
				end if;
				
				if(TERM ='1' and LDSACK="01" and  					-- BYTETERM
					(LONG = '1' or											-- LONG
					 (WORD = '1' and A40(1)='1'))						-- WORD2						
					) then
					SIZING_D <= "101";
				else
					SIZING_D <= "100";
				end if;
			when "101"=>
				SIZ30(0)	<= BYTE;
				SIZ30(1)	<= '0';
				
				AL <="00";
				
				BWL_BS <= "111";
				SIZING_D <="000";
			when others=>					
				SIZ30(0)	<= BYTE;
				SIZ30(1)	<= '0';
					
				AL <="00";
				BWL_BS <= "111";
				SIZING_D <="000";
      end case C1;
   end process SIZING_SM;


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
	

end Behavioral;

