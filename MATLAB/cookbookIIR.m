% coeffs from cookbook

fs = 48000;
G = 5;
f0 = 10000;
BW = 1000;


%%%% Peaking Parametric Equaliser Filter
A = 10^(G/40);
omega0 = 2*pi*(f0/fs);
alpha = sin(omega0)*sinh((log(2)/2)*BW*(omega0/sin(omega0)));

b0 = 1 + alpha*A;
b1 = -2*cos(omega0);
b2 = 1 - alpha*A;

a0 = 1 + alpha/A;
a1 = -2*cos(omega0);
a2 = 1 - alpha/A;

a0temp = a0;
a0 = a0/a0temp;
a1 = a1/a0temp;
a2 = a2/a0temp;

b0 = b0/a0temp;
b1 = b1/a0temp;
b2 = b2/a0temp;


%%%% Filter Response
b = [b0 b1 b2];
a = [a0 a1 a2];
freqz(a,b,[])

%ax = findall(gcf, 'Type', 'axes');

%set(ax, 'XLim', [0.005 1]); 

disp(a)
disp(b)
