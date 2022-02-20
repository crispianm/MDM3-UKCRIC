# from keras.models import Sequential
# from keras.layers import Dense
# from keras.optimizers import gradient_descent_v2
# from keras.layers import Conv2D
# from keras.layers import MaxPooling2D
# from keras.layers import Flatten

# from keras.datasets import fashion_mnist
# from keras.utils.np_utils import to_categorical
# import numpy as np
# from Standard_CNN import CNN

import imageio
import glob

images = []

for im_path in glob.glob("./pngs/*.png"):
     im = imageio.imread(im_path)
     images.append(im)
     # do whatever with the image here



# (x_train, y_train), (x_test, y_test) = fashion_mnist.load_data()

# print(x_train.shape)

# y_train_categorical = to_categorical(y_train)
# y_test_categorical = to_categorical(y_test)
# num_classes = len(np.unique(y_train))
# height = x_train.shape[1]
# width = x_train.shape[2]
# channels = 1
# x_train_cnn = x_train.reshape(x_train.shape[0], height, width, channels)
# x_test_cnn = x_test.reshape(x_test.shape[0], height, width, channels)

# #CNN(x_train_cnn, y_train_categorical)

