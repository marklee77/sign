#!/bin/bash 
mkdir -p deploy
rsync -pr --delete static/ deploy/
rsync -pr private/ deploy/
umask 133
template-render -d ./templates:./widgets -t index.html.mako -m ./private.yaml \
    -o ./deploy/index.html
# git commit, then push to repo on amac-xibo...
