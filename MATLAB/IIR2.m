%IIR

fc1 = 800;
fc2 = 1200;
fs = 44100;


[b,a] = butter(2,[(fc1/22050) (fc2/22050)], 'bandpass');

freqz(5*b,5*a,[],fs)

subplot(2,1,1)
ylim([-100 20])