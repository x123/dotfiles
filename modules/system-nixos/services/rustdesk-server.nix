{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system-nixos.services.rustdesk-server;
  trustedIpv4s = builtins.concatStringsSep "," cfg.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.rustdesk-server = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the RustDesk server service";
      };
      package = lib.mkOption {
        default = pkgs.rustdesk-server;
        type = lib.types.package;
        description = "The RustDesk server package to use";
      };
      openFirewallNftables = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to add nftables rules for RustDesk ports";
      };
      trustedIpv4Networks = lib.mkOption {
        default = ["0.0.0.0/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for";
      };
      trustedIpv6Networks = lib.mkOption {
        default = ["::/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for";
      };
      relayHosts = lib.mkOption {
        default = [config.networking.hostName];
        type = lib.types.listOf lib.types.str;
        description = "List of relay host addresses";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && cfg.enable) {
    services.rustdesk-server = {
      enable = true;
      package = cfg.package;
      relay.enable = true;
      signal = {
        enable = true;
        relayHosts = cfg.relayHosts;
      };
    };

    networking.nftables = lib.mkIf cfg.openFirewallNftables {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # rustdesk
              ip6 saddr { ${trustedIpv6s} } tcp dport { 21115, 21116, 21117, 21118, 21119 } log prefix "nft-input-accept-rustdesk-tcp: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport { 21115, 21116, 21117, 21118, 21119 } counter accept

              ip6 saddr { ${trustedIpv6s} } udp dport 21116 log prefix "nft-input-accept-rustdesk-udp: " level info
              ip6 saddr { ${trustedIpv6s} } udp dport 21116 counter accept

              ip saddr { ${trustedIpv4s} } tcp dport { 21115, 21116, 21117, 21118, 21119 } log prefix "nft-input-accept-rustdesk-tcp: " level info
              ip saddr { ${trustedIpv4s} } tcp dport { 21115, 21116, 21117, 21118, 21119 } counter accept

              ip saddr { ${trustedIpv4s} } udp dport 21116 log prefix "nft-input-accept-rustdesk-udp: " level info
              ip saddr { ${trustedIpv4s} } udp dport 21116 counter accept
            }
          '';
        };
      };
    };
  };
}
