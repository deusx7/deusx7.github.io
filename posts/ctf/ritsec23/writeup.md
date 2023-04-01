<h3> RITSEC CTF '23 </h3>

### I had fun while playing this ctf and learnt new things 😄. Lets get straight to the fun

### Intro
![image](https://user-images.githubusercontent.com/127159644/229284625-035ccb60-e236-40ae-adc1-4673da62fbfb.png)

If you just go to the discord channel and check the rules you will see the flag
![image](https://user-images.githubusercontent.com/127159644/229284664-fb85536f-e833-48f9-a5c2-04c0e2bfaf94.png)

```
Flag: RS{!flag}
```

<h3> Chandi Bot </h3>

### Chandi Bot 1
![image](https://user-images.githubusercontent.com/127159644/229284869-9c32174b-23a2-479b-9d06-46cc41a3a14f.png)

After going to the discord channel there's a bot there called chandi checking its profile gives the flag
![image](https://user-images.githubusercontent.com/127159644/229284828-e4d99d9c-193e-47e1-910f-a41147089416.png)

```
Flag: RS{QUANTUM_RESISTANT_ENCRYPTION}
```

### Chandi Bot 2
![image](https://user-images.githubusercontent.com/127159644/229284882-ebaf2662-e1ce-4409-a2a3-d7ac0ea4a131.png)

Trying the functions of the bot shows this 
![image](https://user-images.githubusercontent.com/127159644/229284961-56d99da8-2daa-483a-86de-82767defe316.png)

Now we can get the flag by doing /flag
![image](https://user-images.githubusercontent.com/127159644/229284979-b4b1da0e-f978-4098-b30b-5d372a149e2f.png)

```
Flag: RS{HMMM_WHAT_ARE_YOU_LOOKING_AT}
```

### Chandi Bot 4
![image](https://user-images.githubusercontent.com/127159644/229289993-89a9938f-bbc1-433f-ae29-e249f5720e11.png)

The bot has a rock paper scissors game (rps)
![image](https://user-images.githubusercontent.com/127159644/229290099-7385d53d-66ba-410f-92cd-bc760ee01012.png)

There's also a buy flag but it requires 10000 points
![image](https://user-images.githubusercontent.com/127159644/229290203-8a753069-086e-4b8d-b49f-fb7894a5af98.png)

And the way to get point is by getting a dad joke from /dad and playing rps with staking the point you have

But the dad joke just gives one point
![image](https://user-images.githubusercontent.com/127159644/229290374-7a2cec85-f7eb-4f27-8b42-eeffa0bd63e3.png)

I currently have 160 points but normally its supposed to be just 1 point 

From now we can play the rps game

But chances of winning is very low tho 

After playing and loosing we get this
![image](https://user-images.githubusercontent.com/127159644/229291964-ec05f126-aad7-455e-bb11-f885833da5bb.png)

Checking the balance shows it reduces by the amount stacked
![image](https://user-images.githubusercontent.com/127159644/229292005-abc29369-5255-4277-95ac-e8a5939393e2.png)

So the idea is that it does

```
if botwins:
  balance = balance - stake
```

Now it subtracts its initial balance with the amount staked

But what if we stake negative number yunno what happens 🙂

```
if botwins:
  balance = balance - (-stake)
```

It will turn to a positive number making the balance increase

Trying my assumption works
![image](https://user-images.githubusercontent.com/127159644/229292355-2017671d-b604-48f1-9950-da19be9cc449.png)

Now we can get the flag
![image](https://user-images.githubusercontent.com/127159644/229292440-b514d16f-30be-4895-b4f4-ad684458e92c.png)

```
Flag: RS{TWO_NEGATIVES_DO_MAKE_A_POSITIVE}
```
