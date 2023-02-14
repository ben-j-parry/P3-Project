close all;

%loads a file which sweeps from 16Hz to 20kHz in 10 secs
[audioData,fs] = audioread("C:\Users\ben-p\OneDrive\Documents\Modules\Part 3\P3 Project\mp3sweeps-1f\20kHzLin10.mp3");

t = (0:length(audioData)-1)/fs;
length(audioData)

band1f1 =  fir1(15,0.002,'low'); %filter specs
bandlf2 =  fir1(15,[0.002 0.004],'bandpass'); %filter specs
band1f = fir1(15, [0.5 0.6], 'bandpass');
%disp(sprintf('%d,',round(fir1(15,[0.5 0.6])*32768))); %from mark zwolinksi

outf = filter(band1f,1,audioData); %gain of 10, 1/0.1

subplot(2,1,1)
plot(t,audioData)
title('Original Signal')
xlabel('Time (s)')
ys = ylim;

subplot(2,1,2)

plot(t,outf)
title('Bandpass Filtered Signal')
xlabel('Time (s)')
ylim(ys) %sets the y axis to same as for the original signal

%%%%%%%%%%%%#
figure 
freqz(band1f,16,fs)
%%%%%%%%%%%%

figure
fftaudio = fft(audioData);
L = length(audioData);

P2 = abs(fftaudio/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(L/2))/L;
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")


