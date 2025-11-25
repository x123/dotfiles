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

    security.rtkit.enable = true;

    xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        #xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
        };
      };
    };

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
