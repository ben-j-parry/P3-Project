%%stanford calcluations

fs = 44100;
bw = 300;
fc = 1000;
g = 2;

c = cot(pi*fc/fs); % bilinear transform constant
cs = c^2;  csp1 = cs+1; Bc=(bw/fs)*c; gBc=g*Bc;
nrm = 1/(csp1 + Bc); % 1/(a0 before normalization)


b0 =  (csp1 + gBc)*nrm;
b1 =  2*(1 - cs)*nrm;
b2 =  (csp1 - gBc)*nrm;

a0 =  1;
a1 =  b1;
a2 =  (csp1 - Bc)*nrm;

a = [a0 a1 a2];
b = [b0 b1 b2];

freqz(b,a,fs)