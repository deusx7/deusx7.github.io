<h3> Anonymous Playground TryHackMe </h3>

Difficulty = Hard

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cbf574c6-ae68-4854-a666-b7cc0c38d09c)

Checking the web server shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b4b022a6-e703-49f1-ba96-3d325b1759e5)

Looking at the source code does not reveal much information

Remember that nmap showed there's a file in /robots.txt indexed

Checking it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4098c704-5267-4500-af0b-3433922b21a7)

Going over there gives us access denied
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f0260872-6462-4b08-96f3-b304accb15ad)

Looking at the cookie shows it set to *denied* 

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fa31997c-cd20-4919-935d-7bef55d62c94)

Changing it to *granted* shows this 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e9ec2cc9-71c6-4ff7-b67c-f8c36f8d5ed5)

This looks like a cipher

```
Cipher: hEzAdCfHzA::hEzAdCfHzAhAiJzAeIaDjBcBhHgAzAfHfN 
```

At this point I was really confused on what to do i looked at the hint thm gave which was:

```
You're going to want to write a Python script for this. 'zA' = 'a'
```

This still doesn't makes sense to me 😥 I had to peek at a writeup for a better explanation on this i then understood it 

So basically:

```python
small alphabet, capital alphabet = alphabet that is at the position small alphabet + Capital alphabet 
```

For instance, 'z' is the 26th and 'A' is the 1st alphabet, and their sum is 27, and the '27th' alphabet (27 % 26 = 1) and the alphabet positioned there is 'a'.

I wrote a script to do the decoding 
