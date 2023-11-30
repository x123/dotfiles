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

  targets.darwin.defaults.dock.autohide = true;
  targets.darwin.defaults.dock.mru-spaces = false;
  targets.darwin.defaults.dock.orientation = "left";
  targets.darwin.defaults.dock.showhidden = true;

  # finder
  targets.darwin.defaults.finder.AppleShowAllExtensions = true;
  targets.darwin.defaults.finder.QuitMenuItem = true;
  targets.darwin.defaults.finder.FXEnableExtensionChangeWarning = false;

  # trackpad
  targets.darwin.defaults.trackpad.Clicking = true;
  targets.darwin.defaults.trackpad.TrackpadThreeFingerDrag = true;

  targets.darwin.defaults.keyboard.enableKeyMapping = true;
  #system.keyboard.remapCapsLockToControl = true;
  #targets.darwin.defaults.keyboard.swapLeftCommandAndLeftAlt = true;

  # dock size
  targets.darwin.defaults."com.apple.dock".tilesize = 64;

  # default search engine
  targets.darwin.search = "DuckDuckGo";

  # show battery percentage
  targets.darwin.currentHostDefaults = {
    "com.apple.controlcenter" = {
      BatteryShowPercentage = true;
    };
  };

}
