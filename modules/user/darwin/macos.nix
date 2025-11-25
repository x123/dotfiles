{
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin = {
      # default search engine
      search = "DuckDuckGo";

      # show battery percentage
      currentHostDefaults = {
        "com.apple.controlcenter" = {
          BatteryShowPercentage = true;
        };
      };

      defaults = {
        # dock
        dock = {
          autohide = true;
          mru-spaces = false;
          orientation = "left";
          showhidden = true;
        };

        # dock size
        "com.apple.dock".tilesize = 64;

        # finder
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          CreateDesktop = false;
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          NewWindowTarget = "Home";
          QuitMenuItem = true;
          ShowPathbar = true;
          ShowStatusBar = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
        };

        # trackpad
        trackpad.Clicking = true;
        trackpad.TrackpadThreeFingerDrag = true;

        keyboard.enableKeyMapping = true;

        NSGlobalDomain = {
          # typing/spelling
          AppleKeyboardUIMode = 3; # not sure
          ApplePressAndHoldEnabled = true; # for extended characters
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;

          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          _HIHideMenuBar = false; # top menubar
        };
      };
    };
  };
}
