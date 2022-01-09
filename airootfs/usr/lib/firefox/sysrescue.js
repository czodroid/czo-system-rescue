// Ensure preference can't be changed by users
lockPref("app.update.auto", false);
lockPref("app.update.enabled", false);
lockPref("intl.locale.matchOS", true);
// Allow user to change based on needs
defaultPref("browser.display.use_system_colors", true);
defaultPref("spellchecker.dictionary_path", "/usr/share/myspell");
defaultPref("browser.shell.checkDefaultBrowser", false);
// Preferences that should be reset every session
pref("browser.EULA.override", true);
// SystemRescue settings
pref("browser.startup.homepage_override.mstone", "ignore");
pref("browser.startup.homepage", "http://www.system-rescue.org/");

//== Czo settings for firefox 95.0.2 ==
// no title
pref("browser.tabs.drawInTitlebar", true);
pref("browser.tabs.inTitlebar", 1);
// url bar room + home
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"fxa-toolbar-menu-button\",\"sidebar-button\",\"screenshot-button\",\"save-to-pocket-button\",\"ublock0_raymondhill_net-browser-action\",\"_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"ublock0_raymondhill_net-browser-action\",\"developer-button\",\"_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"widget-overflow-fixed-list\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":17,\"newElementCount\":4}");
// DuckDuckGo search
pref("browser.urlbar.placeholderName", "DuckDuckGo");
// no import bookmarks
pref("browser.bookmarks.addedImportButton", true);
pref("browser.bookmarks.restore_default_bookmarks", false);
// strict contentblocking
pref("browser.contentblocking.category", "strict");
// cookie and history lost on close
pref("network.cookie.lifetimePolicy", 2);
pref("privacy.history.custom", true);
pref("privacy.sanitize.sanitizeOnShutdown", true);


