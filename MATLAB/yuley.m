close all;

%loads a file which sweeps from 16Hz to 20kHz in 10 secs
[audioData,fs] = audioread("C:\Users\ben-p\OneDrive\Documents\Modules\Part 3\P3 Project\code\MATLAB\mp3sweeps-1f\20kHzExp10.mp3");

t = (0:length(audioData)-1)/fs;
length(audioData)

f = [0 0.6 0.6 1];
m = [0 0 1 1];

%[b,a]
iirfilt = yulewalk(2,f,m);
[h,w] = freqz(b,a,128);

outf = filter(iirfilt,1,audioData);

subplot(2,1,1)
plot(t,audioData)
title('Original Signal')
xlabel('Time (s)')
ys = ylim;

subplot(2,1,2)

plot(t,outf)
title('Filtered Signal')
xlabel('Time (s)')
ylim(ys) %sets the y axis to same as for the original signal



disp(b)
disp(a)

 b_q = b * 2147483647;
 a_q = a * 2147483647;

disp(b_q)
disp(a_q)


figure
plot(w/pi,mag2db(abs(h)))
yl = ylim;
hold on
plot(f(2:3),yl,'--')
xlabel('\omega/\pi')
ylabel('Magnitude')%grid