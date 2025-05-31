#!/usr/bin/env bash
#
# wayar-dwl.sh - display dwl tags, layout, and active title
#   Created by fauxmight (waybar-dwl@ivories.org)
#   Available from https://codeberg.org/fauxmight/waybar-dwl
#   Originally based upon this script by user "novakane" (Hugo Machet) used to do the same for yambar
#   https://codeberg.org/novakane/yambar/src/branch/master/examples/scripts/dwl-tags.sh
#
# USAGE: waybar-dwl.sh MONITOR
#        "MONITOR"   is a wayland output such as "eDP-1"
#
# STYLE: Unlike "normal" waybar modules, styles (foreground, background, underline, overline) are NOT set in style.css
#        Instead, modify the pango_* variables in THIS file
#        A guide to available pango span styling can be found here: https://docs.gtk.org/Pango/pango_markup.html
#
# SELMON INDICATION: on multiple output dwl setups, the inactve monitor will display most elements in the
#                    "inactive" pango style selected. This allows the user to glance at the waybar instance
#                    and be immediately aware of which is the active output (monitor).
#
# REQUIREMENTS:
#  - inotifywait ( 'inotify-tools' on arch )
#  - Launch dwl with `dwl > ~.cache/dwltags` or change $dwl_output_filename
#
# Now the fun part
#
### Example (multi-monitor) ~/.config/waybar/config
#          - waybar-dwl.sh takes one argument: the monitor id as returned by wlr-randr -- e.g. "eDP-1"
#          - naming the module with the monitor id as a #suffix allows running multiple instances of the
#                  dwl module in, perhaps, a waybar instance on each monitor
# [
#     {
#     "output":        "DP-2",
#     "modules-left":  ["custom/dwl#DP-2"],
#     "modules-right": ["clock"],
#     "custom/dwl#DP-2": {
# 	"exec":                    "/xap/etc/waybar/waybar-dwl.sh 'DP-2'",
# 	"format":                  "{}",
# 	"return-type":             "json"
#     },
# },
#     {
#     "output":        "HDMI-A-1",
#     "modules-left":  ["custom/dwl#HDMI-A-1"],
#     "modules-right": ["clock"],
#     "custom/dwl#HDMI-A-1": {
# 	"exec":                    "/xap/etc/waybar/waybar-dwl.sh 'HDMI-A-1'",
# 	"format":                  "{}",
# 	"return-type":             "json"
#     },
# },
# ]
#



############### USER: MODIFY THESE VARIABLES ###############
readonly dwl_output_filename=/tmp/dwl-status                   # File to watch for dwl output
# readonly labels=( "" "" "" "" "" "" "" "" "" )              # Number of lables must match dwl's config.h tagcount
readonly labels=( "1" "2" "3" "4" "5" "6" "7" "8" "9" )              # Number of lables must match dwl's config.h tagcount
pango_tag_default="<span                      foreground='#989710'>" # Pango span style for 'default' tags
pango_tag_active="<span overline='single' overline_color='#fe8019'>" # Pango span style for 'active' tags
pango_tag_selected="<span                     foreground='#458588'>" # Pango span style for 'selected' tags
pango_tag_urgent="<span                       background='#fb4934'>" # Pango span style for 'urgent' tags
pango_layout="<span                           foreground='#fe8019'>" # Pango span style for 'layout' character
pango_title="<span                            foreground='#458588'>" # Pango span style for 'title' monitor
pango_inactive="<span                         foreground='#928374'>" # Pango span style for elements on an INACTIVE monitor
hide_unused_tags=false                                               # Set to 'true' to hide unused tags, 'false' to show all tags
############### USER: MODIFY THESE VARIABLES ###############

dwl_log_lines_per_focus_change=7 # This has changed several times as dwl has developed and may not yet be rock solid
full_components_list=( `seq 0 $(( ${#labels[@]} - 1 ))` "layout" "title" ) # (1, 2, ... length_of_$labels) + "layout" + "title"
monitor="${1}"

_cycle() {
    output_text=""
    # Render some components in $pango_inactive if $monitor is not the active monitor
    if [[ "${selmon}" = 0 ]]; then
	local pango_tag_default="${pango_inactive}"
	local pango_layout="${pango_inactive}"
	local pango_title="${pango_inactive}"
    fi

    for component in "${full_components_list[@]}"; do
	case "${component}" in
	    [0-9]|[1-9][0-9])
		mask=$((1<<component))
		tag_text=${labels[component]}
        # Skip if the tag is unused and hide_unused_tags is true
		if [[ "${hide_unused_tags}" = true ]] && ! (( ("${activetags}" | "${urgenttags}" | "${selectedtags}") & mask )); then
		    continue
		fi
		# Wrap component in the applicable nestable pango spans
		if (( "${activetags}"   & mask )) 2>/dev/null; then tag_text="${pango_tag_active}${tag_text}</span>"; fi
		if (( "${urgenttags}"   & mask )) 2>/dev/null; then tag_text="${pango_tag_urgent}${tag_text}</span>"; fi
		if (( "${selectedtags}" & mask )) 2>/dev/null; then tag_text="${pango_tag_selected}${tag_text}</span>"
		else
			tag_text="${pango_tag_default}${tag_text}</span>"
		fi
		output_text+="${tag_text}  "
		;;
	    layout)
		    output_text+="${pango_layout}${layout} </span>"
		;;
	    title)
		    output_text+="${pango_title}${title}</span>"
		;;
	    *)
		output_text+="?" # If a "?" is visible on this module, something happened that shouldn't have happened
		;;
	esac
    done
}

while [[ -n "$(pgrep waybar)" ]] ; do
    [[ ! -f "${dwl_output_filename}" ]] && printf -- '%s\n' \
				    "You need to redirect dwl stdout to ~/.cache/dwltags" >&2

    # Get info from the file
    dwl_latest_output_by_monitor="$(grep  -E "^${monitor}\s" "${dwl_output_filename}" | tail -n${dwl_log_lines_per_focus_change})"
    title="$(echo   "${dwl_latest_output_by_monitor}" | grep '^[[:graph:]]* title'  | cut -d ' ' -f 3- )"
    title="${title//\"/“}" # Replace quotation - prevent waybar crash
    title="${title//\&/+}" # Replace ampersand - prevent waybar crash
    layout="$(echo  "${dwl_latest_output_by_monitor}" | grep '^[[:graph:]]* layout' | cut -d ' ' -f 3- )"
    selmon="$(echo  "${dwl_latest_output_by_monitor}" | grep 'selmon' | cut -d ' ' -f 3)"

	# SPecific hacky fix that allows users to choose the string "><>" (common; used in dwm) for the floating layout
	layout="$(echo "$layout" | sed -e 's/</\&lt;/g' -e 's/>/\&gt;/g')"
	
    # Get the tag bit mask as a decimal
    activetags="$(  echo "${dwl_latest_output_by_monitor}" | grep '^[[:graph:]]* tags' | awk '{print $3}')"
    selectedtags="$(echo "${dwl_latest_output_by_monitor}" | grep '^[[:graph:]]* tags' | awk '{print $4}')"
    urgenttags="$(  echo "${dwl_latest_output_by_monitor}" | grep '^[[:graph:]]* tags' | awk '{print $6}')"

    _cycle
    printf -- '{"text":"%s"}\n' "${output_text}"

    # 60-second timeout keeps this from becoming a zombified process when waybar is no longer running
    inotifywait -t 60 -qq --event modify "${dwl_output_filename}"
done

