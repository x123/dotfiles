{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.mastodon;
in {
  # nixpkgs.overlays = [
  #   (
  #     final: prev: {
  #       unstable-small = import inputs.nixpkgs-unstable-small {
  #         inherit system;
  #       };
  #     }
  #   )
  # ];
  services = {
    mastodon = {
      enable = true;
      # package = pkgs.unstable-small.mastodon;
      database.createLocally = true;
      localDomain = "social.nixlink.net";
      configureNginx = false; # we use caddy below
      smtp = {
        createLocally = false;
        host = "hetznix.nixlink.net";
        fromAddress = "noreply@social.nixlink.net";
      };
      extraConfig.SINGLE_USER_MODE = "true";
      streamingProcesses = 7;
    };

    postgresqlBackup = {
      databases = ["mastodon"];
    };
  };

  users.users.caddy.extraGroups = ["mastodon"];

  # probably unneccessary
  # systemd.services.caddy.serviceConfig.ReadWriteDirectories = pkgs.lib.mkForce ["/var/lib/caddy" "/run/mastodon-web" "/run/mastodon-streaming"];

  services.caddy = {
    enable = true;
    globalConfig = ''
      http_port 80
      https_port 443
    '';
    virtualHosts = {
      "${cfg.localDomain}" = {
        useACMEHost = "nixlink.net";
        extraConfig = ''
          handle_path /system/* {
            file_server * {
                root /var/lib/mastodon/public-system
            }
          }

          handle /api/v1/streaming/* {
            reverse_proxy {
              to ${pkgs.lib.strings.concatStringsSep " " (map (i: "unix//run/mastodon-streaming/streaming-${toString i}.socket") (pkgs.lib.range 1 cfg.streamingProcesses))}
              lb_policy least_conn

              transport http {
                keepalive 5s
                keepalive_idle_conns 10
              }
            }
          }

          route * {
            file_server * {
              root ${cfg.package}/public
              pass_thru
            }
            reverse_proxy  {
              to ${
            if cfg.enableUnixSocket
            then "unix//run/mastodon-web/web.socket"
            else "http://127.0.0.1:${toString cfg.webPort}"
          }

              header_up X-Forwarded-Port 443
              header_up X-Forwarded-Proto https

              transport http {
                keepalive 5s
                keepalive_idle_conns 10
              }
            }
          }

          handle_errors {
            root * ${cfg.package}/public
            rewrite 500.html
            file_server
          }

          encode gzip

          header /* {
            Strict-Transport-Security "max-age=31536000;"
          }

          header /emoji/* Cache-Control "public, max-age=31536000, immutable"
          header /packs/* Cache-Control "public, max-age=31536000, immutable"
          header /system/accounts/avatars/* Cache-Control "public, max-age=31536000, immutable"
          header /system/media_attachments/files/* Cache-Control "public, max-age=31536000, immutable"
        '';
      };
    };
  };
}
