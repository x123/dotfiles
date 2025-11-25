{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
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
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.invidious.enable) {
    users.users.nginx.extraGroups = [config.users.groups.ssl.name];
    # users.users.caddy.extraGroups = [config.users.groups.ssl.name];

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
