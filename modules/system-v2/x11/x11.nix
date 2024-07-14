{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-v2.enable && cfg.system-v2.x11.enable) {
    programs.dconf.enable = true;

    services.displayManager = {
      autoLogin.enable = false;
      defaultSession = "none+i3";
    };

    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };

      autoRepeatDelay = 250;
      autoRepeatInterval = 45;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm = {
          enable = true;
          greeter.enable = true;
        };
      };

      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3; # or pkgs.i3-gaps
          extraPackages = builtins.attrValues {
            inherit
              (pkgs)
              dmenu
              i3status
              i3lock
              i3lock-fancy
              rofi
              ;
          };
        };
      };
    };
  };
}
