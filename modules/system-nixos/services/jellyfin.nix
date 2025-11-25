{
  config,
  lib,
  ...
}: let
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.jellyfin.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.jellyfin.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.jellyfin = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system jellyfin service";
      };
      openFirewallNftables = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to add nftables rules.";
      };
      trustedIpv4Networks = lib.mkOption {
        default = ["127.0.0.1/32"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for.";
      };
      trustedIpv6Networks = lib.mkOption {
        default = ["::1/128"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for.";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.jellyfin.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    networking.nftables = lib.mkIf (config.custom.system-nixos.services.jellyfin.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # jellyfin
              ip6 saddr { ${trustedIpv6s} } tcp dport { 8096, 8920 } log prefix "nft-input-accept-jellyfin: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport { 8096, 8920 } counter accept

              ip6 saddr { ${trustedIpv6s} } udp dport { 7359 } log prefix "nft-input-accept-jellyfin-discovery: " level info
              ip6 saddr { ${trustedIpv6s} } udp dport { 7359 } counter accept

              ip saddr { ${trustedIpv4s} } tcp dport { 8096, 8920 } log prefix "nft-input-accept-jellyfin: " level info
              ip saddr { ${trustedIpv4s} } tcp dport { 8096, 8920 } counter accept

              ip saddr { ${trustedIpv4s} } udp dport { 7359 } log prefix "nft-input-accept-jellyfin-discovery: " level info
              ip saddr { ${trustedIpv4s} } udp dport { 7359 } counter accept
            }
          '';
        };
      };
    };
  };
}
