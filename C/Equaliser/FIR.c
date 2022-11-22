#include "equaliser.h"
#include "FIR.h"

float FIR(float* x){
 float coeff[10][16];
 float y[16];
    for(int i = 0; i < 16; i++){
         y[i] = convolution(x, coeff[0]);
    }

}

float convolution(float* x, float* coeff, float y){
     //y(n) = ....h(4)x(n-4) + h(3)x(n-3) + h(2)x(n-2)+h(1)x(n-1)+h(0)x(n)
     //not sure if this works 
     
     y = 0.0;
     int xsize = arraylen(x);
    float finV = x[0];

    for (int i = (xsize-1) ; i > 0 ; i--)
    {
         x[i] = x[i-1];
         y += (coeff[i] * x[i]);
    }

     y += (coeff[0] * finV); //sets the value for the last y value
    
    //y = y*gain;
    return y;
}
