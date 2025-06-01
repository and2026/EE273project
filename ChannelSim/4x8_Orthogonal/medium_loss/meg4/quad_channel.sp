* Reference Channel *

*************************************************************************
*************************************************************************
*                                                                       *
*			Parameter Definitions				*
*                                                                       *
*	ADJUST THE FOLLOWING PARAMETERS TO SET SIMULATION RUN TIME	*
*	AND TO SET DRIVER PRE-EMPHASIS LEVELS.				*
*                                                                       *
*	PLOT THE SIGNAL rx_diff TO GET THE DIFFERENTIAL RECEIVE SIGNAL.	*
*                                                                       *
*************************************************************************
*************************************************************************
* Simulation Run Time *
 *.PARAM simtime	= '60/bps'	* USE THIS RUNTIME FOR PULSE RESPONSE
.PARAM simtime	= '256/bps'	* USE THIS RUNTIME FOR EYE DIAGRAM

* CTLE Settings *
***set for 10.7Gbps***
* .PARAM az1     = 1.65g            * CTLE zero frequency, Hz
 .PARAM az1     = 1.60g            * CTLE zero frequency, Hz
 .PARAM ap1     = 5.35g           * CTLE primary pole frequency, Hz
 .PARAM ap2     = 10g           * CTLE secondary pole frequency, Hz

* Driver Pre-emphais *
* .PARAM pre1	= 0.10		* Driver pre-cursor pre-emphasis
* .PARAM post1	= -0.01		* Driver 1st post-cursor pre-emphasis
* .PARAM post2	= 0.00		* Driver 2nd post-cursor pre-emphasis
 .PARAM pre1	= 0.07		* Driver pre-cursor pre-emphasis
 .PARAM post1	= 0.02		* Driver 1st post-cursor pre-emphasis
 .PARAM post2	= -0.02		* Driver 2nd post-cursor pre-emphasis 

* Eye delay -- In awaves viewer, plot signal rx_diff against signal eye
*              then adjust parameter edui to center the data eye.
*
 .PARAM edui	= 0.00	 	* Eye diagram alignment delay.
 				* Units are fraction of 1 bit time.
				* Negative moves the eye rigth.
				* Positive moves the eye left.

* Single Pulse Signal Source *
Vs  inp 0    PULSE (1.250 0 0 trise tfall '(1/bps)-trise' simtime)

* PRBS7 Signal Source *
*Xs  inp inn  (bitpattern) dc0=0 dc1=1 baud='1/bps' latency=0 tr=trise

* AC Signal Source *
*Vs  in 0   AC 1

*************************************************************************
*************************************************************************
* Driver Volatage and Timing *
***set for 10.7Gbps***
 .PARAM vd	= 1000m		* Driver peak to peak diff drive, volts
 .PARAM trise	= 30p		* Driver rise time, seconds
 .PARAM tfall	= 30p		* Driver fall time, seconds
 .PARAM bps	= 10.7g		* Bit rate, bits per second

* PCB Line Lengths *
***set for orthogonal midplane***
 .PARAM len1	= 5.69	**min 0.65, max 5.69*** Line segment 1 length, inches
 .PARAM len2	= 2.98 	**min 2.98, max 2.98*** Line segment 2 length, inches
 .PARAM len3	= 5.66 	**min 1.17, max 5.66*** Line segment 3 length, inches
 .PARAM len4	= 1	**min 1, max 1**      * Line segment 4 length, inches

* Package Parameters *
 .PARAM GENpkgZ = 47.5		* Typ GEN package trace impedance, ohms
 .PARAM GENpkgD = 100p		* Typ GEN package trace delay, sec

* Receiver Parameters *
 .PARAM cload	= 2f		* Receiver input capacitance, farads
 .PARAM rterm	= 50		* Receiver input resistance, ohms

*************************************************************************
*                                                                       *
*		SDD11, SDD21 Calculation Circuit			*
*                                                                       *
*************************************************************************
* SDD11,SDD21 Channel Signal Source -- Replace Behavioral Driver with this
*Vs  s1   s2   AC 2
*Rs1 s1   ppad  50
*Rs2 s2   npad  50

