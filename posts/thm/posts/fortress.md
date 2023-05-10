<h3> Fortress TryHackMe </h3>

Difficulty = Medium

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b90c908d-b712-4207-b663-334cf62092b1)

Lets start enumeration from ftp 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/584e61c6-87d3-48cb-bdb3-0d832ee5c27f)

Reading the *marked.txt* file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/de3ab684-1e53-49d5-9494-552336f8eec3)

While checking the file type for the *file* shows it's a python compiled binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e8252502-7679-416a-a5f3-3f21526834b9)

Lets decompile it using [uncompyle2](https://github.com/wibiti/uncompyle2)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d3c64e11-2d32-4558-bc2e-e1bbf94790a0)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/05362c40-c0bf-4158-9aa3-0fe89383676f)

We can see what it does. It creates a socket running on port *5752* and it asks for username and password, If the provided username and password is correct it calls the secret() function which basically opens up the *secret.txt* file

But the username and password is converted from bytes to long I wrote a script to decode it

```python
#!/usr/bin/python3
# Author: Hack.You
from Crypto.Util.number import long_to_bytes

usern = 232340432076717036154994
passw = 10555160959732308261529999676324629831532648692669445488

print(f'Username: {long_to_bytes(usern)}')
print(f'Password: {long_to_bytes(passw)}')
```

Running the script gives the username and password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/071f17a7-1409-409b-b5ac-360259859634)

Now lets connect to the remote socket hosted on port 5752
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d01ccd61-877e-4f5a-8260-2941292587fb)

It gives us this `t3mple_0f_y0ur_51n5`

What can we do with this now 🤔

Lets move over to the web server 

Checking it just shows the normal apache default web page

Fuzzing for
