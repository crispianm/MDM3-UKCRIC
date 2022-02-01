function td_features = timedomainfeatures(input_matrix)
SignalMean = [];
SignalSTD = [];
SignalMin = [];
SignalMax = [];
SignalSkew = [];
SignalKurt = [];
SignalEnergy = []; % Mean of the sum of squared values in the window
SignalIQR = [];
SignalMedianAbsDev = []; % Median Absolute Deviation

 for i = 1:size(input_matrix,1)
     mn = mean(abs(input_matrix(i,:))); SignalMean(end+1) = mn;
     stdx = std(input_matrix(i,:)); SignalSTD(end+1) = stdx;
     maxx = max(input_matrix(i,:)); SignalMax(end+1) = maxx;
     minx = min(input_matrix(i,:)); SignalMin(end+1) = minx;
     kurtx = kurtosis(input_matrix(i,:)); SignalKurt(end+1) = kurtx;
     skewx = skewness(input_matrix(i,:)); SignalSkew(end+1) = skewx;
     enrgyx = sumsqr(input_matrix(i,:))/length(input_matrix(i,:)); SignalEnergy(end+1) = enrgyx;
     interqrx = iqr(input_matrix(i,:)); SignalIQR(end+1) = interqrx;
     madx = mad(input_matrix(i,:)); SignalMedianAbsDev(end+1) = madx;
 end
 
 td_features = [SignalMean' SignalSTD' SignalMax' SignalMin' SignalKurt' ...
    SignalSkew' SignalEnergy' SignalIQR' SignalMedianAbsDev'];

 