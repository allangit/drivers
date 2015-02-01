import matplotlib.pyplot as plt
import matplotlib.animation as animation
import time
import serial
import numpy as np
import sqlite3

x = [ ]
y = [ ]


fig=plt.figure()
rect=fig.patch
rect.set_facecolor("white")
axi=fig.add_subplot(1,1,1,axisbg="green")
def animate(i):
    readFile = open('datos.txt','r')
    sepFile = readFile.read().split( )
    print sepFile
    readFile.close()

    for plotPair in sepFile:
        xAndY = plotPair.split(',')
        x.append(int(xAndY[0]))
        y.append(int(xAndY[1]))

    axi.clear()
    plt.title("Sistema de Aire Acondicionado",color='b',fontsize=20)
    plt.xlabel("Tiempo ($\mu$s)",color='black',fontsize=20)
    plt.ylabel("Temperatura(C)",color='black',fontsize=20)
    plt.plot(x,y,color="#004a7e",linewidth=3.3,marker='o',label="FLUJO")
    plt.legend()
    
    plt.grid(True,color="r")

ani=animation.FuncAnimation(fig,animate,interval=1000)
plt.show()




