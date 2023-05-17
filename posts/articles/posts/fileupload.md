# File Upload Vulnerability 

<h3> Lab: Remote code execution via web shell upload </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e1351107-0b29-4c94-9a7b-81e3a401b41e)

Going over to the web page and loggin in shows this upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/21d74e06-b89a-4462-9964-2f6c3a77d214)

Attempting to upload this php content works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6c5b762f-0c87-4e66-b299-11b12569e709)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d115bbf1-3248-459a-816f-fcab062640f3)

```php
<?php system($_GET['cmd']); ?>
```

Now back to the web server we can access the uploaded file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6433e664-789b-4b50-b0c1-0ab9da9161d5)

The aim is to submit the content of `/home/carlos/secret` 

So let us get it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/714b4807-d8ea-40f6-a201-a872d766a86b)

Submitting it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d159cacc-9220-47aa-b8d0-8dae1e0eba57)

<h3> Lab: Web shell upload via Content-Type restriction bypass </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6a94c140-bcf9-42fd-9e29-1ddef6758ba7)

After I logged in I saw the upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b1a45176-8a86-4ba3-a2ad-89149a35eae3)

Trying to upload a php file gives this error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ea8fe338-d6c7-458b-b855-273385a63560)

So the web app is just checking only the content type 

Now I uploaded it again but this time I intercepted the request in burp suite
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7c0ba833-452a-4046-bfaf-e8f55e45bac3)

I changed the `Content-Type` header of the file to be uploaded to `image/jpeg`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d6358a65-26e8-41b1-ab02-af91f19aeee3)

After forwarding the request it uploaded
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a38d995c-f0df-4977-9d88-348d6247f832)

Now we can get the secret file content from the user's directory and submit it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8f999b11-1dad-4775-9eaa-4041c0357b6b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2b61deb3-ae1b-4624-8949-4c9480ac8308)

<h3> Lab: Web shell upload via path traversal </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/787174c2-ec4c-4940-a4bf-0e808c887c0f)

After I logged in I saw the upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e3d062d-53c4-49bd-96c8-727680e95c91)

Trying to upload a php file works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/de61120f-2b51-4f55-af1e-a00a20953623)

But when i tried running it, it doesn't execute but rather treated as a plain text
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/123de4cb-0bae-42ee-8228-d1ac44bee624)

Hmmm so likely there's a configuration set on that directory on not to execute the files uploaded

We can try uploading it to a directory backwards

So basically when i upload the file and intercept it on burp suite i can change the filename to `../shell.php`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1c551a6b-9f64-4ef1-82e7-9f34091d19f1)

After forwarding the request show it doesn't understand `/` as it took it as a plain sign
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/57a83331-c7ec-49ad-a7dc-208f8841c467)

One thing I can try is to upload it but this time around url encode `/` which is `%2f`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/29928f88-a4dd-412d-85a7-057eec2baa6b)

Forwarding it shows it worked
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/281355b7-1f50-4844-b148-dae97dc05c38)

Now we can access the file from where files are usually uploaded but one directory backups then get the content of the secret file and submit it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ab265fd8-30c1-4af1-94a2-b74fa01e8de2)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/38e728dc-d3ab-4580-b8bf-318b7601a006)

<h3> Lab: Web shell upload via extension blacklist bypass </h3>
  
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0b93e64a-accf-4fe7-ad80-cb6cfb95438b)

After I logged in I saw the upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e992d3d2-f418-4751-8cd8-856c67972596)

Trying to upload a php file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/703fcd2a-ab23-423b-a05e-af6aaf243418)

It's saying no php file are allowed to be uploaded 

Trying php5 works well for the bypass
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/99e12116-6345-4500-9258-b9c915219b88)

But when i tried to execute it, it just shows it as plain text
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/97f6f0de-f291-4240-9ab1-1a68c6d00460)

Let's try what we did previously by trying to put it in a directory backwards
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0b69f418-b6d0-4807-8cfb-81f71301e905)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/416e30e3-59ea-4c86-8cff-134a3134d8a3)

It doesn't work 

One thing we can try is by trying to upload a .htaccess file so that the web server will treat a jpg file as a php file which basically will be executed

Here's the content of the .htaccess i'll upload

```
AddType application/x-httpd-php .jpg
```

First I'll save it on my box as a file called `access` 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b5a2021c-d48d-490e-adfd-7d61ad9ba5d3)

Then when i want to upload it i'll turn on my proxy and change the Content-Type to `text/plain` and the filename to `.htaccess`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b5764005-6fd9-4c61-9951-c715cc3318c1)

After forwarding the request it works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/35152cbb-ce81-4ef0-959d-29f8c983d9a9)

