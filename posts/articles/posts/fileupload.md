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

After I logged in I saw this upload function
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
