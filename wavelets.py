from scipy import signal
from scipy.fft import fftshift
from os.path import join
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


# Import Data
df = pd.read_csv(join("./MATLAB/LabelledMatrixTimeDomain.csv"), header=None)

# Format Data
data = df.iloc[0:20,3:].to_numpy()


# # # Loop through and save pngs of 7.5 sec chunks
# i = 1
# for row in data:
#     freq, times, Sxx = signal.cwt(row, 64)
#     plt.pcolormesh(times, freq, Sxx, shading='gouraud')
#     # plt.axis('off')
#     plt.ylabel('Frequency [Hz]')
#     plt.xlabel('Time [sec]')
#     plt.tight_layout()
#     plt.savefig("./pngs/Spectogram %d.png" % i, bbox_inches='tight',transparent=False)
#     # plt.show()
#     i += 1

sig  = data[0]
widths = np.arange(1, 31)
cwtmatr = signal.cwt(sig, signal.ricker, widths)
plt.imshow(cwtmatr, extent=[-1, 1, 1, 31], cmap='RdBu', aspect='auto',
           vmax=abs(cwtmatr).max(), vmin=-abs(cwtmatr).max())
plt.show()