close all;

%loads a file which sweeps from 16Hz to 20kHz in 10 secs
[audioData,fs] = audioread("C:\Users\ben-p\OneDrive\Documents\Modules\Part 3\P3 Project\code\MATLAB\mp3sweeps-1f\20kHzExp10.mp3");

t = (0:length(audioData)-1)/fs;
length(audioData)


 %from mark zwolinksi

b = fir1(31,0.5);
outf = filter(b,1,audioData); %gain of 10, 1/0.1
%disp(sprintf('%d,',round(fir1(15,[0.5])*2147483647)))

freqz(b, 1, 48000);
figure
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
%%%%%%%%%%%%

%grid
%figure
%fftaudio = fft(audioData);
%L = length(audioData);

%P2 = abs(fftaudio/L);
%P1 = P2(1:L/2+1);
%P1(2:end-1) = 2*P1(2:end-1);

%f = fs*(0:(L/2))/L;
%plot(f,P1) 
%title("Single-Sided Amplitude Spectrum of X(t)")
%xlabel("f (Hz)")
%ylabel("|P1(f)|")


