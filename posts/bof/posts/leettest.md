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

To overwrite those values i'll need to know the offset of where our input is stored on the stack
![image](https://user-images.githubusercontent.com/127159644/223870459-b75a7eb2-804f-4aa5-8fa0-b2871caebf2d.png)

We can see that our input is at offset 10 on the stack
![image](https://user-images.githubusercontent.com/127159644/223870547-a11a7749-715a-47b7-b0ac-423880252034.png)

Pwntools can also automatically get the offset for us 🙂

Now that we know our offset we need to know the address of the winner value which can be easily gotten from looking at ghidra
![image](https://user-images.githubusercontent.com/127159644/223877359-bf05750c-0640-4106-ba0a-5f5964be5115.png)

But for the random address, it's not going to be just like a memory address its rather going to be at the stack

To get that i'll use a fuzz script which i'll set a breakpoint at the function which compares the value of winner with `random * 0x1337c0de` 

Here's my fuzz script [Fuzz](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/leet_test/fuzz.py)

Running it opens up gdb
![image](https://user-images.githubusercontent.com/127159644/223880282-fe0382d5-e6d6-4a87-a4c2-d5c92c7916b5.png)

And looking at the assembly code 
![image](https://user-images.githubusercontent.com/127159644/223880435-72009337-c807-4f58-83c9-cd29543e5bfd.png)

```
        004013a1 8b 85 cc        MOV        EAX,dword ptr [RBP + random]
                 fe ff ff
        004013a7 69 d0 de        IMUL       EDX,EAX,0x1337c0de
                 c0 37 13
        004013ad 8b 05 c5        MOV        EAX,dword ptr [winner]                           = CAFEBABEh
                 2c 00 00
        004013b3 39 c2           CMP        EDX,EAX
```

We see that:

```
1. The value of random is stored in EAX
2. It then multiplies the value of EAX with 0x1337c0de
3. It then stores the value of 0xCAFEBABE in pointer winner
4. Then it compares the value of EAX which is the random value and the pointer winner which is then stored in the EDX
```

That means that the random value is stored in RAX
![image](https://user-images.githubusercontent.com/127159644/223881236-907a69ac-e988-4fbd-9ca8-e5240dd5ec63.png)

Looking at the stack value of the current RAX we can get the stack address of the RAX
![image](https://user-images.githubusercontent.com/127159644/223881428-5a546bdd-fa97-475f-b233-43719c927aca.png)

With this, we can calculate the random value stack address by subtracting it with a known valid stack address

I'll use this address to get the offset
![image](https://user-images.githubusercontent.com/127159644/223881779-f23e7ebc-0ebb-4d0c-96a1-67de82194192.png)
![image](https://user-images.githubusercontent.com/127159644/223882985-2606f55f-623d-4628-ac5a-811abde4f38e.png)

Cool so the idea is that the offset betweeen the address of the first element of the stack and the random value stack address is 8488

Here's my exploit [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/leet_test/localexploit.py)

Running it locally works
![image](https://user-images.githubusercontent.com/127159644/223887185-f174082f-32af-4fae-b5d2-c2fa149fea5a.png)

I ran it on the remote server but it didn't work
![image](https://user-images.githubusercontent.com/127159644/223887472-2d5b2538-384b-40af-9df9-dcc9ba199af5.png)

So when i ran the fuzz script and compared with my own local fuzz script the stack address are different
![image](https://user-images.githubusercontent.com/127159644/223888238-8e4e8190-6373-4d81-a091-3715f054b164.png)

I decided to use another value
![image](https://user-images.githubusercontent.com/127159644/223889080-8dcd544d-40a0-4809-9fa1-3ea47b51e870.png)

And the remote server has a stack address at offset 55
![image](https://user-images.githubusercontent.com/127159644/223889291-88e1f09a-a786-431d-a3fc-a8584a1d06d7.png)

I edited the exploit code to leak the address at 55 and use offset -608. After running it works 
![image](https://user-images.githubusercontent.com/127159644/223890205-84e64009-11cb-4105-be4d-03ababa73c78.png)

But still i ran it remotely but it didn't work 😂
![image](https://user-images.githubusercontent.com/127159644/223890529-26129f51-7e39-4b1e-ba07-e31b5ed6ff9b.png)

So after a lot of trial i got the offset to be -287

Here's the remote [exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/leet_test/remote_exploit.py)
![image](https://user-images.githubusercontent.com/127159644/223891011-627ce85f-f1fd-4005-a495-6e73df0ab628.png)

And we're done 👻

<br> 
[Back To Home](../index.md)
