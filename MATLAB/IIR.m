close all;

%loads a file which sweeps from 16Hz to 20kHz in 10 secs
[audioData,fs] = audioread("C:\Users\ben-p\OneDrive\Documents\Modules\Part 3\P3 Project\mp3sweeps-1f\20kHzExp10.mp3");


t = (0:length(audioData)-1)/fs;
%fs = 44.1kHz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Octave Bands                    %
%                                                       %
%31.5Hz 63Hz 125Hz 250Hz 500Hz 1kHz 2kHz 4kHz 8kHz 16kHz%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
fig = figure;
sld = uislider(fig,'Value',50);

sld.Limits = [0 2];
sld.Value = 1;
sld.Orientation = 'vertical';
%}

bpf1 = fir1(15,[0.5 0.6],'bandpass'); %filter specs
%disp(sprintf('%d,',round(fir1(15,[0.5 0.6])*32768))) from mark zwolinksi

outf = filtfilt(bpf1,1,audioData);
%outf = filter(bpf,1,audioData); % filter y

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

%%%%%%%%%%%%
%figure 
%freqz(bpf,1)
%%%%%%%%%%%%

figure
ffty = fft(audioData);
ffty = fftshift(ffty);

f = 0:(fs/(length(ffty)-1)):fs;
plot(f, abs(ffty));

