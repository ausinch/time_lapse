#!/bin/bash
# cron_night_timelapse.sh
# start at night fall with 12 second exposure time at 15 second intervals

# 12 hours-20 secs
#libcamera-still --width 1920 --height 1080 --shutter 80000000 -t 43180000 --timelapse 15000 --datetime -o Pictures/

# 13.5 hours-20 secs
libcamera-still --width 1920 --height 1080 --shutter 80000000 -t 48580000 --timelapse 15000 --datetime -o Pictures/
