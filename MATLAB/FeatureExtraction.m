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
FD = SingleSidedAmplitudeSpectrum(:,4:end);
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

%% Frequency Domain 8 to 16 hz.
FD_s = FD(:,41:81);

SignalMeanFreq_s = [];
SignalMaxPeak_s = [];
Sum_of_peaks_s = [];

for i = 1:size(DataMatrix,1)
    mnf_s = mean(abs(FD_s(i,:))); SignalMeanFreq_s(end+1) = mnf_s;
    maxp_s = max(FD(i,:)); SignalMaxPeak_s(end+1) = maxp_s;
    sum_peak = sum(maxk(FD_s(i,:),10)); Sum_of_peaks_s(end+1) = sum_peak;
end
%% Combining Time Domain and Frequency Domain 
FeaturesMatrix = [SignalMean' SignalSTD' SignalMax' SignalMin' SignalKurt' ...
    SignalSkew' SignalEnergy' SignalIQR' SignalMedianAbsDev', SignalMeanFreq',...
    SignalMaxFreq',SignalMeanFreq_s',SignalMaxPeak_s',Sum_of_peaks_s'];

FeaturesMatrix_labelled = [ShiftedDataMatrix(:,1:3) FeaturesMatrix];

% %% PCA Analysis
figure;
%Y = tsne(FeaturesMatrix(:,end-2:end),'Algorithm','exact','Distance', 'chebychev');
gscatter(Y(:,1),Y(:,2),ShiftedDataMatrix(:,1));
xlabel('Principle Component 1')
ylabel('Principle Component 2')
title('PCA Matrix of Features')
grid on

% DBSCAN
%figure;
%[idx] = kmeans(FeaturesMatrix(:,end-2:end),5); 
%gscatter(Y(:,1),Y(:,2),idx)

% 2 = 0, 3 = 1, 4 = 2, 1 = 3, 5 = 4.
correct_labels = [4,1,2,5,3];
predicted_matrix = [[0:4]',zeros(5,2),];
for i = 1:5
    sum_cars = sum(idx==correct_labels(i));
    actual_sum = sum(ShiftedDataMatrix(:,1)==i-1);
    predicted_matrix(i,2) = sum_cars;
    predicted_matrix(i,3) = actual_sum;  
end
 predicted_matrix



writematrix(FeaturesMatrix_labelled, 'ExtractedFeatures_labelled.csv')