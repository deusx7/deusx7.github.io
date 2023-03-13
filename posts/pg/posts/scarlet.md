<h3> Scarlet Proving Grounds Practice </h3>

### Difficulty = Intermediate

### IP Address = 192.168.90.222

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/224586187-fae11163-7370-4fea-86ae-d99473807e2f.png)

We have ssh, nfs and http open 

Going over the web server shows the domain name
![image](https://user-images.githubusercontent.com/127159644/224586517-d17413ea-3d64-4146-a68e-72b4d6b49d59.png)

I added that to my `/etc/hosts` file 
![image](https://user-images.githubusercontent.com/127159644/224586558-8d9aead4-2ba2-4372-843e-393ae1b9d2b0.png)

I'll see what mount is available on the nfs share
![image](https://user-images.githubusercontent.com/127159644/224586592-6e77df84-ec35-46e8-ac47-37b06ca6d119.png)

Cool there's a share which is accessible to everyone

I will mount it to my host
![image](https://user-images.githubusercontent.com/127159644/224586786-89c57c01-f0cb-4f94-aef1-fe69f327a56d.png)

There's a public key hmmmm 🤔

For now we can't do anything with it so lets enumerate the web server

Goin over to the web server shows this page
![image](https://user-images.githubusercontent.com/127159644/224586869-8dca2727-f94a-476a-a970-fc56b708e5c2.png)
![image](https://user-images.githubusercontent.com/127159644/224586892-2cdebbd1-dd0c-4e54-bb3c-6140a237cb6e.png)
![image](https://user-images.githubusercontent.com/127159644/224586925-f17a4107-7460-4830-97b2-0ba73bcf4965.png)

The page is just a static page and the only button thats clickable is /portal
![image](https://user-images.githubusercontent.com/127159644/224587000-49f9c564-3e58-4d21-b6cc-bb78d2640789.png)

Going over there shows a login/signup page
![image](https://user-images.githubusercontent.com/127159644/224587029-dfab68d9-dd29-4224-9844-60e06207da1c.png)

Since i don't have any cred any default / weak cred doesn't work i'll signup 
![image](https://user-images.githubusercontent.com/127159644/224587082-338e2f9c-d819-4129-a26f-3565fce97df3.png)

After logging in, it redirects to this page
![image](https://user-images.githubusercontent.com/127159644/224587183-ea099eb0-3d4d-4ec4-9f19-867137e00f36.png)

If you notice the page it shows the user name we logged in as 

Checking the available cookie shows this session cookie
![image](https://user-images.githubusercontent.com/127159644/224587252-d37a9682-1b9b-4b66-98d5-fb94aefdcffa.png)

So this is a JWT token and you can tell cause it follows the pattern for JWT token which is `header.value.signature`

Using [jwt.io](https://jwt.io/) we see the jwt algorithm which is `RS256`
![image](https://user-images.githubusercontent.com/127159644/224587413-53993398-1740-41fe-9610-9322aedd9488.png)

After this i remembered that we got a public key value initially and from searching google i saw that you can likely perform `JWT Confusion Attack`

Here are the resource that helped me out
[Medium](https://nav7neeet.medium.com/jwt-key-confusion-attack-part1-556c2db4f148)
[Portswigger](https://portswigger.net/web-security/jwt/algorithm-confusion)
[Auth0](https://auth0.com/blog/how-to-handle-jwt-in-python/)

Now the idea is that:

```
1. I'll change the algorithm from 'RS256' TO 'HS256'
2. Sign the new HS256 token
```

Initially i tried using jwt.io but i was having issue with it. So what i did then was to learn the way jwt can be used in python 

And i ended up scripting the signing of new signature using python

Here's the script to sign a new signature [Sign](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/pg/scarlet/signkey.py)

Now when i'll run it and pass an argument which is the username 
![image](https://user-images.githubusercontent.com/127159644/224588181-d783cb6d-943b-4494-afc2-97af773da2ac.png)

It will create a new HS256 JWT token 

So now i will refresh the page and replace the initial cookie with that and excluding `=`
![image](https://user-images.githubusercontent.com/127159644/224588374-7ad4a3e8-9383-4d33-b7d2-f600bf670075.png)

It worked but also looking at the error message it seems like its attempting to retrieve the user from the database

This might be a form of database injection

I'll confirm it
![image](https://user-images.githubusercontent.com/127159644/224588632-09dedb80-4b25-4fdc-8bbd-01b46f3ceef0.png)
![image](https://user-images.githubusercontent.com/127159644/224588826-dfbb7030-915d-47b0-8a8a-a9727341c7b6.png)

Yea its SQL Injection 

From here we want to start performing database enumeration then dumping it

Since its not like a url the injection is based during it manually would take a lot of time

So i wrote a script to automate stuffs [Injection](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/pg/scarlet/inject.py)

Note that it uses a proxy i put that in there for debugging so make sure burp is open or you remove the proxy from the script

Running it makes db enumeration easier
![image](https://user-images.githubusercontent.com/127159644/224589695-df49c097-785e-452e-9fb9-44f6e9bd1f27.png)
![image](https://user-images.githubusercontent.com/127159644/224589720-cf6fd052-a6fd-4586-9484-829b0cb5beca.png)
![image](https://user-images.githubusercontent.com/127159644/224589760-2050fb7f-cb22-4577-a4ad-c29cdcd48dfa.png)

So this means the number of database present is 3 

Also you should note that this isn't MYSQl but rather SQLite making the db enumeration different

Here's the resource that helped me out [PayloadAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/SQLite%20Injection.md)

This is what i did:

```
Get Table Name: ' union select sql,2,3 from sqlite_master where tbl_name = 'users' and type = 'table' --
```
After doing that i got 
![image](https://user-images.githubusercontent.com/127159644/224590967-f3fc3de8-16bc-4718-8d98-8eb8adc3df76.png)

There's a password column so i extracted it also

```
' union select password,2,3 from users --
```

After doing that some word which looked like cred
![image](https://user-images.githubusercontent.com/127159644/224591328-38284f67-3641-4adf-890f-fec27da95b00.png)

But if it were to be cred where would we log in ?

I checked the home page back and saw the teams
![image](https://user-images.githubusercontent.com/127159644/224591503-b1b26114-1fc2-4218-933c-ebe393431a34.png)

`Brain Harper` looks promising cause he's the web admin

Trying it over ssh works `brain:Standingbytheseaside12`
![image](https://user-images.githubusercontent.com/127159644/224591608-ac50de60-c0c6-4633-85a5-ce7b438a59f7.png)










