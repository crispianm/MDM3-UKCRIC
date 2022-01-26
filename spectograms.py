from scipy import signal
from scipy.fft import fftshift
from os.path import join
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


# Import Data
df = pd.read_csv(join("./MATLAB/LabelledMatrixTimeDomain.csv"))
# df = pd.read_csv(join("./data/accelerometer_data_section_5.csv"))


# Format Data
data = df.iloc[0:40,3:].to_numpy()


#Loop through and save pngs of 7.5 sec chunks
i = 0
for chunk in data:

    f, t, Sxx = signal.spectrogram(chunk, 64)
    plt.pcolormesh(t, f, Sxx, shading='gouraud')
    plt.axis('off')
    plt.savefig("./pngs/Spectogram %d.png" % i, bbox_inches='tight',transparent=True)
    # plt.show()
    i += 1