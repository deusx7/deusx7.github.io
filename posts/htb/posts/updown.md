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

There's a function on the web page that allows user to check is a site is up 

I'll test it to know if i can fingerprint anything whether the option chosen is debug mode or not
![image](https://user-images.githubusercontent.com/127159644/224434357-2e5471ed-0fe5-4b19-9dc3-e8f6314094be.png)
![image](https://user-images.githubusercontent.com/127159644/224434500-f4a69762-ff37-460b-a0ab-74fba8c44498.png)

Nothing much expect the domain name which we already know

I'll try it also with debug mode enabled 
![image](https://user-images.githubusercontent.com/127159644/224434661-6860b141-1759-40de-87a0-4c7cb34dbf41.png)
![image](https://user-images.githubusercontent.com/127159644/224434687-7f76a876-7e81-4d74-b95d-a26d4c0f4eaf.png)

Nothing much here also 

I'll fuzz for directories
![image](https://user-images.githubusercontent.com/127159644/224436652-8d204833-fc22-4cc0-ac21-8b78b3b369e8.png)