* Replica Circuit and SDD11 & SDD21 Measurement Circuit
 Vr  rep1 rep2 AC 2		* Replica source
 Rr1 rep1 repp 50		* Replica circuit
 Rr2 repp 0    50
 Rr3 rep2 repn 50
 Rr4 repn 0    50
 Er1 fwd  0 (repp, repn) 1	* Compute V forward
 Er2 inpt 0 (jp1,  jn1)  1	* Computes channel input voltage
 Er3 s11  0 (inpt, fwd)  1	* Computes s11
 Er4 s21  0 (jp14, jn14) 1	* Computes s21

*************************************************************************
*************************************************************************
*                                                                       *
*			Main Circuit					*
*                                                                       *
*************************************************************************
*************************************************************************
*************************************************************************
* Behavioral Driver *
 Xf  inp in   (RCF) TDFLT='0.25*trise'
 Xd  in  ppad npad  (tx_4tap_diff) ppo=vd bps=bps a0=pre1 a2=post1 a3=post2

* Daughter Card 1 Interconnect *
 Xpp1    ppad  tp1   (gen_pkg)				* Driver package model
 Xpn1    npad  tn1   (gen_pkg)				* Driver package model

*Source side terminations
Rtp1 tp1 jp1 13.45					* RT1
Rtn1 tn1 jn1 13.45					* RT1
Rtpn1 jp1 jn1 586.4					* RT2

*Victum through driver package model
 *Xp3p1  0  t3p1 (gen_pkg) 	   			*through driver
 *Xp4n1  0  t4n1 (gen_pkg)				*through driver
Rp3p1 t3p1 0 GENpkgZ
RP4n1 t4n1 0 GENpkgZ



*Source side terminations for vicutm lines
 Rt3p1    t3p1 q3p1   11.9    				*RT1 
 Rt4n1    t4n1 q4n1   11.9				*RT1
 Rt34pn1  q3p1 q4n1   671.69				*RT2

*In the board
 Xvn1    jn1   jn2   (via)				* Package via
 Xvp1    jp1   jp2   (via)				* Package via
 Xv3p1   q3p1 q3p2 (via)				* Package via
 Xc4n1   q4n1 q4n2 (via)				* Package via
Xl1    jp2 jn2 q3p2 q4n2 jp3 jn3 q3p3 q4n3 (quad_stripline)	length=len1  * Line seg 1
 
 Xvp2    jp3   jp4   (via)				* Daughter card via
 Xvn2    jn3   jn4   (via)				* Daughter card via
 Xv3p2   q3p3  q3p4  (via) 				* Daughter card via
 Xv4n2   q4n3  q4n4  (via)				* Daughter card via


*************************************************************************
*************************************************************************
*                                                                       *
*	    Select Your Mid/backplane Configuration Here		*
*                                                                       *
*	    COMMENT OUT THE UNUSED CONFIGURATIONS			*
*                                                                       *
*************************************************************************

* Orthogonal Midplane Interconnect *
Xk1  0  jp4   jn4 q3p4 q4n4 jp5  jn5  q3p5 q4n5 (conn)		    * Ortho connector stack
Tmp1    jp5 0 jp8 0 Z0=50 TD='len2*170p'		    * Through-midplane via
Tmp2    jn5 0 jn8 0 Z0=50 TD='len2*170p'		    * Through-midplane via
Tmp3    q3p5 0 q3p8 0 Z0=50 TD='len2*170p'	    	    * Through-midplane via
Tmp4    q4n5 0 q4n8 0 Z0=50 TD='len2*170p'		    * Through-midplane via
Xk2  0  jp9   jn9 q3p9 q4n9  jp8  jn8 q3p8 q4n8  (conn)		    * Ortho connector stack


*************************************************************************
*************************************************************************

* Daughter Card 2 Interconnect *
 Xvp5    jp9   jp10  (via)				* Daughter card via
 Xvn5    jn9   jn10  (via)				* Daughter card via
 Xv3p5    q3p9   q3p10  (via)				* Daughter card via
 Xv4n5    q4n9   q4n10  (via)				* Daughter card via

 Xl3     jp10  jn10 q3p10 q4n10  jp11 jn11 q3p11 q4n11 (quad_stripline)	length=len3  * Line seg 3
 Xvp6    jp11  jp12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xvn6    jn11  jn12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xv3p6   q3p11 q3p12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xv4n6   q4n11 q4n12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xl4     jp12  jn12 q3p12 q4n12 jp13 jn13 q3p13 q4n13 (quad_stripline)	length=len4  * Line seg 4


 Xvp7    jp13  jp14  (via)				* Package via
 Xvn7    jn13  jn14  (via)				* Package via
 Xv3p7    q3p13  q3p14  (via)				* Package via
 Xv4n7    q4n13  q4n14  (via)				* Package via
 

