{
  lib,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings.gui.user = "x";
    tray.enable = true;
    # overrideDevices = false;
    # overrideFolders = false;
    settings = {
      devices = {
        ios = {
          id = "HRM4WDT-MEG5OOT-S4EEEEG-NCZ3H2F-574WNEB-CZFJ546-AKLVSWW-EBA7MAB";
          autoAcceptFolders = true;
          name = "ios";
        };
      };
      folders = {
        "/home/x/syncthing/keepass-sync" = {
          id = "keepass-sync";
          devices = ["ios"];
        };
      };
    };
  };
}
