# time_lapse
*Di 28 Nov 2023 18:50:30 CET*
Copy .jps's from a device, add time stamp, create mp4 video

This is a bash script that will rsync jpg's from a Raspberry Pi or other external machine.\
A time stamp is added to each jpg.\
An mp4 video is then created.

## What it does
During the day (time lapse period) you can run the script whenever you want to see what has been capture so far.\
   Rsync will copy down only newer files from the image source,\
   Only newer files are time stamped since the script was last run.\
   The mp4 will be recreated from scratch using the time stamped files.

##  Current state
Fully functional with Raspberry Pi's and libcamera-still command

A work in progress - updating soon.\
Still to come: 
  * timestamp based on exif information
  * other exif information to be stamped on image

# Pi tips
Run the cron** scripts on the pi.\
The night script has a 12 second shutter time.
Add this to your crontab:

`# m h  dom mon dow   command
0 7 * * * /home/chris/cron_day_timelapse.sh
30 17 * * * /home/chris/cron_night_timelapse.sh
`
\
*Mi 15 Nov 2023 22:18:57 CET*
git clone with git@github.com:ausinch/time_lapse.git
