{pkgs, config, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      firefox
    ];
  };

  programs.firefox = {
    enable = true;
    profiles."x" = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
        aria2-integration
        clearurls
        darkreader
        decentraleyes
        keepassxc-browser
        libredirect
        no-pdf-download
        noscript
        plasma-integration
        privacy-badger
        ublock-origin
      ];

      settings = {
    # Performance settings
    "gfx.webrender.all" = false; # disabled for stability
    "media.ffmpeg.vaapi.enabled" = true;
    "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

    # Keep the reader button enabled at all times; really don't
    # care if it doesn't work 20% of the time, most websites are
    # crap and unreadable without this
    "reader.parse-on-load.force-enabled" = true;

    # Hide the "sharing indicator", it's especially annoying
    # with tiling WMs on wayland
    "privacy.webrtc.legacyGlobalIndicator" = false;

        # never ask to remember passwords
        "signon.rememberSignons" = false;

    # Actual settings
    "app.shield.optoutstudies.enabled" = false;
    "app.update.auto" = false;
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.contentblocking.category" = "strict";
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "browser.discovery.enabled" = false;
    "browser.laterrun.enabled" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
      false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
      false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
    "browser.newtabpage.activity-stream.section.highlights.includePocket" =
      false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.pinned" = false;
    "browser.protections_panel.infoMessage.seen" = true;
    "browser.quitShortcut.disabled" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.ssb.enabled" = true;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.suggest.openpage" = false;
    "datareporting.policy.dataSubmissionEnable" = false;
    "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.pocket.enabled" = false;
    "identity.fxaccounts.enabled" = false;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };
  };

}
