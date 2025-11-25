{
  config,
  lib,
  ...
}: let
  cfg = config.custom.system-nixos.services.tang;

  # Helpers for NFTables (Direct Mode)
  trustedIpv4sList = cfg.trustedIpv4Networks;
  trustedIpv6sList = cfg.trustedIpv6Networks;
  trustedIpv4sNft = builtins.concatStringsSep "," cfg.trustedIpv4Networks;
  trustedIpv6sNft = builtins.concatStringsSep "," cfg.trustedIpv6Networks;

  # Helper for Caddy (Proxy Mode)
  # Caddy expects space-separated CIDRs for the remote_ip matcher
  trustedCaddyList = builtins.concatStringsSep " " (cfg.trustedIpv4Networks ++ cfg.trustedIpv6Networks);
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
        description = "Whether to add nftables rules for port 7654. (Ignored if Caddy is enabled).";
      };

      trustedIpv4Networks = lib.mkOption {
        default = ["0.0.0.0/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges.";
      };

      trustedIpv6Networks = lib.mkOption {
        default = ["::/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges.";
      };

      caddy = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
          description = "caddy reverse proxy for tang";
        };

        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The FQDN for the Tang virtual host (e.g. tang.example.com).";
        };

        acmeHost = lib.mkOption {
          type = lib.types.str;
          description = "The ACME host to use for certificates (e.g. example.com).";
        };
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && cfg.enable) {
    services = {
      tang = {
        enable = true;
        # If Caddy is enabled, only listen on localhost.
        # Otherwise, listen on the trusted networks directly.
        ipAddressAllow =
          if cfg.caddy.enable
          then ["127.0.0.1" "::1"]
          else cfg.trustedIpv4Networks ++ cfg.trustedIpv6Networks;
      };

      # Caddy configuration (Only if caddy.enable is true)
      caddy = lib.mkIf cfg.caddy.enable {
        enable = true;
        virtualHosts.${cfg.caddy.hostName} = {
          useACMEHost = cfg.caddy.acmeHost;
          extraConfig = ''
            # Security: Only allow requests from trusted networks
            @allowed_clients {
              remote_ip ${trustedCaddyList}
            }

            handle @allowed_clients {
              reverse_proxy 127.0.0.1:7654
            }

            # Block everyone else
            respond 403
          '';
        };
      };
    };

    # NFTables configuration (Only if Caddy is DISABLED)
    # If Caddy is enabled, we assume port 443/80 access is managed elsewhere
    networking.nftables = lib.mkIf (cfg.openFirewallNftables && !cfg.caddy.enable) {
      enable = true;
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # tang
            ${lib.optionalString (trustedIpv6sList != []) ''
              ip6 saddr { ${trustedIpv6sNft} } tcp dport 7654 log prefix "nft-accept-tang: " level info
              ip6 saddr { ${trustedIpv6sNft} } tcp dport 7654 counter accept
            ''}

            ${lib.optionalString (trustedIpv4sList != []) ''
              ip saddr { ${trustedIpv4sNft} } tcp dport 7654 log prefix "nft-accept-tang: " level info
              ip saddr { ${trustedIpv4sNft} } tcp dport 7654 counter accept
            ''}
            }
          '';
        };
      };
    };
  };
}
