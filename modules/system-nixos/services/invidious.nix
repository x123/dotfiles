{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
  trustedIpv4s = builtins.concatStringsSep "," cfg.system-nixos.services.invidious.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.system-nixos.services.invidious.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.invidious = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system invidious service";
      };
      domain = lib.mkOption {
        default = "localhost";
        type = lib.types.str;
        description = "Domain to host invidious on";
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

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.invidious.enable) {
    users.users.nginx.extraGroups = [config.users.groups.ssl.name];
    # users.users.caddy.extraGroups = [config.users.groups.ssl.name];

    networking.nftables = lib.mkIf (cfg.system-nixos.services.invidious.openFirewallNftables) {
      enable = true;
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              ip6 saddr { ${trustedIpv6s} } tcp dport {80, 443} log prefix "nft-accept-lan-invidious: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport {80, 443} counter accept

              ip saddr { ${trustedIpv4s} } tcp dport {80, 443} log prefix "nft-accept-lan-invidious: " level info
              ip saddr { ${trustedIpv4s} } tcp dport {80, 443} counter accept
            }'';
        };
      };
    };

    services = {
      invidious = {
        enable = true;
        database.createLocally = true;
        domain = cfg.system-nixos.services.invidious.domain;
        nginx.enable = true;
        settings = {
          db.user = "invidious";
          db.name = "invidious";
          hmac_key = "if4oomaTh2aPhaiThi5z";
          https_only = true;
          # force_resolve = "ipv6";
          statistics_enabled = false;
          registration_enabled = false;
          popular_enabled = false;
          admins = ["x123"];
          decrypt_polling = true; # may use more bandwidth
        };
      };

      caddy = {
        enable = false;
        virtualHosts = {
          "${cfg.system-nixos.services.invidious.domain}" = {
            extraConfig = ''
              tls ${config.sops.secrets."ssl/invidious.xnix.lan/cert".path} ${config.sops.secrets."ssl/invidious.xnix.lan/key".path}
              reverse_proxy localhost:3000
              log {
                output discard
              }
            '';
          };
        };
      };

      # this is needed to disable automatic ACME cert grab from invidious our own
      # definition in security.acme.certs (in acme.nix)
      nginx.virtualHosts = {
        "${cfg.system-nixos.services.invidious.domain}" = {
          enableACME = false;
          sslCertificate = config.sops.secrets."ssl/invidious.xnix.lan/cert".path;
          sslCertificateKey = config.sops.secrets."ssl/invidious.xnix.lan/key".path;
        };
      };

      postgresqlBackup = {
        databases = ["invidious"];
      };
    };
  };
}
