* Test of Xcede+ Connector s32p Model *

*************************************************************************
*                                                                       *
*			Parameter Definitions				*
*                                                                       *
*************************************************************************
 .PARAM vstep	= 2			* Driver diff pp drive voltage, volts
 .PARAM trise	= 25p			* Driver rise time, seconds
 .PARAM tfall	= 25p			* Driver fall time, seconds

 .PARAM rterm	= 50			* Receiver input resistance, ohms

 .PARAM simtime	= 3n			* Use/adjust for and eye diagram
 .PARAM intv	= 1p			* Reporting interval, seconds.

*************************************************************************
*                                                                       *
*				Main Circuit				*
*                                                                       *
*************************************************************************
* Single Pulse Signal Source *
 Vp  inp 0   PULSE (0 vstep 1n trise tfall simtime 'simtime+1')
 Vn  inn 0   PULSE (vstep 0 1n trise tfall simtime 'simtime+1')
 Rp  inp 1   rterm
 Rn  inn 3   rterm

* Daughter Card Side Terminations *
*R1    1 0  rterm
*R3    3 0  rterm
 R5    5 0  rterm
 R7    7 0  rterm
 R9    9 0  rterm
 R11  11 0  rterm
 R13  13 0  rterm
 R15  15 0  rterm
 R17  17 0  rterm
 R19  19 0  rterm
 R21  21 0  rterm
 R23  23 0  rterm
 R25  25 0  rterm
 R27  27 0  rterm
 R29  29 0  rterm
 R31  31 0  rterm

* Connector *
 S1   1   2   3   4   5   6   7   8   9   10   11   12   13   14   15   16
+    17  18  19  20  21  22  23  24  25   26   27   28   29   30   31   32  MNAME=s_model

* Backplane Side Terminations *
 R2    2 0  rterm
 R4    4 0  rterm
 R6    6 0  rterm
 R8    8 0  rterm
 R10  10 0  rterm
 R12  12 0  rterm
 R14  14 0  rterm
 R16  16 0  rterm
 R18  18 0  rterm
 R20  20 0  rterm
 R22  22 0  rterm
 R24  24 0  rterm
 R26  26 0  rterm
 R28  28 0  rterm
 R30  30 0  rterm
 R32  32 0  rterm

* Connector S-parameter Model *
 .MODEL s_model S TSTONEFILE='./XCedePlus_4pr_97ohm_1p85mm_With_Extra_GND_2mm_Sig_3mm_GND_Wipe.s32p'


*************************************************************************
*                                                                       *
*		    Simulation Controls and Alters			*
*                                                                       *
*************************************************************************
 .OPTION post=1 accurate
 .TRAN intv simtime
 .END
