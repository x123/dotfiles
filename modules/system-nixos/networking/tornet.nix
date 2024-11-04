{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.networking.tornet.enable) {
    services.tor = {
      enable = true;
      openFirewall = true;
      settings = {
        TransPort = [9040];
        DNSPort = 5353;
        VirtualAddrNetworkIPv4 = "172.30.0.0/16";
      };
    };

    # networking = {};
  };
}
