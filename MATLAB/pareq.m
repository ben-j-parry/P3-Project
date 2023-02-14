% Parametric Equalizer Design

Fs = 44.1e3;
N1 = 2;

G  = 5; % 5 dB
Wo = 10000/(Fs/2);
BW = 4000/(Fs/2);
[B1,A1] = designParamEQ(N1,G,Wo,BW,'Orientation','row');
BQ1 = dsp.SOSFilter('Numerator',B1,'Denominator',A1);
hfvt = fvtool(BQ1,'Fs',Fs,'Color','white');
legend(hfvt,'2nd-Order Design');