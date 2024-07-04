{config, ...}: {
  sops.secrets = {
    "caddy/auth/x" = {
      mode = "0440";
      owner = config.users.users.caddy.name;
      group = config.users.users.caddy.group;
    };
  };

  services = {
    uptime-kuma = {
      enable = true;
      settings = {
        HOST = "127.0.0.1";
        PORT = "4000";
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "kuma.boxchop.city" = {
          useACMEHost = "boxchop.city";
          extraConfig = ''
            reverse_proxy 127.0.0.1:4000

            @auth {
              not path /api/push/*
            }

            basic_auth @auth {
              import ${config.sops.secrets."caddy/auth/x".path}
            }

            @httpget {
              protocol http
              method GET
            }
            redir @httpget https://{host}{uri}
          '';
        };
      };
    };
  };
}
