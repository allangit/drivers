#include <stdio.h>

int factorial(int i);

int main(){

	int i;
	for (i=0;i<=10;i++){

		factorial(i);
	}
}

int factorial(int i){

	if (i==0)
		return 1;
	else
		return i*factorial(i-1),


}
