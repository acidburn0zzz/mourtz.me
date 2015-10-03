We know for sure that the program in order to validate our 'key' is going to compare it with a list of accepted keys or something, so lets look the assembly for cmp('compare') instructions.


```shell  
0x000000000040061d <+48>:    cmp    eax,0x188
```

The code above code compares a variable stored at eax with 0x188.
0x188 is a hexadecimal number, converting to decimal gives 392.
We execute the program and give 392 as input and voilà! We have found the password.
