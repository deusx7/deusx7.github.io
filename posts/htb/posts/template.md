# Template

## Difficulty = Easy

---

Navigating to the website we get this:

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/618d1d8d-94de-47d4-acec-64dbb8672c16)

Looks like a website that uses Flask and python

![](https://i.imgur.com/hV8IAi7.png)

Hmmmmm, something is fishy, let enumerate :

- Using google top searches came out as SSTI (Server side Template Injection)

![](https://i.imgur.com/54QC9pm.png)

- Nice, Let test for SSTI vulnerabilities on the website by injecting a simple expression which we expect to be executed/evaluated by the templating engine.
-  To do so, we are using the `{{ ... }}` syntax native to Jinja2

![](https://i.imgur.com/fjtrmPp.png)

- As we can see `7*12 =84`, which is true, This website is vulnerable to SSTI
- let go ahead and exploit it

[Gus Ralph](https://twitter.com/SecGus) presents a very clever RCE payload that leverages the fact that Flask/Jinja2 templates have the `request` object available to them, you can read more from here [OnSecurity article](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)

- Now let use this payload to see if the **system command** `id` get executed:

```
{{request.application.__globals__.__builtins__.__import__('os').popen('id').read()}}
```

![](https://i.imgur.com/LvUBKII.png)

As we can see, it print out the output of the `id` command back to us, we can now replace id and get our flag:

- first of all replace `id` with `ls`

![](https://i.imgur.com/3Oz5Z3K.png)

- Now cat out flag.txt with `cat flag.txt`

![](https://i.imgur.com/a4Kfkky.png)

Have fun 🤟😘
