<h3> Weasel TryHackMe </h3>

![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/d75505c1-e2ce-4fb1-b86f-fe0818711009)

Nmap Scan:
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/8e462a6e-01d5-48fc-bc64-c5fe47d96a15)

From the scan we can tell that this is a windows box 

Let's enumerate smb first

Checking the shares available shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/26c7facd-82f4-4d00-8311-461dfd8143db)

Now we can mount the *datasci-team* share
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/444afca1-a3cb-4896-a042-04ad8d917a25)

```
Command: sudo mount -t cifs -o username=guest,password= //10.10.195.131/datasci-team mount
```

After i looked through the smb folders in that share i didn't see anything interesting except this jupyter token
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5ba4420f-bd7d-455d-b7ee-95cb4e73fdc8)

We can now unmount it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5d1dd99e-5400-4c0c-82a5-a108061808f0)

```
Command: sudo umount mount
```

Back to the port 8888 shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/e4664709-f541-4726-897e-fe03b3c6abcd)

This is an instance of jupyter and it's running on port 8888

It requies a token to get logged in

Remember we got a token from the smb so using it here works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/62df165e-d12d-4d19-9ede-7314f75b361a)

```
Token: 067470c5ddsadc54153ghfjd817d15b5d5f5341e56b0dsad78a
```

To get shell on jupyter is very easy since it usually have a python interactive instance and also a terminal 

But let's go with the terminal option

Click on the *new button* then click the *terminal button*
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/7fc0bd07-3196-4a6d-9bd6-6695bc41e21f)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/4958278f-f2f6-458a-b39c-f48fed665167)
