{
  config,
  lib,
  ...
}: let
  trustedIpv4sList = config.custom.system-nixos.services.tftp.trustedIpv4Networks;
  trustedIpv6sList = config.custom.system-nixos.services.tftp.trustedIpv6Networks;
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.tftp.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.tftp.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.tftp = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system tftp service";
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
      root = lib.mkOption {
        default = "/srv/tftp";
        type = lib.types.str;
        description = "Root path for serving up tftp files (defaults to '/srv/tftp')";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.tftp.enable) {
    services = {
      atftpd = {
        enable = true;
        root = config.custom.system-nixos.services.tftp.root;
      };
    };

    networking.nftables = lib.mkIf (config.custom.system-nixos.services.tftp.openFirewallNftables) {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # tftp
            ${lib.optionalString (trustedIpv6sList != []) ''
              ip6 saddr { ${trustedIpv6s} } udp dport 69 log prefix "nft-accept-tftp: " level info
              ip6 saddr { ${trustedIpv6s} } udp dport 69 counter accept
            ''}

            ${lib.optionalString (trustedIpv4sList != []) ''
              ip saddr { ${trustedIpv4s} } udp dport 69 log prefix "nft-accept-tftp: " level info
              ip saddr { ${trustedIpv4s} } udp dport 69 counter accept
            ''}
            }
          '';
        };
      };
    };
  };
}
