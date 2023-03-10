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

There's a .git directory in /dev and we can confirm it
![image](https://user-images.githubusercontent.com/127159644/224441793-de13e0cb-b211-41bd-b3c4-f7eaefe42032.png)

I'll also fuzz for vhosts
![image](https://user-images.githubusercontent.com/127159644/224441820-5690914b-2daf-46a1-9370-80e2b4ae5dd0.png)

I added `dev.siteisup.htb` to my `/etc/hosts` file

```
┌──(mark㉿haxor)-[~/Desktop/B2B/HTB/Updown]
└─$ cat /etc/hosts | grep siteisup
10.10.11.177    dev.siteisup.htb siteisup.htb
```

Checking the vhosts gives 403
![image](https://user-images.githubusercontent.com/127159644/224442179-1ad1da39-1875-4974-ae7c-7354f6d60166.png)

So i'll use git-dumper to dump the .git directory 
![image](https://user-images.githubusercontent.com/127159644/224442398-6c40dc1d-077c-42f6-bc9f-b39b0821b2f7.png)

Here are the contents
![image](https://user-images.githubusercontent.com/127159644/224442568-0db1dc31-21c8-4894-96ae-e303767e4ff6.png)
![image](https://user-images.githubusercontent.com/127159644/224442624-64491895-6d3c-498e-b605-10f65d75ad3d.png)

The content of checker.php
![image](https://user-images.githubusercontent.com/127159644/224442942-03e929f7-d240-415f-ba69-fc649d2fb20e.png)
![image](https://user-images.githubusercontent.com/127159644/224442969-b8784c0c-1143-4c5e-af10-21f2df3869d7.png)
![image](https://user-images.githubusercontent.com/127159644/224443004-b91ba34d-75bf-416b-81e0-95df7d2c8d4c.png)
![image](https://user-images.githubusercontent.com/127159644/224443034-3241d735-a162-48dc-b5d9-4933b22fbb21.png)

Here's the content of index.php
![image](https://user-images.githubusercontent.com/127159644/224443081-4d94935a-d38e-416d-8457-172703bd5c77.png)

From the source code we see that the checker.php allows file upload while index.php is vulnerable to local file inclusion

And from the filter we see it filers anything `php and php[0-9] i.e php1, php2,....,php9` 

Also the index.php script first checks if the "page" parameter is set and if it does not contain any of the prohibited directory names ("bin", "usr", "home", "var", or "etc"). If both conditions are true, it includes the corresponding PHP file using the "include" function. If the "page" parameter is not set or if it contains one of the prohibited directory names, it includes a file called "checker.php".

