#!/bin/bash
#  by Chris Sullivan Oct 25 2023
#  Downloads .jpg's from a RPi, time stamps it then reders a video
#   JPG file names must be in format mmddhhmmss.jpg . Time stamp info is taken from the filename
#   RPi command:  libcamera-still -t 52200000 --timelapse 10000 --datetime --lens-position 0 -o Pictures/
#                 libcamera-still --width 1920 --height 1080 -t 43200000 --timelapse 10000 --datetime --rotation 180 -o Pictures/
#   This will create a jpg every 10 secs for 52200000ms

version="0.1 Mi 25 Okt 2023 08:50:08 CEST"
ext_source="cam-pi1"
audio="no"
stop_error="yes"

###  Functions
function help()
{
    echo -e "\nThis script will download *.jpg's from a RPi, time stamps it then renders a video.\nYou can run this script multiple times during the capture, only new files are processed since it was last run.
    \nUsage:
    $0 [-a] [-d] [-t] [-e ext_source]
    $0 -h

    -a          audio notifications (via spd-say)
    -d          download files from the external source only. no other processing.
    -t          no time stamp, generate video (not implemented)
    -e source   the external source generating the pictures, DNS or IP (not implemented)
    -f          ignore file transfer failures.  if there are no updates continue with time stamp and mp4 creation.
    -p          do not Process mp4 file.
    -h          help
    "
}
###  Functions End
#  Get parameters
while getopts ade:hp opts; do
    case ${opts} in
        a) audio="yes" ;;
        d) download="yes" ;;
        e) ext_source=${OPTARG} ;;
        p) no_process="yes" ;;
        f) stop_error="no";;
        n) note=${OPTARG} ;;
        h) help
            exit ;;
    esac
done

# check for spd-say for audio notification
if [ "$audio" == "yes" ]; then
    whereis spd-say|grep bin;err=$?
    if [ "$err" != "0" ];then
        echo "*** Note: spd-say is not found on your system"
        echo "*** please install it with \"apt-get install speech-dispatcher\""
        echo "*** Continuing without audio notifications"
        audio="no"
        sleep 5
    fi
fi

if [ "$audio" == "yes" ]; then spd-say "Starting file transfer"; fi

rsync -av $ext_source:~/Pictures/* ~/Pictures/time_lapse
err=$?
if [ $err != 0 ];then
    echo "### rsync error: $err for source $ext_source"
    if [ $stop_error == "yes" ];then 
        echo "###  Stopping"
        if [ "$audio" == "yes" ]; then spd-say "Stopping.  Error $err"; fi
        exit;end
    fi
    echo "Ctrl-c to terminate"
    sleep 3
fi

if [ "$audio" == "yes" ]; then spd-say "Transfer complete"; fi
sleep 3
if [ "$download" == "yes" ]; then
    echo "Terminating."
    if [ "$audio" == "yes" ]; then spd-say "Terminating"; fi
    exit
fi

## * check if dir empty
file_list="$(ls ~/Pictures/time_lapse/*.jpg)"
if [ "$audio" == "yes" ]; then spd-say "Adding time stamp"; fi
tput clear
d_count="$(ls /home/chris/Pictures/time_lapse/| wc -l)"
t_count="$(ls /home/chris/Pictures/time_lapse/tmp/| wc -l)"
echo "Inserting time stamps.  Frames: $d_count.  Already processed: $t_count"
for mod_file in $file_list
do
    file_name="${mod_file: -14}"
    new_file="/home/chris/Pictures/time_lapse/tmp/$file_name"
    #echo "mod_file: $mod_file"
    #echo "new_file: $new_file"
    # if the new_file doesnt exist then
    if [ -f $new_file ]; then
        tput cup 1 0
        echo -n "skipping $new_file"
    else
        mon=${file_name:0:2}
        day=${file_name:2:2}
        time=${file_name:4:4}
        write_string="$day.$mon - $time"
        tput cup 3 0
        echo "processing $new_file"
        ffmpeg -i $mod_file -vf "drawtext=fontfile=/usr/share/fonts/truetype/ubuntu/UbuntuMono-B.ttf: text='$write_string': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1: fontsize=30" $new_file
    fi
done

## * check if $mon is there otherwise get value
echo " "
echo "Time stamp complete."
if [ "$audio" == "yes" ]; then spd-say "Time stamp complete."; fi
echo " "
if [ $no_process == "yes" ]; then
    echo "Video process terminated due to -p"
    if [ "$audio" == "yes" ]; then spd-say "Video process terminated."; fi
    exit
fi
sleep 3
clear
frame_count="$(ls /home/chris/Pictures/time_lapse/tmp/|wc -l)"
if [ "$audio" == "yes" ]; then spd-say "Starting video render.  Frame count $frame_count"; fi
echo "Starting video render.  Frame count: $frame_count"
echo " "
ffmpeg -framerate 30 -pattern_type glob -i '/home/chris/Pictures/time_lapse/tmp/*.jpg' -c:v libx264 -crf 17 -pix_fmt yuv420p timelapse_$mon$day.mp4 -y
echo " "
echo "All done.  Video saved as timelapse_$mon$day.mp4"
if [ "$audio" == "yes" ]; then spd-say "All done.  Video saved as timelapse_$mon$day"; fi