Now i'll upload a php file but then on the proxy change the filename to shell.jpg and the content type to image/jpg
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4c6851a3-0b9a-4f28-b17d-9f2d6bd13ada)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/31c2d434-5793-4b4b-8c7e-0d3ec9966304)

Trying to access the file and execute command works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9055bdf7-f9a4-43aa-8478-03b41af4a1c1)

We can get the content of the secret file and submit it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/076c2104-8ec8-49be-97ba-d97c0b1efdd9)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/94134eb6-4985-4ca6-bfea-303e507d8ea9)


<h3> Lab: Web shell upload via obfuscated file extension </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a17bc08a-e1d4-4ebf-961a-f01f5d305804)

After loggin in I see the upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/69c7bb03-bcd0-49ea-8171-0226a457a934)

Trying to upload a php file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d3524fe7-265c-4674-90da-fd4657ec5ec0)

So there are various ways we can go about this 

But let's take this good one

I'll edit the php file and add a jpg header using hexeditor
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/27d09fbf-ba05-4030-a734-694c82310d63)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d0da03f4-0a01-4391-bb4e-fd990238445a)


```
hexeditor shell.php
```

The reason I added a jpg header is because headers are basically used for file identification
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7ceed1c7-e743-4523-8272-3ba8e0ddee30)

Now i'll upload it and change it's `Content-Type` header to `image/jpg` with also the filename extension as `shell.php3`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d0977e73-0c17-416a-a317-9f1e73f8df60)

But i still get error 🤔
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0e34879b-1a43-4f01-96e8-92d6919b4a85)

We can now try to bypass it by adding a null byte `%00.jpg` in hopes that the web server will understand it and if it does the .jpg will be striped since `%00` is a null byte
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9c72c583-ff8a-46c0-831d-39147572aa16)

And it uploaded
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8151129c-4aca-40d0-b8cb-be76c377c12c)

From here we can execute code and get the content of the secret file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2536914b-bcc3-4c2a-ac9a-586718e2ef3b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3134bf49-d7b1-48f7-8924-966aae39239e)


<h3> Lab: Remote code execution via polyglot web shell upload </h3>
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2324c589-d507-407c-9150-138e022ead2f)

After loggin in I saw the upload function
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/dd893834-b08f-4185-bd65-4fb98c794cae)

Trying to upload a php file shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/12549708-6c03-4570-a62b-2c18214dada4)

Hmmmmmmm so it's actually checking if it's a real image or is it 🤔

Checking the `Content-Type` header to `image/jpg` during the upload in my proxy shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fca09da0-976b-4260-ac6d-f1a97363ce6d)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/686e120f-9349-4d81-85e9-94d37d167bc7)

Interesting maybe it is really checking if the file to be uploaded is an image

I uploaded a real image with .php as the extension here's the result
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/42c31916-ed8c-43ad-9947-ee3da79db813)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d910d00e-2888-48e7-9467-986bc377f3eb)

So basically we can still upload a php file just that it must be a real image

Well we can still get RCE from this

Using `exiftool` I'll edit the image metadata and put a php command execution command in it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d027488a-565b-459a-b7c8-a44e76ed6921)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4d03e51d-e1ca-49f7-afdd-7abffea1f9a2)

With the metadata edited let us upload this file also change the extension to .php 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/df7617e5-a409-4df0-a00c-46c31c7e326b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/56b0355b-34d9-4346-86ef-d4848dfdfece)

Now we can get command execution, get the content of the secret file and submit it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ca072c2d-b8e2-4384-9113-af635608c76b)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d0ce0160-cfb6-4f93-8328-d68d487143b9)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a81b10db-c60d-4ac5-a5bc-a2d2bbe5bdf4)


<h3> Lab: Web shell upload via race condition </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/64f44403-e3b9-422b-b404-a457c70e33e9)

The hint contains the source code
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7e75a184-0542-4949-ba5c-144cf22172f9)

Here's what it does:
- The code specifies a target directory named "avatars/" where the uploaded file will be saved.
- The $target_file variable concatenates the target directory and the name of the uploaded file
- The move_uploaded_file() function moves the uploaded file from its temporary location to the target directory specified by $target_file.
- The checkViruses() function checks if there's virus on the file uploaded (though no code is here so likely it is still in development)
- The checkFileType() function checks the type of file that is uploaded is it is not jpg or png
- If both checkViruses() and checkFileType() return true, it means the file passed the virus check and has an allowed file type (JPG or PNG). In this case, a success message is echoed, displaying the uploaded file's name.

With this we know that there's a race condition because during the upload process it is moved temporary before it checks the file type

We can't upload a php file but with this race condition we can do that

I made a script to quickly upload a php file in hopes that when it still in the default directory which is */avatars/files/* and it hasn't done the file type check i'm able to run the file

