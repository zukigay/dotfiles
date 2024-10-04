monitorcount=1
secondmonitor="$1"
#hyprctl monitors | grep "ID 1" && monitorcount=2
hyprctl monitors | grep "$secondmonitor" && monitorcount=2
# note 'hyprctl monitors | grep "ID 1"' outputs 'Monitor HDMI-A-1 (ID 1):'

if [ "$monitorcount" == "2" ]; then
notify-send "disabling second monitor via hyprctl"
hyprctl keyword monitor "$secondmonitor", disable
else
notify-send "enabling second monitor via config reload"
hyprctl reload
fi


