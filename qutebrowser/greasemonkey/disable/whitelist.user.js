// ==UserScript==
// @match https://www.desmos.com/calculator
// @run-at document-end
// ==/UserScript==

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
