from sklearn.cluster import KMeans
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import pandas as pd
import numpy as np
from sklearn.decomposition import NMF
import mpl_toolkits

# plt.ioff()
# plt.ion()

RawData = pd.read_csv('./MATLAB/ExtractedFeatures_labelled_DM.csv', header=None)

# print(RawData.values[:, 0:3])

Labels_len = 1
Labels = np.array(RawData.iloc[:, 0:Labels_len])
Mean = np.array(RawData.iloc[:, Labels_len+1])
STD = RawData.iloc[:, Labels_len+2]
Max = RawData.iloc[:, Labels_len+3]
Min = RawData.iloc[:, Labels_len+4]
Kurt = RawData.iloc[:, Labels_len+5]
Skew = RawData.iloc[:, Labels_len+6]
Energy = RawData.iloc[:, Labels_len+7]
IQR = RawData.iloc[:, Labels_len+8]
MedianAbsDev = RawData.iloc[:, Labels_len+9]
MeanFreq = RawData.iloc[:, Labels_len+10]
MaxFreq = RawData.iloc[:, Labels_len+11]
MinFreq = RawData.iloc[:, Labels_len+12]
MaxPeak = RawData.iloc[:, Labels_len+13]
SumOfPeak = RawData.iloc[:, Labels_len+14]

def To2DimPCA(Features, dims=2):
    pca = PCA(n_components=dims)
    return pca.fit_transform(Features)

def To2DimNMF(Features):
    nmf = NMF(n_components=2)
    return nmf.fit_transform(Features)

def k_means(label, Data, name=None, dims=2):
    train_X, test_X, train_y, test_y = train_test_split(Data, label, test_size=0.33, random_state=1)
    kmeans = KMeans(n_clusters=max(label)+1, random_state=0)
    kmeans.fit(train_X)
    labels = kmeans.labels_
    predict_labels = kmeans.predict(test_X)
    print(kmeans.score(test_X, test_y))
    if dims==2:
        plt.figure()
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
        if name!=None:
            plt.savefig('./ClusterPlot/'+name+'.png')
        # plt.close()
    plt.show()


PCA_axis = To2DimPCA(RawData.iloc[:, 3:], 3)
fig = plt.figure()
ax = fig.add_subplot(1, 2, 1, projection='3d')
mpl_toolkits.mplot3d.Axes3D.scatter(ax, PCA_axis[:, 0], PCA_axis[:, 1], PCA_axis[:, 2], c=RawData.iloc[:, 0].astype(float))
kmeans = KMeans(n_clusters=2, random_state=0)
kmeans.fit(PCA_axis)
labels = kmeans.labels_
ax1 = fig.add_subplot(1, 2, 2, projection='3d')
scatter = mpl_toolkits.mplot3d.Axes3D.scatter(ax1, PCA_axis[:, 0], PCA_axis[:, 1], PCA_axis[:, 2], c=labels.astype(float))
plt.legend(*scatter.legend_elements())
plt.show()


# NMF_axis = To2DimNMF(RawData.iloc[:, 3:])
# plt.figure()
# plt.scatter(NMF_axis[:, 0], NMF_axis[:, 1], c=RawData.iloc[:, 0].astype(float))
# plt.show()
# print(Mean.shape, STD.shape, np.concatenate((Mean, STD), axis=0).shape)
# print(np.stack((Kurt, Skew)).reshape(2, -1).shape)

# k_means(RawData.iloc[:, 0], PCA_axis)  # K means using PCA axis

# Features = [Mean, STD, Max, Min, Kurt, Skew, Energy, IQR, MedianAbsDev,
#             MeanFreq, MaxFreq, MinFreq, MaxPeak, SumOfPeak]
# for i in range(3, 17):
#     for j in range(3, 17):
#         if i != j:
#             Var = pd.concat([RawData.iloc[:, i], RawData.iloc[:, j]], axis=1).to_numpy()
#             k_means(RawData.iloc[:, 0], Var, str(i)+'_'+str(j))

# Var = pd.concat([Kurt, Skew], axis=1).to_numpy()
# k_means(RawData.iloc[:, 0], Var[:])
