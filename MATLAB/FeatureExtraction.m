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
TD_direction = DirectionMatrix(:,2:end);
TD_direction_labels = DirectionMatrix(:,1);
FD_direction = AmplitudeSpectrum_DM(:,2:end);
TD = DataMatrix(:,4:end);
FD = SingleSidedAmplitudeSpectrum(:,4:end);

%% Time Domain
td_features = timedomainfeatures(TD);
td_features_DM = timedomainfeatures(TD_direction);

%% Frequency Domain features
fd_features = frequencydomainfeatures(FD);
fd_features_DM = frequencydomainfeatures(FD_direction);
%% Combining Time Domain and Frequency Domain 
FeaturesMatrix = [td_features, fd_features];
FeaturesMatrix_labelled = [ShiftedDataMatrix(:,1:3) FeaturesMatrix];

FeaturesMatrix_DM = [td_features_DM, fd_features_DM];
FeaturesMatrix_DM_labelled = [TD_direction_labels FeaturesMatrix_DM];


%% Visualisation
figure;
Y = tsne(FeaturesMatrix(:,end-4:end),'Algorithm','exact','Distance', 'cityblock');
gscatter(Y(:,1),Y(:,2),ShiftedDataMatrix(:,1));
xlabel('t-SNE 1')
ylabel('t-SNE 2')
title('t-SNE dimensionality reduction with Euclidean distance measure')
grid on

% kmeans
colors = 'grmby'; markers = '.';
figure;
rng(1)
[idx] = kmeans(FeaturesMatrix(:,end-4:end),5); 
gscatter(Y(:,1),Y(:,2),idx,colors, markers, 4);
grid on
title('K-Means clustering of after t-SNE dimensionality reduction')

correct_labels = [2,1,3,4,5];
predicted_matrix = [[0:4]',zeros(5,2),];
for i = 1:5
    sum_cars = sum(idx==correct_labels(i));
    actual_sum = sum(ShiftedDataMatrix(:,1)==i-1);
    predicted_matrix(i,2) = sum_cars;
    predicted_matrix(i,3) = actual_sum;  
end

zero_index = find(idx==2);
one_index = find(idx==1);
two_index = find(idx==3);
three_index = find(idx ==4);
four_index = find(idx==5);
guessed_labels = zeros(length(idx),1);
guessed_labels(zero_index) = 0;
guessed_labels(one_index) = 1;
guessed_labels(two_index) = 2;
guessed_labels(three_index) = 3;
guessed_labels(four_index) = 4;


%% calculating the 'true' value of each cluster
true_labels = ShiftedDataMatrix(:,1);
cluster_values_0 = sum(true_labels(zero_index))/length(zero_index);
cluster_values_1 = sum(true_labels(one_index))/length(one_index);
cluster_values_2 = sum(true_labels(two_index))/length(two_index);
cluster_values_3 = sum(true_labels(three_index))/length(three_index);
cluster_values_4 = sum(true_labels(four_index))/length(four_index);

true_cluster_values = [cluster_values_0; cluster_values_1; cluster_values_2; cluster_values_3; cluster_values_4];

%% Finding mislabelled 0s
% mislabelled_euclideans = [];
[mislabelled_2] = find_mislabelled_zeros(two_index,ShiftedDataMatrix);
[mislabelled_3] = find_mislabelled_zeros(three_index,ShiftedDataMatrix);
[mislabelled_4] = find_mislabelled_zeros(four_index,ShiftedDataMatrix);
% mislabelled_euclideans = [mislabelled_2 mislabelled_3 mislabelled_4];
mislabelled_cityblock = [mislabelled_2 mislabelled_3 mislabelled_4];

%% Removing mislabelled data
%removed_mislabelled_euclidean = FeaturesMatrix_labelled;
remove_mislabelled_cityblock = FeaturesMatrix_labelled;
remove_mislabelled_cityblock(mislabelled_cityblock,:) = [];
%removed_mislabelled_euclidean(mislabelled_euclideans,:) = [];
%writematrix(FeaturesMatrix_DM_labelled, 'ExtractedFeatures_labelled_DM.csv')
%writematrix(FeaturesMatrix_labelled, 'ExtractedFeatures_labelled.csv')
%writematrix(removed_mislabelled_euclidean,'removed_mislabelled_euclidean.csv')

writematrix(remove_mislabelled_cityblock,'removed_mislabelled_cityblock.csv')