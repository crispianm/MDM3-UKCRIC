function fd_features = frequencydomainfeatures(input_matrix)

% entire frequency domain statistics
SignalMeanFreq = [];
SignalMaxFreq = [];

for i = 1:size(input_matrix,1)
    mnf = mean(abs(input_matrix(i,:))); SignalMeanFreq(end+1) = mnf;
    maxf = max(input_matrix(i,:)); SignalMaxFreq(end+1) = maxf;
end

% Frequency Domain 8 to 16 hz.
FD_s = input_matrix(:,41:81);

SignalMeanFreq_s = [];
SignalMaxPeak_s = [];
Sum_of_peaks_s = [];
StdDev_s = [];

for i = 1:size(input_matrix,1)
    mnf_s = mean(abs(FD_s(i,:))); SignalMeanFreq_s(end+1) = mnf_s;
    maxp_s = max(FD_s(i,:)); SignalMaxPeak_s(end+1) = maxp_s;
    sum_peak = sum(maxk(FD_s(i,:),10)); Sum_of_peaks_s(end+1) = sum_peak;
    stdx_s = std(input_matrix(i,:)); StdDev_s(end+1) = stdx_s;
end

fd_features = [SignalMeanFreq',SignalMaxFreq',SignalMeanFreq_s',SignalMaxPeak_s',Sum_of_peaks_s', StdDev_s'];
