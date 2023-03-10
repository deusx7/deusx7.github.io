### Binary Exploitation

### Source: PICOCTF

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/ropfu]
└─$ file vuln
vuln: ELF 32-bit LSB executable, Intel 80386, version 1 (GNU/Linux), statically linked, BuildID[sha1]=3aa2bb6a5bf44d90a355da83fa909bbf5d9d90ce, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/ropfu]
└─$ checksec vuln
[*] '/home/mark/Documents/Pentest/BOF/03-begineer_bof/ropfu/vuln'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    Canary found
    NX:       NX disabled
    PIE:      No PIE (0x8048000)
    RWX:      Has RWX segments
```

We're working with a x86 binary which is statically linked and from the checking the protections we see that there's no canary present and NX is disabled this means that we can inject shellcode to the stack and execute it

Source code is given

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

#define BUFSIZE 16

void vuln() {
  char buf[16];
  printf("How strong is your ROP-fu? Snatch the shell from my hand, grasshopper!\n");
  return gets(buf);

}

int main(int argc, char **argv){

  setvbuf(stdout, NULL, _IONBF, 0);
  

  // Set the gid to the effective gid
  // this prevents /bin/sh from dropping the privileges
  gid_t gid = getegid();
  setresgid(gid, gid, gid);
  vuln();
  
}
```

Nothing much going on the main function just calls the vuln function and the vuln function prints out some words then use gets() to receive our input

The problem is the usage of get in the program. get() doesn't validate the amount of bytes passed in and from the code we see that the input buffer can only hold up to 16 bytes of data but since get() is used we can overflow it and cause a buffer overflow

First lets get the offset
![image](https://user-images.githubusercontent.com/127159644/224171429-c031f830-4844-477b-87fc-32a27ecb0b72.png)
![image](https://user-images.githubusercontent.com/127159644/224171505-2f23757b-8951-4596-8128-38ddceda46de.png)

Cool the offset is 28

Now how do we get shell ?

We would have tried some shellcode injection to the stack but the problem is that the length of the shellcode will be bigger than the offset

Making it not possible and since the binary is statiscally linked it already has all the neccessary calls stored in it already so we can't do some ROP like ret2libc or sth i think 🤔

So here's what i did. After searching for gadgets in the binary i got a mov gadgets
![image](https://user-images.githubusercontent.com/127159644/224177412-6fd77a67-9e69-49fb-b048-97bc95e0efd2.png)

Cool this is good cause we can mov the value of a register and put in another

I'll search for writeable part of the binary using `readelf`
![image](https://user-images.githubusercontent.com/127159644/224178131-67bee363-5529-4a85-9d7b-3ed876ca3eb9.png)

One place we would want to write is the .data section

So the idea is that we can write `/bin/sh` into the `.data` section then use a linux syscall `execve` to run `execve(.data, 0, 0)`

Here's the resource to get linux syscall 
[Syscall](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md)

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/ropfu/exploit.py)

All the gadgets there i got from using `ropper` and i hope the exploit code is self explanatory but i commented stuffs there to understand it

Running it locally works
![image](https://user-images.githubusercontent.com/127159644/224188411-db953d4f-ee4e-461f-88d1-63afdb2c0f14.png)

Also running it remotely works
![image](https://user-images.githubusercontent.com/127159644/224188534-17df7014-ed71-44a3-aecc-6c326709da83.png)


And we're done 👻

<br>
[Back To Home](../index.md)
