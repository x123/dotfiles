{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.security.firejail = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable firejail wrapping of binaries";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.security.firejail.enable) {
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        firefox-fj-wrapped = {
          executable = "${pkgs.firefox}/bin/firefox --no-remote --new-instance";
          # will use user generated instead at
          # ~/.config/firejail/firefox.profile and fallback by default on this
          # profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
          extraArgs = [
            "--name=browser"
          ];
        };
      };
    };

    environment.systemPackages = [
      pkgs.iptables
    ];
  };
}
