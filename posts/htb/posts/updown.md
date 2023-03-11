<h3> UpDown HackTheBox </h3>

### Difficulty = Medium

### Ip Address = 10.10.11.177

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/224432299-970a1bea-5924-4862-ad50-2622007b746b.png)

Only two tcp ports open 

Checking the web server which is running on port 80 shows this
![image](https://user-images.githubusercontent.com/127159644/224432541-221297d8-5a2b-4ed9-bf7f-4e2b57f45d4f.png)

And below shows the domain name `siteisup.htb`

I'll add that to my `/etc/hosts` file

```
┌──(mark㉿haxor)-[~/Desktop/B2B/HTB/Updown]
└─$ cat /etc/hosts | grep site
10.10.11.177    siteisup.htb
```

There's a function on the web page that allows user to check is a site is up 

I'll test it to know if i can fingerprint anything whether the option chosen is debug mode or not
![image](https://user-images.githubusercontent.com/127159644/224434357-2e5471ed-0fe5-4b19-9dc3-e8f6314094be.png)
![image](https://user-images.githubusercontent.com/127159644/224434500-f4a69762-ff37-460b-a0ab-74fba8c44498.png)

Nothing much expect the domain name which we already know

I'll try it also with debug mode enabled 
![image](https://user-images.githubusercontent.com/127159644/224434661-6860b141-1759-40de-87a0-4c7cb34dbf41.png)
![image](https://user-images.githubusercontent.com/127159644/224434687-7f76a876-7e81-4d74-b95d-a26d4c0f4eaf.png)

Nothing much here also 

I'll fuzz for directories
![image](https://user-images.githubusercontent.com/127159644/224436652-8d204833-fc22-4cc0-ac21-8b78b3b369e8.png)

There's a .git directory in /dev and we can confirm it
![image](https://user-images.githubusercontent.com/127159644/224441793-de13e0cb-b211-41bd-b3c4-f7eaefe42032.png)

I'll also fuzz for vhosts
![image](https://user-images.githubusercontent.com/127159644/224441820-5690914b-2daf-46a1-9370-80e2b4ae5dd0.png)

I added `dev.siteisup.htb` to my `/etc/hosts` file

```
┌──(mark㉿haxor)-[~/Desktop/B2B/HTB/Updown]
└─$ cat /etc/hosts | grep siteisup
10.10.11.177    dev.siteisup.htb siteisup.htb
```

Checking the vhosts gives 403
![image](https://user-images.githubusercontent.com/127159644/224442179-1ad1da39-1875-4974-ae7c-7354f6d60166.png)

So i'll use git-dumper to dump the .git directory 
![image](https://user-images.githubusercontent.com/127159644/224442398-6c40dc1d-077c-42f6-bc9f-b39b0821b2f7.png)

Here are the contents
![image](https://user-images.githubusercontent.com/127159644/224442568-0db1dc31-21c8-4894-96ae-e303767e4ff6.png)
![image](https://user-images.githubusercontent.com/127159644/224442624-64491895-6d3c-498e-b605-10f65d75ad3d.png)

The content of checker.php
![image](https://user-images.githubusercontent.com/127159644/224442942-03e929f7-d240-415f-ba69-fc649d2fb20e.png)
![image](https://user-images.githubusercontent.com/127159644/224442969-b8784c0c-1143-4c5e-af10-21f2df3869d7.png)
![image](https://user-images.githubusercontent.com/127159644/224443004-b91ba34d-75bf-416b-81e0-95df7d2c8d4c.png)
![image](https://user-images.githubusercontent.com/127159644/224443034-3241d735-a162-48dc-b5d9-4933b22fbb21.png)

Here's the content of index.php
![image](https://user-images.githubusercontent.com/127159644/224443081-4d94935a-d38e-416d-8457-172703bd5c77.png)

From the source code we see that the checker.php allows file upload while index.php is vulnerable to local file inclusion

And from the filter we see it filers anything `php and php[0-9] i.e php1, php2,....,php9` 

Also the index.php script first checks if the "page" parameter is set and if it does not contain any of the prohibited directory names ("bin", "usr", "home", "var", or "etc"). If both conditions are true, it includes the corresponding PHP file using the "include" function. If the "page" parameter is not set or if it contains one of the prohibited directory names, it includes a file called "checker.php".

Checking the list of files git dumped i get a .htaccess file
![image](https://user-images.githubusercontent.com/127159644/224446678-4e61fb8c-b127-4435-a4ea-98d51885b748.png)

Reading it shows this
![image](https://user-images.githubusercontent.com/127159644/224446770-bcc16091-6f93-4d84-a4a1-834dd3b719f8.png)

So basically for us to access the dev vhosts we need a `Required-Header` which is called `Special-Dev` and its value will be `only4dev`

Using [Modify Header](https://addons.mozilla.org/en-US/firefox/addon/modify-header-value/) tool i'll make it add the required header on every request and response being made to the server
![image](https://user-images.githubusercontent.com/127159644/224447447-80699647-f5a5-4ad0-a21d-72cf0dcad997.png)

Now we can access the dev vhosts
![image](https://user-images.githubusercontent.com/127159644/224447524-1e8bc941-4823-4b05-893f-29f1ed680998.png)

We know that we have a file upload function but almost all php type is filtered except .phar

What phar does is like it can contain the content of a php file which will be zipped to a phar file

First lets test our theory by uploading a phar file which will contain a php code to echo `Hello World`
![image](https://user-images.githubusercontent.com/127159644/224447909-38317b9e-01ca-48ca-a5fb-fd161a3f7c70.png)
![image](https://user-images.githubusercontent.com/127159644/224447971-edc1b6f7-9d45-4283-ab46-13d3aa3bd58e.png)

But now we need to know where it uploaded

From the php code 

```
	# Create directory to upload our file.
	$dir = "uploads/".md5(time())."/";
	if(!is_dir($dir)){
        mkdir($dir, 0770, true);
    }
```
We can see it creates a directory which is formed from md5 hashing the current time

So if we check /uploads we will get the directory our phar file uploaded to
![image](https://user-images.githubusercontent.com/127159644/224448477-a2fb6f4c-76e7-4917-a0e9-7e372496b620.png)
![image](https://user-images.githubusercontent.com/127159644/224448494-47a3043d-d166-4580-b291-840aa1121546.png)

The file can't be run cause we just compressed the test.php file into it

But instead we can leverage the LFI to run the test.php file

Here's the resource [HackTricks](https://book.hacktricks.xyz/pentesting-web/file-inclusion#phar)
![image](https://user-images.githubusercontent.com/127159644/224450453-be017aa6-4a90-491a-a3cc-8401b259ecb4.png)

Notice how i didn't put `test.php` but instead `test` thats because from the php .php is already appended

```
$page=$_GET['page'];
	if($page && !preg_match("/bin|usr|home|var|etc/i",$page)){
		include($_GET['page'] . ".php");
 ```
 
 Now lets read the phpinfo to know the allowed system command that can be run
 ![image](https://user-images.githubusercontent.com/127159644/224450661-0243739e-353b-4047-a0a9-6bd8b283652e.png)

