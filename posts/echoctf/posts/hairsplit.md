<h3> Hairsplit EchoCTf </h3>

### Difficulty = Advanced

### IP Address = 10.0.14.24

![image](https://user-images.githubusercontent.com/113513376/222303974-765432fc-a86a-4996-84f7-dcb11f43fc66.png)
We're told to connect to the web server which is on port 1337

Heading over to it shows this 
![image](https://user-images.githubusercontent.com/113513376/222304055-7c0494e5-8851-448d-b09a-c6d4f33a781c.png)

Here's what the web server says we should do:

```
1. Attempt to load this file /v1/<filename>.json
2. Use proxy http://127.0.0.1:82
```

So we can call the api at /v1/<filename>.json and the filename can be anything but i used app

I'll use curl to make the request with verbose on  
![image](https://user-images.githubusercontent.com/113513376/222304375-e62c831a-b438-408b-b1df-efd0ceda37f7.png)

Looking at the request output we see that its checking if `X-Real-Ip = 127.0.0.1`
 
```
<pre>Sorry X-Real-Ip != 127.0.0.1
array(8) {
  ["Accept"]=>
  string(3) "*/*"
  ["User-Agent"]=>
  string(11) "curl/7.87.0"
  ["Connection"]=>
  string(5) "close"
  ["Host"]=>
  string(12) "127.0.0.1:82"
  ["Etsctf"]=>
  string(39) "ETSCTF_9451dd542150a2f75d968cacbc2923b9"
  ["X-Action"]=>
  string(3) "app"
  ["Content-Length"]=>
  string(0) ""
  ["Content-Type"]=>
  string(0) ""
}
```

I'll add that as an header and use the proxy 
![image](https://user-images.githubusercontent.com/113513376/222304771-e6c22b18-91d3-497d-8038-d839a2bf41c7.png)

That's it. It should be an easy box rather than advanced 🤔

```
ETSCTF_9af62c544d7e1a52e756a6ab104d9cc9
ETSCTF_9451dd542150a2f75d968cacbc2923b9
ETSCTF_0f33e972a9b0efda06724d168142584c
ETSCTF_55bed939ad8fb5a483c064f76143ab05
```

And we're done 👻

<br> <br>
[Back To Home](../../index.md)
