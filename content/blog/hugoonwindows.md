+++
title = "Getting Started with Hugo on Windows"
description = ""
tags = [
    "windows",
    "hugo",
    "development",
]
date = "2018-10-20"
categories = [
    "Development",
]
highlight = "true"
+++

## Step 1. Install Hugo

I'm a lefty. This meant in high school when the gym teacher would demonstrate a technique for any sport, my instruction was basically "and if you're lefthanded use the opposite hands". Being a developer that likes to use Windows as my development platform feels a lot like those days. Most open source projects provide only cursory instructions on setting up their tools on Windows, and the amount of information out there in StackOverflow and other sites is similarly lacking. My guess is it's 90% Linux, 8% Mac and 2% Windows.

I'm going to try to help out with my experiences installing and using Hugo. To be fair, I work in a hybrid environment, Windows & Linux. My Linux usage is via the Windows 10 Linux Bash and Raspberry Pis (as well as all the other places where Linux can be found). 

First you need to install Hugo. Goto [hugo releases](https://github.com/gohugoio/hugo/releases) and download either 32-bit or 64-bit. If your machine was built in the last 5 years and isn't an underpowered laptop, you'll need the [64-bit version](https://github.com/gohugoio/hugo/releases/download/v0.49.2/hugo_0.49.2_Windows-64bit.zip). Just let this dribble into your Downloads folder.

Once you have the zip, you can open it up (not extract). You need to copy the contents of the zip file to folder. A place like "c:\hugo" will do fine.

Finally you need to let Windows "know" where the hugo.exe resides by adding the folder to the PATH environment variable. Here's what you do:

Open up File Explorer
Right click on "This PC" and select Properties
Select Advanced system settings

You should see this:
![alt test](/img/SystemProperties.png)

Now select Environment Variables
![alt test](/img/EnvironmentVariables.png)

This will bring you to the environment variable editing dialog below
![alt test](/img/EditEnvironmentVariable.png)

Select the variable named "Path" and choose Edit. In the next screen you need to select "New" (as you are adding a new value to the variable) and enter the folder location where your hugo.exe resides. No trail slash or semi-colon. Save it all up and you are good to go. For added measure fire up a command prompt and type "hugo" to see it working.
