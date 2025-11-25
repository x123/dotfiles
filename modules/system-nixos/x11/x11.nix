{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.x11.enable) {
    programs.dconf.enable = true;

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = {}; # needed for hyprlock to work
    security.pam.services.swaylock = {}; # needed for hyprlock to work

    programs.sway.enable = true;

    services = {
      displayManager = {
        autoLogin.enable = false;
        ly = {
          enable = true;
          settings = {
            animation = "doom"; # or matrix
            hide_borders = true;
            animation_timeout_sec = 0;
          };
        };
        #defaultSession = "none+i3";
      };

      # xserver = {
      #   enable = true;
      #   xkb = {
      #     layout = "us";
      #     variant = "";
      #   };
      #
      #   autoRepeatDelay = 250;
      #   autoRepeatInterval = 45;
      #
      #   desktopManager = {
      #     xterm.enable = false;
      #   };
      #
      #   # displayManager = {
      #   #   # gdm.enable = true;
      #   #   ly.enable = true;
      #   #   # lemurs
      #   #   # ly
      #   #   # emptty
      #   #   # lightdm = {
      #   #   #   enable = true;
      #   #   #   greeter.enable = true;
      #   #   # };
      #   # };
      #
      #   windowManager = {
      #     hypr = {
      #       enable = true;
      #     };
      #     # sway = {
      #     # };
      #     # i3 = {
      #     #   enable = true;
      #     #   package = pkgs.i3; # or pkgs.i3-gaps
      #     #   extraPackages = builtins.attrValues {
      #     #     inherit
      #     #       (pkgs)
      #     #       dmenu
      #     #       i3status
      #     #       i3lock
      #     #       i3lock-fancy
      #     #       rofi
      #     #       ;
      #     #   };
      #     # };
      #   };
      # };
    };
  };
}
