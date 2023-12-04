{pkgs, lib, ...}: {
  imports = [];
  home.packages = with pkgs; [
    blueman
    dunst
    feh
    networkmanagerapplet
    redshift
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

  programs.autorandr = {
    enable = true;
    profiles = {
      "home" = {
        fingerprint.DP-0 = "00ffffffffffff000469b127b98b010027180104a53c2278064ce1a55850a0230b505400000001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff002341534d764c30494c30655064000000fd001e961ed236010a202020202020000000fc00524f47205047323738510a202001fb02030a01654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a74d20016a0a009500410110056502100001e1c2500a0a0a011503020350056502100001a000000000000000000000000000000000000000000000000000000af";
        config = {
          DP-0 = {
            enable = true;
            primary = true;
            crtc = 0;
            mode = "2560x1440";
            rate = "144.00";
          };
        };
      };
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
          {command = "${pkgs.autorandr}/bin/autorandr -l home";}
          {command = "${pkgs.feh}/bin/feh --bg-fill ${background}";}
          {command = "${pkgs.dunst}/bin/dunst &";}
          {command = "${pkgs.picom}/bin/picom --daemon";}
          {command = "${pkgs.i3}/bin/i3-msg workspace 1";}
          {command = "${pkgs.redshift}/bin/redshift -l 55.7:12.6 -t 5700:3600 -g 0.8 -m randr -v";}
          {command = "${pkgs.networkmanagerapplet}/bin/nm-applet &";}
          {command = "${pkgs.blueman}/bin/blueman-applet &";}
        ] ++ (if pkgs.stdenv.isDarwin || pkgs.stdenv.hostPlatform.system == "aarch64-linux" then []
        else [
          {command = "${pkgs.dropbox}/bin/dropbox &";}
        ]
        );
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
