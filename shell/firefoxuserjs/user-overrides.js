user_pref("privacy.resistFingerprinting.letterboxing", false);


user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

user_perf("extensions.pocket.enabled", false); //i dislike this thing
user_pref("network.http.referer.XOriginPolicy", 0); // fix webtoon
user_pref("privacy.clearOnShutdown.offlineApps", false)
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.clearOnShutdown.cache", false);
user_pref("privacy.clearOnShutdown.history", false);   // [DEFAULT: true]
user_pref("browser.sessionstore.privacy_level", 1);//save cookies
user_pref("network.cookie.lifetimePolicy", 0); //save cookies
user_pref("privacy.sanitize.sanitizeOnShutdown", true);//save cookies
user_pref("privacy.clearOnShutdown.offlineApps", false); // Site Data
//enable search bar
user_pref("keyword.enabled", true);
user_pref("browser.search.suggest.enabled", true);
user_pref("privacy.clearOnShutdown.cookies", false);
//webgl
user_pref("webgl.force-enabled", true);
user_pref("webgl.disabled", false);
//theme
user_pref("browser.compactmode.show", true);
//fix 60fps lock
user_pref("privacy.resistFingerprinting", false);
// https://wiki.archlinux.org/title/firefox#GNOME_integration
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
