# DIP problem3 Filtering in frequency domain
# Geyunhao (116020910017)

import cv2
import numpy as np
import scipy
import matplotlib.pyplot as plt

img = cv2.imread('./fig/characters_test_pattern.tif',0)
f = np.fft.fft2(img)# 2-dimension ff
fshift = np.fft.fftshift(f) # move the DC to center
#取绝对值：将复数变化成实数
#取对数的目的为了将数据变化到0-255
s1 = np.log(np.abs(fshift))

# D0 = 5
# D0 = 20
# D0 = 40
# D0 = 100
D0 = 200
plt.subplot(131),plt.imshow(img,'gray'),plt.title('original')
plt.xticks([]), plt.yticks([])

# ideal high pass filter

rows, cols = img.shape
mask = np.ones(img.shape, np.uint8)
mask[int(rows/2-30):int(rows/2+30),int(cols/2-30):int(cols/2+30)] = 0 # directly set o in center area
f1shift = fshift*mask
f2shift = np.fft.ifftshift(f1shift) #对新的进行逆变换
img_new = np.fft.ifft2(f2shift)
#出来的是复数，无法显示
img_new = np.abs(img_new)
#调整大小范围便于显示
img_new = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))
plt.subplot(132),plt.imshow(img_new,'gray'),plt.title('Highpass D0='+str(D0))
plt.xticks([]),plt.yticks([])

# ideal low pass filter(D0 = 30)

mask2 = np.zeros(img.shape, np.uint8)
mask2[int(rows/2-30):int(rows/2+30),int(cols/2-30):int(cols/2+30)] = 1 # directly set o in center area
f3shift = fshift*mask
f4shift = np.fft.ifftshift(f3shift) #对新的进行逆变换
img_new2 = np.fft.ifft2(f4shift)
#出来的是复数，无法显示
img_new2 = np.abs(img_new2)
#调整大小范围便于显示
img_new2 = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))
plt.subplot(133),plt.imshow(img_new2,'gray'),plt.title('lowpass D0='+str(D0))
plt.xticks([]),plt.yticks([]),plt.savefig('output/ideal lowandhigh pass D0='+str(D0))

# butter worth low filter(1-level) H(u,v)= 1/[1+[D(u,v)/D0]^2]; D0 = 30
mask =np.zeros(img.shape)
rows, cols = img.shape
for i in range (rows):
    for j in range (cols):
        D_uv = float(np.sqrt(np.square(i-rows/2)+np.square(j-cols/2)))
        mask [i,j] = float(1.0/(1.0+np.square(D_uv/D0)))
f_blshift = fshift*mask
f_blshift = np.fft.ifftshift(f_blshift) #对新的进行逆变换
img_new = np.fft.ifft2(f_blshift)
#出来的是复数，无法显示
img_new = np.abs(img_new)
#调整大小范围便于显示
img_new = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))
plt.subplot(131),plt.imshow(img,'gray'),plt.title('original')
plt.xticks([]),plt.yticks([])
plt.subplot(132),plt.imshow(img_new,'gray'),plt.title('BLPF D0='+str(D0))
plt.xticks([]),plt.yticks([])

# butter worth high filter(1-level)

mask =np.zeros(img.shape)
rows, cols = img.shape
for i in range (rows):
    for j in range (cols):
        D_uv = float(np.sqrt(np.square(i-rows/2)+np.square(j-cols/2)))
        mask [i,j] = 1.0-float(1.0/(1.0+np.square(D_uv/D0)))
f_bhshift = fshift*mask
f_bhshift = np.fft.ifftshift(f_bhshift) #对新的进行逆变换
img_new = np.fft.ifft2(f_bhshift)
#出来的是复数，无法显示
img_new = np.abs(img_new)
#调整大小范围便于显示
img_new = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))

plt.subplot(133),plt.imshow(img_new,'gray'),plt.title('BHPF D0='+str(D0))
plt.xticks([]),plt.yticks([]),plt.savefig('output/Butterwolf lowandhigh pass D0='+str(D0))

# Gauss low filter(1-level) H(u,v)= np.exp(-D^2（u，v）/2sigma^2); D0 = 30
mask =np.zeros(img.shape)
rows, cols = img.shape
for i in range (rows):
    for j in range (cols):
        D_uv = float(np.sqrt(np.square(i-rows/2)+np.square(j-cols/2)))
        mask [i,j] = np.exp(-np.square(D_uv)/(2*np.square(D0)))
f_glshift = fshift*mask
f_glshift = np.fft.ifftshift(f_glshift) #对新的进行逆变换
img_new = np.fft.ifft2(f_glshift)
img_new = np.abs(img_new)
img_new = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))
plt.subplot(131),plt.imshow(img,'gray'),plt.title('original')
plt.xticks([]),plt.yticks([])
plt.subplot(132),plt.imshow(img_new,'gray'),plt.title('GLPF D0='+str(D0))
plt.xticks([]),plt.yticks([])

# butter worth high filter(1-level)

mask =np.zeros(img.shape)
rows, cols = img.shape
for i in range (rows):
    for j in range (cols):
        D_uv = float(np.sqrt(np.square(i-rows/2)+np.square(j-cols/2)))
        mask[i, j] = 1.0-np.exp(-np.square(D_uv) / 2 * np.square(D0))
f_ghshift = fshift*mask
f_ghshift = np.fft.ifftshift(f_ghshift) #对新的进行逆变换
img_new = np.fft.ifft2(f_ghshift)
#出来的是复数，无法显示
img_new = np.abs(img_new)
#调整大小范围便于显示
img_new = (img_new-np.amin(img_new))/(np.amax(img_new)-np.amin(img_new))

plt.subplot(133),plt.imshow(img_new,'gray'),plt.title('GHPF D0='+str(D0))
plt.xticks([]),plt.yticks([]),plt.savefig('output/Gauss lowandhigh pass D0='+str(D0))

