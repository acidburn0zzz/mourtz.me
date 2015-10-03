/*
 * Only accepted key is 392
 */

#include <stdio.h>

int main(){

    //user's input
    int input;

    //ask for input
    printf("\n\n Enter Key: ");
    scanf("%d", &input);

    if(input == 392){
        printf("win!\n");
        return 0;
    } else {
        printf("lose!\n");
        return 1;
    }
}
