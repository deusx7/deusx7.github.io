<h3> Binary Heaven TryHackMe </h3>

![image](https://user-images.githubusercontent.com/113513376/222932877-e3270a1d-320f-4b3f-a947-4c7950798509.png)

We're given two files and the first question on thm asks:
![image](https://user-images.githubusercontent.com/113513376/222932929-37cb754e-16b5-4fd3-a03f-94bb2c6c6ec5.png)

```
What is the username?
```

### Binary 1
Lets check the binary file type 
![image](https://user-images.githubusercontent.com/113513376/222932941-9c3602d8-5fab-4495-8b91-eb1b52a7ae03.png)

The first binary is an elf file which is dynamically linked an not stripped while the second is a go binary

Lets run the binary to know what it does
![image](https://user-images.githubusercontent.com/113513376/222932976-3e53edf6-575f-4b04-aaec-b1fc26578c81.png)

It asks for username so using ghidra i'll decompile the binary to know what it does
![image](https://user-images.githubusercontent.com/113513376/222933006-bdfd37b5-0cfa-4114-bf13-1e06b5ef6a2b.png)

```c
undefined8
main(undefined8 param_1,undefined8 param_2,undefined8 param_3,undefined8 param_4,undefined8 param_5,
    undefined8 param_6)

{
  long lVar1;
  byte input [9];
  int i;
  
  lVar1 = ptrace(PTRACE_TRACEME,0,1,0,param_5,param_6,param_2);
  if (lVar1 == -1) {
    printf("Using debuggers? Here is tutorial https://www.youtube.com/watch?v=dQw4w9WgXcQ/n%22");
                    /* WARNING: Subroutine does not return */
    exit(1);
  }
  printf("\x1b[36m\nSay my username >> \x1b[0m");
  fgets((char *)input,9,stdin);
  i = 0;
  while( true ) {
    if (7 < i) {
      puts("\x1b[32m\nCorrect! That is my name!\x1b[0m");
      return 0;
    }
    if (*(int *)(username + (long)i * 4) != (char)(input[i] ^ 4) + 8) break;
    i = i + 1;
  }
  puts("\x1b[31m\nThat is not my username!\x1b[0m");
                    /* WARNING: Subroutine does not return */
  exit(0);
}
```

We see what it does:

```
1. There's a debugger protection which prevents the binary from being run in a debugger
2. It asks for our input and stores it in input[]
3. A while loop is called which checks if the value of i is greater than 7 
4. If it is another if check is done and it checks if the username array is equal to our input which a bitwise operation (xor) is done 
5. If it isn't it prints out thats not my username
```

So here's the calculation done on the second if check

```
if int(username) + long(i) * 4 != (char(input[i]) ^ 4) + 8
```

And the value stored in the username array is this 
![image](https://user-images.githubusercontent.com/113513376/222933269-b0125387-2e7d-49bc-bc01-96b84f070eff.png)

```
                             username                                        XREF[3]:     Entry Point(*), main:00101202(*), 
                                                                                          main:00101209(R)  
        00104060 6b 00 00        undefine
                 00 79 00 
                 00 00 6d 
           00104060 6b              undefined16Bh                     [0]                               XREF[3]:     Entry Point(*), main:00101202(*), 
                                                                                                                     main:00101209(R)  
           00104061 00              undefined100h                     [1]
           00104062 00              undefined100h                     [2]
           00104063 00              undefined100h                     [3]
           00104064 79              undefined179h                     [4]
           00104065 00              undefined100h                     [5]
           00104066 00              undefined100h                     [6]
           00104067 00              undefined100h                     [7]
           00104068 6d              undefined16Dh                     [8]
           00104069 00              undefined100h                     [9]
           0010406a 00              undefined100h                     [10]
           0010406b 00              undefined100h                     [11]
           0010406c 7e              undefined17Eh                     [12]
           0010406d 00              undefined100h                     [13]
           0010406e 00              undefined100h                     [14]
           0010406f 00              undefined100h                     [15]
           00104070 68              undefined168h                     [16]
           00104071 00              undefined100h                     [17]
           00104072 00              undefined100h                     [18]
           00104073 00              undefined100h                     [19]
           00104074 75              undefined175h                     [20]
           00104075 00              undefined100h                     [21]
           00104076 00              undefined100h                     [22]
           00104077 00              undefined100h                     [23]
           00104078 6d              undefined16Dh                     [24]
           00104079 00              undefined100h                     [25]
           0010407a 00              undefined100h                     [26]
           0010407b 00              undefined100h                     [27]
           0010407c 72              undefined172h                     [28]
           0010407d 00              undefined100h                     [29]
           0010407e 00              undefined100h                     [30]
           0010407f 00              undefined100h                     [31]
```

we can see some hex values i'll automate the extraction of the second row
![image](https://user-images.githubusercontent.com/113513376/222933353-b64b38cb-89ac-4dd6-8428-ff99767db33d.png)
![image](https://user-images.githubusercontent.com/113513376/222933384-c98916da-8fe1-4e7b-9c78-cc47c4e7fd1f.png)

```
Command: cat username | awk -F " " '{print $2}' | tr "\n" " " | sed 's/ /","/g' | cut -d ":" -f 2
```

I'll save it in a file and rearrange it excluding the zero's
![image](https://user-images.githubusercontent.com/113513376/222933453-16615f26-63ea-4f61-850e-5e24e9c9178d.png)

Since its hex and we know that the calculation that is done to compare the user input is

```
(char(input[i]) ^ 4) + 8
```

Therefore the reverse of it will be

```
(chr(username - 8) ^ 4)
```

Using a python [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/binary_heaven/username.py) i got the decoded value
![image](https://user-images.githubusercontent.com/113513376/222933644-d7a7cff0-9d79-4812-a083-41212c9d4515.png)

Submitting that works xD
![image](https://user-images.githubusercontent.com/113513376/222933718-19d05090-648b-4827-aa24-2b6a427f86f0.png)

### Binary 2
I'll run the binary to get an idea of what it does
![image](https://user-images.githubusercontent.com/113513376/222934142-0d6ebf5f-88e7-418d-9e42-d87b8c4fbb07.png)

Tts asking for password i'll decompile it using ghidra

Since its also not stripped we'll see the function names

And the function i'll go first to is the `main.main` function cause thats the start function in a go binary
![image](https://user-images.githubusercontent.com/113513376/222934686-948c39cd-6022-4cc1-ba23-1a93076a3f08.png)

But tbh looking at it makes me cry 😂 (i don't know go)

So rather lets open it up in gdb and see if we can get anything from there

But gdb output doesn't really look too good in my eye
![image](https://user-images.githubusercontent.com/113513376/222935010-079774ad-d20e-42ca-9eb4-ebe658280e0a.png)
![image](https://user-images.githubusercontent.com/113513376/222935016-3b2b294d-745b-4168-8f9f-306f0ad9b4e8.png)
![image](https://user-images.githubusercontent.com/113513376/222935020-faea441e-f3ea-4736-8222-3ab79abed6e9.png)
![image](https://user-images.githubusercontent.com/113513376/222935024-f2e75dba-c24c-42da-a475-fd3a0bcd230c.png)

So let me try radare2 
![image](https://user-images.githubusercontent.com/113513376/222935047-22388f5f-7f07-4196-aef7-1a84981cdc8d.png)
![image](https://user-images.githubusercontent.com/113513376/222935060-9acdb0a1-7e9b-4cda-87f0-095030fec044.png)
![image](https://user-images.githubusercontent.com/113513376/222935077-abc52d0b-9b67-4fbc-849d-af4aff7a97ab.png)

Hmmmmm whats this weird long string

```
GOg0esGrrr!IdeographicMedefaidrinNandinagariNew_Tai_LueOld_PersianOld_SogdianPau_Cin_HauSignWritingSoft_DottedWarang_CitiWhite_
```

The password length is crazy so i disassembled it in gdb-pwngdb

And saw this 
![image](https://user-images.githubusercontent.com/113513376/222936287-b9857e4f-3372-4372-8496-68ac2b33c70a.png)

So the expected length of the password is 11

Using python or u can do it manually 😂 i'll get the first 11 bytes
![image](https://user-images.githubusercontent.com/113513376/222936512-2b240a4e-33dc-4254-92f2-85c0fa15c1b9.png)

Trying it as the password works
![image](https://user-images.githubusercontent.com/113513376/222936542-e359eff6-450d-4213-af3c-7b06ff5861f2.png)

Now i'll login to ssh as `guardian:GOg0esGrrr!`
![image](https://user-images.githubusercontent.com/113513376/222936583-a7202eea-c8d3-44e0-86b6-8f76a0fc7a3b.png)

There are two users on the box
![image](https://user-images.githubusercontent.com/113513376/222936601-a404637e-8b13-41fd-971d-b8102a6fb445.png)

Searching for suid shows this
![image](https://user-images.githubusercontent.com/113513376/222936619-1927af7f-1c35-42f4-a075-7533aabd70c8.png)

I'll download it to my machine for further analyzing
![image](https://user-images.githubusercontent.com/113513376/222936657-ed5eeb39-4bfa-4c18-9599-6c959ef3c7a7.png)

Lets do the basic file checks
![image](https://user-images.githubusercontent.com/113513376/222936753-3121c35d-ba5f-4a63-a2f2-a0c576d96a2e.png)

We're working with a x86 binary and from looking at its protections it has NX and PIE enabled

And what those does is that:

```
1. NX prevents shellcode injection to the stack and the execution of it
2. PIE randomize memory addresses
```

I'll run it to know what it does
![image](https://user-images.githubusercontent.com/113513376/222936799-9af042e7-fc1b-4a12-943d-212dcb9c2fdd.png)

Cool it leaks system address and requires our input

I'll decompile the binary using ghidra

Since its not stripped i'll see function names

Here's the main function
![image](https://user-images.githubusercontent.com/113513376/222936914-4d09542c-d7a9-4a9b-ac9c-8903b6a37e3d.png)

It just calls the vuln function

And here's the vuln function
![image](https://user-images.githubusercontent.com/113513376/222936926-a53548d2-bae9-4ce5-99fb-00f0daf95269.png)

```c
void vuln(void)

{
  undefined input [24];
  
  FUN_00011100("Binexgod said he want to make this easy.");
  FUN_000110c0("System is at: %lp\n",system);
  FUN_000110d0(input);
  return;
}
```

The vuln function leaks the address of system then recieves our input which is stored in a buffer that can only hold up 24 bytes of data

I'll try overflowing it with 30 A's
![image](https://user-images.githubusercontent.com/113513376/222937029-82eafa86-31b7-4bfb-b770-8b59f8f25aa7.png)

Cool we have segmentation fault

Since we already have a libc leak i'll just perform Ret2Libc

Firstly i'll need to get the remote libc library file since my libc will be different from the remote own
![image](https://user-images.githubusercontent.com/113513376/222937123-637cc850-f914-4be5-91f6-73e27296c187.png)

Now lets get the offset needed to overwrite the EIP
![image](https://user-images.githubusercontent.com/113513376/222937225-2b6ef3fd-804c-4c3e-bf7a-3321441f67c8.png)
![image](https://user-images.githubusercontent.com/113513376/222937235-e8a5a616-ded3-4eeb-8c64-717345ae91ae.png)

The offset is `32`

So what ret2libc does is that it leverage functions within the libc, such as system to call /bin/sh

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/binary_heaven/exploit.py)

Running it locally works
![image](https://user-images.githubusercontent.com/113513376/222937704-8954d21d-41a0-4e86-acb6-e900d03532ab.png)

Now i'll run it so that it will connect to the ssh server and exploit the binary
![image](https://user-images.githubusercontent.com/113513376/222938509-3e16a37a-df8a-4ca0-a316-52c3c9c4d4cf.png)

I'll get a more stable shell
![image](https://user-images.githubusercontent.com/113513376/222938647-4b0e1e53-276a-46ac-a625-1867353a1d3c.png)

And to stabilize the shell i'll do this:

```bash
python3 -c "import pty; pty.spawn('/bin/sh')"
export TERM=xterm
CTRL +Z
stty raw -echo;fg
```

Now lets get root 🤓

There's a binary in the user's desktop with its C code
![image](https://user-images.githubusercontent.com/113513376/222938770-b0ee3fc6-3648-42a5-b225-aa9710998fe0.png)

And the C code basically runs `"/usr/bin/env echo Get out of heaven lol"`

We can see the vulnerability already 

Lets confirm by runnning the binary to know if its the owner of the C code
![image](https://user-images.githubusercontent.com/113513376/222938823-8ea081f2-24fd-4070-a786-3160d20f49b9.png)

Yeah it is 

Now the vulnerability is that it runs system `echo` without specifying its full path

So we can perform a path hijack
![image](https://user-images.githubusercontent.com/113513376/222939015-efd43a01-8981-4734-ad4a-6493d329d9dc.png)

We can get root shell from there
![image](https://user-images.githubusercontent.com/113513376/222939045-fd3b4009-5200-48ba-860c-76a5278efce6.png)

And we're done 👻

<br> <br> 
[Back To Home](../../../index.md)


