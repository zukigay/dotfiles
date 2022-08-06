// ==UserScript==
// @name          Dark Reader (Unofficial)
// @icon          https://darkreader.org/images/darkreader-icon-256x256.png
// @namespace     DarkReader
// @description	  Inverts the brightness of pages to reduce eye strain
// @version       4.7.15
// @author        https://github.com/darkreader/darkreader#contributors
// @homepageURL   https://darkreader.org/ | https://github.com/darkreader/darkreader
// @run-at        document-end
// @grant         none
// @include       http*
// @exclude       http://www.example.com/
// @exclude https://www.youtube.com/watch?v=rJtdW50NOQ0
// @exclude https://search.ononoki.org/
// @exclude https://github.com/*
// @exclude https://www.netflix.com/*
// @exclude https://browserbench.org/JetStream/
// @exclude https://browserbench.org/Speedometer2.1/
// @exclude https://browserbench.org/MotionMark1.2/
// @exclude https://browserbench.org/
// @exclude https://discord.com/*
// @exclude https://qutebrowser.org/doc/quickstart.html
// @exclude https://www.youtube.com/*
// @exclude https://wiki.greasespot.net/Include_and_exclude_rules
// @require       https://cdn.jsdelivr.net/npm/darkreader/darkreader.min.js
// @noframes
// ==/UserScript==

DarkReader.enable({
	brightness: 100,
	contrast: 100,
	sepia: 0
});
