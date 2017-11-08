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
-- Revision: 0.2
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
           CLK30 : in  STD_LOGIC;								--CLK zum Mainboard
           PCLK : inout  STD_LOGIC;								--CLK_40 040
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

   TYPE sm_68030_P IS (
				S0,
				S2,
				S4
				);
								
   TYPE sm_68030_N IS (
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
				get_byte0,		--100
				get_low_word	--011				
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
signal	SM030_N : sm_68030_N;	--State-Machine negatioive CPU-Flanke (Positive SCLK)
signal	SIZ30_D : STD_LOGIC_VECTOR (1 downto 0):="11";	--SIZ30-Signal
signal	AL_D : STD_LOGIC_VECTOR (1 downto 0):="11";		--Lower Address-Signal
signal	SIZING : sm_sizing;	--State-Machine Sizing
signal	SIZING_D : sm_sizing;	--State-Machine Sizing
signal	ATERM : STD_LOGIC:='0';	--
signal	AMISEL : STD_LOGIC:='0';	--
signal	CLK_RAMC_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	SCLK_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	CLK30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK_SIG_D : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK040_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	BCLK060_SIG : STD_LOGIC:='0';	--internes Signal f?r die Taktaufbereitung
signal	TA40_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	AS30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	DS30_SIG : STD_LOGIC:='0';	--internes Signal f?r die Tristatesteuerung
signal	RSTI40_SIG : STD_LOGIC:='0';	--internes Signal f?r die Resetgenerierung
signal	BYTE : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von BYTE-Zugriffen
signal	WORD : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von WORD-Zugriffen
signal	LONG : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation von LONG-Zugriffen
signal	TERM : STD_LOGIC:='0'; --hilfssignal f?r die Identifikation vom Zyklusende
signal	BR30_Q : STD_LOGIC:='0';  --BR30 auf BCLK synchonisiert
signal	BGACK30_Q : STD_LOGIC:='0';  --BGACK30 auf BCLK synchonisiert
signal	CONTROL40_OE : STD_LOGIC:='0';  --Signal f?r die Tristate-Bedingung der 040-Control
signal	LE_BS_SIG : STD_LOGIC:='0';  --LE_BS auf neg SCLK ermittelt
signal	CLK30_SM : STD_LOGIC:='0';
signal	CLK30_D0 : STD_LOGIC:='0';
signal	CLK30_D1 : STD_LOGIC:='0';
signal 	START_SEND : STD_LOGIC;
signal 	START_SEND_SAMPLED : STD_LOGIC;
signal 	START_ACK : STD_LOGIC;
signal 	END_SEND : STD_LOGIC;
signal 	END_SEND_SAMPLED : STD_LOGIC;
signal 	END_ACK : STD_LOGIC;
signal	DSACK_D0 : STD_LOGIC_VECTOR (1 downto 0);	--DSACKx synced
signal 	STERM_D0 : STD_LOGIC;
signal	DSACK_D1 : STD_LOGIC_VECTOR (1 downto 0);	--DSACKx synced
signal 	STERM_D1 : STD_LOGIC;
signal	DSACK_DECODE : STD_LOGIC_VECTOR (1 downto 0);	--signal alias for the statemachine
signal 	STERM_DECODE : STD_LOGIC;
signal	RESETI_DELAY : STD_LOGIC_VECTOR (1 downto 0);	--reset delay for external reset
signal	RESETO_DELAY : STD_LOGIC_VECTOR (3 downto 0);	--reset delay for external reset
signal	RESETO_S : STD_LOGIC;	--reset delay for internal reset
signal 	RESETI_S : STD_LOGIC;	--sampled RESET IN
signal 	RESETI_S1 : STD_LOGIC;	--sampled RESET IN
signal 	DATA_OE : STD_LOGIC;
signal	PLL_CLOCKDIV : STD_LOGIC_VECTOR (1 downto 0):="00";
signal	LE_BS_SIG_D : STD_LOGIC;
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
	PLL_S	<=	"0Z"; --100MHz/50Mhz
	--PLL_S	<=	"Z0"; --80MHz
	--PLL_S	<=	"1Z"; --66MHz
	--PLL_S	<=	"10"; --60MHz
	--PLL_S	<=	"00"; --40MHz
	
	--clocks
	CLK_RAMC	<= CLK_RAMC_SIG;
	SCLK	<=	SCLK_SIG;
	BCLK	<= BCLK_SIG;
	CLK_BS	<= '1';

	--clocks pos edge
	CLOCKS_P: process (PLL_CLK)
	begin
		if (rising_edge(PLL_CLK)) then --200MHz
			PLL_CLOCKDIV <= PLL_CLOCKDIV + 1;
			CLK_RAMC_SIG	<= PLL_CLOCKDIV(0); --100MHz
			BCLK_SIG_D	<= PLL_CLOCKDIV(1);	--50MHz
			SCLK_SIG	<= BCLK_SIG_D; --50MHz 5ns delayed

			PCLK	<= PLL_CLOCKDIV(0); --100 MHz
			--PCLK	<= BCLK_SIG_D; --50 MHz
			--CLK30_SIG	<= not BCLK_SIG_D; --50MHz 15ns delayed (not needed!)
			if(CPU40_60 = '1')then
				BCLK_SIG <= BCLK_SIG_D; --50MHz 5ns delayed
			else
				BCLK_SIG <= not PLL_CLOCKDIV(1); --50Mhz 10Ns delayed
			end if;

			
			CLK30_D0 <= CLK30;		
			CLK30_D1 <= CLK30_D0;		
			LE_BS_SIG_D <= LE_BS_SIG;
		end if;
	end process CLOCKS_P;
	--statemachine clock
	CLK30_SM	<= CLK30_D1;

	--Erzeugung der Resets
	RESET_40O: process (BCLK_SIG)
	begin
		if(rising_edge(BCLK_SIG)) then
			if(RSTO40 ='0' )then
				RESETI_S <= '0';
				RESETI_S1<= '0';
			else
				RESETI_S<=RESET30;
				RESETI_S1<=RESETI_S;
			end if;
		end if;
	end process;

	RESET30	<=	'0' when RSTO40 ='0' else 'Z'; 
	
	RESET_40I: process (BCLK_SIG)
	begin
		if(rising_edge(BCLK_SIG)) then
			if(RSTO40 = '1' and RESETI_S = '0' ) then
				RSTI40_SIG	<=	'0';
				RSTINT	<='0';
			else 
				if(RESETI_S ='1')then
					RSTI40_SIG	<=	'1';
					RSTINT		<=RSTI40_SIG;
				end if;
			end if;
		end if;
	end process RESET_40I;

	RSTI40 <= RSTI40_SIG;

	--CPU Konfiguration
	IPL_SAMPLE: process(RSTINT,BCLK_SIG)
	begin
		if(RSTINT='0')then
			IPL40		<= "111";
		elsif(falling_edge(BCLK_SIG))then	
			IPL40		<= IPL30;
		end if;
	end process IPL_SAMPLE;
	--IPL40		<= "111"	when RSTINT ='0' else IPL30;	
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
	RW30	<= RW40 when CONTROL40_OE ='1' else 'Z';
	SIZ30	<= SIZ30_D when CONTROL40_OE ='1' else "ZZ";
	AL 	<= AL_D when CONTROL40_OE ='1' else "ZZ";
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
	TERM <= '1' when ATERM = '1' else '0';

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

	END_SAMPLE: process(RSTI40_SIG,BCLK_SIG)
	begin
		if(RSTI40_SIG='0')then
			END_SEND_SAMPLED <='0';
		elsif(falling_edge(BCLK_SIG))then	
			END_SEND_SAMPLED <=END_SEND;
		end if;
	end process END_SAMPLE;

	START_STOP_SAMPLE: process(RSTI40_SIG,BCLK_SIG)
	begin
		if(RSTI40_SIG='0')then
			START_SEND <='0';
			END_ACK <= '0';
			TA40_SIG <='1';
			DATA_OE <='0';
		elsif(rising_edge(BCLK_SIG))then
			--toggle signal for new transfer
			if(TS40 ='0' and TT40(1)='0' and SEL16M ='1') then
				START_SEND <= not START_SEND;
				DATA_OE <='1'; --enable on cycle start
			elsif(TA40_SIG = '0') then
				DATA_OE <='0'; --disable one clock after cycle termination
			end if;
			--detect toggle for end transfer
			if(END_ACK /= END_SEND_SAMPLED --normal 68030-cycle termination
				or (TS40 ='0' and TT40(1 downto 0)="11") --Avec termination
				--or (SIZING = idle and SIZING_D = idle and DATA_OE ='1')
				)
			then
				TA40_SIG <= '0';
				END_ACK <= END_SEND;
			else
				TA40_SIG <='1';
			end if;
		end if;
	end process START_STOP_SAMPLE;

	TA40 		<= TA40_SIG when AMISEL = '1' else 'Z';
	
	--LE_BS 	<= LE_BS_SIG_D;	
	LE_BS 	<= LE_BS_SIG;	
	OE_BS		<= DATA_OE when CONTROL40_OE ='1' else '0';
	DIR_BS	<=	RW40;
	

	AMISEL	<= '1' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
															or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '0';
	TBI40		<= '0' when RSTI40_SIG ='1' and ((TT40(1) = '0' and SEL16M ='1') 	-- adressbereich Mainboard
															or TT40(1)='1') 						-- alt func AVEC/BRKPT
						 else '1';

	TEA40		<= '1'; -- not needed anymore
	AS30		<= AS30_SIG when 	--CYCLE30_OE ='1' and 
										CONTROL40_OE ='1' 
								else 'Z';
	DS30		<= DS30_SIG when 	--CYCLE30_OE ='1' and 
										CONTROL40_OE ='1' 
								else 'Z';
								
	--on a 68030 the interesting parts only happen on the falling cpu-clocks
	MC68030_SM: process (RSTI40_SIG,CLK30_SM)
	begin
		if(RSTI40_SIG ='0') then
			AS30_SIG <= '1';
			DS30_SIG <= '1';
			ATERM <= '0';
			LE_BS_SIG <= '0';
			SM030_N <= S1;	
		
		elsif(falling_edge(CLK30_SM)) then
			if(SIZING_D = idle) then 
				AS30_SIG <= '1';
				DS30_SIG <= '1';
				ATERM <= '0';
				LE_BS_SIG <= '0';
				SM030_N <= S1;	
			else
				case SM030_N is
				when S1 =>
					AS30_SIG <= '0';
					DS30_SIG <= not RW40;
					ATERM <= '0';
					LE_BS_SIG <= '0';
					SM030_N <= S3;
				when S3 =>
					AS30_SIG <= '0';
					DS30_SIG <= '0';
					ATERM <= '0';
					LE_BS_SIG <= '0';
					if((	DSACK30 /="11" 
							or STERM30 ='0' 
							or BERR30 ='0'
						) 
						and HALT30 = '1'
						) then
						SM030_N <=S5;
					else
						SM030_N <=S3;
					end if;				
				when S5 =>
					AS30_SIG <= '1';
					DS30_SIG <= '1';
					ATERM <= '1';
					LE_BS_SIG <= '1';
					SM030_N <=S1; 
				end case;
			end if;
		end if;		
	end process MC68030_SM;
		
	
	--We need to sample the start one half-clock before S1 to satisfy the setup-times of A[1:0] and SIZ30
   process (CLK30_SM, RSTI40_SIG) begin
      if RSTI40_SIG='0' then
			START_SEND_SAMPLED <= '0';
			DSACK_D0 <= "11";
			STERM_D0 <= '1';	
			DSACK_D1 <= "11";
			STERM_D1 <= '1';	
		elsif (rising_edge(CLK30_SM)) then
			START_SEND_SAMPLED <= START_SEND;
			if(SIZING_D = idle) then
				DSACK_D0 <= "11";
				STERM_D0 <= '1';	
				DSACK_D1 <= "11";
				STERM_D1 <= '1';	
			elsif(DSACK30/="11" or STERM30='0')then
				DSACK_D0 <= DSACK30;
				STERM_D0 <= STERM30;
				DSACK_D1 <= DSACK_D0;
				STERM_D1 <= STERM_D0;	
			end if;
      end if;
   end process;
	DSACK_DECODE <= DSACK_D0;
	STERM_DECODE <= STERM_D0;

	--this is the clocked statemachine transition process
   process (CLK30_SM, RSTI40_SIG) begin
      if RSTI40_SIG='0' then
      	SIZING <= idle;
			START_ACK <= '0';
			END_SEND <= '0';
      elsif (falling_edge(CLK30_SM)) then
			SIZING <= SIZING_D;
			
			if(SIZING_D = idle and SIZING /=idle ) then
				END_SEND	<= not END_SEND; -- toggle END_SEND to indicate end of cycle
			end if;

			if(SIZING = size_decode ) then
				START_ACK <= START_SEND; --update internal value after sync with start of cycle
			end if;
      end if;
   end process;

	SIZE_AND_ADR_GEN: process (CLK30_SM) begin
		if (rising_edge(CLK30_SM)) then
		case SIZING_D is
				when idle =>
					SIZ30_D(0)	<= BYTE;
					SIZ30_D(1)	<= WORD;								
					if(LONG = '0') then
						AL_D <=	A40;
					else
						AL_D <= "00";
					end if;
--					BWL_BS	<= "111";	
--
--					if( START_ACK /= START_SEND_SAMPLED) then
--						SIZING_D <=size_decode;
--					else
--						SIZING_D <=idle;
--					end if;					
				when size_decode =>
					--size and address decode
					SIZ30_D(0)	<= BYTE;
					SIZ30_D(1)	<= WORD;								
					if(LONG = '0') then
						AL_D <=	A40;
					else
						AL_D <= "00";
					end if;
--					--bus code for data latch
--					if(	(RW40 ='0' and not(BYTE = '1' and A40(0)='1')) or 	-- WRITE: everything except byte acces on odd address
--							(RW40 ='1' and (DSACK_DECODE/="11" or STERM_DECODE='0'))) then 						-- READ: any port
--						BWL_BS(0)	<=	'0';
--					else 
--						BWL_BS(0)	<=	'1';
--					end if;
--						
--					if(	(RW40 ='0' and ( LONG = '1' OR							-- WRITE: LONG
--							(WORD = '1' and A40(1)='0')	or							-- WRITE: WORD A1=0
--							(BYTE = '1' and A40(1)='0')))or 							-- WRITE: BYTE A1=0
--							(RW40 ='1' AND STERM_DECODE = '1' AND (DSACK_DECODE="01" or DSACK_DECODE="10"))) then -- READ: word/byte port
--						BWL_BS(1)	<=	'0';
--					else 
--						BWL_BS(1)	<=	'1';
--					end if;
--
--					if(	(RW40 ='0') or 												-- WRITE: any access
--							(RW40 ='1' AND STERM_DECODE = '1' AND DSACK_DECODE="10")) then 						-- READ: byte port
--						BWL_BS(2)	<=	'0';
--					else 
--						BWL_BS(2)	<=	'1';
--					end if;
--					--target for next bussizing-cycle
--					if(TERM ='1') then -- cycle completed, see how wide the bus was!
--						if	(STERM_DECODE='0' or DSACK_DECODE="00" ) then						-- LONGTERM: access = finished!
--							SIZING_D <= idle;
--						elsif( DSACK_DECODE="01" 	and						-- WORDTERM
--							(WORD = '1' or BYTE = '1')				-- WORD or BYTE access = finished!
--							) then
--							SIZING_D <= idle;					
--						elsif(DSACK_DECODE="10" and							-- BYTETERM
--							BYTE = '1'									-- BYTE access = finished!
--							) then
--							SIZING_D <= idle;
--						elsif(DSACK_DECODE="01" and 							-- WORDTERM
--							LONG = '1'									-- LONG access = get lower word
--							) then
--							SIZING_D <= get_low_word;
--						elsif( DSACK_DECODE="10" and 						-- BYTETERM
--							(LONG = '1' or 							-- LONG
--							(WORD = '1' and A40(1)='0'))			-- WORD 0
--						) then
--							SIZING_D <= get_byte2;
--						elsif(DSACK_DECODE="10" and  						-- BYTETERM
--							WORD = '1' and A40(1)='1'				-- WORD2
--							) then
--							SIZING_D <= get_byte0;
--						else
--							SIZING_D <= idle; -- this can happen on bus errors!
--						end if;
--					else
--						SIZING_D <= size_decode; -- wait another round!
--					end if;
				when get_low_word =>
					--size and address decode
					SIZ30_D	<= "10";
					AL_D		<= "10";
					
--					--bus code for data latch
--					if(RW40='0') then
--						BWL_BS(2 downto 0) <= "010";
--					else
--						BWL_BS(2 downto 0) <= "101";
--					end if;
--					--target for next bussizing-cycle
--					if(TERM ='1' 											-- must be WORDTERM!
--						) then
--						SIZING_D <= idle;
--					else
--						SIZING_D <= get_low_word;
--					end if;
				when get_byte2 =>
					--size and address decode
					SIZ30_D	<= "01";
					AL_D		<=	"01";
				
--					--bus code for data latch
--					
--					BWL_BS(2 downto 0) <= "001";
--					--target for next bussizing-cycle
--					if(TERM ='1' and   									-- BYTETERM
--						WORD = '1' 											-- WORD0
--						) then
--						SIZING_D <= idle;
--					elsif(TERM ='1' and 									-- BYTETERM
--						LONG = '1'											-- LONG
--						) then
--						SIZING_D <= get_byte1;
--					else
--						SIZING_D <= get_byte2;
--					end if;
				when get_byte1 =>
					--size and address decode
					SIZ30_D	<= "01";
					AL_D	<= "10";
					
--					--bus code for data latch
--					BWL_BS(2 downto 0) <= "010";
--					
--					--target for next bussizing-cycle
--					if(TERM = '1' 											-- BYTETERM
--						 and LONG = '1'
--						) then
--						SIZING_D <= get_byte0;
--					else
--						SIZING_D <= get_byte1;
--					end if;
				when get_byte0 =>
					SIZ30_D	<= "01";
					AL_D		<=	"11";
					
--					--bus code for data latch
--					BWL_BS(2 downto 0) <= "011";				
--					
--					--target for next bussizing-cycle
--					if(	TERM ='1'  										-- BYTETERM				
--						 ) then
--						SIZING_D <= idle;
--					else
--						SIZING_D <= get_byte0;
--					end if;
			end case;
		end if;
	end process;

	--somehow a lot of signals need to be "latched" in a unclocked process
	--this idea comes from the abel-conversion
   SIZING_SM: process (SIZING, START_ACK, START_SEND_SAMPLED,  
	 RW40, STERM_DECODE,DSACK_DECODE, A40,
	 BYTE, WORD, LONG, TERM)
   begin

			case SIZING is
				when idle =>
--					SIZ30_D(0)	<= BYTE;
--					SIZ30_D(1)	<= WORD;								
--					if(LONG = '0') then
--						AL_D <=	A40;
--					else
--						AL_D <= "00";
--					end if;
					BWL_BS	<= "111";	

					if( START_ACK /= START_SEND_SAMPLED) then
						SIZING_D <=size_decode;
					else
						SIZING_D <=idle;
					end if;					
				when size_decode =>
--					--size and address decode
--					SIZ30_D(0)	<= BYTE;
--					SIZ30_D(1)	<= WORD;								
--					if(LONG = '0') then
--						AL_D <=	A40;
--					else
--						AL_D <= "00";
--					end if;
					--bus code for data latch
					if(	(RW40 ='0' and not(BYTE = '1' and A40(0)='1')) or 	-- WRITE: everything except byte acces on odd address
							(RW40 ='1' and (DSACK_DECODE/="11" or STERM_DECODE='0'))) then 						-- READ: any port
						BWL_BS(0)	<=	'0';
					else 
						BWL_BS(0)	<=	'1';
					end if;
						
					if(	(RW40 ='0' and ( LONG = '1' OR							-- WRITE: LONG
							(WORD = '1' and A40(1)='0')	or							-- WRITE: WORD A1=0
							(BYTE = '1' and A40(1)='0')))or 							-- WRITE: BYTE A1=0
							(RW40 ='1' AND STERM_DECODE = '1' AND (DSACK_DECODE="01" or DSACK_DECODE="10"))) then -- READ: word/byte port
						BWL_BS(1)	<=	'0';
					else 
						BWL_BS(1)	<=	'1';
					end if;

					if(	(RW40 ='0') or 												-- WRITE: any access
							(RW40 ='1' AND STERM_DECODE = '1' AND DSACK_DECODE="10")) then 						-- READ: byte port
						BWL_BS(2)	<=	'0';
					else 
						BWL_BS(2)	<=	'1';
					end if;
					--target for next bussizing-cycle
					if(TERM ='1') then -- cycle completed, see how wide the bus was!
						if	(STERM_DECODE='0' or DSACK_DECODE="00" ) then						-- LONGTERM: access = finished!
							SIZING_D <= idle;
						elsif( DSACK_DECODE="01" 	and						-- WORDTERM
							(WORD = '1' or BYTE = '1')				-- WORD or BYTE access = finished!
							) then
							SIZING_D <= idle;					
						elsif(DSACK_DECODE="10" and							-- BYTETERM
							BYTE = '1'									-- BYTE access = finished!
							) then
							SIZING_D <= idle;
						elsif(DSACK_DECODE="01" and 							-- WORDTERM
							LONG = '1'									-- LONG access = get lower word
							) then
							SIZING_D <= get_low_word;
						elsif( DSACK_DECODE="10" and 						-- BYTETERM
							(LONG = '1' or 							-- LONG
							(WORD = '1' and A40(1)='0'))			-- WORD 0
						) then
							SIZING_D <= get_byte2;
						elsif(DSACK_DECODE="10" and  						-- BYTETERM
							WORD = '1' and A40(1)='1'				-- WORD2
							) then
							SIZING_D <= get_byte0;
						else
							SIZING_D <= idle; -- this can happen on bus errors!
						end if;
					else
						SIZING_D <= size_decode; -- wait another round!
					end if;
				when get_low_word =>
--					--size and address decode
--					SIZ30_D	<= "10";
--					AL_D		<= "10";
--					
					--bus code for data latch
					if(RW40='0') then
						BWL_BS(2 downto 0) <= "010";
					else
						BWL_BS(2 downto 0) <= "101";
					end if;
					--target for next bussizing-cycle
					if(TERM ='1' 											-- must be WORDTERM!
						) then
						SIZING_D <= idle;
					else
						SIZING_D <= get_low_word;
					end if;
				when get_byte2 =>
--					--size and address decode
--					SIZ30_D	<= "01";
--					AL_D		<=	"01";
--				
					--bus code for data latch
					
					BWL_BS(2 downto 0) <= "001";
					--target for next bussizing-cycle
					if(TERM ='1' and   									-- BYTETERM
						WORD = '1' 											-- WORD0
						) then
						SIZING_D <= idle;
					elsif(TERM ='1' and 									-- BYTETERM
						LONG = '1'											-- LONG
						) then
						SIZING_D <= get_byte1;
					else
						SIZING_D <= get_byte2;
					end if;
				when get_byte1 =>
--					--size and address decode
--					SIZ30_D	<= "01";
--					AL_D	<= "10";
--					
					--bus code for data latch
					BWL_BS(2 downto 0) <= "010";
					
					--target for next bussizing-cycle
					if(TERM = '1' 											-- BYTETERM
						 and LONG = '1'
						) then
						SIZING_D <= get_byte0;
					else
						SIZING_D <= get_byte1;
					end if;
				when get_byte0 =>
--					SIZ30_D	<= "01";
--					AL_D		<=	"11";
--					
					--bus code for data latch
					BWL_BS(2 downto 0) <= "011";				
					
					--target for next bussizing-cycle
					if(	TERM ='1'  										-- BYTETERM				
						 ) then
						SIZING_D <= idle;
					else
						SIZING_D <= get_byte0;
					end if;
			end case;
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
	--CONTROL40_OE <= '1';
	CONTROL40_OE <= '1' when
						DMA_SM = STATE0 or
						DMA_SM = STATE7 or
						DMA_SM = STATE8 or
						DMA_SM = STATE9 or
						DMA_SM = STATE10 
					else '0';
end Behavioral;

