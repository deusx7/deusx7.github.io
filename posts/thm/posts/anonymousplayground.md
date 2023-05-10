<h3> Anonymous Playground TryHackMe </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cbf574c6-ae68-4854-a666-b7cc0c38d09c)

Checking the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b4b022a6-e703-49f1-ba96-3d325b1759e5)

Looking at the source code does not reveal much information

Remember that nmap showed there's a file in /robots.txt indexed

Checking it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4098c704-5267-4500-af0b-3433922b21a7)

Going over there gives us access denied
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f0260872-6462-4b08-96f3-b304accb15ad)

Looking at the cookie shows it set to *denied* 

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fa31997c-cd20-4919-935d-7bef55d62c94)

Changing it to *granted* shows this 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e9ec2cc9-71c6-4ff7-b67c-f8c36f8d5ed5)

This looks like a cipher

```
Cipher: hEzAdCfHzA::hEzAdCfHzAhAiJzAeIaDjBcBhHgAzAfHfN 
```

At this point I was really confused on what to do i looked at the hint thm gave which was:

```
You're going to want to write a Python script for this. 'zA' = 'a'
```

This still doesn't makes sense to me 😥 I had to peek at a writeup for a better explanation on this i then understood it 

So basically:

```python
small alphabet, capital alphabet = alphabet that is at the position small alphabet + Capital alphabet 
```

For instance, 'z' is the 26th and 'A' is the 1st alphabet, and their sum is 27, and the '27th' alphabet (27 % 26 = 1) and the alphabet positioned there is 'a'.

I wrote a [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/Anonymous_Playground/Decode.py) to do the decoding 

Running it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/817ca58e-daa7-467c-89bd-314dbb08f7c9)

Decoded text looks like a cred trying it over ssh works 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d2ea7ff4-e0ab-4ecc-9821-79d7b00ee980)

Reading the note says this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f02f492f-f399-4468-a94d-9b52c182702a)

I transferred the binary to my machine and decompiled it using ghidra

But before that lets view the basic file checks
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6f631778-3678-49a4-a183-6b29134e5508)

So it's a x64 binary and the only mitigation enabled is NX (No-Execute)

Using ghidra I decompiled the binary and here's the main function

```c
undefined8 main(void)

{
  char buf [64];
  
  printf("Who do you want to hack? ");
  gets(buf);
  return 0;
}
```

From the code we see that it prints out some words then use gets() to receive our input 

We know that the bug is there since the usage of gets() does not verify the amount of buffer we pass it 

Looking through the functions shows this function called *call_bash*

Here's the decompiled code

```c
void call_bash(void)

{
  puts("\nWe are Anonymous.");
  sleep(1);
  puts("We are Legion.");
  sleep(1);
  puts("We do not forgive.");
  sleep(1);
  puts("We do not forget.");
  sleep(1);
  puts("[Message corrupted]...Well...done.");
  setuid(1337);
  system("/bin/sh");
  return;
}
```

From this we can see that after it prints out some words it sets our current uid to 1337 then runs system('/bin/bash')

With this we know that the aim is to call this call_bash function since we have control execution over the program

But the problem is that when it pops shell our current uid will be 1337 and no such user there 

What we would we love to make it to be is 0 which basically is for root

So instead of making the instruction pointer call the call_bash function we can just directly call the setuid address

Lets get the offset first
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/76691166-5700-400b-81ab-e33aa19c17eb)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5fa7314e-ac77-4d54-b56a-af7250d0cd50)

Cool the offset is 72. Now based on the calling convection of x64 binary we need to set RDI to 0 since setuid is passing just one argument which is 1337

Using ropper we can get a *pop rdi* gadget
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7716ec5e-8d01-43eb-acb6-2fa412c848d0)

Here's the exploit [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/Anonymous_Playground/solve.py) I made for it

Running it gives shell as root 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9591245b-2a0f-424a-812a-bbb1a966bd16)

With that you can submit the flags 👻

And we're done
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5336d695-01bd-46dc-a8c6-af901ac49a80)
