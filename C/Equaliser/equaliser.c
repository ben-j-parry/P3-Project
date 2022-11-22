
#include "FIR.h"
#include "equaliser.h"

int main(){
    float x[16]; // input values
    float y[16];

    for(int i = 0; i <16; i++){
        scanf("%f", &x[i]);
    }
}

int arraylen(float* arr){
    int xsize = sizeof(arr)/sizeof(arr[0]);

    return xsize;
}