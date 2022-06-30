#!/bin/sh
# dark reader toggle script 
# DK = dark reader
DK="$QUTE_CONFIG_DIR/greasemonkey/darkreader.js"
DKFile=$(cat $DK)
DKUrl="$QUTE_URL"

arg1="$1"
arg2="$2"

DKUrlCh=$(echo "$DKFile" | grep "$DKUrl") # check if url
if [ "$DKUrlCh" == "" ] 
then
	DKOut=$(echo "$DKFile" | sed "s!// @exclude       http://www.example.com/!// @exclude       http://www.example.com/\n// @exclude $DKUrl!")
else
	#DKOut=$(echo "$DKFile" | grep -v "$DKUrl")
	DKOut=$(echo "$DKFile" | grep -v "// @exclude $DKUrl")
fi



echo "$DKOut" > "$DK"
echo "greasemonkey-reload" >> "$QUTE_FIFO"
echo "reload" >> "$QUTE_FIFO"
