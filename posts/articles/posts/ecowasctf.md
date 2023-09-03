# Ecowas CTF

![Category Breakdown](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/2c4e8e4c-bb27-4b76-a376-e431d8b37e36)

**Even though our team didn't take first place this was an exciting Jeopardy CTF for me because i am more of an Attack-defense person, but this taught me some few things, so i have decided to make a write-up on each and every challenge i solved!! GG <!3**
## Decode_me
First of all, we are giving a random number to solve

![](https://i.imgur.com/Y5TsoIJ.png)

looks like the character has a special number which is 2535, i then decided to decode it  with hexadecimal first

![](https://i.imgur.com/2YHQaGT.png)

and then we got a URL encoded text, decoding the URL encoded text gives us this

![](https://i.imgur.com/O7hzyF1.png)

Which is a base64 value, let decode it 

![](https://i.imgur.com/4v3q0ou.png)

and then we got a flag

## grep

we are asked to download a file

![](https://i.imgur.com/DBRKaWX.png)

through the name of the challenge, i knew i had to use the CLI tool `grep`

![](https://i.imgur.com/Nk0jVfZ.png)

we got a flag!!

## Read Me Please

we are giving a file with text at the top and then empty lines

![](https://i.imgur.com/007caGt.png)

This is called snow steganography, download this tool on your command line with `sudo apt install stegsnow`

Now use this syntax on the file and you should get an output

![](https://i.imgur.com/c68Gh7v.png)

Nice, let keep going, copy the output and paste in Cyber Chef and keep clicking the pen button until you get the final flag

![](https://i.imgur.com/Yyam4B4.png)

Done !!

![](https://i.imgur.com/I3UoZVK.png)

#  xss 101

We are given a website :

![](https://i.imgur.com/bQClGiC.png)

After several tests of `xss` vulnerabilities :

![](https://i.imgur.com/651seZE.png)

I decided to `inspects elements` , which going to the `sources` tab gave me an hint on what to do :

![](https://i.imgur.com/66tOQSz.png)

The `jquery.min.js` file was calling the /win....... directory somehow, so i decided to replace the URL with that :

![](https://i.imgur.com/xtXqgPs.png)

........Then we got a Flag

## Sentinnelle

We are given an image :

![](https://i.imgur.com/ARknrzj.png)

Using image forensics tools like strings, exiftool, steghide, binwalk, bulk extractor, file, foremost, totally gives me nothing

![](https://i.imgur.com/wd7ySO5.png)

So then i used a tool to bruteforce images called `stegseek` and got a `.wav` file

![](https://i.imgur.com/52qFDzf.png)

using strings on `olympio.jpg.out` gives us a a `rot47` encoded text at the end of output

![](https://i.imgur.com/6pcnEcA.png)

Decoding this text gives us a flag

![](https://i.imgur.com/TbpnEpI.png)


## Strings

We are given a file to download :

![](https://i.imgur.com/uwU2zDI.png)

concatenating out the file gives us a lot of output

![](https://i.imgur.com/S0Fq9CB.png)

As the name of the file implies i used the `strings` command piped to `grep` to get the flag

```sh
sec-fortress@Pwn-F0rk-3X3C:~/EcowasCTF$ strings strings | grep flag
flag{th4t5_4_l0t_0f_5tr1ng5}
```

## Chevrolet Traverse

We are given a website :

![](https://i.imgur.com/QrPQq0R.png)

Immediately, my mind went to Path Traversals Vulnerability 

![](https://i.imgur.com/8bKn23H.png)

We have `secrets` and `almost_there` , Nice !! , let us keep going

![](https://i.imgur.com/hUjCqgI.png)

We then have `flag.txt` , Let navigate there

![](https://i.imgur.com/RF7ck8v.png)

Nothing, but viewing `page-source` gives us a flag

![](https://i.imgur.com/2pXaZ1k.png)

## Unix Master

we where given a Netcat Logs to connect to

![](https://i.imgur.com/QqfhkK1.png)

Connecting seems to gives us some file and a flag.txt file with an asterik in front

![](https://i.imgur.com/kz7vfxe.png)

After much enumeration, i did `./flag.txt` and got a flag

![](https://i.imgur.com/5dowa6B.png)

## SoppazShoes

We are giving a website :

![](https://i.imgur.com/KwKIb8E.png)

Decided to make some navigation and i landed on this shoe page

![](https://i.imgur.com/sPUamL6.png)

Clicking on each shoes changes the shoe ID number

![](https://i.imgur.com/0rokSFC.png)

After much fuzzing, Number 35 gave a clue

![](https://i.imgur.com/O3esnkm.png)

Moved to number 40 and things where clicking

![](https://i.imgur.com/aZpNx86.png)

Long-Story short, decided to add it to cart then checkout and i got a flag

![](https://i.imgur.com/87aLkbO.png)

***Thanks for reading, Farewell!!**

![image](https://github.com/sec-fortress/sec-fortress.github.io/assets/132317714/aebdcd22-5119-4862-8ae0-c4abdbb115fa)

