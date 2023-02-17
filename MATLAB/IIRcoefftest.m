%USE Filter Builder to create IIR coefficients 

fs = 44100;

b = [0.185190320715258 0 -0.00412150309642649];  %numerator  
a = [1 0 0.810688176188316]; %denominator

%%%% Filter Response
b = [b0 b1 b2];
a = [a0 a1 a2];

freqz(a,b,[])
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XLim', [0.005 1]);