Difficulty: Easy

![[829892f5e7936a448f465b64d64f9c62 1.png]]

# Info

*Deploy & hack into a Windows machine, exploiting a very poorly secured media server.*

# Task 1: Connect

*Connect to the TryHackMe network! Please note that this machine does not respond to ping (ICMP) and may take a few minutes to boot up.*

*-----------------------------------------*

*The virtual machine used in this room (Ice) can be downloaded for offline usage from [https://darkstar7471.com/resources.html](https://darkstar7471.com/resources.html). The sequel to this room, Blaster, can be found [here](https://tryhackme.com/room/blaster).*
# Task 2 : Recon
![](https://i.imgur.com/7tFp450.png)  

*Scan and enumerate our victim!*

- *Deploy the machine! This may take up to three minutes to start.*
- *Launch a scan against our target machine, I recommend using a SYN scan set to scan all ports on the machine. The scan command will be provided as a hint, however, it's recommended to complete the room '[Nmap](https://tryhackme.com/room/furthernmap)' prior to this room.*

First off we are instructed to start our reconnaissance with an Nmap scan to discover open ports on our target machine. We were also previously informed that the machine does not respond to ping so we would need to  add the `-Pn` flag to instruct Nmap not to bother pinging the target because without it Nmap will try and ping the target and when it doesn't receive a response it terminates the entire scan.

We were also advised to use the SYN scan set `-sS` to scan all ports on the machine `-p-`. So let's get right into it. Taking all those into consideration, the Nmap command should look something like this.
`sudo nmap -sC -sV -sS -A -Pn -p- --min-rate 1000 -oN scan <IP>`
- `-sC` use nmap default scripts
- `-sV` for service version detection
- `-sS` for TCP SYN scan
- `-A` OS detection
- `-Pn` disable ping
- `-p-` scan all ports
- `--min-rate 1000` scan speed
- `-oN scan` to output scan results to a the file "scan" for later reference

Nmap scan results:

![[attachments/Pasted image 20240111100913.png]]

*Once the scan completes, we'll see a number of interesting ports open on this machine. As you might have guessed, the firewall has been disabled (with the service completely shutdown), leaving very little to protect this machine. One of the more interesting ports that is open is Microsoft Remote Desktop (MSRDP). What port is this open on?*

![[attachments/Pasted image 20240111101828.png]]

*What service did nmap identify as running on port 8000? (First word of this service)* 

![[attachments/Pasted image 20240111101922.png]]

*What does Nmap identify as the hostname of the machine? (All caps for the answer)*

![[attachments/Pasted image 20240111102136.png]]

# Task 3: Gain Access

![](https://i.imgur.com/FFqM2ZK.png)  

*Exploit the target vulnerable service to gain a foothold!*

*Now that we've identified some interesting services running on our target machine, let's do a little bit of research into one of the weirder services identified: Icecast. Icecast, or well at least this version running on our target, is heavily flawed and has a high level vulnerability with a score of 7.5 (7.4 depending on where you view it). What type of vulnerability is it? Use [https://www.cvedetails.com](https://www.cvedetails.com) for this question and the next.* 
After much research i found the answer to be "Execute code overflow"

*What is the CVE number for this vulnerability? This will be in the format: CVE-0000-0000*

![[attachments/Pasted image 20240111120210.png]]

*Now that we've found our vulnerability, let's find our exploit. For this section of the room, we'll use the Metasploit module associated with this exploit. Let's go ahead and start Metasploit using the command `msfconsole`*

*After Metasploit has started, let's search for our target exploit using the command 'search icecast'. What is the full path (starting with exploit) for the exploitation module? This module is also referenced in '[RP: Metasploit](https://tryhackme.com/room/rpmetasploit)' which is recommended to be completed prior to this room, although not entirely necessary.*

![[attachments/Pasted image 20240111120459.png]]

*Let's go ahead and select this module for use. Type either the command `use icecast` or `use 0` to select our search result.*

*Following selecting our module, we now have to check what options we have to set. Run the command `show options`. What is the only required setting which currently is blank?*

![[attachments/Pasted image 20240111120645.png]]

*First let's check that the LHOST option is set to our tun0 IP (which can be found on the [access](https://tryhackme.com/access) page). With that done, let's set that last option to our target IP. Now that we have everything ready to go, let's run our exploit using the command `exploit`*

![[attachments/Pasted image 20240111120814.png]]

# Task 4: Escalate   

*Enumerate the machine and find potential privilege escalation paths to gain Admin powers!*

*Woohoo! We've gained a foothold into our victim machine! What's the name of the shell we have now?* 

![[attachments/Pasted image 20240111121339.png]]

You can check list of commands to use in a meterpreter shell by typing `help`:

![[attachments/Pasted image 20240111122112.png]]

*What user was running that Icecast process? The commands used in this question and the next few are taken directly from the '[RP: Metasploit](https://tryhackme.com/room/rpmetasploit)' room.*

Using the command `ps` in the meterpreter shell:

![[attachments/Pasted image 20240111121743.png]]

*What build of Windows is the system?*

using the command `sysinfo`:

![[attachments/Pasted image 20240111121947.png]]

*Now that we know some of the finer details of the system we are working with, let's start escalating our privileges. First, what is the architecture of the process we're running?* **Refer  to image above**

*Now that we know the architecture of the process, let's perform some further recon. While this doesn't work the best on x64 machines, let's now run the following command `run post/multi/recon/local_exploit_suggester`. *This can appear to hang as it tests exploits and might take several minutes to complete**
