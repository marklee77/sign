#!/bin/bash 
# change to rsync...
rm -rf deploy
cp -r static deploy 
rsync -pr private/. deploy
template-render -d ./templates:./widgets -t index.php.mako -o ./deploy/index.php
# git commit, then push to repo on amac-xibo...
