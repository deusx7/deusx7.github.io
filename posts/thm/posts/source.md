# DC-2 PROVEN GROUNDS
***
## DIFFICULTY : EASY
![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/343788f7-9c7c-478a-b8b7-c6b81277fb2a)
***

A quick nmap scan gives us this:

![image](../images/Pasted%20image%2020230622231249.png)

**We can see that port 22<ssh> and port 10000<http> are open!!**
***
### Enumerating Port 1000
***
Navigating to the site we see that it has a logon page:

![image](../images/Pasted%20image%2020230622231407.png)

- After much invalid attempt to guess the password and username, we decided to find out what vulnerability the protocol uses and it was vulnerable to RCE **[CVE-2019-15107, CVE-2019-15231](infosecmatter.com/nessus-plugin-library/?id=127911)** using `Metasploit`:

![image](../images/Pasted%20image%2020230622231909.png)
