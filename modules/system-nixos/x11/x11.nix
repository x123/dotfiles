{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.x11.enable) {
    programs.dconf.enable = true;
    programs.i3lock.enable = true;

    services = {
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "none+i3";
      };

      xserver = {
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
  };
}
