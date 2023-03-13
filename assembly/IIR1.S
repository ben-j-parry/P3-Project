 //this should be changed to loading from ROM
//loads the coeffs
li gp, 0
li s0, 1 //b0
li s1, 2 //b1 
li s2, 3 //b2
li s3, 4 //a1
li s4, 5 //a2   
sw s0, 0(gp) # 
sw s1, 4(gp) # 
sw s2, 8(gp) # 
sw s3, 12(gp) # 
sw s4, 16(gp) # 
/*
first ver will li the coeffs then sw them into ram, then lw them to be used by the function
second ver will hardwire them into rom then load and store into ram to be used by function
*/

//initialises the registers
li s0, 0 //x(n-2)
li s1, 0 //x(n-1)
li s2, 0 //x(n)
li s3, 0 //y(n-2)
li s4, 0 //y(n-1)
li s5, 0 //y(n)

IIR_funct:
    mv s0, s1 //x(n-2) = x(n-1)
    mv s1, t2 //x(n-1) = x(n)
    //new x(n) value
    //LADC t2 personal instructions
    mv s3, s4 //y(n-2) = y(n-1)
    mv s4, s5 //y(n-1) = y(n)
    //y(n) = b0*x(n) + b1*x(n−1) + b2*x(n−2) − a1*y(n−1) − a2*y(n−2)
    lw t3, 0(gp) //need 2 because of single cycle issue
    lw t3, 0(gp) 
    mul t0, s2, t3 //b0*x(n)
    lw t3, 4(gp)
    lw t3, 4(gp)
    mul t1, s1, t3 //b1*x(n−1)
    add t0, t0, t1
    lw t3, 8(gp)
    lw t3, 8(gp)
    mul t1, s0, t3 //b2*x(n−2)
    add t0, t0, t1
    lw t3, 12(gp)
    lw t3, 12(gp)
    mul t1, s4, t3 //a1*y(n−1)
    sub t0, t0, t1
    lw t3, 16(gp)
    lw t3, 16(gp)
    mul t1, s3, t3 //a2*y(n−2)
    sub t5, t0, t1 //y(n) gets final value
    //SDAC tb 5 personal instructions
    j IIR_funct  # jump to ra#



 /*
00000013
00000013
00000193
00100413
00200493
00300913
00400993
00500a13
0081a023
0091a223
0121a423
0131a623
0141a823
00000413
00000493
00000913
00000993
00000a13
00000a93
00048413
00090493
000003FF //LADC t2
000a0993
000a8a13
0001ae03
0001ae03
03c902b3
0041ae03
0041ae03
03c48333
006282b3
0081ae03
0081ae03
03c40333
006282b3
00c1ae03
00c1ae03
03ca0333
406282b3
0101ae03
0101ae03
03c98333
40628ab3
000F007C //SDAC t5
f9dff06f
*/
