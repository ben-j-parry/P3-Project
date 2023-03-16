
fs = 48000;

fc = 5000;
G = 5;

fb = 1000;

Q = fc/fb;

[a,b] = peaking(G, fc, Q, fs);

%b = [b0 b1 b2];
%a = [a0 a1 a];

disp(a)
disp(b)
freqz(a,b,[])