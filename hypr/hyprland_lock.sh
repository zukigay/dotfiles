#!/usr/bin/env bash
#hyprland_lock="swaylock -i ~/.config/wallpaper"
hyprland_lock="hyprlock"
$hyprland_lock; exit



sessionlocked=1
while [ "$sessionlocked" == "1" ] && ! [ "$sessiontimeout" == "100" ]; do 
$hyprland_lock && sessionlocked=0
#sessiontimeout=$(($sessiontimeout + 1))
#echo "$sessiontimeout" 
done
