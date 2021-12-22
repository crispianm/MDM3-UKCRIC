import numpy as np
import math
from sklearn.metrics import classification_report
from sklearn.preprocessing import normalize
import tensorflow as tf
from mlxtend.plotting import plot_confusion_matrix
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt

## CNN parameters

segment_size = 200
num_input_channels = 3

num_training_iterations = 5001
batch_size = 200

l2_reg = 5e-4
learning_rate = 5e-4
dropout_rate = 0.15
eval_iter = 1000

n_filters = 196
filters_size = 12
n_hidden = 1024
n_classes = 6


def weight_variable(shape, stddev):
    initial = tf.random.truncated_normal(shape, stddev=stddev)
    return tf.Variable(initial)


def bias_variable(shape):
    initial = tf.constant(0.01, shape=shape)
    return tf.Variable(initial)


def conv1d(x, W):
    return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')


def max_pool_1x4(x):
    return tf.nn.max_pool2d(x, ksize=[1, 1, 4, 1], strides=[1, 1, 4, 1], padding='SAME')


def norm(x):
    temp = x.T - np.mean(x.T, axis=0)
    # x = x / np.std(x, axis = 1)
    return temp.T


## Loading the dataset

print('Loading WISDM dataset...')

# Reading training data

fx = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_x_" + str(segment_size) + ".csv")
fy = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_y_" + str(segment_size) + ".csv")
fz = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_z_" + str(segment_size) + ".csv")
ff = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/basic_features_" + str(segment_size) + ".csv")

data_x = np.loadtxt(fname=fx, delimiter=',')
data_y = np.loadtxt(fname=fy, delimiter=',')
data_z = np.loadtxt(fname=fz, delimiter=',')
features = np.loadtxt(fname=ff, delimiter=',')

fx.close()
fy.close()
fz.close()
ff.close()
data_train = np.hstack((data_x, data_y, data_z))

# Reading test data

fx = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_x_test_" + str(segment_size) + ".csv")
fy = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_y_test_" + str(segment_size) + ".csv")
fz = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/data_z_test_" + str(segment_size) + ".csv")
ff = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/basic_features_test_" + str(segment_size) + ".csv")

data_x = np.loadtxt(fname=fx, delimiter=',')
data_y = np.loadtxt(fname=fy, delimiter=',')
data_z = np.loadtxt(fname=fz, delimiter=',')
features_test = np.loadtxt(fname=ff, delimiter=',')

fx.close()
fy.close()
fz.close()
ff.close()
data_test = np.hstack((data_x, data_y, data_z))

# Reading training labels

fa = open("C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/answers_vectors_" + str(segment_size) + ".csv")
labels_train = np.loadtxt(fname=fa, delimiter=',')
fa.close()

# Reading test labels

fa = open(
    "C:/Users/finnm/Desktop/Uni/Modelling/Activity Recognition/answers_vectors_test_" + str(segment_size) + ".csv")
labels_test = np.loadtxt(fname=fa, delimiter=',')
fa.close()

features = features - np.mean(features, axis=0)
features = features / np.std(features, axis=0)

features_test = features_test - np.mean(features_test, axis=0)
features_test = features_test / np.std(features_test, axis=0)

for i in range(num_input_channels):
    x = data_train[:, i * segment_size: (i + 1) * segment_size]
    data_train[:, i * segment_size: (i + 1) * segment_size] = norm(x)
    x = data_test[:, i * segment_size: (i + 1) * segment_size]
    data_test[:, i * segment_size: (i + 1) * segment_size] = norm(x)

train_size = data_train.shape[0]
test_size = data_test.shape[0]
num_features = features.shape[1]

data_test = np.reshape(data_test, [data_test.shape[0], segment_size * num_input_channels])
labels_test = np.reshape(labels_test, [labels_test.shape[0], n_classes])
features_test = np.reshape(features_test, [features_test.shape[0], num_features])
labels_test_unary = np.argmax(labels_test, axis=1)

