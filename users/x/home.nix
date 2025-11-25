{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "x";
  home.homeDirectory = "/home/x";
  home.sessionVariables = {
    EDITOR = "vim";
  };

  imports = [];

  nixpkgs.overlays = [(
    self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
        }; }
      );
    }
    )
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home.packages = with pkgs; [
    # term/shell
    alacritty
    file
    htop
    pciutils
    ripgrep
    tmux
    usbutils
    whois

    # net
    aria2
    persepolis
    discord
    dropbox
    firefox

    # offixe
    libreoffice

    # audio/video
    pavucontrol
    streamlink
    vlc

    # art
    gimp

    # dev
    git
    git-crypt

    # crypto
    age
    gnupg
    keepassxc
    sops

    # archives
    unzip
    zip

    # network tools
    dnsutils
    ethtool
    ipcalc
    mtr
    nmap

    # misc
    pinentry
    xygrib

    # system tools
    lm_sensors
    sysstat
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
	"gfx.webrender.all" = true; # Force enable GPU acceleration
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

  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };

  programs.git = {
    enable = true;
    userName = "x123";
    userEmail = "x123@users.noreply.github.com";
  };

  programs.vim = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = false;

    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/x/.ssh/id_xbox";
      };
      "github.com" = {
        hostname = "github.com";
        #user = "git";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
      };
    };

  extraConfig = ''
    AddKeysToAgent yes
  '' + ''
    Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
  '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 10;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  }; 

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    shellAliases = {
      adamantium = "ssh adamantium";
      boxchop = "ssh adamantium";
    };
  };

  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[bash](bright-white) ";
      zsh_indicator = "[zsh](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
    '' + ''
      allow-loopback-pinentry
    '';
  };
}
