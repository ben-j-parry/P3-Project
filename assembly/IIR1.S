    #this should be changed to loading from ROM
    #loads the coeffs
    
    li	gp,0
    lui	s0,0x1bdf2
    addi	s0,s0,1855
    lui	s1,0xf4ca2
    addi	s1,s1,416
    lui	s2,0xf713
    addi	s2,s2,-1297

    lui	s3,0xc0f59
    addi	s3,s3,1856
    lui	s4,0x73920
    addi	s4,s4,1535  

    sw s0, 0(gp) 
    sw s1, 4(gp)  
    sw s2, 8(gp)  
    sw s3, 12(gp)  
    sw s4, 16(gp)  

    #initialises the registers
    li s0, 0 #x(n-2)
    li s1, 0 #x(n-1)
    li s2, 0 #x(n)
    li s3, 0 #y(n-2)
    li s4, 0 #y(n-1)
    li s5, 0 #y(n)

    IIR_funct:
        mv s0, s1 #x(n-2) = x(n-1)
        mv s1, t2 #x(n-1) = x(n)
    ##      #new x(n) value
        #LADC t2 personal instructions
        nop
        mv s3, s4 #y(n-2) = y(n-1)
        mv s4, s5 #y(n-1) = y(n)
        #y(n) = b0*x(n) + b1*x(n−1) + b2*x(n−2) − a1*y(n−1) − a2*y(n−2)
        lw t3, 0(gp)
        lw t3, 0(gp) 
        mulhu t0, s2, t3 #b0*x(n)
        lw t3, 4(gp)
        lw t3, 4(gp)
        mulhu t1, s1, t3 #b1*x(n−1)
        add t0, t0, t1
        lw t3, 8(gp)
        lw t3, 8(gp)
        mulhu t1, s0, t3 #b2*x(n−2)
        add t0, t0, t1
        lw t3, 12(gp)
        lw t3, 12(gp)
        mulhu t1, s4, t3 #a1*y(n−1)
        sub t0, t0, t1
        lw t3, 16(gp)
        lw t3, 16(gp)
        mulhu t1, s3, t3 #a2*y(n−2)
        sub t5, t0, t1 #y(n) gets final value
        nop
        ##SDAC tb 5 personal instructions
        j IIR_funct  # jump to ra#