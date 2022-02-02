from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
import pandas as pd
from sklearn.model_selection import train_test_split

RawData = pd.read_csv('./MATLAB/ShiftedLabelsMatrixTimeDomain.csv', header=None)
RX = RawData.iloc[:, 3:]
Ry = RawData.iloc[:, 0]
FeaturesData = pd.read_csv('./MATLAB/ExtractedFeatures_labelled.csv', header=None)
X = FeaturesData.iloc[:, 3:]
y = FeaturesData.iloc[:, 0]  # Only use the total number of cars as label
train_X, test_X, train_y, test_y = train_test_split(X, y, test_size=0.33, random_state=1)

print(i for i in test_y[:, 1] if i == 0)

def RanForest(Data):
    clf = RandomForestClassifier(max_depth=8, random_state=0)
    '''
    Default param - 0.78767
    Bootstrap=False - 0.77691
    max_depth=6 - 0.795499
    max_depth=8 - 0.79843
    (Using 2nd col only as label) max_depth=8 - 0.80137,  max_depth=7 - 0.80528
    (Using 3rd col only as label) max_depth=8 - 0.78865,  max_depth=9 - 0.79159
    max_depth=9 - 0.796477 (col 3:9)
    '''
    clf.fit(Data[0], Data[2])
    # predict = clf.predict(test_X)
    Score = clf.score(Data[1], Data[3])
    print(Score)

def AdaBoost(Data):
    clf = AdaBoostClassifier(n_estimators=100, learning_rate=0.5)
    # Default param - 0.37769
    clf.fit(Data[0], Data[2])
    # predict = clf.predict(test_X)
    Score = clf.score(Data[1], Data[3])
    print(Score)


RanForest([train_X, test_X, train_y, test_y])
# AdaBoost([train_X, test_X, train_y, test_y])