*Terminate agressor lines
Rtp2 jp14 tp2 36.6					* RT1
Rtn2 jn14 tn2 36.6					* RT1
Rtpn2 jp14 jn14 568.4					* RT2

 Xpp2   tp2  jrp   (gen_pkg)				* Recvr package model
 Xpn2   tn2  jrn   (gen_pkg)				* Recvr package model

* Behavioral Receiver *
 Rrp1  jrp 0  rterm
 Rrn1  jrn 0  rterm
 Crp1  jrp 0  cload
 Crn1  jrn 0  cload
 Xctle jrp jrn outp outn  (rx_eq_diff) az1=az1 ap1=ap1 ap2=ap2


*Terminate victum diff pair line
Rt3p2 q3p14 q3rp 35.04					* RT1
Rt4n2 q4n14 q4rn 35.04					* RT1
Rt34pn2 q3p14 q4n14 671.69				* RT2

 Xp3p2   q3rp out3p  (gen_pkg)				* Recvr package model
 Xp4n2   q4rn out4n  (gen_pkg)				* Recvr package model
 Rr3p1	 out3p 0 rterm					* Behavioral Reciver terms
 Rr4n1   out4n 0 rterm					* Behavioral Reciver terms
 Cr3p1   out3p 0 cload					* Behavioral Reciver terms
 Cr4n1   out4n 0 cload					* Behavioral Reciver terms


* Differential Receive Voltage *
 Ex  rx_diff 0  (outp,outn) 1
 Rx  rx_diff 0  1G

* Eye Diagram Horizontal Source *
 Veye1 eye 0 PWL (0,0 '1./bps',1 R TD='edui/bps')
 Reye  eye 0 1G

*************************************************************************
*                                                                       *
*			Libraries and Included Files			*
*                                                                       *
*************************************************************************
*.INCLUDE './stripline6_fr4.inc'
 .INCLUDE './prbs7.inc'
 .INCLUDE './tx_4tap_diff.inc'
 .INCLUDE './rx_eq_diff.inc'
 .INCLUDE './filter.inc'


*************************************************************************
*                                                                       *
*                       Sub-Circuit Definitions                         *
*                                                                       *
*************************************************************************

*************************************************************************
*************************************************************************
*                                                                       *
*			Simplistic Connector Model			*
*                                                                       *
* 	     REPLACE THIS WITH THE APPROPRIATE AMPHENOL MODEL		*
*                                                                       *
*************************************************************************
*************************************************************************
 .SUBCKT (conn) ref inp inn in3p in4n outp outn	out3p out4n				*
*    T1  inp ref outp ref Z0=50 TD=150p					*
*    T2  inn ref outn ref Z0=50 TD=150p					*
* Midplane Side Terminations *
 R1    1 0  50
 R3    3 0  50
 R5    5 0  50
 R7    7 0  50
 R9    9 0  50
 R11  11 0  50
 R13  13 0  50
 R15  15 0  50
* R17  17 0  50
* R19  19 0  50
* R21  21 0  50
* R23  23 0  50
 R25  25 0  50
 R27  27 0  50
 R29  29 0  50
 R31  31 0  50

* Connector *
 S1  1   2   3   4   5   6   7   8   9   10   11   12
+    13   14   15   16  inp  outp  inn  outn  in3p   out3p   in4n   out4n   MNAME=s_model

* Daughter Card Side Terminations *
 R2    2 0  50
 R4    4 0  50
 R6    6 0  50
 R8    8 0  50
 R10  10 0  50
 R12  12 0  50
 R14  14 0  50
 R16  16 0  50
 *R18  18 0  50
 *R20  20 0  50
* R22  22 0  50
* R24  24 0  50
 R26  26 0  50
 R28  28 0  50
 R30  30 0  50
 R32  32 0  50

* Connector S-parameter Model *
***4x8 Orthogonal ***
.MODEL s_model S TSTONEFILE='Orthogonal_rev12_Full_Final.s24p'

 .ENDS (conn)								*
*************************************************************************
*************************************************************************