print("Dataset was uploaded\n")

## creating CNN

print("Creating CNN architecture\n")

# Convolutional and Pooling layers

W_conv1 = weight_variable([1, filters_size, num_input_channels, n_filters], stddev=0.01)
b_conv1 = bias_variable([n_filters])

x = tf.compat.v1.placeholder(tf.float32, [None, segment_size * num_input_channels])
x_image = tf.reshape(x, [-1, 1, segment_size, num_input_channels])

h_conv1 = tf.nn.relu(conv1d(x_image, W_conv1) + b_conv1)
h_pool1 = max_pool_1x4(h_conv1)

# Augmenting data with statistical features

flat_size = int(math.ceil(float(segment_size) / 4)) * n_filters

h_feat = tf.compat.v1.placeholder(tf.float32, [None, num_features])
h_flat = tf.reshape(h_pool1, [-1, flat_size])

h_hidden = tf.concat([h_flat, h_feat], 1)
flat_size += num_features

# Fully connected layer with Dropout

W_fc1 = weight_variable([flat_size, n_hidden], stddev=0.01)
b_fc1 = bias_variable([n_hidden])

h_fc1 = tf.nn.relu(tf.matmul(h_hidden, W_fc1) + b_fc1)

keep_prob = tf.compat.v1.placeholder(tf.float32)
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

# Softmax layer

W_softmax = weight_variable([n_hidden, n_classes], stddev=0.01)
b_softmax = bias_variable([n_classes])

y_conv = tf.nn.softmax(tf.matmul(h_fc1_drop, W_softmax) + b_softmax)
y_ = tf.compat.v1.placeholder(tf.float32, [None, n_classes])

# Cross entropy loss function and L2 regularization term

cross_entropy = -tf.reduce_sum(y_ * tf.log(tf.clip_by_value(y_conv, 1e-10, 1.0)))
cross_entropy += l2_reg * (tf.nn.l2_loss(W_fc1) + tf.nn.l2_loss(b_fc1))

# Training step

train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy)

correct_prediction = tf.equal(tf.argmax(y_conv, 1), tf.argmax(y_, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

# Run Tensorflow session

sess = tf.Session()
sess.run(tf.initialize_all_variables())

# Train CNN
print("Training CNN... ")

max_accuracy = 0.0

for i in range(num_training_iterations):

    print('step', i)

    idx_train = np.random.randint(0, train_size, batch_size)

    xt = np.reshape(data_train[idx_train], [batch_size, segment_size * num_input_channels])
    yt = np.reshape(labels_train[idx_train], [batch_size, n_classes])
    ft = np.reshape(features[idx_train], [batch_size, num_features])

    sess.run(train_step, feed_dict={x: xt, y_: yt, h_feat: ft, keep_prob: dropout_rate})

    if i % eval_iter == 0:

        train_accuracy, train_entropy, y_pred = sess.run([accuracy, cross_entropy, y_conv],
                                                         feed_dict={x: data_test, y_: labels_test,
                                                                    h_feat: features_test, keep_prob: 1})

        print("step %d, entropy %g" % (i, train_entropy))
        print("step %d, max accuracy %g, accuracy %g" % (i, max_accuracy, train_accuracy))
        print(classification_report(labels_test_unary, np.argmax(y_pred, axis=1), digits=4))

        if max_accuracy < train_accuracy:
            max_accuracy = train_accuracy

        predictions = []
        for n in y_pred:
            newnums = []
            for num in n:
                new = round(num)
                newnums.append(new)
            predictions.append(newnums)
        predictions = np.reshape(predictions, [labels_test.shape[0], n_classes])

        confmatrix = confusion_matrix(labels_test.argmax(axis=1), predictions.argmax(axis=1))
        class_labels = ['Jogging', 'Walking', 'Upstairs', 'Downstairs', 'Sitting', 'Standing']
        display = plot_confusion_matrix(conf_mat=confmatrix, class_names=class_labels, show_normed=True)
        plt.show()

plt.show()