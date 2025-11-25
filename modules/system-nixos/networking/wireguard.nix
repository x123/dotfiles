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
    custom.system-nixos.networking.wireguard = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable wireguard and firejail wireguard wrapping binaries";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.networking.wireguard.enable) {
    sops.secrets = {
      "wireguard/privkey" = {
        mode = "0400";
      };
      "wireguard/config" = {
        mode = "0400";
      };
    };

    environment.systemPackages = [
      pkgs.iptables
    ];

    networking = {
      useNetworkd = true;
    };

    networking.wg-quick.interfaces.wg1.configFile = config.sops.secrets."wireguard/config".path;

    systemd.network = {
      enable = true;
      wait-online.enable = false;
    };
  };
}
