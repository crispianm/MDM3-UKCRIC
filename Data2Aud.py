import wave
import pandas as pd
import numpy as np
from SmoothData import Normalisation
from scipy.io.wavfile import write

def WriteAudio(file, framerate, data, channel=1):
    Audio = wave.open(file, 'w')
    Audio.setnchannels(channel)
    Audio.setsampwidth(1)
    Audio.setnframes(len(data))
    Audio.setframerate(framerate)
    for Acc in data:
        Audio.writeframesraw(Acc)
    print(Audio.getnframes())
    Audio.close()


# RawData = pd.read_csv("./MATLAB/LabelledMatrixTimeDomain.csv")
RawData = pd.read_csv("./data/accelerometer_data_section_1.csv")
# AccelerationData = RawData()
AccelerationData = Normalisation(np.array(RawData['Acceleration']))
write('./Audio/Acceleration_scipy.wav', 441, AccelerationData)
# WriteAudio('./Audio/Acceleration_N_R.wav', 440, AccelerationData)
