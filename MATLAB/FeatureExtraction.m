%% Feature extraction
% Time Domain
% - Mean, standard deviation median absolute deviation, min and max
% - Signal magnitude area
% - Energy measure
% - signal entropy
% - Skewness and Kurtosis
% - first derivative means and standard deviation
% - quartiles
% 
% Frequency Domain
% - Index largest magnitude of frequency component
% - Weighted average of frequency components
% - Skewness and Kurtosis of the frequency domain signal
% - RMS

%% Variables
TD = DataMatrix(:,4:end);
FD = SingleSidedAmplitudeSpectrum(:,end);
%% Time Domain
SignalMean = [];
SignalSTD = [];
SignalMin = [];
SignalMax = [];
SignalSkew = [];
SignalKurt = [];
SignalEnergy = []; % Mean of the sum of squared values in the window
SignalIQR = [];
SignalMedianAbsDev = []; % Median Absolute Deviation

 for i = 1:size(DataMatrix,1)
     mn = mean(abs(TD(i,:))); SignalMean(end+1) = mn;
     stdx = std(TD(i,:)); SignalSTD(end+1) = stdx;
     maxx = max(TD(i,:)); SignalMax(end+1) = maxx;
     minx = min(TD(i,:)); SignalMin(end+1) = minx;
     kurtx = kurtosis(TD(i,:)); SignalKurt(end+1) = kurtx;
     skewx = skewness(TD(i,:)); SignalSkew(end+1) = skewx;
     enrgyx = sumsqr(TD(i,:))/length(TD(i,:)); SignalEnergy(end+1) = enrgyx;
     interqrx = iqr(TD(i,:)); SignalIQR(end+1) = interqrx;
     madx = mad(TD(i,:)); SignalMedianAbsDev(end+1) = madx;
 end

%% Frequency Domain
SignalMeanFreq = [];
SignalMaxFreq = [];

for i = 1:size(DataMatrix,1)
    mnf = mean(abs(FD(i,:))); SignalMeanFreq(end+1) = mnf;
    maxf = max(FD(i,:)); SignalMaxFreq(end+1) = maxf;
end
 
%% Combining Time Domain and Frequency Domain 
FeaturesMatrix = [SignalMean' SignalSTD' SignalMax' SignalMin' SignalKurt' ...
    SignalSkew' SignalEnergy' SignalIQR' SignalMedianAbsDev', SignalMeanFreq', SignalMaxFreq'];

FeaturesMatrix_labelled = [DataMatrix(:,1:3) FeaturesMatrix];

%% PCA Analysis
figure;
[coeff,score,latent]= pca(FeaturesMatrix);
gscatter(score(:,1),score(:,2),DataMatrix(:,1));
xlabel('Principle Component 1')
ylabel('Principle Component 2')
title('PCA Matrix of Features')
grid on


% [idx] = kmeans(FeaturesMatrix,5);
% [~, score1, latent, tsquared, explained] = pca(FeaturesMatrix);
% testdataguess = idx;
% 
% pca1test = score1(:,1);
% pca2test = score1(:,2);


writematrix(FeaturesMatrix_labelled, 'ExtractedFeatures_labelled.csv')