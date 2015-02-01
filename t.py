import random
import matplotlib
import matplotlib.pyplot as plt


x=[1,2,3,4,5,6,7,83]
y=[89,12,15,89,15,17,89,100]

plt.title("Sistema de Aire Acondicionado",color='b',fontsize=20)
plt.xlabel("Tiempo ($\mu$s)",color='black',fontsize=20)
plt.ylabel("Temperatura(C)",color='black',fontsize=20)
plt.plot(x,y)
plt.show()
