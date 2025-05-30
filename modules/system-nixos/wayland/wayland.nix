{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.wayland.enable) {
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
      };
    };
  };
}
