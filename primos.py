

def menu():

    print "ESTA ES LA BASE DE DATOS DE SOATI"
    print " LAS OPCIONES SON LAS SIGUIENTES"

    while True:

        n=int(input("digite el numero que desea"))

        if n==1:

            return menu()
        elif n==2:
            return "esta es para ver letras"
        elif n==3:
            break
        else:
            return "ninguna opcion es valida"
            




def primos(n):

    if n!=int(n):

        return "el dato que introdujo no es # "
    else:

        return primos_final(n,[])

def primos_final(n,lista):

    if n==0:
        return lista

    else:
        digito=n%10

        if digito%2==0:

            n=n/10
            lista+=[digito]

            return primos_final(n,lista)
        else:

            return primos_final(n/10,lista)



    

        
