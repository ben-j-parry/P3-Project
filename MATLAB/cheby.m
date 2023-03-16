fc = 5000;
fs = 48000;

[b,a] = cheby1(2,10,fc/(fs/2));

freqz(b,a,[],fs)

subplot(2,1,1)
ylim([-100 20])