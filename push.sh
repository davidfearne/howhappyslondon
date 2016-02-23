#!/bin/bash

##############################################################
#
# Committing to GitHub
# Target OS: Mac OSX
# Author: David Fearne
# GitHub: https://github.com/davidfearne/howhappyslondon
#
##############################################################

read -p "Add Comment" com

git add .
git commit -m "$com"
git push origin master
