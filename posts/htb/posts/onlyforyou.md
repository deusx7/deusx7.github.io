<h3> OnlyForYou HackTheBox </h3>

Difficulty = Medium

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/236711287-ceef7d4e-9e1b-4ac7-badc-ebe28f16d87c.png)

Update your */etc/hosts* file with the content of the domain name *only4you.htb*

Going over to the web server shows this
![image](https://user-images.githubusercontent.com/127159644/236711396-45b855af-4ddc-4ac6-87a5-352a24ba7d72.png)

Using *ffuf* I fuzzed for vhosts
![image](https://user-images.githubusercontent.com/127159644/236711542-c0362d61-3615-4337-964a-b9767825ec42.png)

Adding the new vhosts *beta.only4you.htb* to my */etc/hosts* file
![image](https://user-images.githubusercontent.com/127159644/236711590-70da737f-b94f-4e51-8266-b1b4124cf0de.png)

Checking the vhost shows this
![image](https://user-images.githubusercontent.com/127159644/236711622-20a4ed18-e7fc-4ab4-9bef-115d93b2d1f5.png)

I downloaded the source code for this web instance
![image](https://user-images.githubusercontent.com/127159644/236711685-b024754b-a351-45b8-bc32-75ec0f69703e.png)

There's a file upload functon but I didn't particularly find it interesting cause it was rather secured to me 🤔

But here's the vulnerable part of the code
![image](https://user-images.githubusercontent.com/127159644/236711846-fd096b18-edfa-475a-bfe6-d9d867d0b989.png)

The user can query files for download and there's a prevention against LFI but we can still achieve file inclusion without using *../*
![image](https://user-images.githubusercontent.com/127159644/236712019-dbbffe0c-5cf4-445f-8518-c5e59f253816.png)

I made a [script]() to automate finding of files 
