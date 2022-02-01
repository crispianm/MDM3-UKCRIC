from surfboard.sound import Waveform
from surfboard.feature_extraction import extract_features

sound = Waveform(path='./Audio/Acceleration_scipy.wav')

# Option 1: Extract MFCC and RMS energy components as time series.
# component_dataframe = extract_features([sound], ['mfcc', 'rms'])
# for i in component_dataframe['mfcc'].values:
#     print(i)
# component_dataframe.to_csv('./Audio/component_dataframe.csv', sep='\n', index=False)
# # Option 2: Extract the mean and standard deviation of the MFCC and RMS energy features over time.
feature_dataframe = extract_features([sound], ['mfcc', 'rms'], ['mean', 'std'])


#
#
# feature_dataframe.to_csv('./Audio/feature_dataframe.csv')
# print(component_dataframe)
# print(feature_dataframe)