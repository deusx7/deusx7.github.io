<h3> Dubai Police CTF '23 </h3>

### Professional Category

### Description: This was a fun ctf I partook in and I played as `NeroHero` . My intension was just solving only pwn but I ended up solving all web + pwn and few others

### Web Exploitation
![image](https://user-images.githubusercontent.com/113513376/223123603-08d16cd1-76c4-4ddd-b5b8-211b7a1baeee.png)

#### Lazy Devs:
![image](https://user-images.githubusercontent.com/113513376/223123973-5e594258-2972-473b-8484-6088834385bc.png)

We're given the url to access 

Heading over to it shows a page talking about API
![image](https://user-images.githubusercontent.com/113513376/223124651-2fc28c1e-fb17-4067-b9dd-924916a4140c.png)

There's nothing in source page

So i headed over to ffuf to fuzz for directories
![image](https://user-images.githubusercontent.com/113513376/223125247-f3e7c618-8c1f-4e26-80db-0211925c711d.png)

We have a directory `/src` going over there shows the api source code which is written in php
![image](https://user-images.githubusercontent.com/113513376/223125506-bc553643-014b-4d3c-a4f2-1d6d69950900.png)
![image](https://user-images.githubusercontent.com/113513376/223125664-94bbea89-cf33-476a-9a55-535157c2b156.png)

And here's what it does:

```
1. It checks if the http request method is POST 
2. If the check is right it then sha1sum the value of the auth cookie and compares it with `0e666` 
3. In the same POST request, it checks for the value of the query parameter and unserializes it 
4. But if the check is failed that is the request used to query the site uses GET it just echo this is an api.....
```

Looking at the source code we see that there are two security vulnerabilities there, which are:

```
1. Insecure Deserialization
2. PHP Hash Collision
```

Why the php hash collision appears is because it uses `==` where the operation is fall short in php type comparison

And we know that theres insecure deserialization because of the usage of __wakeup() when an object is unserialized.

So now to first exploit the deserialization i need to generate a payload which will take abuse of __wakeup() 

Here's my [payload](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/dpctf/web/lazydevs/payload.php)
![image](https://user-images.githubusercontent.com/113513376/223127581-745b1eb6-c831-4a6f-9fbe-5a21a7af0f7a.png)

Running it generates the base64 encoded payload
![image](https://user-images.githubusercontent.com/113513376/223128311-08b9be0f-2c24-428f-a3dd-11b44c56732e.png)

Now that we have the payload we need to bypass the check that compares the user auth cookie with `0e666`

Checking JH [github](https://github.com/JohnHammond/ctf-katana)

I got some values to use 
![image](https://user-images.githubusercontent.com/113513376/223128985-07e84727-e918-4dde-9772-65bda9a18fc3.png)

So here's my final exploit to run arbitary commands [Exploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/dpctf/web/lazydevs/exploit.sh)

Running the script gives command execution
![image](https://user-images.githubusercontent.com/113513376/223131580-ce997114-f003-4f61-ad8f-f63b022a8344.png)

Since the flag is in the environment variable lets get it
![image](https://user-images.githubusercontent.com/113513376/223131651-658dea35-225c-4447-87c9-e6ceb901a954.png)

```
Flag: Flag{QIsRpGWpa_ZEsdXdLwLsv5D9xoYOfnQsJ9KSyYE6wDAvgFnK6-F4A62jriM3IUreQh2sEOd-DDJaDmnmER0tvJp8M9-Pm4ye6tI}
```


### I don't have access to the server again cause the ctf is over
![image](https://user-images.githubusercontent.com/113513376/223221513-7b7107dd-714e-46dc-a380-17fe02b92fd3.png)


### But at the end of the ctf here's the scoreboard
![image](https://user-images.githubusercontent.com/113513376/223221901-35707374-febd-4ae4-a896-6788a48eb248.png)
![image](https://user-images.githubusercontent.com/113513376/223221967-40a918fd-076a-49ca-8bde-2b3fcc76abda.png)

<br> <br>
[Back To Home](../../../../index.md)

