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

```config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = http://cody:jh1usoih2bkjaspwe92@gitea.searcher.htb/cody/Searcher_site.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
        remote = origin
        merge = refs/heads/main

```
Doing *sudo -l* using the password gotten from the git config file *jh1usoih2bkjaspwe92* shows we can run `/usr/bin/python3 /opt/scripts/system-checkup.py *` as *root*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5e87f6ac-ae6f-43ca-b9d3-241f5553f2ed)

We don't have read access over this script */opt/scripts/system-checkup.py* as it's owned by user *root*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/baa0a54e-b0a0-415c-99b1-d87411e2cc8f)

But remember when we logged at the git config it was connecting to the gitea which usually runs on port 3000

Checking for internal ports shows that there's a service which is likely gitea running on port 3000
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0eb61930-a04d-4021-b87e-958c55064700)

I used ssh local port forward to access it from my host
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e5ca70f2-f304-407f-874a-9b5390b647eb)

Now accessing the gitea instance and loggin in as user *cody* works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/41145d03-65cc-45f5-91dd-896856584447)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/daf254f8-c587-4f1e-8f2f-20ae22dad26d)

But after looking around there's no repository that looks interesting there
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c6b41248-484f-4baf-acb3-2f2fffddd424)

Back to the script we can run as sudo

It has various options we can pass it as argument
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c4c00c83-d1cb-4a74-a6fe-2778ebc6f42e)

The docker-ps option just checks the process of the docker containers running 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/dbaa4708-104c-4128-9240-43c8bf01a586)

And we can see the two containers running are gitea and mysql_db (this looks more beneficial)

The docker-inspect requires two argument which are the format to be used and the container name
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fcd048f8-805e-46c0-b303-20bc2a47bc3e)

Since it's basically going to be running a docker inspect command which is indeed a valid command
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/676f255e-2d34-45f7-8680-6f8e40adf983)

I just googled for the type of format it needs
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4a483977-5351-4fb7-8cff-efdfc7cbd2f1)

From the docker [docs](https://docs.docker.com/engine/reference/commandline/inspect/) the last option seems to get the subsection which is dumped in its json format

Using that and the mysql_db as the container gives this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/23eab51e-7993-4ac4-afae-7ade770efcca)

It looks quite confusing so i arranged it well
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/28b8e709-041d-4ead-b86e-5a44e0b9e822)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2aac515f-d044-4c31-a420-5b8274877eff)

That looks like a cred sweet 😄

Trying to login as *administrator:yuiu1hoiu4i5ho1uh* works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6d96a15f-0cf5-459a-99d0-d4dab18299f9)

Going over to the scripts repo shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e3b6cb03-734d-405c-86c4-4f79ceea9082)

That means that the script we ran as sudo is here

Reading it show this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/718bd151-1c74-4f19-8195-5b63fc259d64)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/644ce4d0-7e20-458b-8fa0-75c0695425e8)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6b4c78d1-bbaf-4281-b415-6c0e02285c52)

Remember we already tried those first two options and nothing really looks interesting from the code

But as for the third option we can see that it first runs a script *full-checkup.sh* before it prints out Done!

Looking back at the box shows we have don't have full access over the script
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/66630fde-42eb-4b34-8a51-a36e29bcc365)

But since the full path isn't specified we can create our own malicious file then when we run the script with sudo with the third function our malicious script will run also

Trying that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f87f6949-1237-4c48-a246-d0cc447bbf01)

We can now get shell as root
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ba96e13f-52d9-482f-b844-f6976a4e4f10)

And we're done 👻
