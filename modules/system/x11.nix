{pkgs, ...}: {
  imports = [];

  programs.dconf.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    autoRepeatDelay = 250;
    autoRepeatInterval = 45;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = false;
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
}
