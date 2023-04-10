<h3> Devie TryHackMe </h3>

### Difficulty = Medium

### IP Address = 10.10.85.206

Nmap Scan:
![image](https://user-images.githubusercontent.com/127159644/230915896-3b2b90ae-f394-4e76-a4e5-d9ad09e97cce.png)

Only two ports open which are ssh and a web server on port 5000

Checking the web server shows this
![image](https://user-images.githubusercontent.com/127159644/230916100-78fc45a4-5761-41b5-9bd5-5d41c8e5b1f2.png)
![image](https://user-images.githubusercontent.com/127159644/230916136-4183fbde-c326-40ea-b2da-eacc4d5a6c94.png)

Instead of checking and testing the functionality of the web server we're given the source code so lets check it out
![image](https://user-images.githubusercontent.com/127159644/230916456-e56b50b7-b4a1-4a2c-bf07-ea05282e5d17.png)

After checking app.py shows the source code for the web server
![image](https://user-images.githubusercontent.com/127159644/230916679-20602b09-cd3e-463e-9ad9-9c7bf81a20fd.png)
![image](https://user-images.githubusercontent.com/127159644/230916719-249a419d-3d62-4f1b-b4a7-d189e194c2bc.png)
![image](https://user-images.githubusercontent.com/127159644/230916754-4d98eac8-430f-43ab-b9ca-dcc86fe21512.png)
![image](https://user-images.githubusercontent.com/127159644/230916794-5d5fb04d-e9f4-424c-a7c5-3536c58ae008.png)

The vulnerability i then saw is this
![image](https://user-images.githubusercontent.com/127159644/230916932-0999435d-003a-40d0-9b1f-78f97f5b9fc7.png)

```
@app.route("/")
def bisect(xa,xb):
    added = xa + " + " + xb
    c = eval(added)
```

When a post request is made to `/` with the value xa and xb it then sums it up but the problem there is that it uses `eval` which can basically evaluate any python command given to it
