<h3> RITSEC CTF '23 </h3>

### I had fun while playing this ctf and learnt new things 😄. Lets get straight to the fun

### Intro
![image](https://user-images.githubusercontent.com/127159644/229284625-035ccb60-e236-40ae-adc1-4673da62fbfb.png)

If you just go to the discord channel and check the rules you will see the flag
![image](https://user-images.githubusercontent.com/127159644/229284664-fb85536f-e833-48f9-a5c2-04c0e2bfaf94.png)

```
Flag: RS{!flag}
```

<h3> Chandi Bot </h3>

### Chandi Bot 1
![image](https://user-images.githubusercontent.com/127159644/229284869-9c32174b-23a2-479b-9d06-46cc41a3a14f.png)

After going to the discord channel there's a bot there called chandi checking its profile gives the flag
![image](https://user-images.githubusercontent.com/127159644/229284828-e4d99d9c-193e-47e1-910f-a41147089416.png)

```
Flag: RS{QUANTUM_RESISTANT_ENCRYPTION}
```

### Chandi Bot 2
![image](https://user-images.githubusercontent.com/127159644/229284882-ebaf2662-e1ce-4409-a2a3-d7ac0ea4a131.png)

Trying the functions of the bot shows this 
![image](https://user-images.githubusercontent.com/127159644/229284961-56d99da8-2daa-483a-86de-82767defe316.png)

Now we can get the flag by doing /flag
![image](https://user-images.githubusercontent.com/127159644/229284979-b4b1da0e-f978-4098-b30b-5d372a149e2f.png)

```
Flag: RS{HMMM_WHAT_ARE_YOU_LOOKING_AT}
```

### Chandi Bot 4
![image](https://user-images.githubusercontent.com/127159644/229289993-89a9938f-bbc1-433f-ae29-e249f5720e11.png)

The bot has a rock paper scissors game (rps)
![image](https://user-images.githubusercontent.com/127159644/229290099-7385d53d-66ba-410f-92cd-bc760ee01012.png)

There's also a buy flag but it requires 10000 points
![image](https://user-images.githubusercontent.com/127159644/229290203-8a753069-086e-4b8d-b49f-fb7894a5af98.png)

And the way to get point is by getting a dad joke from /dad and playing rps with staking the point you have

But the dad joke just gives one point
![image](https://user-images.githubusercontent.com/127159644/229290374-7a2cec85-f7eb-4f27-8b42-eeffa0bd63e3.png)

I currently have 160 points but normally its supposed to be just 1 point 

From now we can play the rps game

But chances of winning is very low tho 

After playing and loosing we get this
![image](https://user-images.githubusercontent.com/127159644/229291964-ec05f126-aad7-455e-bb11-f885833da5bb.png)

Checking the balance shows it reduces by the amount stacked
![image](https://user-images.githubusercontent.com/127159644/229292005-abc29369-5255-4277-95ac-e8a5939393e2.png)

So the idea is that it does

```
if botwins:
  balance = balance - stake
```

Now it subtracts its initial balance with the amount staked

But what if we stake negative number yunno what happens 🙂

```
if botwins:
  balance = balance - (-stake)
```

It will turn to a positive number making the balance increase

Trying my assumption works
![image](https://user-images.githubusercontent.com/127159644/229292355-2017671d-b604-48f1-9950-da19be9cc449.png)

Now we can get the flag
![image](https://user-images.githubusercontent.com/127159644/229292440-b514d16f-30be-4895-b4f4-ad684458e92c.png)

```
Flag: RS{TWO_NEGATIVES_DO_MAKE_A_POSITIVE}
```

### Chandi Bot 5
![image](https://user-images.githubusercontent.com/127159644/229292628-7cccedb6-e49a-4e15-ac64-8fcfeed5ff32.png)

This part just asks series of question and if its up to 10 and you get it right then the bot gives you the flag
![image](https://user-images.githubusercontent.com/127159644/229292703-8e173825-1fe2-4133-adbc-6b6c1557cb06.png)

After playing with it i gathered that some question asked are 

```
What was the original name of the RITSEC CTF? = RC3
What is RITSEC's main website? = ritsec.club
What is the name of the RITSEC Current Discord Bot?  = 0Bii
What does ISTS stand for? = Information Security Talent Search
Who is the current President of RITSEC? = Bradely
When was RC3 founded? = 2013
When was RITSEC founded? = 2018
What year was the first version of ChandiBot featured in the RITSEC CTF?  = 2022
What does RC3 stand for? = RIT Competitive Cybersecurity Club
When was Sparsa founded? = 2002
When was the first RITSEC CTF? = 2018
Who was the first President of RITSEC? = Micah Martin
What is the name of RITSEC's CTF Team?= Contagion
```

Trying it on the bot works
![image](https://user-images.githubusercontent.com/127159644/229293215-cb20e611-8500-4544-84d1-f78d7e72afa9.png)

```
Flag: RS{TRIVIAL_TRIVIA_TRIUMPHS}
```

<h3> WEB </h3>

#### Echos
![image](https://user-images.githubusercontent.com/127159644/229299501-1dd44a6f-b1fa-41a0-85dd-f3dc42d9b8b2.png)

On heading to the web server it shows this
![image](https://user-images.githubusercontent.com/127159644/229299527-a34b4c10-5943-4910-ac4a-03f09808ca91.png)

Trying to put any output shows that it echos the output back
![image](https://user-images.githubusercontent.com/127159644/229299564-4a9d887e-6559-41f8-8e54-ab587d066a6e.png)

What i then taught from the challenge name is that it runs like echo command on our input

So i tried command injection using `whoami` and it works
![image](https://user-images.githubusercontent.com/127159644/229299615-4f392af2-c9fe-410a-813a-588569fff434.png)

Next i checked for if the flag is in the current directory
![image](https://user-images.githubusercontent.com/127159644/229299635-141223e4-59bd-4eea-bb12-683128959af0.png)

From here we can get the flag
![image](https://user-images.githubusercontent.com/127159644/229299659-4d310a0b-c090-4c06-80f6-e6651cea6247.png)

```
Flag: RS{R3S0UND1NG_SUCS3SS!}
```

#### Rick Roll
![image](https://user-images.githubusercontent.com/127159644/229299691-99aa9d66-5396-43cb-88e5-b210eacd97c6.png)

Checking the web server shows this
![image](https://user-images.githubusercontent.com/127159644/229299749-748b56df-16ae-4731-9f84-ebcc5956be75.png)

Nothing there is really there most links there are just going to get you rick rolled

But this links source code:

```
https://rickroll-web.challenges.ctf.ritsec.club/1.html
https://rickroll-web.challenges.ctf.ritsec.club/2.css
https://rickroll-web.challenges.ctf.ritsec.club/Don't.html
```

Gives the flag:

```
[RS{/\/eveRG0nna_]
[_|3tY0|_|d0vvn]
[_TuRna30unD_]
[_D3s3RTy0u}]
[G1v3y0uuP]
```

Then after i arranged it, i got the flag as:

```
Flag: RS{/\/eveRG0nna_G1v3y0uuP_|3tY0|_|d0vvn_TuRna30unD_D3s3RTy0u}
```

#### X-Men Lore
![image](https://user-images.githubusercontent.com/127159644/229301469-2f9557a1-6cca-4bb9-9832-1f535b51870e.png)

Checking the web server shows this
![image](https://user-images.githubusercontent.com/127159644/229301544-f14c07ba-b53f-432b-b51a-0ec06dc000a6.png)
![image](https://user-images.githubusercontent.com/127159644/229301553-66c7e2fb-0248-442b-ad7b-1a97d41d643b.png)

Clicking on any of the names down and intercepting the request in burp suite shows this
![image](https://user-images.githubusercontent.com/127159644/229301783-f80eff00-8fe8-479e-bdc0-46a2b7b4c754.png)

Some base64 encoded value is stored in the cookie 

Decoding it gives this

```
➜  ~ python3
Python 3.11.1 (main, Dec 31 2022, 10:23:59) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> a='PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz48aW5wdXQ+PHhtZW4+QmVhc3Q8L3htZW4+PC9pbnB1dD4='
>>> import base64
>>> print(base64.b64decode(a))
b"<?xml version='1.0' encoding='UTF-8'?><input><xmen>Beast</xmen></input>"
>>> 
```

So its encoding the it in an xml format and sending to the server then the server decodes the encoded blob then execute it

This is xxe 🙂

I then created a script to help me enumerate files on the server via the xxe [Req](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/ritsec/web/xmen/solve.py)

Running it on and fetching `/etc/passwd` works
![image](https://user-images.githubusercontent.com/127159644/229302089-6c826de2-b622-497e-9e86-4fd9379dacf6.png)

Now this part took me quite a while cause i was looking for the wrong file 😅

Well after my stress i found the file to be at /flag

Reading it works
![image](https://user-images.githubusercontent.com/127159644/229302249-9c2ba65f-537e-4543-8d00-00f99c6e2371.png)

```
Flag: RS{XM3N_L0R3?_M0R3_L1K3_XM3N_3XT3RN4L_3NT1TY!}
```

<h3> Reverse Engineering </h3>
### Cats At Play
![image](https://user-images.githubusercontent.com/127159644/229308875-240e763c-cb86-4c2c-85c4-772a1c60c71d.png)

This is quite very easy lets get to it

After downloading the binary i ran strings on it and got the flag

```
➜  ~ strings meow.exe | grep RS{
RS{C4tsL1keStr1ng5}
➜  ~ 
```

```
Flag: RS{C4tsL1keStr1ng5}
```

<h3> BIN-PWN </h3>

### ret2win
![image](https://user-images.githubusercontent.com/127159644/229309316-ec0edead-0404-46b6-b9b3-705d1f9fdcb9.png)

After downloading the binary i'll check its file type and the protections enabled on it
![image](https://user-images.githubusercontent.com/127159644/229309369-3791e617-8035-430b-ae78-e59d2df4c66a.png)

From here we can see the we're working with a x64 binary and no protections are enabled on it which is a good thing 🙂

Next i'll run the binary to get an overview of what it does
![image](https://user-images.githubusercontent.com/127159644/229309426-ccea1d4c-d8b1-440e-8b91-5547090c050f.png)

It just prints out some words receives our input and prints out another word

Using ghidra i'll decompile the binary and view the main function
![image](https://user-images.githubusercontent.com/127159644/229309898-18d25320-2272-4a39-8899-4b5ba6d14ceb.png)

The main function just calls the user_input() function

Here's the decompiled user_input() function
![image](https://user-images.githubusercontent.com/127159644/229309923-c19eb97d-a868-4258-a993-69ac0cfa8962.png)

```
void user_input(void)

{
  char local_28 [32];
  
  gets(local_28);
  printf("[*] Good start %s, now do some damage :) \n",local_28);
  return;
}
```

This is whats happening:

```
1. It gets our input <--- bug here
2. Then prints out the value of our input
```

The vulnerability here is the usage of get() 

We see that the space that the buffer can hold up to is 32bytes but since gets() is used we can overflow it

There's a special function called `supersecrettoplevelfunction`
![image](https://user-images.githubusercontent.com/127159644/229333396-296cbc17-7b51-4d42-acc4-19c32adef343.png)

```
void supersecrettoplevelfunction(int param_1,int param_2)

{
  puts("[*]  if you figure out my address, you are hired.");
  if ((param_1 == L'\xcafebabe') && (param_2 == L'\xc0debabe')) {
    system("/bin/sh");
  }
  else {
    puts("[!!] You are good but not good enough for my company");
  }
  return;
}
```

We can see it requires two parameters whose value is being compared with 0xcafebabe and 0xc0debabe and after the check is meet we get a shell else it prints out you are good but not good enough for my company

As this function isn't being called in main() or user_input(), the aim is to take hijack of the execution of the program via the buffer overflow vulnerability then make the instruction pointer point to the supersecrettoplevelfunction function

First lets get the offset needed to take control of the RIP
![image](https://user-images.githubusercontent.com/127159644/229333548-ef26f0f2-e512-4bcf-9201-dbbf76266005.png)
![image](https://user-images.githubusercontent.com/127159644/229333566-a1ab85e9-86f0-42de-8ae9-a7e08c7d2681.png)

The offset is `40` also now since this is a x64 binary and we want to pass in argument the convention of doing it matters as its passed into the registers

```
x64 linux arguments to a function are passed in via registers.
rdi:    First Argument
rsi:    Second Argument
rdx:    Third Argument
rcx:    Fourth Argument
r8:     Fifth Argument
r9:     Sixth Argument
```

So we need a `pop rdi; ret` gadget and a `pop rsi; ret` gadget

Using ropper we can get it
![image](https://user-images.githubusercontent.com/127159644/229333663-da2acf0a-8731-4ebc-9d28-6ce24e8d1689.png)

If you notice we don't have a full `pop rsi` gadget but rather `pop rsi; pop r15` its not a problem cause we can pass in 0 byte to the r15 register

Here's the exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/ritsec/pwn/ret2win/exploit.py)

Running it works
![image](https://user-images.githubusercontent.com/127159644/229333873-08bfc258-4654-492b-9048-f2e3b26bb74c.png)

Same works remotely
![image](https://user-images.githubusercontent.com/127159644/229333902-3f5268f9-42b5-4182-b5b7-ffdfeb419a8e.png)

```
Flag: RS{WHAT'S_A_CTF_WITH0UT_RET2WIN}
```

### assembly-hopping
![image](https://user-images.githubusercontent.com/127159644/229333939-edcca96b-6731-46d1-a0d8-6ce3c84d10f6.png)

After downloading the binary i checked its file type and the protection enabled on it
![image](https://user-images.githubusercontent.com/127159644/229333959-3c0e7398-4e07-4cea-b349-cec5849f72b0.png)

We see that no protection is enabled on this binary

Now i'll run it to get an idea of what it does
![image](https://user-images.githubusercontent.com/127159644/229333982-05142fe3-3dc7-4338-857b-1e2cb8e2dfc6.png)

It just takes in our input and print out `[!] Saved to our feedback database....` 

Using ghidra i'll decompile it and view its function
![image](https://user-images.githubusercontent.com/127159644/229334037-4efa6178-382a-40fd-ba59-837739494198.png)

It just calls the feedback_machine() function
![image](https://user-images.githubusercontent.com/127159644/229334057-b8ea1e45-7100-4345-924d-1cdb2b04e4ee.png)

Same as the previous binary it uses gets() which causes a buffer overflow but this time around no function to jump to 🤔

There's a function called assembly on the binary
![image](https://user-images.githubusercontent.com/127159644/229334127-7efc042b-2501-417f-bb93-650b9fb35f2e.png)

And what it seems to be doing is a jump rsp instruction

We can verify it by checking a `jmp rsp` gadget
![image](https://user-images.githubusercontent.com/127159644/229334180-c2972376-83d1-4b0e-99f9-d8a5583c746e.png)

This is good now because we know that no protection are enabled so if we get hijack of the execution on the program we can then do shellcode injection to the stack and execute it

First lets get our offset
![image](https://user-images.githubusercontent.com/127159644/229334249-2240ed3d-d772-4410-97f9-f67807c2935e.png)
![image](https://user-images.githubusercontent.com/127159644/229334256-f5077d3a-3c53-45b9-ae99-199328bc7a8a.png)
![image](https://user-images.githubusercontent.com/127159644/229334268-78bcb101-73c8-45a0-afb7-a97e89cae887.png)

The offset is 216 

Here's my exploit script [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/ritsec/pwn/assembly-hopping/exploit.py)

Running it works
![image](https://user-images.githubusercontent.com/127159644/229334323-0aa575cb-7423-4e9e-b5c9-a56967668341.png)

Same works remotely
![image](https://user-images.githubusercontent.com/127159644/229334335-931e4468-3bd2-4aab-bc56-20644b98328f.png)

```
Flag: RS{AS5EMB1Y_M1GH7_BE_H4RD_BUT_1T_C0MES_IN_CLU7CH}
```

<h3> Cryptography </h3>

### Either or Neither nor
![image](https://user-images.githubusercontent.com/127159644/229334439-5a1f4f92-d6ea-411f-a211-0e42ac2bbbdb.png)

Link given [Link](https://metaproblems.com/6ebee70f0d78d94a4750f9cb70031965/chal.py)

After downloading the file and checking its content i get this
![image](https://user-images.githubusercontent.com/127159644/229334512-dfd27326-a8c5-4e77-a336-59dd161db620.png)






