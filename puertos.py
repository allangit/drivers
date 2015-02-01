#!/usr/bin/python
 
# Importamos la libreira de PySerial
import serial
 
# Abrimos el puerto del arduino a 9600

puertos=[]

for i in range (4):
    
    print ("el valor de es" ,i)
    puerto= serial.Serial(i)
    print puerto
    puertos.append([puerto])
    print (puertos)
    # Creamos un buble sin fin
while True:
    # leemos hasta que encontarmos el final de linea
    sArduino = puerto.readline()
    # Mostramos el valor leido y eliminamos el salto de linea del final
    print "Valor Arduino: " + sArduino.rstrip('\n')
puerto.close()
