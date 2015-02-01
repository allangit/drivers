import random
import matplotlib
import matplotlib.pyplot as plt

def rollDice():

    roll=random.randint(1,100)
    if roll==100:
        print roll, "perdio"
        return False
    elif roll <=50:
        print roll, "valor 1-50"
        return False
    elif 100 < roll >50:
        print roll,"roll correct"
        return True
    
def simple_bettor(funds, initial_wager,wager_count):

    value=funds
    wager=initial_wager
    
    wX=[]
    vY=[]
    cont=1
    while cont <= wager_count:

        if rollDice():
            value+=wager
            wX.append(cont)
            vY.append(value)
        else:
            value-=wager
            wX.append(cont)
            vY.append(value)
            
        cont+=1

    plt.plot(wX,vY)

x=0
while x < 100:
    simple_bettor(100000,100,100)
    x+=1

plt.ylabel("Account Value")
plt.xlabel("Cont value")
plt.show()

