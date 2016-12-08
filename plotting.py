
## http://www.physics.nyu.edu/pine/pymanual/html/chap5/chap5_plot.html
import numpy as np
import matplotlib.pyplot as plt

isinteractive()
ion()
ioff()
draw()
plt.show()

plt.plot([1,2,3,2,3,4,3,4,5])
plt.show()

x = np.linspace(0, 4.*np.pi, 33)
y = np.sin(x)
plt.plot(x, y)
plt.show()

x = np.linspace(0, 4.*np.pi, 129)
y = np.sin(x)
plt.plot(x, y)
plt.show()

# read data from file
xdata, ydata = np.loadtxt('wavePulseData.txt', unpack=True) ## http://www.physics.nyu.edu/pine/pymanual/html/chap5/chap5_plot.html#fig-wavypulse

# create x and y arrays for theory
x = np.linspace(-10., 10., 200)
y = np.sin(x) * np.exp(-(x/5.0)**2)

# create plot
plt.figure(1, figsize = (6,4) )
plt.plot(x, y, 'b-', label='theory')
plt.plot(xdata, ydata, 'ro', label="data")
plt.xlabel('x')
plt.ylabel('transverse displacement')
plt.legend(loc='upper right')
plt.axhline(color = 'gray', zorder=-1)
plt.axvline(color = 'gray', zorder=-1)

# save plot to file
plt.savefig('WavyPulse.pdf')

# display plot on screen
plt.show()
