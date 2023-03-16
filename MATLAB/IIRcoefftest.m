%USE Filter Builder to create IIR coefficients 

b = [ 0.387829472408749265088800939338398166001 -0.775658944817498530177601878676796332002  0.387829472408749265088800939338398166001];  %numerator  
a = [1 -0.405521880452037963848965773649979382753  0.335085418452432448610522897070040926337]; %denominator

a =  a*2147483647;
b =  b*2147483647;

fprintf('%i\n', a);

fprintf('%i\n', b);

freqz(a,b,[])
%ax = findall(gcf, 'Type', 'axes');
%set(ax, 'XLim', [0.005 1]);