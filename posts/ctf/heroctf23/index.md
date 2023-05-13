<h3> HeroCTF '23 </h3>

Here are the challenges I was able to solve:

```
P.S:- The scoreboard was dynamic
```

# Challenges Solved

## Prog
-      Math Trap (50 points)

## System
-     Chm0d (50 points)
-     IMF#0 (50 points)
-     SUDOkLu (50 points)
-     IMF#1: Bug Hunting (500 points)
-     IMF#2: A woman's weapon (500 points)
-     IMF#3: admin:admin (500 points)
-     IMF#4: Put the past behind (500 points)

# Prog

#### Math Trap
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c95cf4e2-bb75-4f89-8ef0-4cd610d630d6)

Since we're given a remote service to connect to let us see what it does

Connecting to it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e1ad6a9-5129-4f1d-b4fe-effcfb7ce99c)

We're asked a calculation 

I used gave it the answer and got this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/17a26531-73a2-4f90-9c0e-57421c8b6c48)

I got *Too Slow* so basically we need to solve each math it gives

And doing this manually is not possible cause it also checks the answer received with time

The way forward is by scripting it and that's what I did

Here's my solve [script](https://github.com/markuched13/markuched13.github.io/blob/main/solvescript/heroctf/prog/Math%20Trap/solve_2.py) it's not really well scripted but it does the job 😄

Running it gives the flag 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/818ff725-48f2-4ec3-b982-13f4829581dd)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c3d3907c-31d6-42a6-b92c-37023db686a8)

```
Flag: Hero{E4sy_ch4ll3ng3_bu7_tr4pp3d}
```

# System

#### Chm0d 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0b569148-b584-4fa0-901c-c64d4919d4fc)

I had to first deploy an instance
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ce755e31-79e2-418f-ac2b-477f906be97f)

Now I logged in using the cred given
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0d5c3534-b8ed-4296-bb6a-a2fc9323c8fe)

Checking the */* directory shows that the flag is there
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/2686b438-5520-41cb-ba3d-af84ee28cad7)

And noticing the permission set on it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6f9b086f-cbeb-414a-b78b-7ab8b0706a9a)

At the moment we don't have any read/write/execute permission over the file

But since the file is owned by us so, we can change the permission set on it using *chmod*

Trying it gives permission denied
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/126f0bca-845b-4fac-806d-ccd92a1b35f8)

Hmmmmm let us see what permission is set on the chmod binary
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3c49ca86-48cb-4ac0-a6af-85f8ab2b1678)

Dang it's permission is the same as the flag.txt file and since the binary is owned by root we can't change it

At this point I taught I had to do privilege escalation so using *scp* I transferred *linpeas.sh* to the box
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/c5419c36-de68-4d58-93ae-1cb369259264)

I immediately noticed that the linpeas i transferred has execute permission set on it 

So maybe any file that is transferred to the box will automatically have execute perm set on it

This is good cause now I can upload my own machine *chmod* binary to the box then run it

Doing that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f3235ee6-2bb5-44c1-89d0-73a102aa99e3)

Now that we have chmod binary on it which has execute permission we can then change the permission on the flag file then read it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/a23b27b2-5821-46a9-ba72-bc414feac8ba)

```
Flag: Hero{chmod_1337_would_have_been_easier}
```
