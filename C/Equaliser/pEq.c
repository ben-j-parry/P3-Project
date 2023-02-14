#include <math.h>
#include <stdlib.h>


int main() {

    float A = pow(10, dbGain /40);
    float omega = 2 * M_PI * freq /srate;
    float sn = sin(omega);
    float cs = cos(omega);
    float alpha = sn * sinh(M_LN2 /2 * bandwidth * omega /sn);
    float beta = sqrt(A + A);
}