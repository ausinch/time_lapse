# time_lapse
Copy .jps's from a device, add time stamp, create mp4 video

This is a bash script that will rsync jpg's from a Raspberry Pi or other external machine.
A time stamp is added to each jpg.
An mp4 video is then created.

## What it does
During the day (time lapse period) you can run the script to see what has been capture so far.
   Rsync will copy down only newer files,
   Only newer files are time stamped
   The mp4 will be recreated from scratch using the time stamped files.

A work in progress