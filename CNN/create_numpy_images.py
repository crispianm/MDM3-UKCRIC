import glob
import numpy as np
from matplotlib import image

images = []
image_paths = []

for im_path in glob.glob("./pngs/dataset/*.png"):
    image_paths.append(im_path)

for i in range(1,2063,1):
    im = image.imread(image_paths[i])
    images.append(im)

print('appended images')
images = np.array(images)
print('created array')
np.save("./pngs/dataset/images.npy", images)
print('saved array')