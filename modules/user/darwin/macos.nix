{pkgs, ...}: {
  imports = [];

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
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
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
}
