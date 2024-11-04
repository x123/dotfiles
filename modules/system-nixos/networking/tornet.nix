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

    networking = {
      useNetworkd = true;
      bridges."tornet".interfaces = [];
      nftables = {
        enable = true;
        tables = {
          nat = {
            family = "ip";
            content = ''
              chain PREROUTING {
                type nat hook prerouting priority dstnat; policy accept;
                iifname "tornet" meta l4proto tcp dnat to 127.0.0.1:9040
                iifname "tornet" udp dport 53 dnat to 127.0.0.1:5353
              }
            '';
          };
        };
      };

      nat = {
        internalInterfaces = ["tornet "];
        forwardPorts = [
          {
            destination = "127.0.0.1:5353";
            proto = "udp";
            sourcePort = 53;
          }
        ];
      };
    };

    systemd.network = {
      enable = true;
      wait-online.enable = false;
      networks.tornet = {
        matchConfig.Name = "tornet";
        DHCP = "no";
        networkConfig = {
          ConfigureWithoutCarrier = true;
          Address = "10.100.100.1/24";
        };
        linkConfig.ActivationPolicy = "always-up";
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.tornet.route_localnet" = 1;
    };
  };
}
