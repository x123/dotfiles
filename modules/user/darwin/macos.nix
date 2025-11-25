{pkgs, ...}: {
  imports = [];

  # typing/spelling
  targets.darwin.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # not sure
  targets.darwin.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = true; # for extended characters
  targets.darwin.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  targets.darwin.defaults.NSGlobalDomain.KeyRepeat = 2;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

  # not sure
  targets.darwin.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  targets.darwin.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  targets.darwin.defaults.NSGlobalDomain._HIHideMenuBar = false; # top menubar

  # dock
  targets.darwin.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    orientation = "left";
    showhidden = true;
  };

  # dock size
  targets.darwin.defaults."com.apple.dock".tilesize = 64;

  # finder
  targets.darwin.defaults.finder = {
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = false;
    QuitMenuItem = true;
  };

  # trackpad
  targets.darwin.defaults.trackpad.Clicking = true;
  targets.darwin.defaults.trackpad.TrackpadThreeFingerDrag = true;

  targets.darwin.defaults.keyboard.enableKeyMapping = true;
  #system.keyboard.remapCapsLockToControl = true;
  #targets.darwin.defaults.keyboard.swapLeftCommandAndLeftAlt = true;

  # default search engine
  targets.darwin.search = "DuckDuckGo";

  # show battery percentage
  targets.darwin.currentHostDefaults = {
    "com.apple.controlcenter" = {
      BatteryShowPercentage = true;
    };
  };

}
