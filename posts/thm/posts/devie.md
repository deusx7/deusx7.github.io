<h3> Devie TryHackMe </h3>

### Difficulty = Medium

### IP Address = 10.10.85.206

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/230915896-3b2b90ae-f394-4e76-a4e5-d9ad09e97cce.png)

Only two ports open which are ssh and a web server on port 5000

Checking the web server shows this
![image](https://user-images.githubusercontent.com/127159644/230916100-78fc45a4-5761-41b5-9bd5-5d41c8e5b1f2.png)
![image](https://user-images.githubusercontent.com/127159644/230916136-4183fbde-c326-40ea-b2da-eacc4d5a6c94.png)

Instead of checking and testing the functionality of the web server we're given the source code so lets check it out
![image](https://user-images.githubusercontent.com/127159644/230916456-e56b50b7-b4a1-4a2c-bf07-ea05282e5d17.png)

After checking app.py shows the source code for the web server
![image](https://user-images.githubusercontent.com/127159644/230916679-20602b09-cd3e-463e-9ad9-9c7bf81a20fd.png)
![image](https://user-images.githubusercontent.com/127159644/230916719-249a419d-3d62-4f1b-b4a7-d189e194c2bc.png)
![image](https://user-images.githubusercontent.com/127159644/230916754-4d98eac8-430f-43ab-b9ca-dcc86fe21512.png)
![image](https://user-images.githubusercontent.com/127159644/230916794-5d5fb04d-e9f4-424c-a7c5-3536c58ae008.png)

The vulnerability i then saw is this
![image](https://user-images.githubusercontent.com/127159644/230916932-0999435d-003a-40d0-9b1f-78f97f5b9fc7.png)

```
@app.route("/")
def bisect(xa,xb):
    added = xa + " + " + xb
    c = eval(added)
```

When a post request is made to `/` with the value xa and xb it then sums it up but the problem there is that it uses `eval` which can basically evaluate any python command given to it

So I made a script to give us the reverse shell xD

Here it is [Shell](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/devie/shell.py)

Running it gave me a reverse shell
![image](https://user-images.githubusercontent.com/127159644/230921428-1f289160-63ef-413d-a103-c42c51809472.png)

From there we can get flag1.txt
![image](https://user-images.githubusercontent.com/127159644/230921954-2bbeeabb-218e-4639-a4ca-bfd9bd3e0af5.png)

```
Flag1: THM{Car3ful_witH_3v@l}
```

Reading the note shows this
![image](https://user-images.githubusercontent.com/127159644/230922327-2496158c-3eae-44ac-9a9c-28e13441d6cd.png)

```
Super Secure Key: NEUEDTIeN1MRDg5K
```

So lets check out the script then!

But we don't have permission over it
![image](https://user-images.githubusercontent.com/127159644/230923206-5f9ae889-07f3-4b59-a0c1-cfd47b47088d.png)

Checking sudo permission shows that we can run the script as gordon
![image](https://user-images.githubusercontent.com/127159644/230923389-cfdef594-a243-4e1e-9e73-976879a0d7de.png)

Running it works
![image](https://user-images.githubusercontent.com/127159644/230924668-06da95d4-116a-401f-962c-8370e3774a56.png)

I created a password to encrypt as `pwnerhaxor` and it gave me its encoded value

Then i used python to decode it and then use the value i wanted to encrypt which is `pwnerhaxor` as the key XOR should use

But the real key doesn't seem to be complete yet `supersecre`

So i used a longer text
![image](https://user-images.githubusercontent.com/127159644/230925204-0c3a109b-ac26-4ce1-8ffa-1473039149a6.png)

And i got the real xor key

Now i can decode gordon password since we know the key `supersecretkeyxorxor`
![image](https://user-images.githubusercontent.com/127159644/230926034-fe2db549-02f4-47d1-92ff-a1a0eb8a68eb.png)

It decoded to `G0th@mR0ckz!Q<|b@fX!` but when i tried switching to user gordon it doesn't work

After trying various pattern i got `G0th@mR0ckz!` to work

Now we can ssh as `gordon:G0th@mR0ckz!`

We can get the second flag
![image](https://user-images.githubusercontent.com/127159644/230926578-6a42594b-20aa-449e-ba41-cd0d094e26a5.png)

```
Flag2: THM{X0R_XoR_XOr_xOr}
```

After uploading pspy to the target and running it i got this process running as root
![image](https://user-images.githubusercontent.com/127159644/230928074-a98887ea-4bc2-49e3-984a-4476778dde95.png)

```
2023/04/10 15:02:02 CMD: UID=0    PID=2145   | /usr/sbin/CRON -f
2023/04/10 15:02:02 CMD: UID=0    PID=2146   | /bin/sh -c /usr/bin/bash /usr/bin/backup
2023/04/10 15:02:02 CMD: UID=0    PID=2148   | cp report1 report2 report3 /home/gordon/backups/
2023/04/10 15:02:02 CMD: UID=0    PID=2147   | /usr/bin/bash /usr/bin/backup
```

I downloaded the backup binary locally 
![image](https://user-images.githubusercontent.com/127159644/230928764-3a5f2ef5-bdbf-4a05-b78d-ab5ea907a95d.png)

Checking it shows that its just a bash script that does this
![image](https://user-images.githubusercontent.com/127159644/230928875-8633f4b8-4136-475b-8a1a-c4c19aaf27bb.png)

```
#!/bin/bash
cd /home/gordon/reports/
cp * /home/gordon/backups/
```

Cool so its running as root here's what we can now do

We can copy `/bin/bash` to `/home/gordon/reports/` then set suid perm on it so that when crons run it's permission will be changed to root
![image](https://user-images.githubusercontent.com/127159644/230930600-f519fe1c-7607-402a-8266-be37e1b457d9.png)

But after i checked `/home/gordon/backups` the bash binary doesn't have setuid perm
![image](https://user-images.githubusercontent.com/127159644/230931039-40cf5020-31ad-4a1b-baa6-f0a6a56f98f9.png)

And that's because when cp is used to copy an suid binary it drops its permission so we can use the mode 

Then i checked cp help from my terminal
![image](https://user-images.githubusercontent.com/127159644/230932150-6e50d764-bb4e-4a87-9c67-897f4a80174c.png)

Seems if we use `--preserve=mode` will prevent permission dropage
![image](https://user-images.githubusercontent.com/127159644/230937146-c8c85ed8-682b-4615-946b-b5c43f32bb3b.png)

After doing that when we check /home/gordon/backups the sh binary should have setuid permission
![image](https://user-images.githubusercontent.com/127159644/230937529-e6d8dc85-bae8-4a7b-bcd2-43f30d2d28ca.png)

We can get the root flag from there

```
Flag: THM{J0k3r$_Ar3_W1ld}
```

And we're done 👻
