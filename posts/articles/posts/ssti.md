### Server Side Template Injection

<h3> VulnMachines SSTI </h3>
  
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/5ba69ce8-7c1d-4b12-acd4-ac938cc0a05a)

After going over to the web page it shows this
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/3f12114e-5007-40e8-872c-0852bc94afe7)

Trying to input something shows it get reflected back
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/6b197aee-aeec-4a59-ae29-fdf22ae038e5)

Using basic SSTI payload works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/0c3d4f0d-3339-4052-a5ff-80a80299048d)

Let's use this SSTI check to know what template engine it uses
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/72ceb69f-0749-42af-a825-e578cbcceee7)

First i'll try `${7*7}` but it doesn't get evaluated
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/fca6e016-516e-4d4e-99eb-f2f51a177d5a)

Next we move unto the down part of what we are using to get the template engine

Now i'll try this `{{7*7}}`
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/40a994fe-f655-4155-b869-57472c9ee536)

It gets evaluated

So we move unto `{{7*'7'}}`

But doing that gives us an error
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/727b0876-0742-4285-b9aa-90f9ffa334b7)

```
Your nickname contains restricted characters!
```

To bypass this we can try using double quote instead of single quote

Doing that works
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/1cd3936c-6e86-445b-ad6a-3162ba396fbd)

From here we can say the template engine is either *Jinja2 or Twig*

But from the web server header we can then conclude it's *Jinja2* templating engine that is being used since the webserver is built on python
![image](https://github.com/h4ckyou/h4ckyou.github.io/assets/127159644/f1e4fd74-e41d-4cc8-8bff-b980e4cf0796)

