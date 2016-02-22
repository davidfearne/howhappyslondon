#!/bin/bash

##############################################################
#
# Committing to GitHub
# Target OS: Mac OSX
# Author: David Fearne
# GitHub: https://github.com/davidfearne/howhappyslondon
#
##############################################################

cd /User/David/www

read -p "Add Comment" com

git add .
git push origin master
git commit -m "$com"
