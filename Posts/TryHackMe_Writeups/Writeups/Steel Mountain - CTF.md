🔒 **Capture The Flag (CTF) - Steel Mountain** 🔒

I recently completed the "Steel Mountain" CTF challenge, and I wanted to share my experience with you. This engaging exercise allowed me to hone my skills in Windows enumeration, Metasploit usage, and privilege escalation. Here's a breakdown of my journey:

**1. Initial Access** I began by performing a quick nmap scan, revealing an open port 80 hosting a website. After inspecting the source code, I found the answer to the first challenge - the "Employee of the Month" is Bill Harper. Further scanning uncovered port 8080 running a Rejetto HTTP File Server which was vulnerable to CVE (2014-6287) that I leveraged to gain initial access. Using Metasploit, I obtained an initial shell and secured the user flag.

**2. Privilege Escalation** To escalate privileges, I utilized a PowerShell script called PowerUp. It's a powerful tool for evaluating Windows machines and identifying misconfigurations. After uploading it and executing it, I discovered an unquoted service path vulnerability with the service name "AdvancedSystemCareService9." By crafting a malicious payload using msfvenom and replacing the legitimate file, I was able to restart the service and gain a shell as NT Authority\System, securing the root flag.

**3. Access and Escalation without Metasploit**  Next step was to complete the challenge without relying on Metasploit. Using the same CVE but a different exploit, I transferred a netcat binary to the target system and gained access. Then, I used winPEAS to enumerate the system for potential privilege escalation vectors. Identifying the same unquoted service path vulnerability, I uploaded a malicious payload, replaced the legitimate file, and achieved root access without Metasploit.

It was an invaluable experience that allowed me to put my skills to the test.

Special thanks to TryHackMe for creating this challenging room, and a heartfelt shoutout to Olawole Hassan for generously providing me with a TryHackMe voucher to complete it.

Stay curious and keep learning! 🚀🔓
