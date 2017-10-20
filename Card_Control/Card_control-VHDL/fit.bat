SET PATH=%PATH%;c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64

--xst -intstyle ise -ifn "C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/Card_Control/Card_control-VHDL/control.xst" -ofn "C:/Users/Matze/Amiga/Hardwarehacks/gb_a1k_tk/Logik/Card_Control/Card_control-VHDL/control.syr"
cpldfit.exe -intstyle ise -p xc95144xl-10-TQ100 -ofmt vhdl -htmlrpt -exhaust -optimize speed -loc on -slew fast -init low -inputs %1 -pterms %2 -unused float -power std -terminate float control.ngd >log.txt 
tsim -intstyle ise control control.nga
hprep6 -s IEEE1149 -n control -i control