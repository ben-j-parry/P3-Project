#new version to test
    nop
	nop
	#corresponds to IIRF1_3_1.hex
	
	#hard wired coeffs in rom
    #initialises the registers
	li gp, 0 #ROM
    li sp, 256 #RAM
    li s0, 0 #x(n-2)
    li s1, 0 #x(n-1)
    li t2, 0 #x(n) input
    li s3, 0 #y(n-2)
    li s4, 0 #y(n-1)
    li t5, 0 #y(n) output

    
    sw zero, 0(sp) #x(n-2)
    sw zero, 4(sp) #x(n-1)
    sw zero, 8(sp) #x(n)
    sw zero, 12(sp) #y(n-2)
    sw zero, 16(sp) #y(n-1)
    sw zero, 20(sp) #y(n)
    
    #mulhsu is used as sample is unsigned, coeff is signed
    #A is signed, B is unsigned
    IIR_funct:
        #new switch value
		#LSW a2 #0000067E
        nop
        add gp, zero, a2
		#mv gp, a2

        #loads the intermediate values for the filters and shifts them
		lw s0, 4(sp) #x(n-2) = x(n-1)
        lw s0, 4(sp)
		lw s1, 8(sp) #x(n-1) = x(n)
        lw s1, 8(sp)
		#new x(n) value
        #LADC t2 personal instructions 000003FF
		lw s3, 16(sp) #y(n-2) = y(n-1)
        lw s3, 16(sp)
		lw s4, 20(sp) #y(n-1) = y(n)
        lw s4, 20(sp)

        #y(n) = b0*x(n) + b1*x(n−1) + b2*x(n−2) − a1*y(n−1) − a2*y(n−2)
        lw t3, 0(gp) #b0
        lw t3, 0(gp) 
        mulh t0, t3, t2 #b0*x(n)
        lw t3, 4(gp) #b1
        lw t3, 4(gp)
        mulh t1, t3, s1 #b1*x(n−1)
        add t0, t0, t1 #b0*x(n) + b1*x(n−1)
        lw t3, 8(gp) #b2
        lw t3, 8(gp)
        mulh t1, t3, s0 #b2*x(n−2)
        add t0, t0, t1 #b0*x(n) + b1*x(n−1) + #b2*x(n−2)
        lw t3, 12(gp) #a1
        lw t3, 12(gp)
        mulh t1, t3, s4 #a1*y(n−1)
        sub t0, t0, t1 #b0*x(n) + b1*x(n−1) + #b2*x(n−2) - a1*y(n−1)
        lw t3, 16(gp) #a2
        lw t3, 16(gp)
        mulh t1, t3, s3 #a2*y(n−2)
        sub t5, t0, t1 #b0*x(n) + b1*x(n−1) + #b2*x(n−2) - a1*y(n−1) - a2*y(n−2)
		lw t3, 20(gp)
		lw t3, 20(gp)
		mulh t5, t3, t5 #y(n) * gain
        #y(n) gets final value
		
        sw s0, 0(sp) #store x(n-2) in ram
        sw s1, 4(sp) # x(n-1)
        sw t2, 8(sp) # x(n)
        sw s3, 12(sp) # y(n-2)
        sw s4, 16(sp) # y(n-1)
        sw t5, 20(sp) # y(n)

        #mv t2, t5

        #wait for next sample
		addi a0, zero, 0
		addi a1, zero, 350
	loop:
		bge a0, a1, exit
		addi a0, a0, 1
		j loop
	exit:
		nop
		nop
        ##SDAC t5 personal instructions 000F007C
		#must slow down the processor
		
        j IIR_funct  # jump to ra#

 /* new ver
000003FF //LADC t2
000F007C //SDAC t5

00000013
00000013
00000193
10000113
00000413
00000493
00000393
00000993
00000a13
00000f13
00012023
00012223
00012423
00012623
00012823
00012a23
00412403
00412403
00812483
00812483
000003FF
01012983
01012983
01412a03
01412a03
0001ae03
0001ae03
027e12b3
0041ae03
0041ae03
029e1333
006282b3
0081ae03
0081ae03
028e1333
006282b3
00c1ae03
00c1ae03
034e1333
406282b3
0101ae03
0101ae03
033e1333
40628f33
0141ae03
0141ae03
03ee1f33
00812023
00912223
00712423
01312623
01412823
01e12a23
00000513
12c00593
00b55663
00150513
ff9ff06f
00000013
000F007C
f51ff06f

 
//000003FF //LADC t2
//000F007C //SDAC t5

*/