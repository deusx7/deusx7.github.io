# Agent Sudo TRYHACKME
***
## DIFFICULTY : EASY
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/fa537622-4898-4eb1-a32a-7e255ca2057b)


***

A quick nmap Scan gives us this:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/09b58d7a-6158-4f3a-ac3b-20ea92a959d3)

We can see that we have **port 21,22,80** opened, Port 80 looks juicy, We have an **Announcement** Http-Title.

***

Moving to the website we get this message:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/dfa5a29d-5a91-4219-810d-9428f6481b78)

We are asked to use a **codename** as `user-agent` to access some information on the site
- We can use the **hackbar** browser extension or **burp suite** to do this🤠
- In this case i will be using **hackbar**
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/d63bd939-64fd-4118-bf84-5adcef4f2006)

Changing the value of the User-Agent to **C** gave us some useful information:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/d039ae47-add9-44e1-94d3-bcbccb226e58)
***

Now we are known as `chris`, We have successfully enumerated our target and can now bruteforce **FTP** on port 21 using **hydra**:

Syntax: `sudo hydra -t 4 -l chris -P /usr/share/wordlists/rockyou.txt  -vV 10.10.115.114 ftp`
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/58627b49-1387-4f86-b125-acb1c87384a3)

Login To FTP with `ftp chris@10.10.115.114` and **mget** the files:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/6bfecaa2-91f8-4fe2-ae88-f4e894fbdbc6)

We can run `binwalk` in other to see all files embeded in each other:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/dd834bb0-9e32-4d0c-a8ff-179b45d857e2)

We can see here that **cutie.png** has some zip archives, extract the archives with `binwalk -e cutie.png`, After extraction we get  a folder:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/ad4b66a8-b0d5-4024-bada-9cd725b879d0)

We get a zip file here and it requires a password, we can bruteforce with **john**, but first of all create a password hash with **zip2john** and then bruteforce:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/398518e4-fa71-4deb-a829-0743abbf258e)

We got a password again, use it on the **8702.zip** by using the command:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/a43f85e1-79d7-4ba1-8642-7db7570c93d6)

Make sure to type the **password** at the end of the prompt and type **yes**
Now we have got a **To_agentR.txt** file, concatenating it gives us an output that says;
```
Agent C,

We need to send the picture to 'QXJlYTUx' as soon as possible!

By,
Agent R
```
Great we have got a base64 encoded data, **QXJlYTUx**, just do `echo QXJlYTUx | base64 -d` in your terminal to decode.

I think this should be the password to a steg .jpg file, remember the files we got from FTP, we have another image file, let try it out:
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/8a9aff69-994a-4d98-9609-1622b12808b6)

Time to login through **SSH<port 22>**:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/68032a81-aedd-4e2f-a01c-1b51ad805a9a)

We got the user flag and an image, We are asked to lookup the image 🙃
- You can use [tinyEye](https://tineye.com/) to perform an image reverse
- Fox News tell us it is a "Roswell alien autopsy" ✔️

***
## Priviledge Escalation
***
- We are logged in as user **james**.
- We can't view the root folder, neither the content in it😮‍💨.
- A quick `sudo -l` tells us we can run bash
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/58c36527-6bcf-4789-8c54-26b5a45923f1)

Tested this by getting a reverse shell using **gtfobins**
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/9a448768-cb64-407f-8b62-d74e4335259b)

- After much enumeration, we found out that it is vulnerable to [CVE-2019-14287](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-14287),which allows bypass of !root configuration, and USER= logging, for a **"sudo -u#-1 /bin/bash"** command.
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/bc98d6f8-45dd-4562-9b50-a83df3fb5181)

Happy Hacking🥱//
