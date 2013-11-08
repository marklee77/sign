#!/bin/bash 
mkdir -m 755 -p deploy
rsync -pr static/ deploy/
rsync -pr private/ deploy/
umask 133
template-render -d ./templates:./widgets -t index.html.mako -m ./private.yaml \
    -o ./deploy/index.html
mkdir -m 755 -p deploy/css
lessc style/default.less > deploy/css/default.css
lessc style/main.less > deploy/css/main.css
