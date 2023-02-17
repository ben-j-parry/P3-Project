%st method
%https://www.st.com/resource/en/application_note/an2874-bqd-filter-design-equations-stmicroelectronics.pdf
%doesnt work lol

fs = 44100;
fc = 1000;
G = 10;
Q = 1/(2^(1/2));

thetaC = 2*pi*fc/fs;
gF = 10^(G/20);
beta1 = 2*thetaC/Q + thetaC^2 + 4;

b0 = (2 * gF * thetaC / Q + thetaC^2 + 4) / beta1; 
b1 = (2 * thetaC^2 - 8) / beta1;
b2 = (4 - 2 * gF * thetaC / Q + thetaC^2) / beta1;


a0 = beta1/beta1; 
a1 = (2 * thetaC^2 - 8) / beta1 ;
a2 = (4 - 2 * thetaC / Q + thetaC^2) / beta1;

b = [b0 b1 b2];
a = [a0 a1 a2];
freqz(a,b,[])