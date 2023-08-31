# Discovering vulnerabilities quickly with targeted scanning

---
---

We are given a website to discover a vulnerability that enables us to read arbitrary files from the server. To solve the lab, we have to retrieve the contents of `/etc/passwd` within 10 minutes.

![](https://i.imgur.com/EuF858b.png)

Clicking **View details** >> **Check stock** then intercepting the request with burp gives us different endpoint we could test

![](https://i.imgur.com/SOnrIXk.png)

_Burp :_

![](https://i.imgur.com/qu4YTaa.png)

I tried out different `Local File Inclusion` Payloads but none seems to work, even tried fuzzing with different payloads but for every result, i get a random number 😅

![](https://i.imgur.com/04d00qk.png)

Since the topic focuses on discovering Vulnerabilities, i decided to scan this page using **Burpsuite Professional** , Navigate to the **Target** tab and look for the Site under the **Contents** tab

![](https://i.imgur.com/TdHQB8A.png)

Right click on the **Contents** tab and click **scan** 

![](https://i.imgur.com/8GGa4v6.png)

You should be referred to a New window like this, Just confirm the website URL and click `OK` at the bottom of this window if everything is checked

![](https://i.imgur.com/XCa2Z0B.png)

The next tab under the **Contents** tab where we have `Requests` and `Response`, **Right-click** and click `send to repeater`

![](https://i.imgur.com/iD7Ygqk.png)

Navigate to the `Repeater` tab and click `send` then go back to the **Target** tab and you should see additional vulnerabilities (Issues)

![](https://i.imgur.com/tQVBxo2.png)

If you can't see additional vulnerabilities, Navigate to the dashboard and under **Tasks** click the small arrow icon to see more <....> 

![](https://i.imgur.com/qQNCeGO.png)

You should now get a new tab, Navigate to **issue activity** to see all potential Vulnerabilities

![](https://i.imgur.com/J4G9PWy.png)

Now that we have discovered all this vulnerabilities, you can check them one by one, But the vulnerability here is `Out of-band resource load (HTTP)` , we can exploit this by checking the request and seeing what payload burp used

![](https://i.imgur.com/jzYtFCZ.png)

We have got an XXE injection going on here, using this exact payload we can retrieve the `/etc/passwd` file from the server

```xml
<foo xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include parse="text" href="file:///etc/passwd"/></foo>
```

Note that If your time is up just click restart and things should go on fine 

![](https://i.imgur.com/dpDxiJs.png)

Navigate to the **Repeater** tab and input this payload in the `productID` parameter

![](https://i.imgur.com/8WnXA0V.png)

That will be all for today 🥳

<button onclick="window.location.href='https://sec-fortress.github.io';">Back To Home螥</button>

