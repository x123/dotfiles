{pkgs, ...}: {
  imports = [];

  targets.darwin.currentHostDefaults = {
    "com.apple.controlcenter" = {
      BatteryShowPercentage = true;
    };
  };

}
