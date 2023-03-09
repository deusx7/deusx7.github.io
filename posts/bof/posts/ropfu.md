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

Making it not possible and since the binary is statiscally linked it already has all the neccessary calls stored in it already so we can't do some ROP like ret2libc or sth 

