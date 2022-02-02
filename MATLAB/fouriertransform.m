function [AmpSpectrum, DiscreteFourierTransform] = fouriertransform(input_matrix)
Fs = 64; %Sampling Frequency
T = 1/Fs;
L = length(input_matrix(1,4:end)); % Length of Signal 
t = (0:L-1)*T;
AmpSpectrum = [];
DiscreteFourierTransform = [];
for i = 1:size(input_matrix,1)
    DFT = fft(input_matrix(i,4:end));
    P2 = abs(DFT/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    AmpSpectrum = [AmpSpectrum; P1];
    DiscreteFourierTransform = [DiscreteFourierTransform; DFT];
end
AmpSpectrum = [input_matrix(:,1:3) AmpSpectrum];
DiscreteFourierTransform = [input_matrix(:,1:3) DiscreteFourierTransform];