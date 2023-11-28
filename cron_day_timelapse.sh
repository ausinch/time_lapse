#!/bin/bash
# cron_day_timelapse.sh
# start before sunrise with automatic exposure time at 5 second intervals

# 12 hours-20 secs
#libcamera-still --width 1920 --height 1080 -t 43180000 --timelapse 5000 --datetime -o Pictures/

# 10.5 hours-20 secs
libcamera-still --width 1920 --height 1080 -t 37780000 --timelapse 5000 --datetime -o Pictures/
