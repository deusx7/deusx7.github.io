<h3> LeetTest HackTheBox </h3>

#### Binary Exploitation

#### Basic File Checks
![image](https://user-images.githubusercontent.com/113513376/222926984-d2674583-204a-4bd3-abe8-a9c67e8299a0.png)

We're working with a x64 binary and we see all protections are enabled except NX 

I will run it to know what it does
![image](https://user-images.githubusercontent.com/113513376/222927055-2d0c93f5-4754-490c-91dc-198ddf876ebc.png)

I'll decompile the binary using ghidra and since its not stripped i'll see the functions names

Here's the decompiled main function
![image](https://user-images.githubusercontent.com/113513376/222927106-fb68a2e4-546f-47d9-89f4-8f4f09c4d059.png)

```
void main(void)

{
  long in_FS_OFFSET;
  uint check;
  int random;
  int flag;
  void *win;
  char input [280];
  undefined8 canary;
  
  canary = *(undefined8 *)(in_FS_OFFSET + 0x28);
  initialize();
  random = open("/dev/urandom",0);
  read(random,&check,4);
  close(random);
  check = check & 0xffff;
  while( true ) {
    printf("Welcome to HTB!\nPlease enter your name: ");
    fgets(input,0x100,stdin);
    printf("Hello, ");
    printf(input);
    if (check * 0x1337c0de == winner) break;
    puts("Sorry! You aren\'t 1337 enough :(\nPlease come back later\n------------------------");
  }
  flag = open("flag.txt",0);
  win = malloc(0x100);
  read(flag,win,0x100);
  close(flag);
  printf("\nCome right in! %s\n",win);
                    /* WARNING: Subroutine does not return */
  exit(0);
}
```

I had to rename some variables in order to understand the code

So here's what i can tell is going on:

```
1. It opens up /dev/urandom and reads 4 bytes from it which is stored in &check
2. It then closes the open syscall
3. It goes in a while loop and reads the user input (256 bytes) so no buffer overflow here since the input buffer can hold up to 280 bytes of data
4. It then prints out the content of our input without using a format specifier # bug here
5. Then an if check is done to compare the value stored in check multiply by 0x1337c0de to the value stored in winner
6. If the check is true then it gives the flag
```

The value stored in winner is `0xCAFEBABE`

So the thing i can tell from here is that we need to overwrite the value of `check` to a value that when multiplied will give `0xCAFEBABE`

But thats not possible cause it converts it to a float number 

And the float number formed can't be converted in hex
![image](https://user-images.githubusercontent.com/113513376/222929024-e6b129bb-6299-4915-ba1e-7c103c23de71.png)

So the only thing i can think of is to overwrite both the check value and the winner value to be in form of something like

```
check * 0x1337c0de == winnner 

And check = 0 also winner = 0
```

So basically the if check will be true since:

```
0 * 0x1337c0de == 0 ( is true )
```
