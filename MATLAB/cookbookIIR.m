% coeffs from cookbook

fs = 44100;
G = 10;
f0 = 1000;
BW = 500;


%%%% Peaking Parametric Equaliser Filter
A = 10^(G/40);
omega0 = 2*pi*(f0/fs);
alpha = sin(omega0)*sinh((log(2)/2)*BW*(omega0/sin(omega0)));

b0 = 1+alpha*A;
b1 = -2*cos(omega0);
b2 = 1 + alpha;

a0 = 1 + alpha;
a1 = -2*cos(omega0);
a2 = 1 - alpha;


%%%% Filter Response
b = [b0 b1 b2];
a = [a0 a1 a2];
freqz(a,b,[])

ax = findall(gcf, 'Type', 'axes');

set(ax, 'XLim', [0.005 1]);