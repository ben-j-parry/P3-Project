%USE Filter Builder to create IIR coefficients 
fs = 44100;
 
b = [0.185190320715258 0 -0.00412150309642649];  %numerator  
a = [1 0 0.810688176188316]; %denominator
y = filter
%freqz(b,a,fs)
