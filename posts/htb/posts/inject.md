<h3> Inject HackTheBox </h3>

### Difficulty = Easy

### IP Address = 10.129.177.221

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/224515453-6958e5a4-ca20-4084-ac6e-5be0585d8ee5.png)

Checking the web server banner doesn't really show anything
![image](https://user-images.githubusercontent.com/127159644/224515492-6327037e-fc63-40ac-b1b7-2f2762729059.png)

Moving over to the web page shows this
![image](https://user-images.githubusercontent.com/127159644/224515512-0b339d81-9534-492b-90c7-713a37e98088.png)
![image](https://user-images.githubusercontent.com/127159644/224515517-2efb83b0-829a-48be-bd68-5d7d93c093ba.png)

I tried registering but its still underconstruction
![image](https://user-images.githubusercontent.com/127159644/224515555-e0758eb4-2a10-4e84-9753-ada6e2ecd3b7.png)

Also attempting to login returns to the home page
![image](https://user-images.githubusercontent.com/127159644/224515573-a052514c-00e2-4453-99c1-07c74c3220e7.png)

But there's a file upload function
![image](https://user-images.githubusercontent.com/127159644/224515583-4653603d-fb3f-4ef2-877c-c5869615611b.png)

I uploaded a valid image and it worked
![image](https://user-images.githubusercontent.com/127159644/224515599-2c33164e-c3f1-4175-ba66-13874a66319d.png)

After i tried accessing the file i got this
![image](https://user-images.githubusercontent.com/127159644/224515619-c8a1aa2a-0a6b-472b-bedd-dcfd1ee2fe69.png)

If you notice the url schema it is including the current file in its current working directory which is our uploaded image

Trying Directory Transversal from the web browser just makes the site go slow

I then tried with curl and it works with directory listing enabled
![image](https://user-images.githubusercontent.com/127159644/224515668-97d86cfa-5e8d-48fc-9d9e-e08ea8f367dc.png)

When i tried accessing ../resources i got an error and also when i then tried /var/www it leaked the web path
![image](https://user-images.githubusercontent.com/127159644/224515721-7cf0899d-1c46-46f4-9ed4-38fc9fc2ff8e.png)

Since i'll be enumerating files on the server i don't want to do it manually so i 
 
I used a bash script to automate listing files [ReadFiles](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/inject/readfiles.sh)

After looking at files on the web server i found this
![image](https://user-images.githubusercontent.com/127159644/224521753-d1ba120f-7efb-4674-9f61-28bbd1db7134.png)
![image](https://user-images.githubusercontent.com/127159644/224521758-07b9d481-5134-4ed8-8c89-f1c96a805ac3.png)

This are the dependencies that the web servers spring framework uses

After looking through them i got a vulnerable version which is this
![image](https://user-images.githubusercontent.com/127159644/224521906-c3763fdc-1bff-4e15-a405-ff58afdecc68.png)

Searching for exploit leads here [Exploit](https://github.com/me2nuk/CVE-2022-22963)

Trying it works
![image](https://user-images.githubusercontent.com/127159644/224523573-9ba444c3-7be1-4004-baf1-0a5cfd1b628c.png)

I tried making an exploit script to give shell but i can't seem to get it work :( 

But when i try using just nc it works but i can't get shell via it[FailedExploit](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/inject/failed_exp.py)
![image](https://user-images.githubusercontent.com/127159644/224523610-11bff5c4-67fd-4bf1-8649-debb40131f83.png)

Anyway lets get shell 
![image](https://user-images.githubusercontent.com/127159644/224523936-c4d4f2ff-54c4-4887-bc1d-9f32407e04cd.png)

For shell i just uploaded a bash reverse shell to /dev/shm , made it executable then specify the full path for it to be run `/dev/shm/lol.sh`
![image](https://user-images.githubusercontent.com/127159644/224524020-3af2d86c-9f50-4e1e-a501-b954de059975.png)

Now lets escalate privilege

Since there are two users we're likely goin to have to escalate to one before escalating to root
![image](https://user-images.githubusercontent.com/127159644/224524036-a2bd3f35-7eae-4084-91a7-1e160c7bad35.png)

Checking around the directories the user can access i get settings.xml which contains a cred for user phil
![image](https://user-images.githubusercontent.com/127159644/224524099-4d1daeac-d3bf-4a91-aa25-5bc593d6832d.png)

Trying it over ssh deosn't work
![image](https://user-images.githubusercontent.com/127159644/224524155-64aacd7b-31c6-42ba-a4ba-c895514eee7e.png)

But switching user to it does
![image](https://user-images.githubusercontent.com/127159644/224524163-ef78f2fa-fd4d-45a1-8983-68c8b278b68f.png)

Now lets escalate privilege to root 🤓
