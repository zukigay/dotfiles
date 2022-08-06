#!/usr/bin/env python
Dark_reader_sites = [ "*://www.netflix.com" ]
qute_config = os.environ['QUTE_CONFIG_DIR']
_darkreaderfile = qute_config + "/greasemonkey/darkreader.js"
print(_darkreaderfile)
f = open(_darkreaderfile, "w")
def listToString(s): 
    
    # initialize an empty string
    _include_temp="\n// @include       "
    str1 = "" 
    
    # traverse in the string  
    for ele in s: 
        str1 = _include_temp + ele + str1   
    
    # return string  
    return str1
Dark_reader_sites_str = listToString(Dark_reader_sites)
Dark_reader="// ==UserScript==\n// @name          Dark Reader (Unofficial)\n// @icon          https://darkreader.org/images/darkreader-icon-256x256.png\n// @namespace     DarkReader\n// @description	 Inverts the brightness of pages to reduce eye strain\n// @version       4.7.15\n// @author        https://github.com/darkreader/darkreader#contributors\n// @homepageURL   https://darkreader.org/ | https://github.com/darkreader/darkreader\n// @run-at        document-end\n// @grant         none\n// @include       http*" + Dark_reader_sites_str + "\n// @require       https://cdn.jsdelivr.net/npm/darkreader/darkreader.min.js\n// @noframes\n// ==/UserScript==\nDarkReader.enable({\n   brightness: 100,\n  contrast: 100,\n    sepia: 0\n});"
f.write(Dark_reader)
f.close
