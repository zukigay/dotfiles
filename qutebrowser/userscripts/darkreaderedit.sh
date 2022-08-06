#!/bin/sh
darkreader="$QUTE_CONFIG_DIR/greasemonkey/darkreader.js"
darkreaderhash1="$(sha512sum "$darkreader")"
kitty nvim "$darkreader"
darkreaderhash2="$(sha512sum "$darkreader")"

#python $QUTE_CONFIG_DIR/userscripts/darkreader.py
if [ "$darkreaderhash1" != "$darkreaderhash2" ]
then
echo "greasemonkey-reload" >> "$QUTE_FIFO"                                                           
echo "reload" >> "$QUTE_FIFO"
fi
