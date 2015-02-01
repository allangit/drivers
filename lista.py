
def primos_pares(numero):

    lista_p=[]
    lista_i=[]

    if numero==0:

        return []
    else:

        digito=numero%10

        if digito%2==0:

            lista_p+=[digito]
            lista_i=lista_i
            return lista_p+lista_i+primos_pares(numero/10)
        else:
            lista_p=lista_p
            lista_i+=[digito]
            return lista_p+lista_i+primos_pares(numero/10)
