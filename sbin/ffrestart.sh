#!/bin/sh
pkill firefox
sleep 5
DISPLAY=:0.0 firefox &
