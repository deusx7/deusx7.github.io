<h3> Zeno TryHackMe </h3>

### Difficulty = Medium

Let's start with scanning for open ports 

I use rustscan to get the ports then nmap to scan specific ports
![image](https://user-images.githubusercontent.com/127159644/235651240-ef4fb2ce-0553-4eac-9937-62d857ed6d70.png)

We can see there's a web service running on port *12340*

Navigating to it shows this
![image](https://user-images.githubusercontent.com/127159644/235651114-1235e03f-726e-4054-a47e-f3c92e385e6c.png)

Nothing really interesting there so I ran gobuster to fuzz for directories and luckily I got this
![image](https://user-images.githubusercontent.com/127159644/235651381-e1fe94c2-d810-4b2f-98e6-2133c07cf6e6.png)

```
Wordlist Used: /usr/share/seclists/Discovery/Web-Content/big.txt
```

Going over the directory on the web server shows this
![image](https://user-images.githubusercontent.com/127159644/235651543-746a7790-a2dc-405c-9165-f0908b4e6119.png)

The name of the web service got me thinking *Pathfinder Hotel Restaurant* 

So I searched for [exploit](https://www.exploit-db.com/exploits/47520) and saw this RCE
![image](https://user-images.githubusercontent.com/127159644/235651729-ebc6e2c3-d51f-4a1a-b100-3e6af2ffb4e2.png)

Trying it works 
![image](https://user-images.githubusercontent.com/127159644/235652887-11bd754a-ae08-429e-95f3-5aa7db33e047.png)

We can now confirm it by accessing it and executing a command
![image](https://user-images.githubusercontent.com/127159644/235652964-e9250e2e-783c-4472-a97f-dbcdf294e60c.png)

Now lets get a reverse shell :D

I url encoded my python reverse shell 
![image](https://user-images.githubusercontent.com/127159644/235653596-1f204300-394c-4981-813e-798f46af8511.png)

So we get the shell 😉
![image](https://user-images.githubusercontent.com/127159644/235653724-134efc4c-5cf5-4c3e-9f66-ef96360ba685.png)

Our user perm sucks right?

Lets escalate privilege *Best will be to switch to user edward*

But I tried playing around and got the db password but it didn't work while i tried using it via ssh or switching to user edward

I then logged in to the db and got some hashes after cracking it and trying it, it also didn't work
![image](https://user-images.githubusercontent.com/127159644/235658352-21398100-d234-43c6-98fe-845b6bf6dd19.png)
![image](https://user-images.githubusercontent.com/127159644/235658425-e4a85462-069e-41d8-a774-13e973c107a5.png)
![image](https://user-images.githubusercontent.com/127159644/235658463-a869b0c5-7a36-47bb-8a8d-9e4102fb83e1.png)

So i ran linpeas to see what else is interesting

After running it I got this cred *FrobjoodAdkoonceanJa*
![image](https://user-images.githubusercontent.com/127159644/235661487-0ae0868f-1d14-43ea-888f-92dd3b622eac.png)

Trying to ssh to user edward with it works
![image](https://user-images.githubusercontent.com/127159644/235661733-16bd96f6-8690-4427-9fed-bc59f98c619e.png)

Now lets escalate privilege to root

Running *sudo -l* shows we can reboot any service
![image](https://user-images.githubusercontent.com/127159644/235664935-c0ce7a53-3e70-42ee-9822-e53c23382c68.png)

We now need a service that is writeable and searching for it we get one 🤓
![image](https://user-images.githubusercontent.com/127159644/235665161-a3366d89-f722-489e-82bc-ea1485568819.png)

Checking its content shows it starts the script running at */root/zeno-monitoring.py*
![image](https://user-images.githubusercontent.com/127159644/235665255-8d6385be-62cf-4a18-aecb-d1018e840925.png)

I'll replace its content with this:
![image](https://user-images.githubusercontent.com/127159644/235668365-f3db23a0-e9f7-4b31-964c-c9e0f95b1f7e.png)

```
[Unit]
Description=Zeno monitoring

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'chmod +s /bin/bash'

[Install]
WantedBy=multi-user.target
```

So now when we restart the box and login */bin/bash* should have *SUID* permission set on it
![image](https://user-images.githubusercontent.com/127159644/235669434-32f06385-94de-47c3-87be-d5ae303a24c8.png)

And we're done 👻
