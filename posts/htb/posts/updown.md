<h3> UpDown HackTheBox </h3>

### Difficulty = Medium

### Ip Address = 10.10.11.177

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/224432299-970a1bea-5924-4862-ad50-2622007b746b.png)

Only two tcp ports open 

Checking the web server which is running on port 80 shows this
![image](https://user-images.githubusercontent.com/127159644/224432541-221297d8-5a2b-4ed9-bf7f-4e2b57f45d4f.png)

And below shows the domain name `siteisup.htb`

I'll add that to my `/etc/hosts` file

```
┌──(mark㉿haxor)-[~/Desktop/B2B/HTB/Updown]
└─$ cat /etc/hosts | grep site
10.10.11.177    siteisup.htb
```

