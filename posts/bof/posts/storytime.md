<h3> StoryTime HS'19 CTF </h3>

Basic File Check:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/61303808-89e0-482e-8244-d39ce4fc614f)

```
➜  Storytime file storytime 
storytime: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=3f716e7aa7e236824c52ed0410c1f14739919822, not stripped
➜  Storytime checksec --file=storytime --format=json | jq .storytime
{
  "relro": "partial",
  "canary": "no",
  "nx": "yes",
  "pie": "no",
  "rpath": "no",
  "runpath": "no",
  "symbols": "yes",
  "fortify_source": "no",
  "fortified": "0",
  "fortify-able": "1"
}
```

From the check we can see that we're working with a x64 binary and the only protection enabled is NX (No-Execute) which basically prevents us from writing shellcode to the stack and executing it

I'll run the binary to get an overview of what it does
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7935b3c5-b78b-4581-80fb-b8c655cb1ee5)

Interesing...... Just receives our input and exits

Time to decompile to get the pseudo code using ghidra

Here's the main function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/458832d3-4e23-4162-8680-9c671578dd4d)

```c
int main(void)

{
  char buffer [48];
  
  setvbuf(stdout,(char *)0,2,0);
  write(1,"HSCTF PWNNNNNNNNNNNNNNNNNNNN\n",0x1d);
  write(1,"Tell me a story: \n",0x12);
  read(0,buffer,400);
  return 0;
}
```

Looking at it just shows a buffer variable which can only hold up to 48 bytes of data then the program writes out some text to standard output and then uses read to receive our input but it is giving us the ability to read up to 400 bytes of data into a 48 buffer variable and we have a buffer overflow here

There are other functions in the program here are the decompiled code

Function climax():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/297f722b-c40e-41e4-b19e-66b6077a0063)

```c

void climax(void)

{
  char buffer [48];
  
  read(0,buffer,4000);
  return;
}
```

From there we see another buffer overflow which is letting us read up to 4000 bytes of data in a buffer that can only hold up to 48 bytes

Function beginning():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c97b86b9-327c-4559-b367-0f39d21e2f6a)

```c

void beginning(void)

{
  write(1,"Once upon a time...\n",0x28);
  return;
}
```

This just writes some text to stdout

Function middle():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/65b8deb6-3a23-4361-a005-80cf7e5a0db5)

```c

void middle(void)

{
  write(1,"Middle of story is the best! :D\n",0x28);
  return;
}
```

This just writes some text to stdout

Function end():
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e966c22f-f021-4914-bf4c-31cbc3650cec)

```c

void end(void)

{
  write(1,"The End!\n",0x28);
  return;
}
```

This just writes some text to stdout

Now we see the other functions just writes some text to standard output and just one out of the others has a buffer overflow vuln in it

Let us get the offset required to take control execution over the binary



