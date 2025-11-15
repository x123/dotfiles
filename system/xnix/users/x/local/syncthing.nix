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
  };
}
