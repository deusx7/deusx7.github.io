<h3> Busqueda HackTheBox </h3>

Difficulty = Easy

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/086b72bb-0475-4e36-a09b-da257e6442de)

I'll add the domain *searcher.htb* to my */etc/hosts* file

Going over to the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ac485c9c-b4fa-42f0-aab9-0c70ab99dfac)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5405720d-0967-4cb3-9101-d2953c465f63)

So basically this is a server that uses any search engine chosen and returns a query of what the users searches for
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/025f89a9-39ec-4e31-b5eb-e4601c099da0)

Below the web app the github link for the source code is given
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/96880a73-09c1-4d09-81c6-a67727092d10)

I didn't really spend time looking at the source code

But here's what I then decided to try

Since we know it's a python based web app

I tried python code injection

Here's a good [resource](https://sethsec.blogspot.com/2016/11/exploiting-python-code-injection-in-web.html) on it 

Getting it to work was a little bit tricky tho cause I had to include '+{payload}+'
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0846344f-83f6-4c79-b95a-267531d34523)

Back on my tcp dump listener
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/607fa259-dabe-4858-868f-c083d9caa5f2)

So we can get shell from here
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/80a41bf2-dfe5-4069-8686-d7344af0249d)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5c8bd117-978d-4693-81d2-bb91ff65135a)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bc5c3960-e70e-430d-90e4-77e9be811f82)

Looking at the user cwd shows a git directory and viewing the config file shows a password
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/23e7ee9b-f143-4eef-ad64-a23d8706a2d1)

Doing *sudo -l* using the password gotten from the git config file *jh1usoih2bkjaspwe92* shows we can run `/usr/bin/python3 /opt/scripts/system-checkup.py *` as *root*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5e87f6ac-ae6f-43ca-b9d3-241f5553f2ed)
