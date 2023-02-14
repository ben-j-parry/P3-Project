noise = randn(50000,1);
x = filter(1,[1 1/2 1/3 1/4],noise);
x = x(end-4096+1:end);


a = lpc(x,5);
est_x = filter([0 -a(2:end)],1,x);

plot(1:100,x(end-100+1:end),1:100,est_x(end-100+1:end),'--')
grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate')