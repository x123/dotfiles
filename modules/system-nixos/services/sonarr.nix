{
  config,
  lib,
  ...
}: let
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.sonarr.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.sonarr.trustedIpv6Networks;
  sonarrUser = config.custom.system-nixos.services.sonarr.user;
  sonarrGroup = config.custom.system-nixos.services.sonarr.group;
in {
  options = {
    custom.system-nixos.services.sonarr = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system sonarr service";
      };
      user = lib.mkOption {
        default = "sonarr";
        type = lib.types.str;
        description = "User that sonarr runs as, defaults to sonarr";
      };
      group = lib.mkOption {
        default = "sonarr";
        type = lib.types.str;
        description = "Group that sonarr runs as, defaults to sonarr";
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.sonarr.enable) {
    services.sonarr = {
      enable = true;
      user = sonarrUser;
      group = sonarrGroup;
      openFirewall = true;
    };

    networking.nftables = lib.mkIf (config.custom.system-nixos.services.sonarr.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # sonarr
              ip6 saddr { ${trustedIpv6s} } tcp dport 8989 log prefix "nft-input-accept-sonarr: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport 8989 counter accept

              ip saddr { ${trustedIpv4s} } tcp dport 8989 log prefix "nft-input-accept-sonarr: " level info
              ip saddr { ${trustedIpv4s} } tcp dport 8989 counter accept
            }
          '';
        };
      };
    };
  };
}
