/*
 * The input must satisfy the following condition: The sequence of bytes increase monotonically.
 */

#include <stdio.h>
#include <math.h>
#include <limits.h>

int numDigits(int number)
{
    int digits = 0;
    while (number) {
        number /= 10;
        digits++;
    }
    return digits;
}

int main(){

    //user's input
    int input;

    //ask for input
    printf("\n\n Enter Key: ");
    scanf("%d", &input);

    // exit if input is a negative number or above the maximum integers value
    if(input < 0 || input > INT_MAX){
        printf("Bad input detected! Terminating the program...\n");
        return 1;
    }

    // number of digits
    // int digits = input > 0 ? log10 (input) + 1 : -1;
    int digits = numDigits(input);

    if(digits >= 3){

        int i;
        int qq;
        for(i=digits - 1; i >=0 ; i--){
            int y = pow(10, i);
            int z = input/y;
            int x2 = input / (y * 10);

            if(i != digits - 1 && z - x2*10 < qq){
                printf("lose!\n");
                return 1;
            }

            qq = z - x2*10;
        }

        printf("win!\n");
        return 0;
    } else {

        printf("lose!\n");
        return 1;
    }
}
