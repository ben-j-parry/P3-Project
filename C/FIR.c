#include <stdio.h>


float FIR(float* x, float* coeff, float y, float LastV, int xsize);
float gaincalc(float* coeff);

int main()
{
    //float coeff[16] = {0.0147, 0.0059, -0.0515, 0.0073, 0.1375, -0.0726, -0.01949, 0.1624, 0.1624, -0.1949, -0.0726, 0.1375, 0.0073, -0.0515, 0.0059, 0.0147}; //filter coefficients
   
    float coeff[5] = {0.1,0.4,0.56,0.32,0.98};
    float x[4] = {0.2,0.4,0.7,0.43}; //input initial conditions
    float y; //output value
    int xsize = sizeof(x)/sizeof(x[0]); //length of array/length of one element

    //float gain = gaincalc(coeff);
    //need to work out how the gain is calculated, best to be done using a circuit and the fpga
   

    for(int i = 0; i < (xsize+5); i++){ //prints each output value for each input value.
        y = FIR(x, coeff, y, x[0], xsize);
        printf("%f\n",y);
    }
       
    return 0;

}

float FIR(float* x, float* coeff, float y, float LastV, int xsize)
{
   //y(n) = ....h(4)x(n-4) + h(3)x(n-3) + h(2)x(n-2)+h(1)x(n-1)+h(0)x(n)

   y = 0.0;

    for (int i = (xsize-1) ; i > 0 ; i--)
    {
         x[i] = x[i-1];
         y += (coeff[i] * x[i]);
    }

     y += (coeff[0] * LastV); //sets the value for the last y value
    
    //y = y*gain;
    return y;
}

/*
float gaincalc(float* coeff){
    int numcoeff = sizeof(coeff)/sizeof(coeff[0]);
    float gsum = 0.0;

    for(int i = 0; i < numcoeff; i++){
        gsum += coeff[i];
    }
    //unity gain is coeff/sum of gains
    gsum = 1/gsum; //this is not correct

    return gsum;

}
*/