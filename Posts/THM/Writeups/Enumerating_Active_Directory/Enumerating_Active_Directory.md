
# Enumerating Active Directory

![[attachments/Pasted image 20240510095503.png]]

This room covers various Active Directory enumeration techniques, their use cases as well as drawbacks.

In this write-up, I'll only be covering sections people might have difficulty with.

# Task 1: Why AD Enumeration

Here is how you can setup your machine if you are making use of **OpenVPN** on Kali Linux

First up go to the [access page](https://tryhackme.com/r/access)

Next is to download the OpenVPN configuration file for this room.

Select Networks > "adenumeration" 

![[attachments/Pasted image 20240510095738.png]]

Download configuration file

![[attachments/Pasted image 20240510095818.png]]

Connect using configuration file:

```shell
sudo openvpn <config_file>
```


![[attachments/Pasted image 20240510095907.png]]

Confirm connectivity by checking the access page:

![[attachments/Pasted image 20240510100011.png]]

Next is to configure DNS.

Search for "Advanced Network Configuration"

![](attachments/20240503210915.png)

Double click on the network connection you're using

![](attachments/20240503211021.png)

Go to IPv4 settings and set:

Additional DNS servers - `THMDCIP`

The IP for THMDC can be found here:

![[attachments/Pasted image 20240510103054.png]]

Set Additional search domains - `1.1.1.1` as instructed in the room

![[attachments/Pasted image 20240510103145.png]]

Next up open your terminal and edit the `/etc/hosts` file using any text editor of your choice. Then enter this entry  `THMDCIP   za.tryhackme.com`

![[attachments/Pasted image 20240510103815.png]]

Go to your terminal and run the command:

```shell
sudo systemctl restart NetworkManager
```

Test if everything is working fine by running:

```shell
nslookup thmdc.za.tryhackme.com
```

![[attachments/Pasted image 20240510104057.png]]

Note: Remember to start the network

![[attachments/Pasted image 20240510104151.png]]

![[attachments/Pasted image 20240510104230.png]]

Next thing is to navigate to http://distributor.za.tryhackme.com/creds and get your credentials 

![[attachments/Pasted image 20240510130303.png]]

![[attachments/Pasted image 20240510130329.png]]

To connect via ssh, use the syntax:

```shell
ssh za.tryhackme.com\\rachel.dunn@thmjmp1.za.tryhackme.com
```

![[attachments/Pasted image 20240510131141.png]]

![[attachments/Pasted image 20240510130523.png]]

To connect via RDP with `xfreerdp`, use this syntax:

```shell
xfreerdp /v:THMJMP1.za.tryhackme.com /u:rachel.dunn /p:Bmlj9838 /cert:ignore +clipboard /dynamic-resolution
```


![[attachments/Pasted image 20240510131411.png]]

![[attachments/Pasted image 20240510131435.png]]

# Task 2: Credential Injection

Before jumping into AD objects and enumeration, let's first talk about credential injection methods. From the Breaching AD network, you would have seen that credentials are often found without compromising a domain-joined machine. Specific enumeration techniques may require a particular setup to work.  

Windows vs Linux

_"If you know the enemy and know yourself, you need not fear the results of a hundred battles. If you know yourself but not the enemy, for every victory gained you will also suffer defeat."_ - Sun Tzu, Art of War.  

You can get incredibly far doing AD enumeration from a Kali machine. Still, if you genuinely want to do in-depth enumeration and even exploitation, you need to understand and mimic your enemy. Thus, you need a Windows machine. This will allow us to use several built-in methods to stage our enumeration and exploits. In this network, we will explore one of these built-in tools, called the `runas.exe` binary.

Runas Explained

Have you ever found AD credentials but nowhere to log in with them? Runas may be the answer you've been looking for!

In security assessments, you will often have network access and have just discovered AD credentials but have no means or privileges to create a new domain-joined machine. So we need the ability to use those credentials on a Windows machine we control.

If we have the AD credentials in the format of `<username>:<password>`, we can use Runas, a legitimate Windows binary, to inject the credentials into memory. The usual Runas command would look something like this:

```
runas.exe /netonly /user:<domain>\<username> cmd.exe
```

Let's look at the parameters:

- **/netonly** - Since we are not domain-joined, we want to load the credentials for network authentication but not authenticate against a domain controller. So commands executed locally on the computer will run in the context of your standard Windows account, but any network connections will occur using the account specified here.
- **/user** - Here, we provide the details of the domain and the username. It is always a safe bet to use the Fully Qualified Domain Name (FQDN) instead of just the NetBIOS name of the domain since this will help with resolution.
- **cmd.exe** - This is the program we want to execute once the credentials are injected. This can be changed to anything, but the safest bet is cmd.exe since you can then use that to launch whatever you want, with the credentials injected.

Once you run this command, you will be prompted to supply a password. Note that since we added the /netonly parameter, the credentials will not be verified directly by a domain controller so that it will accept any password. We still need to confirm that the network credentials are loaded successfully and correctly.

**Note:** If you use your own Windows machine, you should make sure that you run your first Command Prompt as Administrator. This will inject an Administrator token into CMD. If you run tools that require local Administrative privileges from your Runas spawned CMD, the token will already be available. This does not give you administrative privileges on the network, but will ensure that any local commands you execute, will execute with administrative privileges.  

It's Always DNS

**Note:** These next steps you only need to perform if you use your own Windows machine for the exercise. However, it is good knowledge to learn how to perform since it may be helpful on red team exercises.

After providing the password, a new command prompt window will open. Now we still need to verify that our credentials are working. The most surefire way to do this is to list SYSVOL. Any AD account, no matter how low-privileged, can read the contents of the SYSVOL directory.

SYSVOL is a folder that exists on all domain controllers. It is a shared folder storing the Group Policy Objects (GPOs) and information along with any other domain related scripts. It is an essential component for Active Directory since it delivers these GPOs to all computers on the domain. Domain-joined computers can then read these GPOs and apply the applicable ones, making domain-wide configuration changes from a central location.

Before we can list SYSVOL, we need to configure our DNS. Sometimes you are lucky, and internal DNS will be configured for you automatically through DHCP or the VPN connection, but not always (like this TryHackMe network). It is good to understand how to do it manually. Your safest bet for a DNS server is usually a domain controller. Using the IP of the domain controller, we can execute the following commands in a PowerShell window:

```powershell
$dnsip = "<DC IP>"
$index = Get-NetAdapter -Name 'Ethernet' | Select-Object -ExpandProperty 'ifIndex'
Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses $dnsip
```

Of course, 'Ethernet' will be whatever interface is connected to the TryHackMe network. We can verify that DNS is working by running the following:

```cmd
C:\> nslookup za.tryhackme.com
```

Which should now resolve to the DC IP since this is where the FQDN is being hosted. Now that DNS is working, we can finally test our credentials. We can use the following command to force a network-based listing of the SYSVOL directory:

```cmd
C:\Tools>dir \\za.tryhackme.com\SYSVOL\
 Volume in drive \\za.tryhackme.com\SYSVOL is Windows
 Volume Serial Number is 1634-22A9

 Directory of \\za.tryhackme.com\SYSVOL

02/24/2022  09:57 PM    <DIR>          .
02/24/2022  09:57 PM    <DIR>          ..
02/24/2022  09:57 PM    <JUNCTION>     za.tryhackme.com [C:\Windows\SYSVOL\domain]
               0 File(s)              0 bytes
               3 Dir(s)  51,835,408,384 bytes free
```

We won't go too much in-depth now into the contents of SYSVOL, but note that it is also good to enumerate its contents since there may be some additional AD credentials lurking there.  

IP vs Hostnames

**Question:** _Is there a difference between_ _`dir \\za.tryhackme.com\SYSVOL` and `dir \\<DC IP>\SYSVOL`_ _and why the big fuss about DNS?_

There is quite a difference, and it boils down to the authentication method being used. When we provide the hostname, network authentication will attempt first to perform Kerberos authentication. Since Kerberos authentication uses hostnames embedded in the tickets, if we provide the IP instead, we can force the authentication type to be NTLM. While on the surface, this does not matter to us right now, it is good to understand these slight differences since they can allow you to remain more stealthy during a Red team assessment. In some instances, organisations will be monitoring for OverPass- and Pass-The-Hash Attacks. Forcing NTLM authentication is a good trick to have in the book to avoid detection in these cases.

Using Injected Credentials

Now that we have injected our AD credentials into memory, this is where the fun begins. With the /netonly option, all network communication will use these injected credentials for authentication. This includes all network communications of applications executed from that command prompt window.

This is where it becomes potent. Have you ever had a case where an MS SQL database used Windows Authentication, and you were not domain-joined? Start MS SQL Studio from that command prompt; even though it shows your local username, click Log In, and it will use the AD credentials in the background to authenticate! We can even use this to [authenticate to web applications that use NTLM Authentication](https://labs.f-secure.com/blog/pth-attacks-against-ntlm-authenticated-web-applications/).  

We will be using that in the next task for our first AD enumeration technique.

