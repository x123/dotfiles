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
        "kuma.nixlink.net" = {
          useACMEHost = "nixlink.net";
          extraConfig = ''
            reverse_proxy 127.0.0.1:4000

            @auth {
              not path /api/push/* /api/status-page/* /status/* /assets/* /apple-touch-icon.png /icon.svg
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
