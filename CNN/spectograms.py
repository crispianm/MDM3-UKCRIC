from scipy import signal
from scipy.fft import fftshift
from os.path import join
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


# Import Data
df = pd.read_csv(join("./sevensecwindow.csv"), header=None)
# df = pd.read_csv(join("./data/accelerometer_data_section_5.csv"))


# Format Data
data = df.iloc[:,3:].values.reshape(-1,).tolist()
data = np.array(data)

# calc max 
f, t, Sxx = signal.spectrogram(data, 64)
max_value = np.amax(Sxx)

# Loop through and save pngs of 7.5 sec chunks
data = df.iloc[0:5,3:].to_numpy()
i = 0
for chunk in data:

    chunk[0] = 1
    f, t, Sxx = signal.spectrogram(chunk, 64)
    plt.rcParams["figure.figsize"] = (5,5)
    plt.tight_layout()
    plt.set_cmap('cividis')
    plt.axis('off')
    plt.pcolormesh(t, f, Sxx, shading='gouraud')
    # plt.savefig("./pngs/dataset/Spectogram %d.png" % i, bbox_inches='tight',transparent=True)
    # print("Saving image: ", "Spectogram %d.png" % i)
    plt.show()
    i += 1