<h2> Stringer EchoCTF </h2>

### Difficulty = Advanced

### IP Address = 10.0.14.28

![image](https://user-images.githubusercontent.com/113513376/222299045-6d070678-3e7e-462b-bd7a-331dc1e7de86.png)

We're given a netcat server to connect to 

```
Connect: nc 10.0.14.28 1337
```

Connecting to it shows a server
![image](https://user-images.githubusercontent.com/113513376/222299398-824ab740-8554-47f4-b0bb-6292930243c5.png)

Giving it any input prints back its content
![image](https://user-images.githubusercontent.com/113513376/222299455-20f0de19-5f3d-44ea-9d4b-14a8021fb943.png)

From the box name `stringer` its likely a service which is vulnerable to format string vulnerability

Lets confirm it by leaking addresses off the stack using `%s`
![image](https://user-images.githubusercontent.com/113513376/222299567-2fee1d4f-2485-4a16-817a-26ed788053f5.png)

Cool we get a flag 

Now that we've confirmed its a format string vulnerability the idea is to start leaking off values off the stack till we get all flags needed

But obviously we can do this `%1$s` which will print the content of the first string offset  
![image](https://user-images.githubusercontent.com/113513376/222299814-85e58d16-2399-4605-af1f-7c70dfeb6dc8.png)

And we can keep on going on 
![image](https://user-images.githubusercontent.com/113513376/222299969-198fe8c3-4721-4848-9c8f-745f904fe83f.png)

Not all the offset will have a value stored in it but yet we can keep on leaking that way

Doing it manually sucks and its time wasting

So i made a script to help me do it

Here's my leak script [Leak](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/echoctf/stringer/leak.py)

What it will do is to loop from 1 to 99 and keep on sending `%i$s` where `i` is the value iterated which is from `1-99`

Running it works but since my internet connection is really slow it keeps on disconnecting to the remote server 
![image](https://user-images.githubusercontent.com/113513376/222300954-3d0ec3d5-a319-43f0-a115-64767ef5cdf6.png)

But eventually after few minutes i got the script to leak the flag and i then made just a one linear bash script to only leak the flag

Here's the solve script [Solve](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/echoctf/stringer/solve.sh)

Running it works 
![image](https://user-images.githubusercontent.com/113513376/222301580-1a69e798-b1db-425b-b7ac-643f123056d5.png)

And we're done 👻

<br> <br> 
[Back To Home](../../../index.md)

