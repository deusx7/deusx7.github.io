<h3> Surf Proving Grounds Practice </h3>

### Difficulty = Intermediate

### IP Address = 192.168.126.171

Nmap Scan:

```
─$ cat nmapscan                                 
# Nmap 7.92 scan initiated Sat Mar  4 00:55:39 2023 as: nmap -sCV -A -p22,80 -oN nmapscan 192.168.126.171
Nmap scan report for 192.168.126.171
Host is up (0.43s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey: 
|   2048 74:ba:20:23:89:92:62:02:9f:e7:3d:3b:83:d4:d9:6c (RSA)
|   256 54:8f:79:55:5a:b0:3a:69:5a:d5:72:39:64:fd:07:4e (ECDSA)
|_  256 7f:5d:10:27:62:ba:75:e9:bc:c8:4f:e2:72:87:d4:e2 (ED25519)
80/tcp open  http    Apache httpd 2.4.38 ((Debian))
|_http-title: Surfing blog
|_http-server-header: Apache/2.4.38 (Debian)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Mar  4 00:55:51 2023 -- 1 IP address (1 host up) scanned in 12.43 seconds
```

Checking the web server on port shows this
![image](https://user-images.githubusercontent.com/113513376/222858069-45e0154a-d397-4557-8cae-ae363a1ecd46.png)

Nothing really much there except 2 posts talking about surfing

I ran gobuster on it and found this 
![image](https://user-images.githubusercontent.com/113513376/222858382-93338bcb-363b-4111-8cd0-860a7376e1bf.png)

Going on to /administration shows a login page
![image](https://user-images.githubusercontent.com/113513376/222858175-0b148573-0a6c-4914-80bf-c0223930ba98.png)

Trying default/weak cred doesn't work

So i noticed the request in burp and saw a cookie which caught my attention
![image](https://user-images.githubusercontent.com/113513376/222858228-a991a10f-e8ee-4cf4-9e82-021a59826ab9.png)

```
Cookie: auth_status=eydzdWNjZXNzJzonZmFsc2UnfQ==; PHPSESSID=ie6k33s7t2ahuop2kuqpcm2hc5
```

Decoding the cookie with base64 decode shows its value

```
┌──(mark㉿haxor)-[~/…/B2B/Pg/Practice/Surf]
└─$ echo eydzdWNjZXNzJzonZmFsc2UnfQ== | base64 -d                   
{'success':'false'}     
```

I'll generate a new cookie and replace it with the request cookie

```
┌──(mark㉿haxor)-[~/…/B2B/Pg/Practice/Surf]
└─$ echo -n "{'success':'true'}" | base64                      
eydzdWNjZXNzJzondHJ1ZSd9
```

Now i'll replace it 
![image](https://user-images.githubusercontent.com/113513376/222858627-3610e4b5-733b-44f1-8384-a868f8c44921.png)

And i get logged in
![image](https://user-images.githubusercontent.com/113513376/222858670-d37baf7b-bfe1-49ab-9725-e9aef0949e56.png)

After poking around the web page i got this that we had just few access over some functions

We can create a user and exploit the customers list in form of a csv file
![image](https://user-images.githubusercontent.com/113513376/222859229-c8083690-3f55-4603-9b8a-498371d3dc65.png)

Trying to access the shell console gives an error
![image](https://user-images.githubusercontent.com/113513376/222859558-e5c5d862-3383-48e9-b1d9-d71a50ecb2d4.png)

There's another function called check server status clicking it just shows that the server is running
![image](https://user-images.githubusercontent.com/113513376/222859633-b29c8533-afdd-4a13-a488-1f742dd1520a.png)

Hmmmm lets intercept the request in burp and check what happens when we click the check button
![image](https://user-images.githubusercontent.com/113513376/222859681-c2ac604c-2b2f-480e-ae0d-205823eb0311.png)

Cool we see that its accessing the internal service

```
url=http://127.0.0.1:8080
```

Therefore this is a SSRF vulnerability

With SSRF (Server Side Request Forgery) we can access internal service running on the target

But when i try accessing internal resource i don't really get an output

Lets check if it can reach our host

I'll set a listener on port 80 then try to access it
![image](https://user-images.githubusercontent.com/113513376/222860719-e0d40298-612a-4640-9765-c3f250d060c8.png)

After forwarding the request i get a connection back on my listener
![image](https://user-images.githubusercontent.com/113513376/222860811-53f20e65-9e0d-4f2c-9e9e-fbc9c4e2085c.png)

Out of curiosity i fuzzed for internal ports to know if maybe theres another web server running except the one on port 8080
![image](https://user-images.githubusercontent.com/113513376/222863998-6697a5a6-ca74-425e-9165-ef042939abe8.png)
![image](https://user-images.githubusercontent.com/113513376/222864017-5ea5790a-4898-4bd9-9acd-d2f1f9494480.png)

Only 2 web server running on the target

Anyways if you notice what the check said
![image](https://user-images.githubusercontent.com/113513376/222864062-3e8764ff-2c83-4494-b72c-4834dec3d973.png)

It refers to `phpfusion`

Searching google for it shows an exploit
![image](https://user-images.githubusercontent.com/113513376/222864100-f1e4dedc-7ded-4057-a38e-8ba724954b01.png)

Reading it gives
![image](https://user-images.githubusercontent.com/113513376/222864174-94f88f25-492f-4f96-9783-1bf01cd9a271.png)
![image](https://user-images.githubusercontent.com/113513376/222864214-8dc20d19-6e19-4a1c-8950-0fdda3a678e4.png)

What basically is happening is that its running system on base64_decode(payload)

Where the payload is a base64 encoded value

We can't run this on the remote server since we can't access it directly

So i'll just do it manually and take advantage of the ssrf to run system command

Firstly to confirm if it works i'll generate a base64 encoded value to send icmp request to me which i'll then capture using tcpdump
![image](https://user-images.githubusercontent.com/113513376/222864474-f7c9b9db-67b5-4eec-a734-1ba11fa7260e.png)

Then i'll url encode the payload
![image](https://user-images.githubusercontent.com/113513376/222864511-8062e727-a32f-4f37-b9c5-68cd476724e9.png)

With this i will send it to the target
![image](https://user-images.githubusercontent.com/113513376/222864608-70c8b349-931e-490e-b6cf-0c57ef0d3825.png)

Back on tcpdump we get icmp packets flowing
![image](https://user-images.githubusercontent.com/113513376/222864797-b94d282b-cfa3-420e-8ef2-4a8cd896278f.png)

Now i'll repeat the same process but this time we need to get shell 🐚

But note that from the exploit code 

```
# !!spaces are important in order to avoid ==!!
```

So we need to add space if we get `==` from our generated payload

I used curl as its more efficient rather than us url encoding stuffs smh
![image](https://user-images.githubusercontent.com/113513376/222868594-7962c29d-51c5-4cf1-ba61-76743f2022f8.png)

Lets stabilize our shell

```
python3 -c "import pty; pty.spawn('/bin/bash')"
export TERM=xterm
CTRL +Z
stty raw -echo;fg
reset
```

Only one user on the box

```
www-data@Surf:/tmp$ ls -l /home
total 4
drwxr-xr-x 2 james james 4096 Nov  9  2021 james
www-data@Surf:/tmp$ 
```

Looking around the web app files i got this
![image](https://user-images.githubusercontent.com/113513376/222868781-df309945-f575-4d82-9271-1697ce13d3de.png)
![image](https://user-images.githubusercontent.com/113513376/222868791-0a303220-518c-45d0-bfb9-e0256b28dd6f.png)

I tried getting like cred 
![image](https://user-images.githubusercontent.com/113513376/222868990-d5c8d064-dbb9-4478-aba5-2d1d162a20b5.png)
![image](https://user-images.githubusercontent.com/113513376/222869005-b7459e3c-e253-41fc-aca5-3ce76dba4158.png)
![image](https://user-images.githubusercontent.com/113513376/222869023-56105764-577a-4540-8e5c-02331a338f31.png)

But unfortunately i couldn't brute force it

So looking over the other web directory i got another config file
![image](https://user-images.githubusercontent.com/113513376/222869149-8ab9def2-f7c8-49c5-9cd8-cd759b156d39.png)

Trying it to switch as user james with password `FlyToTheMoon213!` works
![image](https://user-images.githubusercontent.com/113513376/222869257-c635c3e6-7af9-46a0-8c4f-9ee7c5076726.png)

Lets get root 🤓

Running `sudo -l` shows the user `james` can run `php /var/backups/database-backup.php` as user `root`
![image](https://user-images.githubusercontent.com/113513376/222869300-a34a95cd-686a-48ca-8c36-5ad3001a93e4.png)

Checking the perm shows that user www-data owns it
![image](https://user-images.githubusercontent.com/113513376/222869402-af932299-208a-4cff-935b-00eff46db155.png)

So if we are user www-data we can replace it to something else then run it sweet

I'll exit my shell to land as user www-data then change its content to change the permission of `/bin/bash` to a `suid` binary
![image](https://user-images.githubusercontent.com/113513376/222870055-51e89a9a-e00e-4613-9b1d-ea102a7338d0.png)
![image](https://user-images.githubusercontent.com/113513376/222870087-7d4b8121-42e3-4001-b76e-99bf97a1e250.png)

And we're done 👻

<br> <br>
[Back To Home](../../../index.md)

