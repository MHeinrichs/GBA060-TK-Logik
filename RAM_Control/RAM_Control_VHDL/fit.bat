SET PATH=%PATH%;c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64

rem xst -intstyle ise -ifn "C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/RAM_Control/RAM_Control_VHDL/ramcon.xst" -ofn "C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/RAM_Control/RAM_Control_VHDL/ramcon.syr"
cpldfit.exe -intstyle ise -p xc95144xl-10-TQ100 -ofmt vhdl -htmlrpt -optimize density -loc on -slew fast -init low -inputs 50 -pterms 25 -unused float -power std -terminate float ramcon.ngd >log.txt 
tsim -intstyle ise ramcon ramcon.nga
hprep6 -s IEEE1149 -n ramcon -i ramcon