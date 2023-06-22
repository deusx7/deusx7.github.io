# Writing a Ping sweep script
**A ping sweep can be defined as performing an entire ICMP echo request on a network, let's go:**

first thing is to perform an ICMP request with:
- `ping -c 1 <ip> > ip.txt`
	- we are telling `ping` to perform the request with the -c option only once and then save it to a txt file.
```OUTPUT

PING 192.168.0.157 (192.168.0.157) 56(84) bytes of data.
64 bytes from 192.168.0.157: icmp_seq=1 ttl=64 time=0.056 ms

--- 192.168.0.157 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.056/0.056/0.056/0.000 ms
```

Now let tweak our txt file
- We can do `cat ip.txt | grep "64 bytes" | cut -d " " -f 4 | tr -d ":"
	-  Now here, we are concatinating out the text in **ip.txt**, then sending a pipe to **grep** only the lines that has **64 bytes**, after that:
	   ![image](../images/pingsweep_script/Pasted%20image%2020230622002127.png)
    
	   Then the next pipe which is **cut** set a delimeter, in other to cut out only the text after 4 spaces with the `-f 4` option, setting it to 3 or 2 will cut from the number of spaces 
           given, Output:
    
	   ![image](../images/pingsweep_script/Pasted%20image%2020230622002410.png)
    
	   Now we have to remove the semicolon, that isn't an IP with the semicolon, we could just do the `tr -d ":"` whereby tr stands for **translator** and we set a delimeter as usual to remove any symbol with **':'**	   
	   ![[Pasted image 20230622002707.png]]

# Creating our Bash script
we start with the `#!/bin/bash` which is called **shebang**, once we have this, you can as usual pull copy our `ping -c 1 192.168.0.$host | grep "64 bytes" | cut -d " " -f 4 | tr -d ":"` to the next line, we only replace the `cat` cmd with `ping` so we can get our output directly to the terminal:
![[Pasted image 20230622004656.png]]

Now let explain//
- The ```for host in `seq 1 254`; do ``` mean we start a **for** lip and give a variable called **host** in `seq` short for **sequence**, that is any where we assign the value $host to it replaces it from 1 to 254, the ; mean allow all command at that line to run at one interval at a time, same as the `&`, run each command once at a interval but changing the conditions as given, note that, the ampersand(&) is always faster than ;, you should tweak thescript to see and, then **done**.
