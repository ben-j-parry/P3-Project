clear all;
f = [0 0.4 0.4 1];
m = [0 0 1 1];

[b,a] = yulewalk(2,f,m);
[h,w] = freqz(b,a,128);

disp(b)
disp(a)

b = b*536870912;
a = a*536870912;

fprintf('\n')
fprintf('%.0f\n',b)
fprintf('%.0f\n',a)
fprintf('\n')

b_hex = dec2hex(fix(b),8);
a_hex = dec2hex(fix(a),8);

disp(b_hex)
disp(a_hex)

%fprintf('%c',b_hex)
%fprintf('%c',a_hex)


plot(w/pi,mag2db(abs(h)))
yl = ylim;
hold on
plot(f(2:3),yl,'--')
xlabel('\omega/\pi')
ylabel('Magnitude')
grid