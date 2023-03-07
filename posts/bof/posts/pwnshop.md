<h3> PwnShop HackTheBox </h3>

#### Binary Exploitation

#### Basic File Checks

![image](https://user-images.githubusercontent.com/113513376/222904805-179dc0a7-3021-478b-8386-4394b3df5106.png)

We're working with a x64 binary and its is stripped

The protections enabled are NX and PIE and here's what they do:

```
1. NX(No-Execute) prevents shellcode injection to the stack and execution of the shellcode
2. PIE randomize memory addresses 
```

I'll run it to know what it does
![image](https://user-images.githubusercontent.com/113513376/222905603-7b91ebb0-84f5-4768-b0cb-37396cd76657.png)

Using ghidra i'll decompile the binary

From the entry function we can get the main function
![image](https://user-images.githubusercontent.com/113513376/222905636-b6b2d667-8dca-4bf8-bfde-acca877968bd.png)

The main function address is `FUN_001010a0`

Here's the decompiled code
![image](https://user-images.githubusercontent.com/113513376/222906045-12b70b66-7a79-4b65-9bae-5ed8bb7c323b.png)

```

undefined  [16] FUN_001010a0(void)

{
  int iVar1;
  ulong in_RCX;
  char cVar2;
  
  FUN_0010121e();
  puts("========= HTB PwnShop ===========");
  while( true ) {
    while( true ) {
      puts("What do you wanna do?");
      printf("1> Buy\n2> Sell\n3> Exit\n> ");
      iVar1 = getchar();
      getchar();
      cVar2 = (char)iVar1;
      if (cVar2 != '2') break;
      FUN_0010126a();
    }
    if (cVar2 == '3') break;
    if (cVar2 == '1') {
      FUN_0010132a();
    }
    else {
      puts("Please try again.");
    }
  }
  return ZEXT816(in_RCX) << 0x40;
}
```

We can see what it does:

```
1. Prints out the banner thingy
2. Gets our option and the available option is just 1,2 and 3
3. If 2 is chosen it calls the function for option2 same applies to 1 and 3
4. But if a given value is is not among the option it prints out please try again
```

Here's the decompiled function if option 1 is chosen
![image](https://user-images.githubusercontent.com/113513376/222906243-8bf10247-2393-4f36-834c-62028140338f.png)

```
void FUN_0010132a(void)

{
  undefined auStack72 [72];
  
  puts("Sorry, we aren\'t selling right now.");
  printf("But you can place a request. \nEnter details: ");
  read(0,auStack72,0x50);
  return;
}
```

From reading the code we can see that it receives our input and reads in 80 bytes of data in a 70 bytes buffer so there's a buffer overflow here

Here's the decompiled function if option 2 is chosen
![image](https://user-images.githubusercontent.com/113513376/222906380-a96098fd-ccc9-4010-a206-316e97b0b88f.png)

```

void FUN_0010126a(void)

{
  int iVar1;
  long lVar2;
  undefined4 *puVar3;
  byte bVar4;
  undefined4 auStack72 [8];
  undefined8 local_28;
  undefined4 *local_20;
  
  bVar4 = 0;
  local_20 = &DAT_001040c0;
  printf("What do you wish to sell? ");
  local_28 = 0;
  puVar3 = auStack72;
  for (lVar2 = 8; lVar2 != 0; lVar2 = lVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + (ulong)bVar4 * -2 + 1;
  }
  read(0,auStack72,0x1f);
  printf("How much do you want for it? ");
  read(0,&local_28,8);
  iVar1 = strcmp((char *)&local_28,"13.37\n");
  if (iVar1 == 0) {
    puts("Sounds good. Leave details here so I can ask my guy to take a look.");
    puVar3 = local_20;
    for (lVar2 = 0x10; lVar2 != 0; lVar2 = lVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + (ulong)bVar4 * -2 + 1;
    }
    read(0,local_20,0x40);
  }
  else {
    printf("What? %s? The best I can do is 13.37$\n",&local_28);
  }
  return;
}
```


Here's what it does:

```
1. It first receives our input which reads 31 bytes of our input and stores it in a 8bytes buffer
2. Our input is received again but this time it reads 8 byte of our input to and stores it in &local_28
```

So there's another buffer overflow in this part of the code

After i tried running the binary and just trying to overflow it i noticed if you feed in 7 or 8 bytes to the second input of option 2 it leaks some value
![image](https://user-images.githubusercontent.com/113513376/222906699-ef0a6ad3-c1bf-4943-b09f-29c939026fdf.png)

Here's whats happening

```
  undefined8 local_28;
  undefined4 *local_20;
  
  bVar4 = 0;
  local_20 = &DAT_001040c0

  printf("How much do you want for it? ");
  read(0,&local_28,8);
  iVar1 = strcmp((char *)&local_28,"13.37\n");
```

Our input is overwriting the new line character and leaking address

But the address it leaks is `&DAT_001040c0` which is the pointer to `local_20`

Also note that `DAT_001040c0` is in the `.bss` section of the binary

We know that pie is enabled so first we need to get the pie base address before we can continue exploitation

So the idea is that the value that is being leaked is going to be `&DAT_001040c0` with that we can calculate the piebase address

Using ghidra i get the offset of the `&DAT_001040c0` section which is `0x40c0`

Here's the script to leak the pie base address [Leak](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/pwnshop/pie_leak.py)

Now lets do some exploitation 🤓

Lets get the offset

Looking at the vulnerable function of the code

```
void FUN_0010132a(void)

{
  undefined auStack72 [72];
  
  puts("Sorry, we aren\'t selling right now.");
  printf("But you can place a request. \nEnter details: ");
  read(0,auStack72,80);
  return;
}
```

We're allowed to write in 80 bytes in a 72 bytes buffer. The amount of space we can just overwrite is just `8` bytes

And 8 bytes isn't enough for us to perform some roping so we need to increase the amount of bytes we can write to the stack

A way of doing this is by doing stack pivoting which basically will free more space for us on the stack

We need a gadget to subtract data off the stack. Using ropper i get a gadget
![image](https://user-images.githubusercontent.com/113513376/222907538-1c12b515-7e76-4f00-b50a-d31bdf422037.png)

This `0x0000000000001219: sub rsp, 0x28; ret;` looks okay cause it subtracts 0x28 off the rsp 

I'll also get a pop_rdi gadget using ropper
![image](https://user-images.githubusercontent.com/113513376/222912138-1b2005ad-e092-415f-a0ef-90d71f3aa7ab.png)

Here's the way to get the offset
![image](https://user-images.githubusercontent.com/113513376/222911333-1c24d841-9681-4df0-9498-2fbc7af69a01.png)
![image](https://user-images.githubusercontent.com/113513376/222911388-6378a8c7-1f14-4527-afc0-1af4917eabef.png)

The offset is `72` 

I'll just perform a ret2libc attack. Since we know that the got of puts is already going to be populated since its already called in the main function
![image](https://user-images.githubusercontent.com/113513376/222911789-41860016-8add-4f0e-be6d-659a6f2ecbe4.png)

Also since its a stripped binary i can't just call `elf.symbols['main']` so basically after i leak the got of puts i'll need to return back to the vulnerable function to perform another rop chain 

Here's how i got the address
![image](https://user-images.githubusercontent.com/113513376/222913305-70897d3f-2a49-495c-94fa-5ae736f66056.png)

This is the way the payload is going to be 

```
Overflow + Leak puts got + Return to function thats vuln to buffer overflow (FUN_0010132a)
```

This is the script i used for it [Script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/pwnshop/got_leak.py)

I decided to directly run it on the remote server cause i'm having issue running the final exploit locally

And since the remote server will likely use a different libc from ours lets leak 

Running it remotely leaks the address
![image](https://user-images.githubusercontent.com/113513376/222925140-805a9c93-b91d-4e0c-a707-241d2e0d596a.png)

So now we can use [LibcDB](https://libc.blukat.me/) to get the likely libc the remote file uses
![image](https://user-images.githubusercontent.com/113513376/222925024-b94182e7-21d3-44a8-a098-32de04f676cc.png)

The libc is going to between the 3rd and 4th since the binary is x64

Looking at it shows the offset to various syscalls
![image](https://user-images.githubusercontent.com/113513376/222925066-942a76d1-2e8a-4385-848c-36e808767f9c.png)

I downloaded the libc file

```
┌──(mark㉿haxor)-[~/…/BofLearn/Challs/HTB/pwnshop]
└─$ ls -l libc6_2.23-0ubuntu11.2_amd64.so pwnshop 
-rw-r--r-- 1 mark mark 1868984 Jan 26  2021 libc6_2.23-0ubuntu11.2_amd64.so
-rwxr-xr-x 1 mark mark   14384 Nov 18  2020 pwnshop
```

Now here's my exploit [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/pwn/pwnshop/exploit.py)

And i had to automate it using rop object cause i had issue with data receive 😞

But anyways here's what the exploit does

```
1. It leaks the pie base address
2. Leaks puts got
2. Calculates the libc base address
3. Run system('/bin/sh')
```

Running it works
![image](https://user-images.githubusercontent.com/113513376/222925874-305f1498-f957-4c96-86ac-85613a83d77b.png)

And we're done 👻

<br> <br>
[Back To Home](../../../index.md)







