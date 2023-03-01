%       IIR Biquad Coefficient Calculator for Preset FPGA Values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Need to coefficients to fixed point values
%
close all;

%loads a file which sweeps from 16Hz to 20kHz in 10 secs
[audioData,fs] = audioread("C:\Users\ben-p\OneDrive\Documents\Modules\Part 3\P3 Project\code\MATLAB\mp3sweeps-1f\20kHzExp10.mp3");

t = (0:length(audioData)-1)/fs;
%fs = 44.1kHz

fs = 44100;
G = 10;
f0 = 10000;
BW = 10;

biquad = dsp.BiquadFilter;
biquad.structure = 'Direct Form 1';

%%%% Peaking Parametric Equaliser Filter
A = 10^(G/20);
omega0 = 2*pi*(f0/fs);
alpha = sin(omega0)*sinh((log(2)/2)*BW*(omega0/sin(omega0)));
a0 = 1 + alpha;

b0 = (1+alpha*A);
b1 = (-2*cos(omega0));
b2 = (1 + alpha);


a1 = (-2*cos(omega0));
a2 = (1 - alpha);

%a0 = 1;



%%%% Filter Response
b = [b0 b1 b2];
a = [a0 a1 a];
%freqz(a,b,[])

 %y = filter(b,a,audioData);


subplot(2,1,1)
plot(t,audioData)
title('Original Signal')
xlabel('Time (s)')
%y = ylim;

subplot(2,1,2)

plot(t,y)
title('Parametric Equaliser Filtered Signal')
xlabel('Time (s)')
%ylim([-3 3]);
xlim([0 10]);
%ylim(y) %sets the y axis to same as for the original signal