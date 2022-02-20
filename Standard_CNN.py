from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import gradient_descent_v2
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten



def CNN(x_train, y_train, x_test, y_test, kernel_size = (3,3), pool_size = (2,2), strides = (2,2)):
    input_shape = x_train.shape[1:]
    num_classes = len(y_train[0])

    model = Sequential()
    
    model.add(Conv2D(filters=32, kernel_size=kernel_size, padding='same', activation='relu', input_shape=input_shape))
    model.add(MaxPooling2D(pool_size, strides))

    model.add(Conv2D(filters=64, kernel_size=kernel_size, padding='same', activation='relu',))
    model.add(MaxPooling2D(pool_size, strides))

    model.add(Flatten())

    model.add(Dense(128, activation='relu'))
    model.add(Dense(64, activation='relu'))
    model.add(Dense(num_classes, activation='softmax'))

    model.compile(loss='categorical_crossentropy', optimizer=gradient_descent_v2.SGD(learning_rate=0.0001), metrics=['accuracy'])

    history = model.fit(x_train, y_train, epochs=10)
    loss, accuracy = model.evaluate(x_test, y_test)

    return history, loss, accuracy