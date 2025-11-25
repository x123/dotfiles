{
  config,
  lib,
  ...
}: let
  trustedIpv4sList = config.custom.system-nixos.services.tang.trustedIpv4Networks;
  trustedIpv6sList = config.custom.system-nixos.services.tang.trustedIpv6Networks;
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.tang.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.tang.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.tang = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system tang service";
      };
      openFirewallNftables = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to add nftables rules.";
      };
      trustedIpv4Networks = lib.mkOption {
        default = ["0.0.0.0/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for.";
      };
      trustedIpv6Networks = lib.mkOption {
        default = ["::/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for.";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.tang.enable) {
    services = {
      tang = {
        enable = true;
        ipAddressAllow =
          [
          ]
          ++ config.custom.system-nixos.services.tang.trustedIpv4Networks
          ++ config.custom.system-nixos.services.tang.trustedIpv6Networks;
      };
    };

    networking.nftables = lib.mkIf (config.custom.system-nixos.services.tang.openFirewallNftables) {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # tang
            ${lib.optionalString (trustedIpv6sList != []) ''
              ip6 saddr { ${trustedIpv6s} } tcp dport 7654 log prefix "nft-accept-tang: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport 7654 counter accept
            ''}

            ${lib.optionalString (trustedIpv4sList != []) ''
              ip saddr { ${trustedIpv4s} } tcp dport 7654 log prefix "nft-accept-tang: " level info
              ip saddr { ${trustedIpv4s} } tcp dport 7654 counter accept
            ''}
            }
          '';
        };
      };
    };
  };
}
