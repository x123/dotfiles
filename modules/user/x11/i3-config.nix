{pkgs, lib, ...}: {
  imports = [];
  home.packages = with pkgs; [
    feh
    dunst
    networkmanagerapplet
    blueman
  ];

  programs.rofi = {
    enable = true;
    theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modes = "window,drun,ssh,run,combi";
      combi-modes = "window,ssh,drun,run";
    };
  };

  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;

  # compositing
  services.picom.enable = true;

  xsession.windowManager.i3 =
    let
      my-modifier = "Mod1";
      background = "${pkgs.plasma-workspace-wallpapers}/share/wallpapers/Path/contents/images/2560x1600.jpg";
      # fetch background from web
      # background = pkgs.fetchurl {
      # url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/03c6c20be96c38827037d2238357f2c777ec4aa5/wallpapers/nix-wallpaper-dracula.png";
      # sha256 = "SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
      # };
    in {
      enable = true;
      config = {
        startup = [
          {command = "${pkgs.feh}/bin/feh --bg-fill ${background}";}
          {command = "${pkgs.dunst}/bin/dunst &";}
          {command = "${pkgs.picom}/bin/picom --daemon";}
          {command = "${pkgs.i3}/bin/i3-msg workspace 1";}
          {command = "systemctl --user start redshift";}
        ];
        modifier = my-modifier;
        terminal = "alacritty";
        window = {
          hideEdgeBorders = "smart";
          titlebar = false;
        };
        keybindings = lib.mkOptionDefault {
          "${my-modifier}+Shift+l" = "exec ${pkgs.i3lock}/bin/i3lock -n -c 000000";
          "${my-modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
          "${my-modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi";
        };
        focus = {
          followMouse = false;
          mouseWarping = true;
        };
      };
    };
}
