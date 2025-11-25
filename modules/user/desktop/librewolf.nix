{
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
in {
  imports = [];

  config =
    lib.mkIf
    config.custom.user.desktop.enable
    {
      xdg = lib.mkIf (!isDarwin) {
        desktopEntries = {
          fj-librewolf = {
            name = "fj-librewolf";
            exec = "firejail --name=browser librewolf";
            categories = ["Application" "Network" "WebBrowser"];
            mimeType = ["text/html" "text/xml"];
            terminal = false;
          };
        };

        mimeApps.defaultApplications = {
          "x-scheme-handler/https" = ["fj-librewolf.desktop"];
          "x-scheme-handler/http" = ["fj-librewolf.desktop"];
        };
      };

      home = lib.mkIf (!isDarwin) {
        file = {
          firejail-librewolf-profile = {
            enable = true;
            text = ''
              include ${pkgs.firejail}/etc/firejail/librewolf.profile
              blacklist ${pkgs.nixVersions.stable}/bin/*
              noblacklist ''${HOME}/.nix-profile/share/themes
              noblacklist ''${HOME}/.nix-profile/bin/librewolf
              blacklist ''${HOME}/.nix-profile/bin/*
              blacklist ''${HOME}/.nix-profile/etc/*
              blacklist ''${HOME}/.nix-profile/example/*
              blacklist ''${HOME}/.nix-profile/include/*
              # blacklist ''${HOME}/.nix-profile/lib/*
              blacklist ''${HOME}/.nix-profile/libexec/*
              blacklist ''${HOME}/.nix-profile/manifest.nix
              blacklist ''${HOME}/.nix-profile/opt/*
              blacklist ''${HOME}/.nix-profile/rplugin.vim
              blacklist ''${HOME}/.nix-profile/sbin/*
              blacklist ''${HOME}/.nix-profile/share/*
              blacklist ''${HOME}/.nix-profile/XyGrib/*
              blacklist ''${HOME}/.nix-profile/yed/*
            '';
            target = ".config/firejail/librewolf.profile";
          };
        };
      };

      programs.librewolf = {
        enable = true;
        package =
          if isDarwin
          then pkgs.librewolf
          else pkgs.librewolf-bin;
        profiles."x" = {
          extensions.packages = builtins.attrValues {
            inherit
              (pkgs.nur.repos.rycee.firefox-addons)
              darkreader
              decentraleyes
              # keepassxc-browser
              libredirect
              # no-pdf-download
              noscript
              # plasma-integration
              privacy-badger
              redirector
              sponsorblock
              tridactyl
              ublock-origin
              youtube-alternative-switch
              ;
          };

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

            # disable AI features
            "browser.ml.chat.enabled" = false;

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
    };
}
