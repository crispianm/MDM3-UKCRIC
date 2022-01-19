from scipy import signal
from scipy.fft import fftshift
from os.path import join
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

rng = np.random.default_rng()
# Import Data and format
df = pd.read_csv(join("./data/accelerometer_data_section_1.csv"))
df['Timestamp'] = pd.to_datetime(df['Timestamp'], infer_datetime_format=True)
# df['Timestamp'] = range(len(df['Timestamp']))

# SPlit into chunks of 3seconds
x = df['Acceleration'].to_numpy()
def split_dataframe(df, chunk_size = 100): 
    chunks = list()
    num_chunks = len(df) // chunk_size + 1
    for i in range(num_chunks):
        chunks.append(df[i*chunk_size:(i+1)*chunk_size])
    return chunks

x = split_dataframe(x, chunk_size=480)
seconds = 3
fs = 64

number = fs * seconds
# N = 1e5
# amp = 2 * np.sqrt(2)
# noise_power = 0.01 * fs / 2
# time = np.arange(N) / float(fs)
# mod = 500*np.cos(2*np.pi*0.25*time)
# carrier = amp * np.sin(2*np.pi*3e3*time + mod)
# noise = rng.normal(scale=np.sqrt(noise_power), size=time.shape)
# noise *= np.exp(-time/5)
# x = carrier + noise

#Look through and save pngs of 3 sec chunks

# x = np.array_split(x, 10000)

i = 0
for chunk in x:

    f, t, Sxx = signal.spectrogram(chunk, 64)
    plt.pcolormesh(t, f, Sxx, shading='gouraud')
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.savefig("./pngs/Spectogram %d.png" % i)
    # plt.show()

    i += 1