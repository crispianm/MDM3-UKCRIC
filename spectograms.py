from scipy import signal
from scipy.fft import fftshift
from os.path import join
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


# Import Data
df = pd.read_csv(join("././MATLAB/ShiftedLabelsMatrixTimeDomain.csv"), header=None)


datassss = []
for i in range(12):
    data0 = df.iloc[i,3:].to_numpy()
    datassss.append(data0)

# data.append(df.iloc[1,3:].to_numpy())
data = np.concatenate(datassss)
# print(data)


# Loop through and save pngs of 7.5 sec chunks
freq, times, Sxx = signal.spectrogram(data, 64, scaling='spectrum')
plt.pcolormesh(times, freq, Sxx, shading='gouraud')
plt.set_cmap('brg')
# plt.axis('off')
plt.ylabel('Frequency [Hz]')
plt.xlabel('Time [sec]')
plt.tight_layout()
plt.savefig("./pngs/Spectogram.png", bbox_inches='tight',transparent=False)
plt.rcParams["figure.figsize"] = (20,3)
# plt.ylim([0,20])
plt.show()