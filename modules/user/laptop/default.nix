{
  config,
  lib,
  pkgs,
  ...
}: let
  i3lock = "${pkgs.i3lock}/bin/i3lock";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  xset = "${pkgs.xorg.xset}/bin/xset";
in {
  imports = [
  ];

  options = {
    custom.laptop.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable laptop specific settings.";
    };
  };

  config = lib.mkIf (config.custom.laptop.enable && !pkgs.stdenv.isDarwin) {
    services.xidlehook = {
      enable = true;
      detect-sleep = true;
      not-when-audio = true;
      not-when-fullscreen = true;
      environment = {
        "PRIMARY_DISPLAY" = "eDP-1";
      };
      timers = [
        {
          delay = 300;
          command = "${pkgs.writeShellScript "i3lock-dpms" ''
            revert() {
              ${xset} dpms 0 0 0
            }
            trap revert HUP INT TERM
            ${xset} +dpms dpms 5 5 5
            ${i3lock} -n -c 000000
            revert
          ''}";
        }
        {
          delay = 300;
          command = "${pkgs.writeShellScript "hybrid-sleep" ''
            ${systemctl} hybrid-sleep
          ''}";
        }
      ];
    };
  };
}
