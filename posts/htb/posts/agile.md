<h3> Agile HackTheBox </h3>

#### Seasonal Machine 1

#### Difficulty = Medium

Nmap Scan:
![image](https://user-images.githubusercontent.com/113513376/222959816-18341b35-f08f-4045-9244-3bbd7df0441b.png)

We see the domain name i'll it to my `/etc/hosts` file

```
┌──(mark㉿haxor)-[~/Desktop/B2B/HTB/Agile]
└─$ cat /etc/hosts | grep supe
10.129.169.172  superpass.htb
```

Going over to the web server shows this
![image](https://user-images.githubusercontent.com/113513376/222960024-e08e6751-2b8c-4d55-8b5c-760ed291e89d.png)
![image](https://user-images.githubusercontent.com/113513376/222960044-88db7fe6-8ffe-4488-ad2c-44562bafbf19.png)

I tried login in with default/weak cred but it failed
![image](https://user-images.githubusercontent.com/113513376/222960096-7e240daa-86a3-421f-9209-9c20db2aefe1.png)

When i tried sqli it throws back the debug error
![image](https://user-images.githubusercontent.com/113513376/222960211-35b13542-67c9-4f7f-a613-1259cc3a9bf6.png)

I created an account 
![image](https://user-images.githubusercontent.com/113513376/222960177-d3021b44-8ee6-4d36-a2fd-5b9c78c7c30d.png)

After i log in i get to the /vault
![image](https://user-images.githubusercontent.com/113513376/222960367-08e62a33-adac-49a8-8dc4-9fbb56fbbcae.png)

There are two options in it
![image](https://user-images.githubusercontent.com/113513376/222960411-2676b44b-e54f-44cc-a245-4eb35893148f.png)

To add a password vault and an export function

Clicking on export and intercepting the request shows this
![image](https://user-images.githubusercontent.com/113513376/222960451-9f4eb30c-57c5-414a-b779-33df3a4468f8.png)
![image](https://user-images.githubusercontent.com/113513376/222960464-a421d48b-a256-49ff-aae0-15ffbd6b8478.png)

Since i didn't really create a password vault it says no password found for user

So i created a password vault then intercept the request 
![image](https://user-images.githubusercontent.com/113513376/222960575-0b646e35-0b13-4c25-abbd-d0e488c4d4a6.png)
![image](https://user-images.githubusercontent.com/113513376/222960623-0a9b778e-9663-4084-8388-31b2021bb75a.png)
![image](https://user-images.githubusercontent.com/113513376/222960643-724a3c5b-0035-470c-939a-f9d35ecca685.png)
![image](https://user-images.githubusercontent.com/113513376/222960667-666014c6-0c65-468f-9565-7daa6dc30d1e.png)

It had an issue downloading the password vault file for some reason anyways noticing the url schema

```
http://superpass.htb/download?fn=pwn_export_ecc341d257.csv
```

It looks like its getting the file from the CWD 

So i'll try doing a directory transversal to read `/etc/passwd`
![image](https://user-images.githubusercontent.com/113513376/222960751-cdb5b00c-4a2c-4eb7-9e2b-43ffbb14cdb1.png)
![image](https://user-images.githubusercontent.com/113513376/222960759-826c0168-cfd6-439f-9017-c2265378fec1.png)

Cool we have directory transversal + local file read 

At this point i'll like to know where the app source code is. And the only way i can get that is by fuzzing for `/proc/FUZZ/cmdline` 

You can use ffuf to get the process then view them manually or use a bash command to curl while it fuzzed but i'll use python 

Here's my fuzz script [Fuzz](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/agile/fuzz.py)

Running it takes some while but after it runs finish it creates various file*.txt 

Using a one linear bash command i'll read the content of each of them
![image](https://user-images.githubusercontent.com/113513376/222963104-6f45c1d8-ea14-4d0a-975d-9fae02e2921c.png)

Reading the output.txt file shows the process we fuzzed
![image](https://user-images.githubusercontent.com/113513376/222963170-01295977-29e3-45e6-be54-e0d326950672.png)

And its running `python3` on `app.py ( wsgi:app )`

Remember previously we generated the debug error when we tried loggin in with SQli 

Which also leaked the files

I'll download the app.py file
![image](https://user-images.githubusercontent.com/113513376/222963402-c3ae752a-b18f-4086-b5e1-d77ef90f9622.png)

Also we leaked the vault.py file from the error
![image](https://user-images.githubusercontent.com/113513376/222963444-c118eeb8-c93b-463e-a84e-d4d492aed58c.png)

Here's the file
![image](https://user-images.githubusercontent.com/113513376/222963463-b0569795-1255-4cd6-bbe2-72033f639fe9.png)

Reading the app.py shows more of like the source app file for wsgi server

But vault.py is for the /vault directory
![image](https://user-images.githubusercontent.com/113513376/222963692-2d40b12d-8759-4315-918e-a8ac53af3090.png)
![image](https://user-images.githubusercontent.com/113513376/222963707-51028b70-eb91-47ce-9448-90fea7588b0c.png)
![image](https://user-images.githubusercontent.com/113513376/222963730-6f16cd52-0cb4-41ee-b7cd-45a04e180ef2.png)
![image](https://user-images.githubusercontent.com/113513376/222963743-3814e07a-60e9-499a-9e10-d6a9d2063e80.png)

After reading the code i understood that some routes are for editing the db

But this portion of the code is interesting
![image](https://user-images.githubusercontent.com/113513376/222963953-aa7eeebb-18bd-4d0d-a68a-e5d9f3c995bb.png)

We can tell that:

```
1. It checks if the url is /vault/row/<id> where id=integer
2. Then it uses the password file template
3. It checks if id=<id> 
4. Then it returns the corresponding value of the id being accessed
```

With this we know that since no form of cookie check or some mitigation is done we can likely access other users password info

I made a script to help me check if there are valid id's in /vault/row/FUZZ

Here's my script [IDOR](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/htb/b2b/agile/idor.py)

Running it gives this
![image](https://user-images.githubusercontent.com/113513376/222965288-b4327f0c-20bf-4611-b330-b772aa8f36f7.png)

Now i can access it manually (would have scripted it tho 😞)
![image](https://user-images.githubusercontent.com/113513376/222965386-638789a2-8afb-4cd9-b6c8-f4c46ddda84e.png)
![image](https://user-images.githubusercontent.com/113513376/222965405-273fbfe5-d64f-4685-b91b-d2dccdc6174b.png)
![image](https://user-images.githubusercontent.com/113513376/222965429-6a4445a5-6514-436e-8b45-839e4f033e50.png)
![image](https://user-images.githubusercontent.com/113513376/222965454-09c1c592-93b6-45ca-9e52-b439ea111e97.png)
![image](https://user-images.githubusercontent.com/113513376/222965498-993bdd78-a96e-4bb3-820d-cb862d28f5be.png)

I saved em all in a file
![image](https://user-images.githubusercontent.com/113513376/222965750-02b3ca0f-5450-4c83-8090-186829895496.png)

Remember this we initially got the `/etc/passwd` file so likely one of this password will be for the user

I extracted the first row from the `/etc/passwd` file
![image](https://user-images.githubusercontent.com/113513376/222966114-9ef498a1-37fe-49b8-8f13-decfd147dac5.png)

I'll do the same to extract those password value from the pass.txt file
![image](https://user-images.githubusercontent.com/113513376/222965973-85cea812-7afe-4ecd-96e7-8e776ca5839a.png)

Then i'll run hydra to brute force user and password
![image](https://user-images.githubusercontent.com/113513376/222966210-ed0e6951-430f-43b3-9bdf-29a0e8679739.png)

Cool we have a cred `corum:5db7caa1d13cc37c9fc2`

Trying it over ssh works 
![image](https://user-images.githubusercontent.com/113513376/222966633-3c32b29e-95c4-4e71-b6c6-b67cfad7ecf3.png)

There are 3 users on the box 
![image](https://user-images.githubusercontent.com/113513376/222966691-4dc96125-0e48-4fbb-be19-a3420b9e9a2a.png)

Lets perform some privesc 🤓

Searching for SUID shows that `/opt/google/chrome/chrome-sandbox` has the suid perm set on it 
![image](https://user-images.githubusercontent.com/113513376/222966730-76051cc6-b4c5-4b78-8191-0baa7ce63769.png)

I searched online for what it is and got some resources for example this

```
[Resource](https://chromium.googlesource.com/chromium/src/+/0e94f26e8/docs/linux_suid_sandbox.md)
[Resource](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/suid_sandbox_development.md)
```

But i didn't really understand it so lets check for internal service running on the target
![image](https://user-images.githubusercontent.com/113513376/222967357-7dea1865-7c17-40d5-89d6-7e07043f455e.png)

I'll port forward all this port back to my host
![image](https://user-images.githubusercontent.com/113513376/222967462-112d0022-0612-4aa2-9b76-0cac680ada37.png)

Now i can confirm if it worked
![image](https://user-images.githubusercontent.com/113513376/222967747-b62f1fef-ca3b-42a1-af2c-547a9d32ac9d.png)
![image](https://user-images.githubusercontent.com/113513376/222967831-cd894f53-0fc7-4317-80ff-6c543a18b50e.png)
![image](https://user-images.githubusercontent.com/113513376/222967847-d0d712d0-49cb-47aa-bf94-5637b36097c1.png)

Checking the service on port 5000 doesn't load

But for port 5555 shows a web service which is similar to the one we got earlier
![image](https://user-images.githubusercontent.com/113513376/222967874-54601b34-e760-48c5-bd2d-044743c20be7.png)
![image](https://user-images.githubusercontent.com/113513376/222967878-bf7dea73-bf67-4081-a333-94a07efd73c0.png)

I'll create an account then try to leak passwords maybe there will be another cred

When i tried using my idor leak password script it runs but then the remote server gives internal error

So we can't send large amount of requests to it

But trying it manually shows another user cred `edwards:d07867c6267dcb5df0af`
![image](https://user-images.githubusercontent.com/113513376/222968274-e7558907-7262-4e19-b18b-5ed7158a98aa.png)

Trying it over ssh works 
![image](https://user-images.githubusercontent.com/113513376/222968346-e641cd3e-6d59-42fc-918c-931c120a9fa1.png)

Checking if the user has sudo perm shows this
![image](https://user-images.githubusercontent.com/113513376/222968378-2391c4c8-b83c-4782-9ec1-a4b55a318c1a.png)

So we can `sudoedit` as `dev_admin` on `sudoedit /app/app-testing/tests/functional/creds.txt` & `/app/config_test.json`

I read the first file which shows a mysql cred
![image](https://user-images.githubusercontent.com/113513376/222968438-af4cff58-4a00-48c3-8967-ad3fed7a36a1.png)

And the second file seems to be some cred for user edwards weird 🤔
![image](https://user-images.githubusercontent.com/113513376/222968474-7dc5cad4-267b-464c-b8c5-5dbfdfa5e1a6.png)

```
Command: sudo -u dev_admin sudoedit /app/config_test.json
         sudo -u dev_admin sudoedit /app/app-testing/tests/functional/creds.txt
```

I then tried login in to mysql using the cred `superpasstester:VUO8A2c2#3FnLq3*a9DX1U` 

And it works 
![image](https://user-images.githubusercontent.com/113513376/222968619-479ca789-e2fc-4701-b102-27467a7b9fb7.png)
![image](https://user-images.githubusercontent.com/113513376/222968643-f1e9bd98-b297-4b31-b4a8-26f717652d86.png)

Nothing really interesting in the db

Now if you notice the sudo perm
![image](https://user-images.githubusercontent.com/113513376/222968867-873a2f1a-3d32-4da5-b8dd-9274da7ec46a.png)

It uses `sudoedit`. Searching google for exploit shows me this
![image](https://user-images.githubusercontent.com/113513376/222968962-fe397361-8a53-4a9b-be04-b0604d35f84a.png)

But on looking at the exploit script it works only when the user has root perm over sudoedit then it writes data into the `/etc/sudoers` file
![image](https://user-images.githubusercontent.com/113513376/222969025-8185f7da-39a3-4867-bb4f-5c2bb59f2c60.png)

Looking at the last line shows the main exploit that is being ran

```
EDITOR="vim -- /etc/sudoers" $EXPLOITABLE
```

So with this, we can read any file that belongs to user dev_admin

While i searched for important file i got this
![image](https://user-images.githubusercontent.com/113513376/222969481-2bf9ae4d-f59a-470e-9f8d-a3f77afbb18a.png)

There's `/app/venv/bin/activate` which basically is like a virtual environment 

Now i can get shell as user dev_admin

```
Command: EDITOR="vi -- /app/venv/bin/activate" sudo -u dev_admin sudoedit /app/app-testing/tests/functional/creds.txt 
```

Running that will let us read the activate file

And since this is a bash file we can add our command so that when we try using the virtual enviroment our command will also be executed
![image](https://user-images.githubusercontent.com/113513376/222969699-b950218f-a031-457d-8c6c-396a53055dc7.png)

Now if we try switching to the virtual environment our payload will also be executed
![image](https://user-images.githubusercontent.com/113513376/222969892-2e2ef784-5590-4944-a233-aaa7f66d4169.png)

From here we can switch to root
![image](https://user-images.githubusercontent.com/113513376/222969905-1e494bd4-47b0-42d9-b772-298a5666002f.png)


And we're done 👻

<br> <br>
[Back To Home](../../../index.md)
