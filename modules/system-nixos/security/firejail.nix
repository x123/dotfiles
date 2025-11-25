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
        firefox = {
          executable = "${pkgs.firefox}/bin/firefox --no-remote --new-instance";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
      };
    };

    environment.systemPackages = [
      pkgs.iptables
    ];
  };
}
