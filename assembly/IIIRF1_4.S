#new version to test
    nop
	nop

	#hard wired coeffs in rom
    #initialises the registers
	
	#4th order IIR filter
    #doesnt work
	
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
    
    sw zero, 24(sp) #x(n-2)
    sw zero, 28(sp) #x(n-1)
    sw zero, 32(sp) #x(n)
    sw zero, 36(sp) #y(n-2)
    sw zero, 40(sp) #y(n-1)
    sw zero, 44(sp) #y(n)
    #mulhsu is used as sample is unsigned, coeff is signed
    #A is signed, B is unsigned
    IIR_funct:
        #new switch value
		#LSW a2 #0000067E
        #nop
        #mv gp, a2

filter_1:

		li gp, 0 #ROM
		li sp, 256 #RAM
        #filter 1
        #loads the intermediate values for the filters and shifts them
		lw s0, 4(sp) #x(n-2) = x(n-1)
        lw s0, 4(sp)
		lw s1, 8(sp) #x(n-1) = x(n)
        lw s1, 8(sp)
		#new x(n) value
        #LADC t2 personal instructions 000003FF
        nop
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

        mv t2, t5 #makes y1(n) become x2(n)

filter_2:
		
		addi gp, gp, 24
		addi sp, sp, 24
		
        #filter 2
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
		
output_gain:
		lw t3, 24(gp)
		lw t3, 24(gp)
		mulh t5, t3, t5#y(n) gets final value
		
        sw s0, 0(sp) #store x(n-2) in ram
        sw s1, 4(sp) # x(n-1)
        sw t2, 8(sp) # x(n)
        sw s3, 12(sp) # y(n-2)
        sw s4, 16(sp) # y(n-1)
        sw t5, 20(sp) # y(n)

        #wait for next sample
		addi a0, zero, 0
		addi a1, zero, 350
	loop:
		bge a0, a1, exit
		addi a0, a0, 1
		j loop
	exit:
        nop
        ##SDAC t5 personal instructions 000F007C
		
        j IIR_funct  # jump to ra#

 // new ver
//0000067E //LSW a2
//000003FF //LADC t2
//000F007C //SDAC t5
