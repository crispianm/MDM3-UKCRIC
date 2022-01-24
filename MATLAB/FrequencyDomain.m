timeDomainData = DataMatrix;

%% Single Sided Amplitude Spectrum
Fs = 64; %Sampling Frequency
T = 1/Fs;
L = length(DataMatrix(1,4:end)); % Length of Signal 
t = (0:L-1)*T;
figure;
plot(t,DataMatrix(1,4:end))
SingleSidedAmplitudeSpectrum = [];
DiscreteFourierTransform = [];
for i = 1:size(DataMatrix,1)
    DFT = fft(DataMatrix(i,4:end));
    P2 = abs(DFT/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    SingleSidedAmplitudeSpectrum = [SingleSidedAmplitudeSpectrum; P1];
    DiscreteFourierTransform = [DiscreteFourierTransform; DFT];
end
SingleSidedAmplitudeSpectrum = [DataMatrix(:,1:3) SingleSidedAmplitudeSpectrum];
DiscreteFourierTransform = [DataMatrix(:,1:3) DiscreteFourierTransform];


figure;
f = Fs*(0:(L/2))/L;
row = 2;
plot(f,SingleSidedAmplitudeSpectrum(row, 4:end))
xlabel('f(Hz)')
ylabel('|P1(f)|')
title('Single-Sided Amplitude Spectrum') 
grid on

%% Spectral Power Density
SpectralPowerDensity = [];
for i = 1:size(DataMatrix,1)
    xdft = fft(DataMatrix(i,4:end));
    xdft = xdft(1:L/2 +1);
    psdx =(1/(Fs*L))*abs(xdft).^2;
    psdx(2:end-1) = 2*(psdx(2:end-1));
    SpectralPowerDensity = [SpectralPowerDensity;psdx];
end 

SpectralPowerDensity = [DataMatrix(:,1:3) SpectralPowerDensity];

figure;
row = 2;
freq = 0:Fs/length(DataMatrix(1,4:end)):Fs/2;
plot(freq, 10*log10(SpectralPowerDensity(row,4:end)))
grid on 
xlabel('Frequency(Hz)')
ylabel('Power / Frequency (dB/Hz)')
title('Periodogram using FFT')


writematrix(DiscreteFourierTransform, 'DiscreteFourierTransform_labelled.csv')
writematrix(SingleSidedAmplitudeSpectrum, 'SingleSidedAmplitudeSpectrum_labelled.csv')
writematrix(SpectralPowerDensity, 'SpectralPowerDensity_labelled.csv')