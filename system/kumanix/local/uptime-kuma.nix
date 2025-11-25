{...}: {
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
        "kumanix.empire.internal" = {
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

  networking = {
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              tcp dport 80 counter accept comment "Allow HTTP/80"
              tcp dport 443 counter accept comment "Allow HTTPS/443"
            }
          '';
        };
      };
    };
  };
}
