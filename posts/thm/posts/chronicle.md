<h3> Chronicle TryHackme </h3>

Difficulty = Medium

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f7ee2c74-5e1f-4d75-8d4d-b0b5b2f486a2)

Checking the web instance on port 80 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/71784515-0b27-473a-9a77-61ef766a769e)

Using gobuster I'll fuzz for directories
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/62d7ed93-1659-4a25-b6f7-a6aee60f7554)

It shows another directory called /old checking it shows a note.txt file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4305325b-a2c2-49a2-807b-d55f2aa81753)

Reading its content shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/20314b8a-3563-4c1d-a81f-24453ed26d68)

I'll fuzz for things there again
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/76abb144-02a7-4230-86df-8b0ebc565725)

We can see 200 http code status for */.git/HEAD*

Lets confirm it 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cfe91460-75cc-44be-9cea-6286875f4d31)

Boom we have an exposed .git on the web server

Using *git-dumper* I'll dump its content committed 🙂
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4e108f8b-672d-4b3a-baa3-6436d0f4eba0)

Looking at the cwd we can see *note.txt*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/308df6ff-6601-45aa-a697-3a6ae79d40af)

Checking the git logs gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1bb765ce-35e8-489e-b55b-6ea50f77f1fa)

```
Command: git log
```

Looking through commit one shows the css of the web app
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4bfd8e12-a26d-4d5a-b301-30e631142c45)

While for commit two shows the web app source code
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9a686473-8542-4ce6-91c6-581606421676)

And remember that there's another web server running on port 8081 so likely this is the source code since nmap showed that its based off a python web server

Moving over to port 8081 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e9203a58-15e3-4e8f-bd08-d8eedc79f08f)

Nothing much interesting there except the login page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5d70971f-5853-4bff-b8da-8f423b56f8f7)

And the forgot password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/02a79e9d-c6fd-4108-a554-5975a0ffb15c)

Looking at the source code shows that it really indeeds just requires a username then it shows the password of that user
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d70fca49-8b76-4ccf-b840-d8c31b3f87f8)

But it requires the correct key value for it to work and since we have it lets try it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b1bf3b15-0e4f-44e5-88db-b1be6760e6d2)

We get Invalid Username the only here is to brute force right?

So I made a script to do that for me

```python
import requests
import json

# wordlist = /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt

with open('usernames.txt', 'r') as f:
    usernames = [line.strip() for line in f.readlines()]

for users in usernames:
    url = f'http://10.10.39.47:8081/api/{users}'
    data = {
        "key": "7454c262d0d5a3a0c0b678d6c0dbc7ef"
       }
    key = json.dumps(data)
    header = {'Content-type': 'application/json'}
    proxy = {'http': 'http://127.0.0.1:8080'}
    req = requests.post(url, data=key, headers=header, proxies=proxy)
    if 'Invalid Username' not in req.text:
        print(f'Username Found = {users}')
        print(req.text)
```

Running it gives a username and its password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9f3a2472-971e-43d9-af36-15f6f5320b65)

Now we can login to ssh using *tommy:DevMakesStuff01*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6ea9c656-029e-48fb-9c2e-c21690b63e4d)

Lets escalate privilege 

After checking the other user directory I got a mozilla directory
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/28a0b5c6-7756-4742-ae61-c12a2e852d37)

We can use this [tool](https://github.com/lclevy/firepwd) to dump its password

First I need to make a tar ball of it then transfer it to my host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0e9f60f2-0f36-4ca0-ba3c-b02b42e653e1)

Now i will decompress it and use the tool to dump it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/793c2cba-17d5-4aa9-a0f8-e38d9b958ef2)

But it asks for password after some trial *password1* works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/885e14d5-931b-46ce-820a-9892502c5c2a)

I then tried loggin in to ssh as user *carlJ:Pas$w0RD59247*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/67e5eee9-52cc-4f66-8fdd-1910f5ba9ad6)

Searching for suid shows this binary 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/56299232-7412-42dd-8242-3f2c9866402c)

I transferred it to my machine and decompiled it in ghidra

Lets check the file type and the mitigations enabled
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1166be89-1a17-4b36-bf29-b8de1f940707)

It's a x64 binary and has only one protection enabled which is :

```
1. NX enabled (No-Execute)
```

What NX enabled prevents is shellcode being placed on the stack and executing it

Looking at the main function shows this:

```c
int main(void)  {   
    int buf;
    char message [80];
    setuid(0);
       
    puts("What do you wanna do\n1-Send Message\n2-Change your Signature");
    __isoc99_scanf(%d, &buf);
    fgetc(stdin);
    
    if (buf == 1) {
        puts("What message you want to send(limit 80)");
        fgets(message,80,stdin); 
        puts("Sent!");
    }   
    else if (buf == 2) {     
        puts("Write your signature...");
        sig();
    }   
    
    return 0; 
}
```

And here's the sig() decompiled function:

```c
void sig(void)  { 
    char buf [64];
    gets(buf); 
    puts("Changed");
    
    return;
}
```

From the code we can tell that it a binary that:

```
1. Asks if we want to send a message or change signature
2. If we choose the send message option it prompts for input then receives 80 bytes of our input which is stored in a 80 bytes buffer and puts Sent!
3. If we choose the change signature option it calls the sig function which uses gets() to receive out input then puts Changes # bug here 
```

Looking at the sig function we can tell it's a buffer overflow vulnerability from the usage of gets() in the code

Lets get the offset to overflow the binary

I use gdb in cases like this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/31852355-c7cb-4f04-ace5-c3e231eb7f9a)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cefb3bcd-4c79-43d3-947c-b99a5c4e6c18)

The offset is *72*

In cases like this the attack ROP we can use is *Ret2Libc*

Cause during program execution we can see the got of puts is being used
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/df055899-a77c-469d-b722-7b46b82772c8)

So we can basically leak it, calculate the libc base address then rop to system

I made a pwn script 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/93768ff8-203f-4c3b-bc41-7df205c67aad)

Before thinking of how to make it work remotely luckily the creator left pwntools python library on the box
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/557f05bd-7778-4ed1-a9f7-c34a4c5ab16c)

Now i will just upload it to the target and run it here's the [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/chronicle/solve.py)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2566aea3-3f04-4b69-bbbc-eaf409c8be02)

After running it I got shell as root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3df13efb-0002-4d59-8991-c0fd55304037)
