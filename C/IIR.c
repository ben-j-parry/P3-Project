// IIR.c
// Program designed to calculate the output of the algorithm
// This program is not designed for conversion to assembly
// Ver:  v2
// Date: 24/02/23
#include <stdio.h>
#include <math.h>


     float x_[3] = {0};
     float y_[3] = {0};


float IIR(float x){

     float coeff[5] = {0.3199, 0.5600, 0.3190, -0.0230, 0.2242};

     x_[2] = x_[1]; //x(n-2)
     x_[1] = x_[0]; //x(n-1)
     x_[0] = x; //x(n)
    
     y_[2] = y_[1]; //y(n-2)
     y_[1] = y_[0]; //y(n-1)

     //IIR Difference Equation
     //y(n) =      b0*x(n)    +     b1*x(n−1)    +     b2*x(n−2)    −    a1*y(n−1)     −      a2*y(n−2)
     y_[0] = floor(coeff[0]*x_[0]) + floor(coeff[1]*x_[1]) + floor(coeff[2]*x_[2]) - floor(coeff[3]*y_[1]) - floor(coeff[4]*y_[2]); //y(n)

     return y_[0];


}

 void main(){
    float x[50]; // input values
    float y;
     float data = 0;

     for (long j = 0; j < 50; j++){
          
          x[j] = (data+1)*50.0;
          //printf("%f\n", data);
          //printf("%ld\n",x[j]);
     }

    for (int i = 0; i < 50; i++){
     data = (i+6)*3;
          y = IIR(data);
          //printf("%f\n", data);
          printf("%lf \n", y);
    }
}
