from sklearn.cluster import KMeans
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import pandas as pd
import numpy as np
from sklearn.decomposition import NMF

plt.ioff()

RawData = pd.read_csv('./MATLAB/ShiftedLabelsMatrixTimeDomain.csv', header=None)

# print(RawData.values[:, 0:3])

Labels = np.array(RawData.iloc[:, 0:3])
Mean = np.array(RawData.iloc[:, 3])
STD = RawData.iloc[:, 4]
Max = RawData.iloc[:, 5]
Min = RawData.iloc[:, 6]
Kurt = RawData.iloc[:, 7]
Skew = RawData.iloc[:, 8]
Energy = RawData.iloc[:, 9]
IQR = RawData.iloc[:, 10]
MedianAbsDev = RawData.iloc[:, 11]
MeanFreq = RawData.iloc[:, 12]
MaxFreq = RawData.iloc[:, 13]
MinFreq = RawData.iloc[:, 14]
MaxPeak = RawData.iloc[:, 15]
SumOfPeak = RawData.iloc[:, 16]

def To2DimPCA(Features):
    pca = PCA(n_components=2)
    return pca.fit_transform(Features)

def To2DimNMF(Features):
    nmf = NMF(n_components=2)
    return nmf.fit_transform(Features)

def k_means(label, Data, name=None):
    train_X, test_X, train_y, test_y = train_test_split(Data, label, test_size=0.33, random_state=1)
    kmeans = KMeans(n_clusters=max(label)+1, random_state=0)
    kmeans.fit(train_X)
    labels = kmeans.labels_
    predict_labels = kmeans.predict(test_X)
    print(kmeans.score(test_X, test_y))
    # plt.figure()
    plt.subplot(131)
    plt.title('fit')
    plt.scatter(train_X[:, 0], train_X[:, 1], c=labels.astype(float), edgecolor="k")
    plt.subplot(132)
    plt.title('predict')
    plt.scatter(test_X[:, 0], test_X[:, 1], c=predict_labels.astype(float), edgecolor="k")
    plt.subplot(133)
    plt.title('ground truth')
    scatter = plt.scatter(Data[:, 0], Data[:, 1], c=label.astype(float), edgecolor="k")
    plt.legend(*scatter.legend_elements())
    plt.savefig('./ClusterPlot/'+name+'.png')
    plt.close()
    # plt.show()


# PCA_axis = To2DimPCA(RawData.iloc[:, 3:])
NMF_axis = To2DimNMF(RawData.iloc[:, 3:])
plt.figure()
plt.scatter(NMF_axis[:, 0], NMF_axis[:, 1], c=RawData.iloc[:, 0].astype(float))
plt.show()
# print(Mean.shape, STD.shape, np.concatenate((Mean, STD), axis=0).shape)
# print(np.stack((Kurt, Skew)).reshape(2, -1).shape)
# k_means(RawData.iloc[:, 0], PCA_axis)  # K means using PCA axis
# print([RawData.iloc[:, 3], RawData.iloc[:,4]])

# Features = [Mean, STD, Max, Min, Kurt, Skew, Energy, IQR, MedianAbsDev,
#             MeanFreq, MaxFreq, MinFreq, MaxPeak, SumOfPeak]
# for i in range(3, 17):
#     for j in range(3, 17):
#         if i != j:
#             Var = pd.concat([RawData.iloc[:, i], RawData.iloc[:, j]], axis=1).to_numpy()
#             k_means(RawData.iloc[:, 0], Var, str(i)+'_'+str(j))

Var = pd.concat([Kurt, Skew], axis=1).to_numpy()
k_means(RawData.iloc[:, 0], Var[:])
