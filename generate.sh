#!/bin/sh
rm -rf deploy
cp -r static deploy
rsync -pr private/. deploy
hyde gen 
