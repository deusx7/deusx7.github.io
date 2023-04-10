<h3> Devie TryHackMe </h3>

### Difficulty = Medium

### IP Address = 10.10.85.206

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/230915896-3b2b90ae-f394-4e76-a4e5-d9ad09e97cce.png)

Only two ports open which are ssh and a web server on port 5000

Checking the web server shows this
![image](https://user-images.githubusercontent.com/127159644/230916100-78fc45a4-5761-41b5-9bd5-5d41c8e5b1f2.png)
![image](https://user-images.githubusercontent.com/127159644/230916136-4183fbde-c326-40ea-b2da-eacc4d5a6c94.png)

Instead of checking and testing the functionality of the web server we're given the source code so lets check it out
![image](https://user-images.githubusercontent.com/127159644/230916456-e56b50b7-b4a1-4a2c-bf07-ea05282e5d17.png)

After checking app.py shows the source code for the web server
![image](https://user-images.githubusercontent.com/127159644/230916679-20602b09-cd3e-463e-9ad9-9c7bf81a20fd.png)
![image](https://user-images.githubusercontent.com/127159644/230916719-249a419d-3d62-4f1b-b4a7-d189e194c2bc.png)
![image](https://user-images.githubusercontent.com/127159644/230916754-4d98eac8-430f-43ab-b9ca-dcc86fe21512.png)
![image](https://user-images.githubusercontent.com/127159644/230916794-5d5fb04d-e9f4-424c-a7c5-3536c58ae008.png)

The vulnerability i then saw is this
![image](https://user-images.githubusercontent.com/127159644/230916932-0999435d-003a-40d0-9b1f-78f97f5b9fc7.png)

```
@app.route("/")
def bisect(xa,xb):
    added = xa + " + " + xb
    c = eval(added)
```

When a post request is made to `/` with the value xa and xb it then sums it up but the problem there is that it uses `eval` which can basically evaluate any python command given to it

So I made a script to give us the reverse shell xD

Here it is [Shell](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/thm/devie/shell.py)

Running it gave me a reverse shell
![image](https://user-images.githubusercontent.com/127159644/230921428-1f289160-63ef-413d-a103-c42c51809472.png)

From there we can get flag1.txt
![image](https://user-images.githubusercontent.com/127159644/230921954-2bbeeabb-218e-4639-a4ca-bfd9bd3e0af5.png)

```
Flag1: THM{Car3ful_witH_3v@l}
```

Reading the note shows this
![image](https://user-images.githubusercontent.com/127159644/230922327-2496158c-3eae-44ac-9a9c-28e13441d6cd.png)

```
Super Secure Key: NEUEDTIeN1MRDg5K
```

So lets check out the script then!

But we don't have permission over it
![image](https://user-images.githubusercontent.com/127159644/230923206-5f9ae889-07f3-4b59-a0c1-cfd47b47088d.png)

Checking sudo permission shows that we can run the script as gordon
![image](https://user-images.githubusercontent.com/127159644/230923389-cfdef594-a243-4e1e-9e73-976879a0d7de.png)

Running it works
![image](https://user-images.githubusercontent.com/127159644/230924668-06da95d4-116a-401f-962c-8370e3774a56.png)

I created a password to encrypt as `pwnerhaxor` and it gave me its encoded value

Then i used python to decode it and then use the value i wanted to encrypt which is `pwnerhaxor` as the key XOR should use

But the real key doesn't seem to be complete yet `supersecre`

So i used a longer text
![image](https://user-images.githubusercontent.com/127159644/230925204-0c3a109b-ac26-4ce1-8ffa-1473039149a6.png)

And i got the real xor key

Now i can decode gordon password since we know the key `supersecretkeyxor`
![image](https://user-images.githubusercontent.com/127159644/230926034-fe2db549-02f4-47d1-92ff-a1a0eb8a68eb.png)

It decoded to `G0th@mR0ckz!Q<|b@fX!` but when i tried switching to user gordon it doesn't work

After trying various pattern i got `G0th@mR0ckz!` to work

Now we can ssh as `gordon:G0th@mR0ckz!`

We can get the second flag
![image](https://user-images.githubusercontent.com/127159644/230926578-6a42594b-20aa-449e-ba41-cd0d094e26a5.png)

```
Flag2: THM{X0R_XoR_XOr_xOr}
```



