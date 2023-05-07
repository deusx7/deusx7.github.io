<h3> Monitors Two </h3>

Difficulty = Easy

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/236706924-2c717963-1502-478f-88fa-3c3fc732acc8.png)

Checking the web server on port 80 shows an instance of *Cacti Version 1.2.22 * 
![image](https://user-images.githubusercontent.com/127159644/236707001-64ac9a50-c482-406d-b0f4-206aae36da70.png)

Searching google for default credentials show that it's *guest:guest*

After attempting to loggin in with it doesn't works

Then since we know the version i searched up google for [exploit](https://www.rapid7.com/db/modules/exploit/linux/http/cacti_unauthenticated_cmd_injection/) and found this
![image](https://user-images.githubusercontent.com/127159644/236707146-b716274a-a25a-4adf-a120-65f8f4c63b8a.png)

Well I tried using metasploit for it 👀. But for some reason the exploit isn't available on my own version of metasploit I guess i have to save the ruby exploit manually

So I used a github [exploit](https://github.com/FredBrave/CVE-2022-46169-CACTI-1.2.22)

Trying it works
![image](https://user-images.githubusercontent.com/127159644/236707633-bf884d37-b00b-4c81-ae56-6d53f79619c6.png)

We can tell that this is a docker container
![image](https://user-images.githubusercontent.com/127159644/236707820-bdafe220-4b66-406d-a222-1e8c14048263.png)

We can stabilize our shell using:

```bash
/usr/bin/script -qc /bin/bash /dev/null
export TERM=xterm
CTRL +Z
stty raw -echo;fg
```

I uploaded linpeas.sh to the box for further enumeration
![image](https://user-images.githubusercontent.com/127159644/236707872-ca91d3c8-d9b4-47b7-be45-cc2171a2e209.png)


