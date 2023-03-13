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