*************************************************************************
*                                                                       *
*		    6 mil Wide 50 ohm Stripline in FR4			*
*                                                                       *
*	    REPLACE THIS WITH YOUR DIFFERENTIAL STRIPLINE MODEL		*
*                                                                       *
*************************************************************************
*************************************************************************

 .SUBCKT (quad_stripline) inp inn in3p in4n outp outn out3p out4n length=1 *inch
    W1 inp inn in3p in4n 0 outp outn out3p out4n 0 RLGCMODEL=quad_stripline N=4 l='length*0.0254' delayopt=3
 .ENDS (quad_stripline)


*SYSTEM_NAME : quad_stripline
*
*  ------------------------------------ Z = 3.200400e-04
*  //// Top Ground Plane //////////////
*  ------------------------------------ Z = 3.048000e-04
*       diel_2   H = 1.600200e-04
*  ------------------------------------ Z = 1.447800e-04
*       diel_1   H = 1.295400e-04
*  ------------------------------------ Z = 1.524000e-05
*  //// Bottom Ground Plane ///////////
*  ------------------------------------ Z = 0

* L(H/m), C(F/m), Ro(Ohm/m), Go(S/m), Rs(Ohm/(m*sqrt(Hz)), Gd(S/(m*Hz))

.MODEL quad_stripline W MODELTYPE=RLGC, N=4
+ Lo = 3.630174e-07
+      3.497747e-08 3.630154e-07
+      1.239748e-11 1.170508e-10 3.630154e-07
+      1.313089e-12 1.239748e-11 3.497747e-08 3.630174e-07
+ Co = 1.186792e-10
+      -1.155127e-11 1.186799e-10
+      -1.842259e-16 -3.867382e-14 1.186799e-10
+      0.000000e+00 -1.842254e-16 -1.155127e-11 1.186792e-10
+ Ro = 1.212152e+01
+      0.000000e+00 1.212152e+01
+      0.000000e+00 0.000000e+00 1.212152e+01
+      0.000000e+00 0.000000e+00 0.000000e+00 1.212152e+01
+ Go = 0.000000e+00
+      -0.000000e+00 0.000000e+00
+      -0.000000e+00 -0.000000e+00 0.000000e+00
+      0.000000e+00 -0.000000e+00 -0.000000e+00 0.000000e+00
+ Rs = 2.459144e-03
+      1.380705e-04 2.471441e-03
+      3.819534e-07 2.815465e-06 2.471441e-03
+      7.952224e-08 3.819534e-07 1.380705e-04 2.459144e-03
+ Gd = 4.474100e-12
+      -4.354728e-13 4.474127e-12
+      -6.945153e-18 -1.457969e-15 4.474127e-12
+      0.000000e+00 -6.945133e-18 -4.354728e-13 4.474100e-12

*************************************************************************
*************************************************************************

* Daughter Card Via Sub-circuit -- typical values for 0.093" thick PCBs *
 .SUBCKT (via) in out  Z_via=30 TD_via=20p
    Tvia  in 0 out 0  Z0=Z_via TD=TD_via
 .ENDS (via)

* Motherboard Via Sub-circuit *
*     zvia    = via impedance, ohms
*     len1via = active via length, inches
*     len2via = via stub length, inches
*     prop    = propagation time, seconds/inch
*
 .SUBCKT (mvia) in out  zvia=50 len1via=0.09 len2via=0.03 prop=180p
    T1  in  0 out 0  Z0=zvia TD='len1via*prop'
    T2  out 0 2   0  Z0=zvia TD='len2via*prop'
 .ENDS (mvia)

* Generic Package Model *
 .SUBCKT (gen_pkg)  in out  Z_pkg=GENpkgZ Td_pkg=GENpkgD
    Tpkg in 0 out 0 Z0=Z_pkg TD=Td_pkg
 .ENDS (gen_pkg)


*************************************************************************
*                                                                       *
*			Simulation Controls and Alters			*
*                                                                       *
*************************************************************************
 .OPTIONS post ACCURATE
*.AC DEC 1000 (100k,10g) SWEEP DATA=plens
 .TRAN 5p simtime *SWEEP DATA=plens
 .DATA	plens
+       az1     ap1     ap2	pre1
+	1k	1k	100g	0.0
*+	800meg	3.125g	100g	0.0
*+	850meg	3.125g	10g	0.0
*+	850meg	3.125g	10g	0.16
*+	1g	3.125g	100g	0.0
 .ENDDATA
 .END

