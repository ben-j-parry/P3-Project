close all;

load chirp

t = (0:length(y)-1)/Fs;

bhi = fir1(34,0.48,'high',chebwin(35,30));
%freqz(bhi,1)

blo = fir1(15,[0.5 0.6],'bandpass');
%freqz(blo,1); % filter freq response

outlo = filter(blo,1,signal);

%{
%subplot(2,2,1)
%plot(t,y)
%title('Original Signal')
ys = ylim;

%subplot(2,2,2)
%figure;
%plot(t,outlo)
title('Bandpass Filtered Signal')
xlabel('Time (s)')
ylim(ys)

%subplot(2,2,3)
%}

ffty = fft(y);
ffty = fftshift(ffty);

f = fs/2*linspace(-1,1,Fs);


of = freqz(y,1);
%figure;

plot(f, abs(ffty));
title('Freq Response of Original Signal')

%subplot(2,2,4)
ff = freqz(outlo,1);
%plot(ff);
title('Freq Response of Filtered Signal')

