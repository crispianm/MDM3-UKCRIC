import wave
import pandas as pd
import numpy as np

RawData = pd.read_csv("./data/accelerometer_data_section_1.csv")
AccelerationData = np.array(RawData['Acceleration'])
Audio = wave.open('Acceleration.wav', 'w')
Audio.setnchannels(1)
Audio.setsampwidth(2)
Audio.setframerate(64)
for Acc in AccelerationData:
    Audio.writeframesraw(Acc)
print(Audio.getnframes())
Audio.close()
