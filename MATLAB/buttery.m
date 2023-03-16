load chirp

t = (0:length(y)-1)/Fs;

fc = 10000;
fs = 48000;

%[b,a] = butter(2,fc/(fs/2), 'high');
[z,p,k] = butter(2, 0.4,'high');
[z,p,k] = 

soshi = zp2sos(z,p,k);

freqz(soshi);

disp(soshi);

outhi = sosfilt(soshi,y);

figure
subplot(2,1,1)
plot(t,y)
title('Original Signal')
ys = ylim;

subplot(2,1,2)
plot(t,outhi)
title('Bandpass-Filtered Signal')
xlabel('Time (s)')
ylim(ys)



%outlo = sosfilt(soslo,y);
%freqz(b,a,[],fs)

%subplot(2,1,1)
%ylim([-100 20])