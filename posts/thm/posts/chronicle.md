<h3> Chronicle TryHackme </h3>

Difficulty = Medium

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f7ee2c74-5e1f-4d75-8d4d-b0b5b2f486a2)

Checking the web instance on port 80 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/71784515-0b27-473a-9a77-61ef766a769e)

Using gobuster I'll fuzz for directories
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/62d7ed93-1659-4a25-b6f7-a6aee60f7554)

It shows another directory called /old checking it shows a note.txt file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4305325b-a2c2-49a2-807b-d55f2aa81753)

Reading its content shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/20314b8a-3563-4c1d-a81f-24453ed26d68)

I'll fuzz for things there again
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/76abb144-02a7-4230-86df-8b0ebc565725)

We can see 200 http code status for */.git/HEAD*

Lets confirm it 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cfe91460-75cc-44be-9cea-6286875f4d31)

Boom we have an exposed .git on the web server

Using *git-dumper* I'll dump its content committed 🙂
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4e108f8b-672d-4b3a-baa3-6436d0f4eba0)

Looking at the cwd we can see *note.txt*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/308df6ff-6601-45aa-a697-3a6ae79d40af)

Checking the git logs gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1bb765ce-35e8-489e-b55b-6ea50f77f1fa)

```
Command: git log
```

Looking through commit one shows the css of the web app
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4bfd8e12-a26d-4d5a-b301-30e631142c45)

While for commit two shows the web app source code
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9a686473-8542-4ce6-91c6-581606421676)

And remember that there's another web server running on port 8081 so likely this is the source code since nmap showed that its based off a python web server

Moving over to port 8081 shows this

