function [B,A] = booststan(g,fc,bw,fs);
%BOOST - Design a digital boost filter at given gain g, 
%        center frequency fc in Hz,
%        bandwidth bw in Hz (default = fs/10), and
%        sampling rate fs in Hz (default = 1).

    if nargin<4, fs = 1; end
    if nargin<3, bw = fs/10; end

    c = cot(pi*(fc/fs)); % bilinear transform constant
    cs = c^2;  csp1 = cs+1; Bc=(bw/fs)*c; gBc=g*Bc;
    nrm = 1/(csp1 + Bc); % 1/(a0 before normalization)
    b0 =  (csp1 + gBc)*nrm;
    b1 =  2*(1 - cs)*nrm;
	b2 =  (csp1 - gBc)*nrm;
    a0 =  1;    
    a1 =  b1;
    a2 =  (csp1 - Bc)*nrm;
    A = [a0 a1 a2];
    B = [b0 b1 b2];

    if nargout==0
        figure(1);
         freqz(B,A); % /l/mll/myfreqz.m
        dstr=sprintf('boost(%0.2f,%0.2f,%0.2f,%0.2f)',g,fc,bw,fs);
        subplot(2,1,1); title(['Boost Frequency Response: ',...
                      dstr],'fontsize',24);
    end

end
