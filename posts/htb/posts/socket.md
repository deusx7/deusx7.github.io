<h3> Socket HackTheBox </h3>

### Difficulty = Medium

### IP Address = 10.129.192.218

Nmap Scan
![image](https://user-images.githubusercontent.com/127159644/227752209-8bcc9dfd-8685-4712-aa97-27157cefbd71.png)

I added the domain to my `/etc/hosts/` file 

After checking the web server
![image](https://user-images.githubusercontent.com/127159644/227752256-e92d99e0-3e8d-4e55-a8c8-bca0c05f4ec9.png)

The only function there is that it checks converts a string to a qr code or it decodes a qr code and shows it content

THere's a given file which can be downloaded
![image](https://user-images.githubusercontent.com/127159644/227752314-2284d46b-4768-4e7a-9dd7-a0eb2ec0be61.png)

After downloading the file given which turns out to be a zip file i extracted it
![image](https://user-images.githubusercontent.com/127159644/227752448-abeca5ea-8dc0-455f-835f-38296891d3d4.png)

And its looks like a python compiled binary

So we can decompile it using uncompyle6 but before that we need to convert it to a pyc file

```
pyi-archive_viewer qreader
? X qreader
to filename? ./qreader.pyc
```

Then decompile using uncompyle6

```
uncompyle6 qreader.pyc > qreader.py
```


