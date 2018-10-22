---
author: "Harry Collins"
date: 2018-10-17
linktitle: CICD
title: Continuous Integration & Deployment
highlight: true
---


## Getting Started

I've been working on testing the boundaries of Continues Integration & Deployment with a simple project of my, the Alexa Jersey Beers Skill. 

I first tried out Jenkins, a friend of mine had been using it for work so I figured it would be a good start. While Jenkins works, I found it cumbersome to work with and difficult to get GitHub integration fully working. The more I read about Jenkins, the more it appears it is dated and needs a major overhaul.

I then tried GitLabs. I really like the simplicity in how they integrated with GitHub, all the SSH access keys are automatically created. But once again, I had a lot of issues getting GitLabs to hear the GitHub events when checkins occurred.

## CircleCI Baby!
At this time I heard about CircleCI. Since I had two people I know using it in real production environments, I decided to give it a try. **CircleCI is awesome!

First, CircleCI easily integrates with GitHub, just drop a .circleci folder in your projects root folder. Next, when you register your project with CircleCI you are given a skeletal config.yml file to place in the folder you just created, this is where CircleCI reads the instructions for how to build and deploy your project.

CircleCI provides a rich set of Docker images to get you off the ground running, it's very easy to instantiation a VM with a complete Python x.x environment. Then you can tailor it to your needs by installing additional tools. And to keep things running efficiently, CircleCI will cache your configuration which greatly speeds up instance setup.

Stash all your secrets (passwords, connections, etc.) in environment variables and setup some SSH keys. This information is not visible on admin screens once it has been entered, so hosting a config.yml file in a GitHub public repository does not leak secure information. In fact my Python project generates a config.py file from the environment variables, the one in GitHub is just a stub for testing.

## Summary
Of course you can get the job done with any of the aforementioned tools, but I found CircleCI easy to use, flexible and well documented. I'm using the cloud version of CircleCI (Jenkins was a local install), and I do most of my work from a Windows platform, so your mileage may vary.
