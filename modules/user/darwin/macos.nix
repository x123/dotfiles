{pkgs, ...}: {
  imports = [];

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
