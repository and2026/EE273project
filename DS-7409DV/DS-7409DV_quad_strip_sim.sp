 92 ohm Differential Pair * Holmes
* Trace : Gap : Trace = 6 mil : 8 mil : 6 mil
* Material: Meg&N, HVLP copper foil 
************************************************************************* 
 .PARAM thick	= 0.6		* Trace thickness, mils -- 1/2 oz copper
 .PARAM width	= 4.0 		* Trace width, mils
 .PARAM gap	= 7.37		* Pair-to-pair air gap, mils
 .PARAM space	= 24.0 		* Trace pair air gap, mils
 .PARAM etch	= 0.3		* Trace etch factor, mils
 .PARAM rrms	= 2u 		* RMS trace roughness, meters
 .PARAM core	= 3.9		* Core dielectric thickness, mils  (2x1035)
 .PARAM preg	= 4.9 		* Pre-preg dielectric thickness, mils  (2x1035)
 .PARAM dk_core	= 3.49 		* Core relative dielectric constant 
 .PARAM dk_preg	= 3.49 		* Pre-preg relative dielectric constant
 .PARAM df_core	= 0.0025	* Core dissipation factor
 .PARAM df_preg	= 0.0025	* Pre-preg dissipation factor
 .PARAM length	= 12.0		* Trace length, inches
 .PARAM Zo_diff	= 97		* Differential impedance, ohms
************************************************************************* 

* Vs 1 2 AC 2
Vs 1 2 PULSE(0 1 1n 10p 10p 186.9p 6n)
 R1 1     in1  '0.5*Zo_diff'
 R2 2     in2  '0.5*Zo_diff'
 R3 in3   0    '0.5*Zo_diff'
 R4 in4   0    '0.5*Zo_diff'
 R5 out1  0    '0.5*Zo_diff'
 R6 out2  0    '0.5*Zo_diff'
 R7 out3  0    '0.5*Zo_diff'
 R8 out4  0    '0.5*Zo_diff'
 E1 vdiff 0 (out1,out2) 1
 
 W1 in1 in2 in3 in4 gnd out1 out2 out3 out4 gnd FSmodel=quad_striplines INCLUDERSIMAG=YES N=4 l='0.0254*length' delayopt=3
 .MATERIAL diel_1 DIELECTRIC ER=dk_core LOSSTANGENT=df_core
 .MATERIAL diel_2 DIELECTRIC ER=dk_preg LOSSTANGENT=df_preg
 
 .MATERIAL copper METAL CONDUCTIVITY=57.6meg ROUGHNESS=rrms
 
 .SHAPE trap TRAPEZOID TOP='(width-2*etch)*25.4e-6' BOTTOM='width*25.4e-6' HEIGHT='thick*25.4e-6'
 
 .LAYERSTACK stack_1
 + LAYER=(copper,'thick*25.4e-6'), LAYER=(diel_1,'core*25.4e-6')
 + LAYER=(diel_2,'preg*25.4e-6'), LAYER=(copper,'thick*25.4e-6')
 
 .FSOPTIONS opt1 PRINTDATA=YES
 + COMPUTE_GD=YES
 + COMPUTE_RS=YES
 
 .MODEL quad_striplines W MODELTYPE=FieldSolver
 + LAYERSTACK=stack_1, FSOPTIONS=opt1 RLGCFILE=quad_striplines.rlgc
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=(0,'(thick+core)*25.4e-6'))
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=('(width+gap)*25.4e-6','(thick+core)*25.4e-6'))
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=('(2*width+space+gap)*25.4e-6','(thick+core)*25.4e-6'))
 + CONDUCTOR=(SHAPE=trap, MATERIAL=copper, ORIGIN=('(3*width+2*gap+space)*25.4e-6','(thick+core)*25.4e-6'))
 
 .OPTION POST=1 ACCURATE
* .PRINT AC VM(vdiff)
 *.AC DEC 100 1meg 40G

.TRAN 100p 10n
.PRINT TRAN VM(vdiff)


 .END