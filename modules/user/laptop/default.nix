{
  config,
  lib,
  pkgs,
  ...
}: let
  grep = "${pkgs.gnugrep}/bin/grep";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  xset = "${pkgs.xorg.xset}/bin/xset";
  i3lock-dpms = "${pkgs.writeShellScript "i3lock-dpms" ''
    set -euo pipefail
    revert() {
      ${xset} dpms 0 0 0
    }
    trap revert HUP INT TERM
    ${xset} +dpms dpms 5 5 5
    ${pkgs.i3lock}/bin/i3lock -n -c 000000
    revert
  ''}";
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
    services.screen-locker = {
      enable = true;
      inactiveInterval = 5;
      lockCmd = i3lock-dpms;
      xss-lock = {
        package = pkgs.xss-lock;
        extraOptions = ["--transfer-sleep-lock"];
      };
    };

    services.xidlehook = {
      enable = true;
      detect-sleep = true;
      not-when-audio = true;
      not-when-fullscreen = true;
      timers = [
        {
          delay = 900;
          command = "${pkgs.writeShellScript "hybrid-sleep" ''
            set -euo pipefail
            # exit if we are on AC power
            ${grep} 1 /sys/class/power_supply/AC/online > /dev/null && exit 0
            ${systemctl} hybrid-sleep
          ''}";
        }
      ];
    };
  };
}
