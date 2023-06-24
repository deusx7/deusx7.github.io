# Agent-sudo TRYHACKME
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




