<h3> Console HackTheBox </h3>

### Binary Exploitation

### Basic File Checks

![image](https://user-images.githubusercontent.com/113513376/222837497-6171ddb0-b16b-48b4-8843-59ed5bab5e4f.png)

We're working with a x64 binary and all protections are disabled except NX which is No Execute generally it prevents shellcode injection to the stack and exection of the shellcode

I'll run it to know what it does
![image](https://user-images.githubusercontent.com/113513376/222837692-9c2975bf-d086-4188-8125-d611e211e0d8.png)

Nothing really interesting yet so i'll decompile the binary using ghidra

Take note that since this binary is a stripped binary we won't see function names

Looking at the entry function is the best way to get to the main function
![image](https://user-images.githubusercontent.com/113513376/222838986-8913003e-04aa-4f27-b36d-49b28d554d9c.png)

Now i'll click on the function that __libc_start_main is calling `FUN_00401397`

Here's now the main function
![image](https://user-images.githubusercontent.com/113513376/222839649-a3ea3b2b-a7c2-4398-aed8-7836cd73f0d8.png)

```
void FUN_00401397(void)

{
  char input [16];
  
  FUN_00401196();
  puts("Welcome HTB Console Version 0.1 Beta.");
  do {
    printf(">> ");
    fgets(input,16,stdin);
    program(input);
    memset(input,0,16);
  } while( true );
}
```

We can tell what it does:

```
1. It justs reads 16 bytes of our input to stdin 
2. Then it calls the other function called program (Note: I already renamed some variables in this function and i also did rename the function)
```

Here's the decompiled program() function
![image](https://user-images.githubusercontent.com/113513376/222847808-7810d594-52c0-4915-8dc1-ac7395c7309c.png)

```
void program(char *param_1)

{
  int compare;
  char buffer [16];
  
  compare = strcmp(param_1,"id\n");
  if (compare == 0) {
    puts("guest(1337) guest(1337) HTB(31337)");
  }
  else {
    compare = strcmp(param_1,"dir\n");
    if (compare == 0) {
      puts("/home/HTB");
    }
    else {
      compare = strcmp(param_1,"flag\n");
      if (compare == 0) {
        printf("Enter flag: ");
        fgets(buffer,48,stdin);
        puts("Whoops, wrong flag!");
      }
      else {
        compare = strcmp(param_1,"hof\n");
        if (compare == 0) {
          puts("Register yourself for HTB Hall of Fame!");
          printf("Enter your name: ");
          fgets(&DAT_004040b0,10,stdin);
          puts("See you on HoF soon! :)");
        }
        else {
          compare = strcmp(param_1,"ls\n");
          if (compare == 0) {
            puts("- Boxes");
            puts("- Challenges");
            puts("- Endgames");
            puts("- Fortress");
            puts("- Battlegrounds");
          }
          else {
            compare = strcmp(param_1,"date\n");
            if (compare == 0) {
              system("date");
            }
            else {
              puts("Unrecognized command.");
            }
          }
        }
      }
    }
  }
  return;
}
```

Looking at the code we see what it's doin:

```
1. It checks if our input is the compared value i.e dir,id,flag etc. 
2. Then it runs the value that its suppose to run when the input is chosen
```

So there's nothing much too do

And we know that security issues lays within user input

The only portion of the program that allows user to give input is

```
compare = strcmp(param_1,"hof\n");
  if (compare == 0) {
    puts("Register yourself for HTB Hall of Fame!");
    printf("Enter your name: ");
    fgets(&DAT_004040b0,10,stdin);
   puts("See you on HoF soon! :)");
}

compare = strcmp(param_1,"flag\n");
   if (compare == 0) {
      printf("Enter flag: ");
      fgets(buffer,48,stdin);
      puts("Whoops, wrong flag!");
}
```

And we also see this interesting option

```
compare = strcmp(param_1,"date\n");
   if (compare == 0) {
      system("date");
}
```

Which basically just runs system(data) and we will get our current date 

With this we can see the vulnerability is in this portion of the code

```
char buffer [16];

compare = strcmp(param_1,"flag\n");
  if (compare == 0) {
    printf("Enter flag: ");
    fgets(buffer,48,stdin);
    puts("Whoops, wrong flag!");
}
```

We see that the size of input buffer can only hold up to 16bytes of data but the fgets lets us write in 48 bytes of data

So there's a buffer overflow vulnerability in that portion of the code

Another thing i noticed is that the hof option allows user input. Before it reads the input its initial space is empty
![image](https://user-images.githubusercontent.com/113513376/222853342-b6703054-34b3-4846-ac27-eb69f1c5053c.png)

What we can basically do is to:

```
1. Write the value of /bin/sh into the DAT_004040b0 section since hof writes the user input there
2. Then i'll make a rop chain to call system(DAT_004040b0) which will basically run system on the value stored in DAT_004040b0
```

One thing we should note that the value just reads in 10 bytes of data

And since we can put `/bin/sh` which is just 7 bytes it's ok to get shell

Firsly lets confirm our theory

Using gdb i'll debug and see if our input is written in DAT_004040b0 when the hof option is called

The address of `DAT_004040b0` is `004040b0` and i used ghidra to get it

Ok cool lets fire up gdb-gef
![image](https://user-images.githubusercontent.com/113513376/222854333-30c25866-0239-4602-99d3-7cf59a049b5e.png)
![image](https://user-images.githubusercontent.com/113513376/222854363-77614c38-171b-4f59-8112-3f627fa43c0e.png)
![image](https://user-images.githubusercontent.com/113513376/222854420-a8ba4089-af89-419a-884e-e9fbe2a7a6bb.png)

Now lets view the content of the address `0x04040b0`
![image](https://user-images.githubusercontent.com/113513376/222854486-5bca73c1-0a73-49e6-8ad4-53ddbb694d57.png)

Well well it works now lets make the exploit 🤓

I'll get a pop_rdi gadget using ropper
![image](https://user-images.githubusercontent.com/113513376/222854591-97a89228-903f-4cf9-83f7-ba31a1f049a5.png)

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/console.py)

Running in on the remote server works 
![image](https://user-images.githubusercontent.com/113513376/222854957-88af2183-a900-4bba-ae4c-1e13eddb795c.png)


And we're done 👻

<br> <br>
[Back To Home](../../../index.md)



