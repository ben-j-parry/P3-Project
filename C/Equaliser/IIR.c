//#include <stdlib.h>
#include <stdio.h>

     float myxn[3] = {0};
     float myyn[3] = {0};

//add coefficient calculations
float coeff(){


}


float IIR(float x){

     float coeff[5] = {1.0, 1.5, 2.0, 2.5, 3.0};

     
     myxn[2] = myxn[1]; //x(n-1)
     myxn[1] = myxn[0]; //x(n-1)
     myxn[0] = x; //x(n)
    
     myyn[2] = myyn[1]; //y(n-2)
     myyn[1] = myyn[0]; //y(n-1)

     //IIR Difference Equation
     //y(n) =      b0*x(n)    +     b1*x(n−1)    +     b2*x(n−2)    −    a1*y(n−1)     −      a2*y(n−2)
     myyn[0] = (coeff[0]*myxn[0]) + (coeff[1]*myxn[1]) + (coeff[2]*myxn[2]) - (coeff[3]*myyn[1]) - (coeff[4]*myyn[2]); //y(n)

     return myyn[0];


}

int main(){
    float x[7] = {1, 2, 3, 4, 5, 6, 7}; // input values
    float y;


    for (int i = 0; i < 7; i++){
          y = IIR(x[i]);

          printf("%f \n", y);
    }
}
