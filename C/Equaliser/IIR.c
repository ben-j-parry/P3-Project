// IIR.c
// Program designed to calculate the output of the algorithm
// This program is not designed for conversion to assembly
// Ver:  v2
// Date: 24/02/23
#include <stdio.h>

     long x_n[3] = {0};
     long y_n[3] = {0};

long IIR(long x){

     long b[3] = {467609407, -188079712, 259074799};
     long a[3] = {2147483647, -1057646784, 1938949631};

     
     x_n[2] = x_n[1]; //x(n-1)
     x_n[1] = x_n[0]; //x(n-1)
     x_n[0] = x; //x(n)
    
     y_n[2] = y_n[1]; //y(n-2)
     y_n[1] = y_n[0]; //y(n-1)

     //IIR Difference Equation
     //y(n) =      b0*x(n)    +     b1*x(n−1)    +     b2*x(n−2)    −    a1*y(n−1)     −      a2*y(n−2)
     y_n[0] = (b[0]*x_n[0]) + (b[1]*x_n[1]) + (b[2]*x_n[2]) - (a[1]*y_n[1]) - (a[2]*y_n[2]); //y(n)

     return y_n[0];


}

long main(){
    long x[7] = {1, 2, 3, 4, 5, 6, 7}; // input values
    long y;


    for (int i = 0; i < 7; i++){
          y = IIR(x[i]);

          printf("%lf \n", y);
    }
}
