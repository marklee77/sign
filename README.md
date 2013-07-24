sign
====

Department of Engineering Computing Digital Signage Project

To get this running I just have a computer boot up into ubuntu and log in
automatically, then start firefox and open it to a locally hosted page (the
google javascript code in particular requires that you access the page through
a web server, rather than simply as a file). I run "unclutter -root -i 5"
(available in ubuntu with the unclutter package) to hide the mouse, and use the
R-kiosk add-on for firefox to make it full screen. In the configs/ directory
there is a custom userChrome.css that gets rid of side bars and status updates,
just drop it into the firefox profile directory.

NOTE: you will probably have to tinker a bit with the drivers and settings to
keep the monitor from blanking due to inactivity.

I use a cron job to turn the monitor on every weekday morning and off again
every night.
