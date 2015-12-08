### ! Remember: `%rbp` is the base pointer and `%rsp` is the stack pointer !

If you 're not familiar with assembly you 're gonna struggle here.

1.)
``` 
0x000000000040077d <+86>:    cmp    DWORD PTR [rbp-0x20],0x2    ;
0x0000000000400781 <+90>:    jle    0x40084d <main+294>         ; if(DWORD PTR [rbp-0x20] <= 2) exit() else continue()
```
2.)
```
0x00000000004007e6 <+191>:   cmp    eax,DWORD PTR [rbp-0x28]
;   <+188>:   sub    eax,0x1
;   <+185>:   mov eax,DWORD PTR [rbp-0x20] # eax = DWORD PTR [rbp-0x20]       
0x00000000004007e9 <+194>:   je     0x400816 <main+239>         
;   if(DWORD PTR [rbp-0x28] == DWORD PTR [rbp-0x20] -1) goto <main+239> else continue()
```
3.)
```
0x0000000000400800 <+217>:   cmp    eax,DWORD PTR [rbp-0x24]    ; 
0x0000000000400803 <+220>:   jge    0x400816 <main+239>         ; if(eax >= DWORD PTR [rbp-0x24] ) goto <main+239> else exit()
```
4.)
```
0x0000000000400832 <+267>:   cmp    DWORD PTR [rbp-0x28],0x0    ;
0x0000000000400836 <+271>:   jns    0x400795 <main+110>         ; if(DWORD PTR [rbp-0x28] >=0) goto <main+110> else exit()
```

### <u>Conclusion</u>

Cause of (1) we know that if numDigits(our input) is <=2 is rejected by having a look at the code before this particular instruction.
```
<+83>:    mov    DWORD PTR [rbp-0x20],eax
;   where 
<+78>:    call   0x4006ed <numDigits>
;   which means our input has been stored in DWORD PTR [rbp-0x20]
```
___
> (2) checks if counter '[rbp-0x28]' is  **equal** to `[rbp-0x20] - 1`, where `[rbp-0x20]` has beeen initialized **outside the loop** with the intial value of **numDigits** function **result**  with our input as **parameter**.
```
0x0000000000400775 <+78>:    call   0x4006ed <numDigits>
0x000000000040077a <+83>:    mov    DWORD PTR [rbp-0x20],eax
0x0000000000400787 <+96>:    mov    eax,DWORD PTR [rbp-0x20]
0x000000000040078a <+99>:    sub    eax,0x1
```
### ! [rbp-0x20] never changes after <+83> !
___
>> Usually when we have a jump backwards we have a **loop** somewhere and this is what happened in (4). In addition, we know that the loop breaks if
`[rbp-0x28]` becomes negative. If we ckeck the initial value of counter or `[rbp-0x28]` we ll find it is equal to **numDigits** result - 1 with our input as **parameter**.
```
0x0000000000400787 <+96>:    mov    eax,DWORD PTR [rbp-0x20]
0x000000000040078a <+99>:    sub    eax,0x1
0x000000000040078d <+102>:   mov    DWORD PTR [rbp-0x28],eax
```
___
>>> if (2) is false then it goes to (3) and if (3) is also false the program exits.
```
0x0000000000400814 <+237>:   jmp    0x40085c <main+309>
```
___
>>>> [rbp-0x24] and eax in (3) after excuting the following instructions.
```
;   eax
0x0000000000400750 <+41>:    call   0x4005f0 <__isoc99_scanf@plt>
0x0000000000400755 <+46>:    mov    eax,DWORD PTR [rbp-0x2c]       ; eax = our_input
...
0x00000000004007bd <+150>:   mov    eax,DWORD PTR [rbp-0x2c]       ; nothing changes
...
0x00000000004007c4 <+157>:   mov    DWORD PTR [rbp-0x18],eax       ; [rbp-0x18] = our_input
...
0x00000000004007fb <+212>:   mov    eax,DWORD PTR [rbp-0x18]       ; eax = our_input
;   DWORD PTR [rbp-0x24]
...
0x0000000000400826 <+255>:   mov    eax,DWORD PTR [rbp-0x18]       ; eax = our_input(aftermath)
0x000000000040082b <+260>:   mov    DWORD PTR [rbp-0x24],eax       ; [rbp-0x24] = our_input(aftermath)
```
Now we know that both variables in (3) are deeply linked to our input.

Lets back up a little and write what we know so far.

- 1.) `if(numDigits(our_input) <= 2) exit() else continue()`
- 2.) `for(int counter = numDigits(our_input) - 1; counter >= 0; counter--)`
- 3.) `if(our_input(aftermath) >= our_input(aftermath)) continue() else exit()`

Knowing all those stuff if you execute the program again you are most likely to crack it!

### `I know especially the 2nd crackme is badly written. When I find time I will rewrite the whole article. :(`